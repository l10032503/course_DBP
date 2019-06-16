insert into student values ('1912345', '1111', '눈송이', 1, '컴퓨터과학부', 0);
insert into enroll values ('1912345', 'C1235',1,2019,1);
insert into enroll values ('1912345', 'C2134',1,2019,1);
insert into enroll values ('1912345', 'C1238',2,2019,1);

insert into enroll values ('1912345', 'C1229',1,2018,2);
insert into enroll values ('1912345', 'C1297',1,2018,2);
insert into enroll values ('1912345', 'C2234',1,2018,2);

insert into enroll values ('1912345', 'C1207',1,2018,1);
insert into enroll values ('1912345', 'C2456',1,2018,1);
insert into enroll values ('1912345', 'C2567',1,2018,1);

insert into professor values ('30303','1111','심준호','컴퓨터과학부');
insert into professor values ('33333','1111','박숙영','컴퓨터과학부');
insert into professor values ('34343','1111','김주균','컴퓨터과학부');
insert into professor values ('32353','1111', '박영훈' ,'컴퓨터과학부');
insert into professor values ('30304','1111','이기용','컴퓨터과학부');
insert into professor values ('30305','1111','최영우','컴퓨터과학부');
insert into professor values ('30338','1111','이현자','컴퓨터과학부');
insert into professor values ('32322','1111','채희준','컴퓨터과학부');
insert into professor values ('38888','1111','창병모','컴퓨터과학부');

insert into professor values ('35555','1111','김교양','기초교양대학');
insert into professor values ('30001','1111','김경영','경영학부');
insert into professor values ('30002','1111','김경제','경제학부');
insert into professor values ('30003','1111','김한국','한국어문학부');
insert into professor values ('30004','1111','김중문','중어중문학부');
insert into professor values ('30005','1111','김프문','프랑스언어문화학과');
insert into professor values ('30006','1111','김독문','독일언어문화학과');
insert into professor values ('30007','1111','김역문','역사문화학과');
insert into professor values ('30008','1111','김문정','문헌정보학과');
insert into professor values ('30009','1111','김문광','문화관광학전공');
insert into professor values ('30010','1111','김르꼬','르꼬르동블루 외식경영전공');
insert into professor values ('30011','1111','김화학','화학과');
insert into professor values ('30012','1111','김생명','생명시스템학부');
insert into professor values ('30013','1111','김수학','수학과');
insert into professor values ('30014','1111','김통계','통계학과');
insert into professor values ('30015','1111','김체교','체육교육과');
insert into professor values ('30016','1111','김무용','무용과');
insert into professor values ('30017','1111','김화공','화공생명공학부');
insert into professor values ('30018','1111','김아이티','IT공학전공');
insert into professor values ('30019','1111','김전공','전자공학전공');
insert into professor values ('30020','1111','김물리','응용물리전공');
insert into professor values ('30021','1111','김화학','화학과');
insert into professor values ('30022','1111','김기계','기계시스템학부');
insert into professor values ('30023','1111','김기공','기초공학부');
insert into professor values ('30024','1111','김가족','가족자원경영학과');
insert into professor values ('30025','1111','김아복','아동복지학부');
insert into professor values ('30026','1111','김의류','의류학과');
insert into professor values ('30027','1111','김식영','식품영양학과');
insert into professor values ('30028','1111','김정외','정치외교학과');
insert into professor values ('30029','1111','김행정','행정학과');
insert into professor values ('30030','1111','김홍광','홍보광고학과');
insert into professor values ('30031','1111','김소경','소비자경제학과');
insert into professor values ('30032','1111','김사심','사회심리학과');
insert into professor values ('30033','1111','김법학','법학부');
insert into professor values ('30034','1111','김피아노','피아노과');
insert into professor values ('30035','1111','김관현','관현악과');
insert into professor values ('30036','1111','김성악','성악과');
insert into professor values ('30037','1111','김작곡','작곡과');
insert into professor values ('30038','1111','김시디','시각영상디자인과');
insert into professor values ('30039','1111','김산디','산업디자인과');
insert into professor values ('30040','1111','김환디','환경디자인과');
insert into professor values ('30041','1111','김공예','공예과');
insert into professor values ('30042','1111','김회화','회화과');
insert into professor values ('30043','1111','김글협','글로벌협력전공');
insert into professor values ('30044','1111','김앙프','앙트프러너십전공');
insert into professor values ('30045','1111','김영문','영어영문학전공');
insert into professor values ('30046','1111','김미디어','미디어학부');


