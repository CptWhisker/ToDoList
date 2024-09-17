//
//  ViewController.swift
//  ToDoList
//
//  Created by user on 15.09.2024.
//

import UIKit

protocol TaskListViewControllerProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func showTasks(_ tasks: [TaskModel])
    func setFilterCounts(_ counts: FilteredTasksCount)
    func updateTask(_ task: TaskModel)
}

class TaskListViewController: UIViewController, TaskListViewControllerProtocol {

    // MARK: - Properties
    var presenter: TaskListPresenterProtocol?
    let configurator: TaskListConfiguratorProtocol = TaskListConfigurator()
    private var tasks: [TaskModel] = [
    TaskModel(id: UUID(), title: "One", description: "Description", createdAt: "Sep 12, 19:44", isCompleted: true),
    TaskModel(id: UUID(), title: "Two", description: "Description", createdAt: "Sep 14, 20:00", isCompleted: false),
    TaskModel(id: UUID(), title: "Three", description: "Description", createdAt: "Sep 15 21:30", isCompleted: true),
    TaskModel(id: UUID(), title: "One", description: "Description", createdAt: "Sep 12, 19:44", isCompleted: true),
    TaskModel(id: UUID(), title: "Two", description: "Description", createdAt: "Sep 14, 20:00", isCompleted: false),
    TaskModel(id: UUID(), title: "Three", description: "Description", createdAt: "Sep 15 21:30", isCompleted: true),
    TaskModel(id: UUID(), title: "One", description: "Description", createdAt: "Sep 12, 19:44", isCompleted: true),
    TaskModel(id: UUID(), title: "Two", description: "Description", createdAt: "Sep 14, 20:00", isCompleted: false),
    TaskModel(id: UUID(), title: "Three", description: "Description", createdAt: "Sep 15 21:30", isCompleted: true)
    ]
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today's Task"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wednesday, 11 May"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var newTaskButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "New Task"
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = .systemBlue.withAlphaComponent(0.1)
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        return button
    }()
    private lazy var allTasksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("All   9", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .left
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 6).isActive = true
        button.addTarget(self, action: #selector(filterAll), for: .touchUpInside)
        return button
    }()
    private lazy var completedTasksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Closed   6", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .left
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 6).isActive = true
        button.addTarget(self, action: #selector(filterCompleted), for: .touchUpInside)
        return button
    }()
    private lazy var incompletedTasksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open   3", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .left
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 6).isActive = true
        button.addTarget(self, action: #selector(filterIncompleted), for: .touchUpInside)
        return button
    }()
    private lazy var filterButtonsSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .gray
        return view
    }()
    private lazy var filterButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allTasksButton, filterButtonsSeparator, incompletedTasksButton, completedTasksButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    private lazy var tasksCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(
            TaskCell.self,
            forCellWithReuseIdentifier: "TaskCell"
        )
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
//        presenter?.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Public Methods
    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tasksCollectionView.reloadData()
    }
    
    func setFilterCounts(_ counts: FilteredTasksCount) {
        allTasksButton.setTitle("All   \(counts.all)", for: .normal)
        incompletedTasksButton.setTitle("Open   \(counts.incompleted)", for: .normal)
        completedTasksButton.setTitle("Closed   \(counts.completed)", for: .normal)
    }
    
    func updateTask(_ task: TaskModel) {
        guard let indexPath = taskIndexPath(for: task) else { return }
        tasksCollectionView.reloadItems(at: [indexPath])
    }

    private func taskIndexPath(for task: TaskModel) -> IndexPath? {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return nil }
        return IndexPath(item: index, section: 0)
    }

    private func configureUI() {
//        view.backgroundColor = .white.withAlphaComponent(0.95)
        view.backgroundColor = .todoBackground
        
        view.addSubview(labelsStackView)
        view.addSubview(newTaskButton)
        view.addSubview(filterButtonsStackView)
        view.addSubview(tasksCollectionView)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            labelsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelsStackView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            labelsStackView.heightAnchor.constraint(equalToConstant: 75),
            
            newTaskButton.centerYAnchor.constraint(equalTo: labelsStackView.centerYAnchor),
            newTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newTaskButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3),
            newTaskButton.heightAnchor.constraint(equalToConstant: 40),
            
            filterButtonsStackView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 24),
            filterButtonsStackView.leadingAnchor.constraint(equalTo: labelsStackView.leadingAnchor),
            filterButtonsStackView.trailingAnchor.constraint(lessThanOrEqualTo: newTaskButton.trailingAnchor),
            filterButtonsStackView.heightAnchor.constraint(equalToConstant: 25),
            
            tasksCollectionView.topAnchor.constraint(equalTo: filterButtonsStackView.bottomAnchor, constant: 24),
            tasksCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tasksCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tasksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func addNewTask() {
        presenter?.didTapAddTaskButton()
    }
    
    @objc private func filterAll() {
        presenter?.filterAllTasks()
    }
    
    @objc private func filterCompleted() {
        presenter?.filterCompletedTasks()
    }
    
    @objc private func filterIncompleted() {
        presenter?.filterIncompletedTasks()
    }
}

extension TaskListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.configure(with: tasks[indexPath.item], delegate: presenter as? TaskCellDelegate)
        return cell
    }
}

extension TaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight: CGFloat = 120
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

extension TaskListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.item]
        
        presenter?.didSelectTask(selectedTask)
    }
}

