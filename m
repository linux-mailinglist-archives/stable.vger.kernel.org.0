Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1A3595A3D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiHPLe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiHPLd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:33:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5E13D7F;
        Tue, 16 Aug 2022 03:55:45 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27G8rmEx027122;
        Tue, 16 Aug 2022 09:34:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=geYC7pxhsrOmPGNgdDMXz4UoEgum44IJZcXvb3/Q1u8=;
 b=erIOhpF/ysrLzRUp2IKU/u1HlQhAYLGDNCNsvDcKVAyows0TZEK8ddJwz8BuRnH+grt8
 NxVvHTeVzd8Ib+q0KzTibMROXNZd/PSXH5AiQlQNpJRWVVY0yw+TGifPnALofXWE7Cx+
 hhNvFXUKzhdWKPS/5zgAJSUt3liwNTyghVwwjZ1CQc/lceldzU7kYFaE5oYEB95bN/vy
 XeSM4pQAugSSNjOGeSviuTcE80tNjSHi2+zhFrqSzJ01Fa9ruXh5HtiLIWL9EJiTrkv+
 hC43ogKFFS9cDoMQUPJNT29Bhc6beVvoM82RTUCbaze/UmEE/Y7MvYwYwakgS0BuaLb/ Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j084ph1ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:34:08 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27G8tcQh001763;
        Tue, 16 Aug 2022 09:34:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j084ph1tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:34:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27G9Khoc028515;
        Tue, 16 Aug 2022 09:34:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hx37jb121-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:34:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27G9Y11H30671192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 09:34:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E15B942045;
        Tue, 16 Aug 2022 09:34:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D52942042;
        Tue, 16 Aug 2022 09:34:01 +0000 (GMT)
Received: from thinkpad (unknown [9.171.21.247])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 16 Aug 2022 09:34:01 +0000 (GMT)
Date:   Tue, 16 Aug 2022 11:33:59 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared
 mappings
Message-ID: <20220816113359.33843f54@thinkpad>
In-Reply-To: <Yvq99MmpaGJBhlt4@monkey>
References: <20220811103435.188481-1-david@redhat.com>
        <20220811103435.188481-3-david@redhat.com>
        <YvVRfSYsPOraTo6o@monkey>
        <20220815153549.0288a9c6@thinkpad>
        <CADFyXm7-0zXDG+ZHjft95aAAiSZh_RyAqgJw1nGsALwEL1XKiw@mail.gmail.com>
        <20220815175929.303774fd@thinkpad>
        <CADFyXm40iiz-xFpLK4qGgHGh5Qp+98G9qxnqC20c8qtRiKt9_A@mail.gmail.com>
        <20220815203844.43b74fd1@thinkpad>
        <Yvq99MmpaGJBhlt4@monkey>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5C9jKUvD9aBXwVnKWZ0IDTmmZ3F3W8KU
X-Proofpoint-GUID: 5VabGubG1R3NgE0IFFioonvvL7qXenOy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_07,2022-08-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208160037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Aug 2022 14:43:16 -0700
Mike Kravetz <mike.kravetz@oracle.com> wrote:

