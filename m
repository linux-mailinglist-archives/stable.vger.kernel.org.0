Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963D45938F9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245575AbiHOTS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344876AbiHOTRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C940558CB;
        Mon, 15 Aug 2022 11:38:56 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FIP1Ws031013;
        Mon, 15 Aug 2022 18:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=N9LsmLK6b7t/onSqjptKTGAZ8GZfy2XWd0ZCD9Gl2Lc=;
 b=a6idzkIY5iMDybeP7NMPDwnr7PZ7krwpEI+ioN1ZybEMa8STDvfASVkUdkVE9AU1uk5u
 +uOlZENcXLAYMJVZIdq/HnIOCofa6YB+IoMoV/yI+efIqcdJ2H0QOTj1KmAvuCS3eicl
 Xdy6hVLV1CpYH8Dw9yKiK9GrJHmo6HOAcdcA2mrcTkYOQjaqOcAsuEAUD9LxNJ4QpTlV
 AaiXxpaioztf885AvYOkkOa9eapou8JpGKBT2+aHKKZRUySZ9HmpV+oyyoTP5gHbySRc
 6c/k14pjQ4luqwPz4RPvbj4ZZdvSd3zBYbSlYQhV+TyiOGM2GzUyu8p82/AaYBUUNs5R KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hyudbg9vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 18:38:52 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27FIUu7A023880;
        Mon, 15 Aug 2022 18:38:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hyudbg9v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 18:38:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27FIapT5031215;
        Mon, 15 Aug 2022 18:38:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9a937-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 18:38:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27FIcl0530998906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 18:38:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0A911C04C;
        Mon, 15 Aug 2022 18:38:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D932911C04A;
        Mon, 15 Aug 2022 18:38:46 +0000 (GMT)