--2019년 2학기
insert into course values ('C1234','데이터베이스프로그래밍', '명신관 418호', 2019, 2, '30303',3,1,'컴퓨터과학부', 1,3,2,2,30,29);
insert into course values ('C1234','데이터베이스프로그래밍', '명신관 418호', 2019, 2, '30303',3,2,'컴퓨터과학부', 2,4,3,3,30,29);
insert into course values ('C1256','시스템종합설계', '명신관 413호', 2019, 2, '33333',3,1,'컴퓨터과학부', 1,3,1,2,30,29);
insert into course values ('C1278','자료구조', '명신관 415호', 2019, 2, '33333',3,1,'컴퓨터과학부', 2,4,2,2,30,20);
insert into course values ('C1277','운영체제', '명신관 413호', 2019, 2, '34343',3,1,'컴퓨터과학부', 2,4,1,1,30,20);
insert into course values ('C1245','컴파일러', '명신관 202호', 2019, 2, '32353',3,1, '컴퓨터과학부', 2, 4, 4, 4, 30, 20);
insert into course values ('C2134','글쓰기와 읽기', '순헌관 302호', 2019, 2, '35555',2,1,'기초교양대학', 1,3,1,1,30,20);
insert into course values ('C2234','발표와 토론', '명신관 602호', 2019, 2, '35555',2,1,'기초교양대학', 1,3,3,3,30,30);
insert into course values ('C2456','영어쓰기와 읽기', '진리관 303호', 2019, 2, '35555',3,1,'기초교양대학', 1,3,5,5,30,20);
insert into course values ('C2567','영어발표와 토론', '순헌관 102호', 2019, 2, '35555',3,1,'기초교양대학', 1,3,6,6,30,20);


--2019년 1학기
insert into course values ('C1235','데이터사이언스개론', '명신관 302호', 2019, 1, '30304',3,1,'컴퓨터과학부', 1,3,2,2,60,60);
insert into course values ('C1235','데이터사이언스개론', '명신관 304호', 2019, 1, '30305',3,2,'컴퓨터과학부', 1,3,2,2,60,60);
insert into course values ('C1238','소프트웨어의 이해', '명신관 102호', 2019, 1, '33333',3,1,'컴퓨터과학부', 1,3,4,4,30,29);
insert into course values ('C1238','소프트웨어의 이해', '명신관 102호', 2019, 1, '30338',3,2,'컴퓨터과학부', 1,3,6,6,30,30);
insert into course values ('C1238','소프트웨어의 이해', '명신관 102호', 2019, 1, '32322',3,3,'컴퓨터과학부', 1,3,1,1,30,27);
insert into course values ('C2134','글쓰기와 읽기','명신관 201호', 2019, 1, '35555',2,1,'기초교양대학', 2,4,1,1,30,20);
insert into course values ('C2234','발표와 토론','명신관 303호', 2019, 1, '35555',2,1,'기초교양대학', 2,4,3,3,30,20);
insert into course values ('C2456','영어쓰기와 읽기','명신관 421호', 2019, 1, '35555',3,1,'기초교양대학', 2,4,5,5,30,20);
insert into course values ('C2567','영어발표와 토론','명신관 526호', 2019, 1, '35555',3,1,'기초교양대학', 2,4,6,6,30,20);

--2018년 2학기
insert into course values ('C1229','디지털 논리회로', '명신관 413호', 2018, 2, '34343',3,1,'컴퓨터과학부', 2,4,1,1,30,30);
insert into course values ('C1237','자바 프로그래밍', '명신관 303호', 2018, 2, '30338',3,1,'컴퓨터과학부', 1,3,2,2,30,30);
insert into course values ('C1297','리눅스 시스템', '명신관 303호', 2018, 2, '38888',3,1,'컴퓨터과학부', 1,3,5,5,30,30);
insert into course values ('C2134','글쓰기와 읽기','명신관 325호', 2018, 2, '35555',2,1,'기초교양대학', 1,3,6,3,30,20);
insert into course values ('C2234','발표와 토론','명신관 305호', 2018, 2, '35555',2,1,'기초교양대학', 1,3,5,4,30,20);
insert into course values ('C2456','영어쓰기와 읽기','명신관 411호', 2018, 2, '35555',3,1,'기초교양대학', 1,3,4,5,30,20);
insert into course values ('C2567','영어발표와 토론','명신관 517호', 2018, 2, '35555',3,1,'기초교양대학', 1,3,3,6,30,20);

--2018년 1학기
insert into course values ('C1207','프로그래밍 언어론', '명신관 404호', 2018, 1, '38888',3,1,'컴퓨터과학부', 1,3,2,2,50,47);
insert into course values ('C1207','프로그래밍 언어론', '명신관 404호', 2018, 1, '38888',3,2,'컴퓨터과학부', 2,4,2,2,50,50);
insert into course values ('C2134','글쓰기와 읽기','명신관 516호', 2018, 1, '35555',2,1,'기초교양대학', 2,4,2,1,30,20);
insert into course values ('C2234','발표와 토론','명신관 611호', 2018, 1, '35555',2,1,'기초교양대학', 2,4,3,3,30,20);
insert into course values ('C2456','영어쓰기와 읽기','명신관 213호', 2018, 1, '35555',3,1,'기초교양대학', 1,3,4,5,30,20);
insert into course values ('C2567','영어발표와 토론','명신관 224호', 2018, 1, '35555',3,1,'기초교양대학', 1,3,5,6,30,20);