> On 08/15/22 20:38, Gerald Schaefer wrote:
> > On Mon, 15 Aug 2022 20:03:20 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> > > On Mon, Aug 15, 2022 at 5:59 PM Gerald Schaefer
> > > <gerald.schaefer@linux.ibm.com> wrote:
> > > > On Mon, 15 Aug 2022 17:07:32 +0200
> > > > David Hildenbrand <david@redhat.com> wrote:
> > > > > On Mon, Aug 15, 2022 at 3:36 PM Gerald Schaefer
> > > > > <gerald.schaefer@linux.ibm.com> wrote:
> > > > > > On Thu, 11 Aug 2022 11:59:09 -0700
> > > > > > Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > > > > >
> > > > Sure, forgot to send it with initial reply...
> > > >
> > > > [   82.574749] ------------[ cut here ]------------
> > > > [   82.574751] WARNING: CPU: 9 PID: 1674 at mm/hugetlb.c:5264 hugetlb_wp+0x3be/0x818
> > > > [   82.574759] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc uvdevice s390_trng vfio_ccw mdev vfio_iommu_type1 eadm_sch vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common pkey zcrypt rng_core autofs4
> > > > [   82.574785] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not tainted 5.19.0-next-20220815 #36
> > > > [   82.574787] Hardware name: IBM 3931 A01 704 (LPAR)
> > > > [   82.574788] Krnl PSW : 0704c00180000000 00000006c9d4bc6a (hugetlb_wp+0x3c2/0x818)
> > > > [   82.574791]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > > [   82.574794] Krnl GPRS: 000000000227c000 0000000008640071 0000000000000000 0000000001200000
> > > > [   82.574796]            0000000001200000 00000000b5a98090 0000000000000255 00000000adb2c898
> > > > [   82.574797]            0000000000000000 00000000adb2c898 0000000001200000 00000000b5a98090
> > > > [   82.574799]            000000008c408000 0000000092fd7300 000003800339bc10 000003800339baf8
> > > > [   82.574803] Krnl Code: 00000006c9d4bc5c: f160000407fe        mvo     4(7,%r0),2046(1,%r0)
> > > >            00000006c9d4bc62: 47000700           bc      0,1792
> > > >           #00000006c9d4bc66: af000000           mc      0,0
> > > >           >00000006c9d4bc6a: a7a80040           lhi     %r10,64
> > > >            00000006c9d4bc6e: b916002a           llgfr   %r2,%r10
> > > >            00000006c9d4bc72: eb6ff1600004       lmg     %r6,%r15,352(%r15)
> > > >            00000006c9d4bc78: 07fe               bcr     15,%r14
> > > >            00000006c9d4bc7a: 47000700           bc      0,1792
> > > > [   82.574814] Call Trace:
> > > > [   82.574842]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> > > > [   82.574846]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> > > > [   82.574848]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> > > > [   82.574850]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> > > > [   82.574855]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> > > > [   82.574858]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> > > > [   82.574861]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > > > [   82.574866]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > > > [   82.574870] Last Breaking-Event-Address:
> > > > [   82.574871]  [<00000006c9d4b926>] hugetlb_wp+0x7e/0x818
> > > > [   82.574873] Kernel panic - not syncing: panic_on_warn set ...
> > > > [   82.574875] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not tainted 5.19.0-next-20220815 #36
> > > > [   82.574877] Hardware name: IBM 3931 A01 704 (LPAR)
> > > > [   82.574878] Call Trace:
> > > > [   82.574879]  [<00000006ca664f22>] dump_stack_lvl+0x62/0x80
> > > > [   82.574881]  [<00000006ca657af8>] panic+0x118/0x300
> > > > [   82.574884]  [<00000006c9ac3da6>] __warn+0xb6/0x160
> > > > [   82.574887]  [<00000006ca29b1ea>] report_bug+0xba/0x140
> > > > [   82.574890]  [<00000006c9a75194>] monitor_event_exception+0x44/0x80
> > > > [   82.574892]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > > > [   82.574894]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > > > [   82.574897]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> > > > [   82.574899]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> > > > [   82.574901]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> > > > [   82.574903]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> > > > [   82.574906]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> > > > [   82.574907]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> > > > [   82.574909]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > > > [   82.574912]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > > 
> > > 
> > > do_dat_exception() sets
> > >   access = VM_ACCESS_FLAGS;
> > > 
> > > do_exception() sets
> > >   is_write = (trans_exc_code & store_indication) == 0x400;
> > > 
> > > and FAULT_FLAG_WRITE
> > >    if (access == VM_WRITE || is_write)
> > >           flags |= FAULT_FLAG_WRITE;
> > > 
> > > however, for VMA permission checks it only checks
> > >   if (unlikely(!(vma->vm_flags & access)))
> > >           goto out_up;
> > > 
> > > as VM_ACCESS_FLAGS includes VM_WRITE | VM_READ ...
> > > 
> > > We end up triggering a write fault (FAULT_FLAG_WRITE), even though the
> > > VMA does not allow for writes.
> > > 
> > > I assume that's what happens and that it's a bug in s390x code.
> > > 
> > 
> > Hmm, that looks weird, but that doesn't mean it has to be broken.
> > We are talking about a pte_none() fault, not a protection exception
> > (do_dat_exception vs. do_protection_exception). Not sure if we get
> > any proper store indication in that case, but yes, this looks weird,
> > will have a closer look. Thanks for pointing out!
> > 
> > FWIW, meanwhile, I added a check to hugetlb_wp() in v5.19, for
> > (!unshare && !(vma->vm_flags & VM_WRITE)). This did not trigger,
> > however, it did trigger already before your commit. So something
> > already changed before your commit, and after v5.19.
> > 
> > Further bisecting showed that the check started to trigger
> > after commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()"),
> > and after that the "HUGETLB_ELFMAP=R linkhuge_rw" testcase also
> > started segfaulting (not sure why we did not notice earlier...).
> > 
> > Anyway, I guess this means that your commit only made that change
> > in behavior more obvious, by adding the WARN_ON_ONCE, but it really
> > was introduced by that other commit.
> > 
> > Not sure if this gives any more insight to anyone, still confused
> > by your comments on do_exception(), which also sound like a possible
> > root cause for ending up in hugetlb_wp() w/o VM_WRITE (but why only
> > after commit bcd51a3c679d?).
> 
> I know it doesn't mean much, but I did not/do not see these issues on x86.

Thanks, we were also trying to reproduce on x86, w/o success so far. But
I guess that matches David latest observations wrt to our exception handling
code on s390.

Good news is that the problem goes away when I add this simple patch, which
should result in proper VM_WRITE check for vma flags, before triggering a
FAULT_FLAG_WRITE fault:

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -379,7 +379,9 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
        flags = FAULT_FLAG_DEFAULT;
        if (user_mode(regs))
                flags |= FAULT_FLAG_USER;
-       if (access == VM_WRITE || is_write)
+       if (is_write)
+               access = VM_WRITE;
+       if (access == VM_WRITE)
                flags |= FAULT_FLAG_WRITE;
        mmap_read_lock(mm);
 
Still find it a bit hard to believe that this > 10 years old logic really
is/was broken all the time. I guess it simply did not matter for normal
PTE faults, probably because the common fault handling code later would
check itself via maybe_mkwrite(). And for hugetlb PTEs, it might not have
mattered before commit bcd51a3c679d.

> 
> bcd51a3c679d eliminates the copying of page tables at fork for non-anon
> hugetlb vmas.  So, in these tests you would likely see more pte_none()
> faults.

Yes, makes sense, assuming now that it actually is related to s390
exception handling code, not checking for VM_WRITE before triggering a
write fault for pte_none().

Thanks for checking! And Thanks a lot to David for finding that issue
in s390 exception handling code!
