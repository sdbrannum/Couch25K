import Foundation

class CountdownTimer {
    private var timer: Timer?
    private var exerciseTimeLeft: TimeInterval = 0.0
    private var workoutTimeLeft: TimeInterval = 0.0
    private let withTimeInterval: TimeInterval = 0.1

    init(workoutTotalTime: TimeInterval) {
        self.workoutTimeLeft = workoutTotalTime
    }

    func setExerciseTimeLeft(time: TimeInterval) {
        self.exerciseTimeLeft = time
    }

    func start(onTimeLeftUpdate: @escaping (_ exerciseTimeLeft: TimeInterval, _ workoutTimeLeft: TimeInterval) -> Void) {
        guard exerciseTimeLeft >= 0.0, timer == nil else { return }
        timer = Timer(timeInterval: withTimeInterval, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.exerciseTimeLeft = self.stepped(self.exerciseTimeLeft, by: -0.1)
            self.workoutTimeLeft  = self.stepped(self.workoutTimeLeft,  by: -0.1)
            onTimeLeftUpdate(self.exerciseTimeLeft, self.workoutTimeLeft)
            if self.exerciseTimeLeft == 0.0 {
                self.stop()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func stepped(_ time: TimeInterval, by delta: TimeInterval) -> TimeInterval {
        Double(round(10 * (time + delta)) / 10)
    }
}
