Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63B74113F0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 14:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhITME6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 08:04:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33970 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231645AbhITME5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 08:04:57 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K9sunx015755;
        Mon, 20 Sep 2021 08:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=PXlivad2y0opsdLjjZTGeznpLvJ0aQ8XkjVS+v3kY98=;
 b=bPZNee10Yf1bjTeog8uBJZK0R/kyBOVUbwwkItPxKisRUCsyLhT4alRUw88CpJVpDL9E
 ggRgNviu9Jbi7KYHAIpQUdkJmJo9fyG9wzTZKZp5cLwNaKBFnDtcqtGqkEKvxQ0tIbD5
 1ORLNZn3d3qtuhpLEymZWvunLeHY5Rw+kl1sMxlwhbj6rWVc6mzfumiwMQHxfMcNIh/X
 CxH8ZG97OZCzmN5T229bIgu6U9AKg8DomLYhCs6NSf21OWtQuSyXhTjSChgY1KyT3rTo
 Meh39pEdonWWcrVBdZLWRC2ev9lwAjSRrfZ8Fn+y2xNud5Djzttthamkk+7XXhELIVlQ pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjxyrkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 08:03:23 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KBwCKc026044;
        Mon, 20 Sep 2021 08:03:23 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjxyrk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 08:03:23 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KC37Yr021719;
        Mon, 20 Sep 2021 12:03:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cj7c0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 12:03:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KC3Hb941812478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 12:03:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19C8311C081;
        Mon, 20 Sep 2021 12:03:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57A1A11C0B7;
        Mon, 20 Sep 2021 12:03:16 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.153.169])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Sep 2021 12:03:16 +0000 (GMT)
Date:   Mon, 20 Sep 2021 15:03:14 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     bp@suse.de, dave.hansen@intel.com, david@redhat.com,
        jolsa@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/mm: Fix kern_addr_valid() to cope
 with existing but not" failed to apply to 4.4-stable tree
Message-ID: <YUh4gss5hNFWOdYu@linux.ibm.com>
References: <163212171511930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163212171511930@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vqqfvrmoy7oz0g6NQrDRiYgAkYjXtL_J
X-Proofpoint-ORIG-GUID: fiKHTZma2pRDPf41lnI75lL-vRzp4nVQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_06,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1011 suspectscore=0 priorityscore=1501
 adultscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200077
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 20, 2021 at 09:08:35AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The version below applies to both v4.4 and v4.9:

From 997cc522b7c683ed13a8a4e44672fe4164b7d611 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Thu, 19 Aug 2021 16:27:17 +0300
Subject: [PATCH] x86/mm: fix kern_addr_valid to cope with existing but not present entries

Jiri Olsa reported a fault when running:

	# cat /proc/kallsyms | grep ksys_read
	ffffffff8136d580 T ksys_read
	# objdump -d --start-address=0xffffffff8136d580 --stop-address=0xffffffff8136d590 /proc/kcore

	/proc/kcore:     file format elf64-x86-64

	Segmentation fault

