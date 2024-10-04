String getInitials(String initial) => initial.isNotEmpty
    ? initial.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
    : '';
