Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A8628DF0
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 01:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbfEWXmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 19:42:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51382 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388129AbfEWXmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 19:42:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4NNZ2ft069885;
        Thu, 23 May 2019 23:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1JgCZLzWfbnFfhqA0xcFotNG2JFUIrcN6ULOCR0spU4=;
 b=RzEbk4y2wCftai4pgWkoIfZgeDxTNqbDnB8zPnEPw+8WhO9kRAuHZnEMoExtIJp5s3AW
 yXnh4THZsPLkMRUuaNtCpqs2Z7Pz89GX6Fsh0XpiHyl1jwz5B5Z3StYzaxUohjONyUOF
 /gXivDJlxj3C4pk6TdeX7oJXaMU8t8xEP8Grv8aV8sLyoigGqlsntc4CkvKIGV7zxesR
 b2Ue062TOI1e73BtzXd/y15FId1XcAvcgZo5kc3wtNkwbKT/QodT9yehGGDOcSaKy90E
 qdnRaFbwM8IjOSI49iR/z/9ZZ5obhCZFy1+zCny+TxZ2wbJAzX5YEbsbkaF1zI2E3+3o Bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2smsk5nmjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 23:42:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4NNfb2a001327;
        Thu, 23 May 2019 23:42:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2smsgthywy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 23:42:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4NNgS2O023570;
        Thu, 23 May 2019 23:42:29 GMT
Received: from [192.168.1.222] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 23:42:28 +0000
Subject: Re: FAILED: patch "[PATCH] hugetlb: use same fault hash key for
 shared and private" failed to apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        dbueso@suse.de, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
References: <155810520474160@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <ba47662e-26be-5e28-e64e-59bc01603fa8@oracle.com>
Date:   Thu, 23 May 2019 16:42:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155810520474160@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905230152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905230152
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/19 8:00 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Thu, 23 May 2019 14:19:09 -0700
Subject: [PATCH] hugetlb: use same fault hash key for shared and private
 mappings

commit 1b426bac66e6cc83c9f2d92b96e4e72acf43419a upstream.

hugetlb uses a fault mutex hash table to prevent page faults of the
same pages concurrently.  The key for shared and private mappings is
different.  Shared keys off address_space and file index.  Private
keys off mm and virtual address.  Consider a private mappings of a
populated hugetlbfs file.  A fault will map the page from the file
and if needed do a COW to map a writable page.

Hugetlbfs hole punch uses the fault mutex to prevent mappings of file
pages.  It uses the address_space file index key.  However, private
mappings will use a different key and could race with this code to map
the file page.  This causes problems (BUG) for the page cache remove
code as it expects the page to be unmapped.  A sample stack is:

page dumped because: VM_BUG_ON_PAGE(page_mapped(page))
kernel BUG at mm/filemap.c:169!
...
RIP: 0010:unaccount_page_cache_page+0x1b8/0x200
...
Call Trace:
__delete_from_page_cache+0x39/0x220
delete_from_page_cache+0x45/0x70
remove_inode_hugepages+0x13c/0x380
? __add_to_page_cache_locked+0x162/0x380
hugetlbfs_fallocate+0x403/0x540
? _cond_resched+0x15/0x30
? __inode_security_revalidate+0x5d/0x70
? selinux_file_permission+0x100/0x130
vfs_fallocate+0x13f/0x270
ksys_fallocate+0x3c/0x80
__x64_sys_fallocate+0x1a/0x20
do_syscall_64+0x5b/0x180
entry_SYSCALL_64_after_hwframe+0x44/0xa9

There seems to be another potential COW issue/race with this approach
of different private and shared keys as noted in commit 8382d914ebf7
("mm, hugetlb: improve page-fault scalability").

Since every hugetlb mapping (even anon and private) is actually a file
mapping, just use the address_space index key for all mappings.  This
results in potentially more hash collisions.  However, this should not
be the common case.

Link: http://lkml.kernel.org/r/20190328234704.27083-3-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20190412165235.t4sscoujczfhuiyt@linux-r8p5
Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c    |  7 ++-----
 include/linux/hugetlb.h |  4 +---
 mm/hugetlb.c            | 19 +++++--------------
 3 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4acc677ac8fb..a52b76117090 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -451,9 +451,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			if (next >= end)
 				break;
 
-			hash = hugetlb_fault_mutex_hash(h, current->mm,
-							&pseudo_vma,
-							mapping, next, 0);
+			hash = hugetlb_fault_mutex_hash(h, mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
@@ -637,8 +635,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
-						index, addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b699d59d0f4f..6b8a7b654771 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -92,9 +92,7 @@ void putback_active_hugepage(struct page *page);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-				struct vm_area_struct *vma,
-				struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 				pgoff_t idx, unsigned long address);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8b682da98d95..75d8bd7e8798 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3812,21 +3812,14 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 }
 
 #ifdef CONFIG_SMP
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-			    struct vm_area_struct *vma,
-			    struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
 {
 	unsigned long key[2];
 	u32 hash;
 
-	if (vma->vm_flags & VM_SHARED) {
-		key[0] = (unsigned long) mapping;
-		key[1] = idx;
-	} else {
-		key[0] = (unsigned long) mm;
-		key[1] = address >> huge_page_shift(h);
-	}
+	key[0] = (unsigned long) mapping;
+	key[1] = idx;
 
 	hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
 
@@ -3837,9 +3830,7 @@ u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
  * For uniprocesor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-			    struct vm_area_struct *vma,
-			    struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
 {
 	return 0;
@@ -3885,7 +3876,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping, idx, address);
+	hash = hugetlb_fault_mutex_hash(h, mapping, idx, address);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
-- 
2.20.1

