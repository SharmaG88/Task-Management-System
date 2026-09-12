# Frontend Design & Architecture (Flutter)

Yeh document aapke Todo App (Google Calendar Style) ke Frontend (UI/UX) ka detailed plan hai. Isko follow karke aap step-by-step UI develop kar sakte hain.

## 1. Theming & Color Palette (UI Design System)

App ko modern aur clean dikhane ke liye hum ek specific color coding use karenge, jisse user ko task ka status samajhne mein asani ho:

- **Primary Color:** Deep Purple ya Indigo (Modern aur professional look).
- **Background Color:** Light Grey (`Colors.grey[100]`) ya pure White.
- **Task States (Color Coding):**
  - 🔵 **Active (To Do):** Blue ya Purple gradient. User ko dikhega ki task abhi pending hai.
  - 🟢 **Done:** Green color with strikethrough (text ke upar line) and lowered opacity. 
  - 🔴 **Late (Missed):** Red ya Deep Orange. Agar current time `endTime` ko cross kar gaya hai aur task done nahi hai, toh red alert dikhayenge.

## 2. Core Screens (App ki Main UI)

### A. Splash Screen
- **Purpose:** App khulte hi 1-2 seconds ke liye ek logo dikhana jab tak app check kare ki user logged in hai ya nahi.
- **Widgets:** `Scaffold`, `Center`, `FlutterLogo` ya `Image`, `CircularProgressIndicator`.

### B. Login Screen
- **Purpose:** User authentication via Google.
- **UI Element:** Screen ke center mein ek clean "Sign in with Google" button.
- **Widgets:** `ElevatedButton.icon`, `SvgPicture` (Google logo ke liye).

### C. Home Screen (Dashboard & Timeline)
- **Dashboard Header:** Top par ek summary bar: "X Pending | Y Done | Z Late".
- **Timeline View:** Google Calendar ki tarah ek time bar (left side mein time labels jaise 10 AM, 11 AM) aur task blocks.
- **Current Time Line:** Ek horizontal red dash line jo current time ke hisaab se position hogi.
- **Widgets:** `Scaffold`, `AppBar`, `ListView.builder` (timeline ke liye), `Stack` (current time line draw karne ke liye).

## 3. Reusable Widgets (Chhote UI Parts)

Code ko clean rakhne ke liye hum in UI elements ko alag files mein banayenge:

1. **`TaskTile` Widget:** 
   - Har ek task item is widget ka use karega. 
   - Isme Swipe gestures add karenge (Swipe left to delete, swipe right to done).
   - *Widgets Used:* `Dismissible`, `Card`, `Checkbox`, `ListTile`.
2. **`AddTaskBottomSheet` Widget:**
   - Floating Action Button dabane par naya task dalne ka popup.
   - Isme Title input aur **Time Picker** (Start & End Time) hoga.
   - *Widgets Used:* `BottomSheet`, `TextField`, `showTimePicker()`, `ElevatedButton`.
3. **`DashboardSummary` Widget:**
   - Home screen ke top par dikhne wala score board.
   - *Widgets Used:* `Row`, `Column`, `Text`.

## 4. Frontend Directory Structure

`lib/` folder ke andar Frontend ka code kuch is tarah divide hoga:

```text
lib/
 ┣ screens/
 ┃ ┣ splash_screen.dart
 ┃ ┣ login_screen.dart
 ┃ ┗ home_screen.dart
 ┃
 ┣ widgets/
 ┃ ┣ task_tile.dart           # Single task item UI
 ┃ ┣ add_task_sheet.dart      # Bottom sheet for new task
 ┃ ┗ dashboard_summary.dart   # Top counter widget
 ┃
 ┗ theme/
   ┗ app_colors.dart          # Saare colors (Red, Green, Blue) yahan define karenge
```

## 5. UI Logic (Provider ke sath connection)

UI directly database se baat nahi karega. Frontend ka flow yeh hoga:
1. `HomeScreen` build hoga aur `Provider` se tasks ki list magega (`context.watch<TaskProvider>().tasks`).
2. Agar list empty hai, toh ek **Empty State SVG image** dikhayega (e.g. "Relax, no tasks").
3. Agar tasks hain, toh unhe `TaskTile` mein pass karke render karega.
4. User kisi task par mark done karta hai, toh `TaskTile` sidha Provider ka function call karega: `context.read<TaskProvider>().markTaskDone(taskId)`.

---
*Tip: Aap is file ko apne git commit mein add kar sakte hain: `git add frontend_design.md` aur `git commit -m "Added frontend design specs"`.*
