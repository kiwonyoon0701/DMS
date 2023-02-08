## Cross Account DMS

----

Source 

- Account A
- VPC-OnPREM : 10.100.0.0/16



Target

- Account B
- VPC-Target : 20.100.0.0/16

---

### VPC Peering

Peering Request from Account-A-OnPrem to Account-B-Target

![image-20230208172449066](images/image-20230208172449066.png)



#### Account B - Accept

![image-20230208172654106](images/image-20230208172654106.png)



---

### Edit DNS Settings

#### ![image-20230208172724882](images/image-20230208172724882.png)



![image-20230208172739090](images/image-20230208172739090.png)



---

### Route Table

#### Account A

![image-20230208172817351](images/image-20230208172817351.png)

![image-20230208173131049](images/image-20230208173131049.png)

![image-20230208173152423](images/image-20230208173152423.png)



#### Account B

![image-20230208173313669](images/image-20230208173313669.png)

![image-20230208173335882](images/image-20230208173335882.png)

![image-20230208173358099](images/image-20230208173358099.png)

---



### Now Ping is working

```
ec2-user@ip-10-100-1-101:/home/ec2-user> ping 20.100.1.101
PING 20.100.1.101 (20.100.1.101) 56(84) bytes of data.
64 bytes from 20.100.1.101: icmp_seq=101 ttl=64 time=0.311 ms
64 bytes from 20.100.1.101: icmp_seq=102 ttl=64 time=0.287 ms

```



---

## Create RI in Account B(Target)



![image-20230208174433806](images/image-20230208174433806.png)

---

## Create Endpoint

![image-20230208180232703](images/image-20230208180232703.png)



---

![image-20230208180424512](images/image-20230208180424512.png)



---

## Create DMS Task



![image-20230208181146433](images/image-20230208181146433.png)



---

이상 Cross Account VPC Peering으로 Account A의 Data를 DMS로 Account B로 이관하는 방법을 알아봤습니다. :)