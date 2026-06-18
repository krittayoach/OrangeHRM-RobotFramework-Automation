# OrangeHRM Automation Testing (Robot Framework)

มินิโปรเจกต์นี้เป็นส่วนหนึ่งของการทดลองทำ **Automated Software Testing**
ใช้สำหรับทดสอบระบบจัดการทรัพยากรบุคคล [OrangeHRM Demo](https://opensource-demo.orangehrmlive.com/)
พัฒนาด้วย **Robot Framework** + **SeleniumLibrary** โดยใช้โครงสร้างแบบ **Page Object Model (POM)** เพื่อให้ดูแลรักษาโค้ดได้ง่าย

## ขอบเขตการทดสอบ (Test Scope)

ครอบคลุม 3 โมดูลหลัก รวม 8 test cases:

| Module | Test Cases | รายละเอียด |
|--------|-----------|-----------|
| **Authentication** | TC-1 ถึง TC-3 | ทดสอบ Login สำเร็จ/ไม่สำเร็จ และ Data-Driven หลาย user |
| **Admin (User Management)** | TC-4 ถึง TC-6 | เพิ่ม user, ตรวจสอบ password matching, ค้นหา user |
| **PIM (Employee Management)** | TC-7 ถึง TC-8 | เพิ่มพนักงานใหม่พร้อมอัปโหลดรูป และค้นหาข้อมูล |

## โครงสร้างโปรเจกต์ (Project Structure)

```
.
├── Testcase/                       # Test suites
│   ├── 01_Login_Scenarios.robot
│   ├── 02_Admin_User_Management.robot
│   └── 03_PIM_Employee_Management.robot
├── Keywords/                       # Page Object keywords
│   ├── Common.resource             # เปิด browser ที่ใช้ร่วมกัน
│   └── Page/
│       ├── Login_Page.resource
│       ├── Admin_Page.resource
│       └── PIM_Page.resource
├── TestData/
│   └── profile.png                 # รูปสำหรับทดสอบอัปโหลดใน PIM
├── config.py                       # URL / Browser / Test data
├── requirements.txt
└── README.md
```

## สิ่งที่ต้องติดตั้ง (Prerequisites)

- Python 3.x ขึ้นไป
- Google Chrome ( และ ChromeDriver ที่เข้ากับเวอร์ชัน Chrome — Selenium รุ่นใหม่จัดการให้อัตโนมัติ)

## การติดตั้ง (Installation)

```bash
pip install -r requirements.txt
```

## การรันเทส (Run Tests)

รันทั้งหมด:

```bash
robot Testcase/
```

รันเฉพาะ suite:

```bash
robot Testcase/01_Login_Scenarios.robot
```

รันเฉพาะ tag (เช่น Smoke):

```bash
robot --include Smoke Testcase/
```

กำหนดโฟลเดอร์ผลลัพธ์:

```bash
robot --outputdir results Testcase/
```

ตรวจ syntax โดยไม่เปิด browser จริง:

```bash
robot --dryrun Testcase/
```

หลังรันเสร็จดูผลได้ที่ `log.html` และ `report.html`

## หมายเหตุ (Notes)

- ค่า URL, browser และข้อมูล login อยู่ใน `config.py`
- TC-4/TC-7 จะ **สุ่ม username / ชื่อพนักงานใหม่ทุกครั้งที่รัน** เพื่อให้รันซ้ำได้โดยไม่ชนข้อมูลเดิม
- โฟลเดอร์ผลลัพธ์ (`results/`, `output.xml`, `log.html`, ฯลฯ) ถูก gitignore ไว้แล้ว ไม่ต้อง commit