Received: from thinkpad (unknown [9.171.38.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 15 Aug 2022 18:38:46 +0000 (GMT)
Date:   Mon, 15 Aug 2022 20:38:44 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared
 mappings
Message-ID: <20220815203844.43b74fd1@thinkpad>
In-Reply-To: <CADFyXm40iiz-xFpLK4qGgHGh5Qp+98G9qxnqC20c8qtRiKt9_A@mail.gmail.com>
References: <20220811103435.188481-1-david@redhat.com>
        <20220811103435.188481-3-david@redhat.com>
        <YvVRfSYsPOraTo6o@monkey>
        <20220815153549.0288a9c6@thinkpad>
        <CADFyXm7-0zXDG+ZHjft95aAAiSZh_RyAqgJw1nGsALwEL1XKiw@mail.gmail.com>
        <20220815175929.303774fd@thinkpad>
        <CADFyXm40iiz-xFpLK4qGgHGh5Qp+98G9qxnqC20c8qtRiKt9_A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rFC2ibwh4iruEGbScT8KyrrBjCjpNYOV
X-Proofpoint-GUID: O6vJICnxZbyojlSZmo1CbWyBJgEIOHXk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 adultscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208150070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Aug 2022 20:03:20 +0200
David Hildenbrand <david@redhat.com> wrote:

> On Mon, Aug 15, 2022 at 5:59 PM Gerald Schaefer
> <gerald.schaefer@linux.ibm.com> wrote:
> >
> > On Mon, 15 Aug 2022 17:07:32 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> >
> > > On Mon, Aug 15, 2022 at 3:36 PM Gerald Schaefer
> > > <gerald.schaefer@linux.ibm.com> wrote:
> > > >
> > > > On Thu, 11 Aug 2022 11:59:09 -0700
> > > > Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > > >
> > > > > On 08/11/22 12:34, David Hildenbrand wrote:
> > > > > > If we ever get a write-fault on a write-protected page in a shared mapping,
> > > > > > we'd be in trouble (again). Instead, we can simply map the page writable.
> > > > > >
> > > > > <snip>
> > > > > >
> > > > > > Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
> > > > > > unregistering and consequently keeps the PTE writeprotected. Reason for
> > > > > > this is to avoid the additional overhead when unregistering. Note
> > > > > > that this is the case also for !hugetlb and that we will end up with
> > > > > > writable PTEs that still have the uffd-wp PTE bit set once we return
> > > > > > from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, because it
> > > > > > seems to be a generic thing -- wp_page_reuse() also doesn't clear it.
> > > > > >
> > > > > > VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE
> > > > > > indicates that MAP_SHARED handling was at least envisioned, but could never
> > > > > > have worked as expected.
> > > > > >
> > > > > > While at it, make sure that we never end up in hugetlb_wp() on write
> > > > > > faults without VM_WRITE, because we don't support maybe_mkwrite()
> > > > > > semantics as commonly used in the !hugetlb case -- for example, in
> > > > > > wp_page_reuse().
> > > > >
> > > > > Nit,
> > > > > to me 'make sure that we never end up in hugetlb_wp()' implies that
> > > > > we would check for condition in callers as opposed to first thing in
> > > > > hugetlb_wp().  However, I am OK with description as it.
> > > >
> > >
> > > Hi Gerald,
> > >
> > > > Is that new WARN_ON_ONCE() in hugetlb_wp() meant to indicate a real bug?
> > >
> > > Most probably, unless I am missing something important.
> > >
> > > Something triggers FAULT_FLAG_WRITE on a VMA without VM_WRITE and
> > > hugetlb_wp() would map the pte writable.
> > > Consequently, we'd have a writable pte inside a VMA that does not have
> > > write permissions, which is dubious. My check prevents that and bails
> > > out.
> > >
> > > Ordinary (!hugetlb) faults have maybe_mkwrite() (e.g., for FOLL_FORCE
> > > or breaking COW) semantics such that we won't be mapping PTEs writable
> > > if the VMA does not have write permissions.
> > >
> > > I suspect that either
> > >
> > > a) Some write fault misses a protection check and ends up triggering a
> > > FAULT_FLAG_WRITE where we should actually fail early.
> > >
> > > b) The write fault is valid and some VMA misses proper flags (VM_WRITE).
> > >
> > > c) The write fault is valid (e.g., for breaking COW or FOLL_FORCE) and
> > > we'd actually want maybe_mkwrite semantics.
> > >
> > > > It is triggered by libhugetlbfs testcase "HUGETLB_ELFMAP=R linkhuge_rw"
> > > > (at least on s390), and crashes our CI, because it runs with panic_on_warn
> > > > enabled.
> > > >
> > > > Not sure if this means that we have bug elsewhere, allowing us to
> > > > get to the WARN in hugetlb_wp().
> > >
> > > That's what I suspect. Do you have a backtrace?
> >
> > Sure, forgot to send it with initial reply...
> >
> > [   82.574749] ------------[ cut here ]------------
> > [   82.574751] WARNING: CPU: 9 PID: 1674 at mm/hugetlb.c:5264 hugetlb_wp+0x3be/0x818
> > [   82.574759] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc uvdevice s390_trng vfio_ccw mdev vfio_iommu_type1 eadm_sch vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common pkey zcrypt rng_core autofs4
> > [   82.574785] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not tainted 5.19.0-next-20220815 #36
> > [   82.574787] Hardware name: IBM 3931 A01 704 (LPAR)
> > [   82.574788] Krnl PSW : 0704c00180000000 00000006c9d4bc6a (hugetlb_wp+0x3c2/0x818)
> > [   82.574791]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > [   82.574794] Krnl GPRS: 000000000227c000 0000000008640071 0000000000000000 0000000001200000
> > [   82.574796]            0000000001200000 00000000b5a98090 0000000000000255 00000000adb2c898
> > [   82.574797]            0000000000000000 00000000adb2c898 0000000001200000 00000000b5a98090
> > [   82.574799]            000000008c408000 0000000092fd7300 000003800339bc10 000003800339baf8
> > [   82.574803] Krnl Code: 00000006c9d4bc5c: f160000407fe        mvo     4(7,%r0),2046(1,%r0)
> >            00000006c9d4bc62: 47000700           bc      0,1792
> >           #00000006c9d4bc66: af000000           mc      0,0
> >           >00000006c9d4bc6a: a7a80040           lhi     %r10,64
> >            00000006c9d4bc6e: b916002a           llgfr   %r2,%r10
> >            00000006c9d4bc72: eb6ff1600004       lmg     %r6,%r15,352(%r15)
> >            00000006c9d4bc78: 07fe               bcr     15,%r14
> >            00000006c9d4bc7a: 47000700           bc      0,1792
> > [   82.574814] Call Trace:
> > [   82.574842]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> > [   82.574846]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> > [   82.574848]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> > [   82.574850]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> > [   82.574855]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> > [   82.574858]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> > [   82.574861]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > [   82.574866]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > [   82.574870] Last Breaking-Event-Address:
> > [   82.574871]  [<00000006c9d4b926>] hugetlb_wp+0x7e/0x818
> > [   82.574873] Kernel panic - not syncing: panic_on_warn set ...
> > [   82.574875] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not tainted 5.19.0-next-20220815 #36
> > [   82.574877] Hardware name: IBM 3931 A01 704 (LPAR)
> > [   82.574878] Call Trace:
> > [   82.574879]  [<00000006ca664f22>] dump_stack_lvl+0x62/0x80
> > [   82.574881]  [<00000006ca657af8>] panic+0x118/0x300
> > [   82.574884]  [<00000006c9ac3da6>] __warn+0xb6/0x160
> > [   82.574887]  [<00000006ca29b1ea>] report_bug+0xba/0x140
> > [   82.574890]  [<00000006c9a75194>] monitor_event_exception+0x44/0x80
> > [   82.574892]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > [   82.574894]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > [   82.574897]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> > [   82.574899]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> > [   82.574901]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> > [   82.574903]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> > [   82.574906]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> > [   82.574907]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> > [   82.574909]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > [   82.574912]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> 
> 
> do_dat_exception() sets
>   access = VM_ACCESS_FLAGS;
> 
> do_exception() sets
>   is_write = (trans_exc_code & store_indication) == 0x400;
> 
> and FAULT_FLAG_WRITE
>    if (access == VM_WRITE || is_write)
>           flags |= FAULT_FLAG_WRITE;
> 
> however, for VMA permission checks it only checks
>   if (unlikely(!(vma->vm_flags & access)))
>           goto out_up;
> 
> as VM_ACCESS_FLAGS includes VM_WRITE | VM_READ ...
> 
> We end up triggering a write fault (FAULT_FLAG_WRITE), even though the
> VMA does not allow for writes.
> 
> I assume that's what happens and that it's a bug in s390x code.
> 

Hmm, that looks weird, but that doesn't mean it has to be broken.
We are talking about a pte_none() fault, not a protection exception
(do_dat_exception vs. do_protection_exception). Not sure if we get
any proper store indication in that case, but yes, this looks weird,
will have a closer look. Thanks for pointing out!

FWIW, meanwhile, I added a check to hugetlb_wp() in v5.19, for
(!unshare && !(vma->vm_flags & VM_WRITE)). This did not trigger,
however, it did trigger already before your commit. So something
already changed before your commit, and after v5.19.

Further bisecting showed that the check started to trigger
after commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()"),
and after that the "HUGETLB_ELFMAP=R linkhuge_rw" testcase also
started segfaulting (not sure why we did not notice earlier...).

Anyway, I guess this means that your commit only made that change
in behavior more obvious, by adding the WARN_ON_ONCE, but it really
was introduced by that other commit.

Not sure if this gives any more insight to anyone, still confused
by your comments on do_exception(), which also sound like a possible
root cause for ending up in hugetlb_wp() w/o VM_WRITE (but why only
after commit bcd51a3c679d?).
