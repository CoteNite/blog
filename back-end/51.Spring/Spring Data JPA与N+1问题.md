# Spring Data JPA与N+1问题


Spring Data JPA是Spring旗下的Spring Data项目下针对SQL的ORM，其名字中的JPA为`Java Persistent API(即Java持久化API)`，是Java为了统一各大ORM厂商的接口而定义的一套规范，至于JPA的具体实现则交由各大ORM厂商自行实现，目前Spring Data JPA默认采用的是Hibernate作为JPA实现

## N+1问题是什么

所谓N+1问题，是在这样一种语境下出现的：

存在表A B，其中表A中的实体与表B中的实体是一对多的关系，在这种情况下，如果我们使用JPA去查询N条表A中的数据，会连带进行N次查询，去查询每一条表A的实体下关联的表B的实体的数量，进而**总计为N次对表B的查询，与一次对表A的查询，即N+1问题**

## 解决方案

目前JPA会推荐我们使用`@ManyToOne(fetch = FetchType.LAZY)`的方式去指定关联关系

```kotlin
@Entity  
@Table  
class Course(  
    @Id  
    @SequenceGenerator(  
        name="course_sequence",  
        sequenceName = "course_sequence",  
        allocationSize = 1  
    )  
    @GeneratedValue(  
        strategy = GenerationType.SEQUENCE,  
        generator = "course_sequence"  
    )  
    var courseId: Long?=null,  
    var title: String,  
    var credit: String,  
    @OneToOne(mappedBy = "course")  
    var courseMaterial: CourseMaterial,  
    @ManyToOne(fetch = FetchType.LAZY)  
    @JoinColumn(  
        name="teacher_id",  
        foreignKey = ForeignKey(ConstraintMode.NO_CONSTRAINT)  
    )  
    var teacher: Teacher  
){  
  
    override fun toString(): String {  
        return "Course(courseId=$courseId, title='$title', credit='$credit', courseMaterial=$courseMaterial, teacher=$teacher)"  
    }  
}
```

在这种情况先，我们针对A表的查询就不会连带着进行对B表的查询，进而在根源层面杜绝了N+1问题

## 懒加载后带来的问题

虽然解决了N+1问题，但是随之而来的会有更多的问题

我们看上面对course代码中toString方法的定义，可能会感觉没有什么问题，可是我们在Junit下使用findById查询course数据并将得到的实体类打印出来，很快就会发现出现了报错，这是因为我们在调用toString方法的时候，由于其中的关联实体使用的是懒加载，因此查询完course后就会关闭原本的查询session，而打印时在获取关联实体时会因为session已经关闭而获取不到关联的实体类

因此我们需要对toString方法进行改造

```kotlin
@Entity  
@Table  
class Course(  
    @Id  
    @SequenceGenerator(  
        name="course_sequence",  
        sequenceName = "course_sequence",  
        allocationSize = 1  
    )  
    @GeneratedValue(  
        strategy = GenerationType.SEQUENCE,  
        generator = "course_sequence"  
    )  
    var courseId: Long?=null,  
    var title: String,  
    var credit: String,  
    @OneToOne(mappedBy = "course")  
    var courseMaterial: CourseMaterial,  
    @ManyToOne(fetch = FetchType.LAZY)  
    @JoinColumn(  
        name="teacher_id",  
        foreignKey = ForeignKey(ConstraintMode.NO_CONSTRAINT)  
    )  
    var teacher: Teacher  
){  
  
    override fun toString(): String {  
        return "Course(courseId=$courseId, title='$title', credit='$credit')"  
    }  
}
```

JPA推荐我们使用的方式是在toString方法中只打印实体自身的内容