krava33 login: [   68.330612] general protection fault, probably for non-canonical address 0xf887ffcbff000: 0000 [#1] SMP PTI
[   68.333118] CPU: 12 PID: 1079 Comm: objdump Not tainted 5.14.0-rc5qemu+ #508
[   68.334922] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
[   68.336945] RIP: 0010:kern_addr_valid+0x150/0x300
[   68.338082] Code: 1f 40 00 48 8b 0d e8 12 61 01 48 85 f6 0f 85 ca 00 00 00 48 81 e1 00 f0 ff ff 48 21 c1 48 b8 00 00 00 00 80 88 ff ff 48 01 ca <48> 8b 3c 02 48 f7 c7 9f ff ff ff 0f 84 d8 fe ff ff 48 89 f8 0f 1f
[   68.342220] RSP: 0018:ffffc90000bcbc38 EFLAGS: 00010206
[   68.343428] RAX: ffff888000000000 RBX: 0000000000001000 RCX: 000ffffffcbff000
[   68.345029] RDX: 000ffffffcbff000 RSI: 0000000000000000 RDI: 800ffffffcbff062
[   68.346599] RBP: ffffc90000bcbea8 R08: 0000000000001000 R09: 0000000000000000
[   68.349000] R10: 0000000000000000 R11: 0000000000001000 R12: 00007fcc0fd80010
[   68.350804] R13: ffffffff83400000 R14: 0000000000400000 R15: ffffffff843d23e0
[   68.352609] FS:  00007fcc111fcc80(0000) GS:ffff888275e00000(0000) knlGS:0000000000000000
[   68.354638] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.356104] CR2: 00007fcc0fd80000 CR3: 000000011226e004 CR4: 0000000000770ee0
[   68.357896] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.359694] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   68.361597] PKRU: 55555554
[   68.362460] Call Trace:
[   68.363252]  read_kcore+0x57f/0x920
[   68.364289]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.365630]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.366955]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.368277]  ? trace_hardirqs_on+0x1b/0xd0
[   68.369462]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.370793]  ? lock_acquire+0x195/0x2f0
[   68.371920]  ? lock_acquire+0x195/0x2f0
[   68.373035]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.374364]  ? lock_acquire+0x195/0x2f0
[   68.375498]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.376831]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.379883]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.381268]  ? lock_release+0x22b/0x3e0
[   68.382458]  ? _raw_spin_unlock+0x1f/0x30
[   68.383685]  ? __handle_mm_fault+0xcfc/0x15f0
[   68.384994]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.386389]  ? lock_acquire+0x195/0x2f0
[   68.387573]  ? rcu_read_lock_sched_held+0x12/0x80
[   68.388969]  ? lock_release+0x22b/0x3e0
[   68.390145]  proc_reg_read+0x55/0xa0
[   68.391257]  ? vfs_read+0x78/0x1b0
[   68.392336]  vfs_read+0xa7/0x1b0
[   68.393328]  ksys_read+0x68/0xe0
[   68.394308]  do_syscall_64+0x3b/0x90
[   68.395391]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   68.396804] RIP: 0033:0x7fcc11cf92e2
[   68.397824] Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 2e 0a 00 e8 95 e9 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[   68.402420] RSP: 002b:00007ffd6e0f8da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   68.404357] RAX: ffffffffffffffda RBX: 0000565439305b20 RCX: 00007fcc11cf92e2
[   68.406061] RDX: 0000000000800000 RSI: 00007fcc0f980010 RDI: 0000000000000003
[   68.407747] RBP: 00007fcc11dcd300 R08: 0000000000000003 R09: 00007fcc0d980010
[   68.410937] R10: 0000000003826000 R11: 0000000000000246 R12: 00007fcc0f980010
[   68.412624] R13: 0000000000000d68 R14: 00007fcc11dcc700 R15: 0000000000800000
[   68.414322] Modules linked in: intel_rapl_msr intel_rapl_common nfit kvm_intel kvm irqbypass rapl iTCO_wdt iTCO_vendor_support i2c_i801 i2c_smbus lpc_ich drm drm_panel_orientation_quirks zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
[   68.419591] ---[ end trace e2c30f827226966b ]---
[   68.420969] RIP: 0010:kern_addr_valid+0x150/0x300
[   68.422308] Code: 1f 40 00 48 8b 0d e8 12 61 01 48 85 f6 0f 85 ca 00 00 00 48 81 e1 00 f0 ff ff 48 21 c1 48 b8 00 00 00 00 80 88 ff ff 48 01 ca <48> 8b 3c 02 48 f7 c7 9f ff ff ff 0f 84 d8 fe ff ff 48 89 f8 0f 1f
[   68.426826] RSP: 0018:ffffc90000bcbc38 EFLAGS: 00010206
[   68.428150] RAX: ffff888000000000 RBX: 0000000000001000 RCX: 000ffffffcbff000
[   68.429813] RDX: 000ffffffcbff000 RSI: 0000000000000000 RDI: 800ffffffcbff062
[   68.431465] RBP: ffffc90000bcbea8 R08: 0000000000001000 R09: 0000000000000000
[   68.433115] R10: 0000000000000000 R11: 0000000000001000 R12: 00007fcc0fd80010
[   68.434768] R13: ffffffff83400000 R14: 0000000000400000 R15: ffffffff843d23e0
[   68.436423] FS:  00007fcc111fcc80(0000) GS:ffff888275e00000(0000) knlGS:0000000000000000
[   68.438354] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.442077] CR2: 00007fcc0fd80000 CR3: 000000011226e004 CR4: 0000000000770ee0
[   68.443727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.445370] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   68.447010] PKRU: 55555554

The fault happens because kern_addr_valid() dereferences existent but not
present PMD in the high kernel mappings.

Such PMDs are created when free_kernel_image_pages() frees regions larger
than 2Mb. In this case a part of the freed memory is mapped with PMDs and
the set_memory_np_noalias() -> ... -> __change_page_attr() sequence will
mark the PMD as not present rather than wipe it completely.

Make kern_addr_valid() to check whether higher level page table entries are
present before trying to dereference them to fix this issue and to avoid
similar issues in the future.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>	# 4.4+
Tested-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
---
 arch/x86/mm/init_64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d76ec9348cff..547d80fc76d7 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1182,21 +1182,21 @@ int kern_addr_valid(unsigned long addr)
 		return 0;
 
 	pud = pud_offset(pgd, addr);
-	if (pud_none(*pud))
+	if (!pud_present(*pud))
 		return 0;
 
 	if (pud_large(*pud))
 		return pfn_valid(pud_pfn(*pud));
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (!pmd_present(*pmd))
 		return 0;
 
 	if (pmd_large(*pmd))
 		return pfn_valid(pmd_pfn(*pmd));
 
 	pte = pte_offset_kernel(pmd, addr);
-	if (pte_none(*pte))
+	if (!pte_present(*pte))
 		return 0;
 
 	return pfn_valid(pte_pfn(*pte));
-- 
2.28.0

 
