Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFB429C847
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 20:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829319AbgJ0TE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 15:04:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1829313AbgJ0TE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 15:04:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RJ2BK2048482;
        Tue, 27 Oct 2020 15:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bCy2xH+AjAyhLFkSzKrpu4+tH0gcsqeTR7dukXpPFoo=;
 b=hPvlQ4xN+b4t8zowjEKQ70/YggSnDA8hILi8jf+6WnH1Z+gCEbO0Db0WCpE3U9B0YBn5
 49HZQ3RPwcg2i/+mx9TgNHzdDTCPdT9mi1MuV5atSysMHmPUmelJUkYcdNHh70yEoTei
 HOpXARRL5P/P8WuzCOr/ngbNGvdZEjAYNID7y5IffAWzlTRMGyXpA4oNaOoC8giunTpo
 ll1yaFYhxkJRBnvCE2gr9hRjhwFUDkoeEAcAEDcffbIdtyZs4uex1B/YZXct4X8gGBvE
 lDFqbEnuKVxuBMnkV+96ql0EJ6L3J2KBPjRElxWL7odoEbKOVJNDqjzodgiGlOQOaUuy hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dydtqxuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 15:04:14 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09RJ3GFu053294;
        Tue, 27 Oct 2020 15:04:13 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dydtqxtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 15:04:13 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RIr3ht008168;
        Tue, 27 Oct 2020 19:04:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 34cbhh3p8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 19:04:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RJ48M031982012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:04:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AB3FAE058;
        Tue, 27 Oct 2020 19:04:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E79A9AE056;
        Tue, 27 Oct 2020 19:04:07 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.41.45])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 19:04:07 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     nathanl@linux.ibm.com, cheloha@linux.ibm.com, mhocko@suse.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] mm/slub: fix panic in slab_alloc_node()
Date:   Tue, 27 Oct 2020 20:04:06 +0100
Message-Id: <20201027190406.33283-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <7ef64e75-2150-01a9-074d-a754348683b3@suse.cz>
References: <7ef64e75-2150-01a9-074d-a754348683b3@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_10:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270109
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While doing memory hot-unplug operation on a PowerPC VM running 1024 CPUs
with 11TB of ram, I hit the following panic:

BUG: Kernel NULL pointer dereference on read at 0x00000007
Faulting instruction address: 0xc000000000456048
Oops: Kernel access of bad area, sig: 11 [#2]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp
CPU: 160 PID: 1 Comm: systemd Tainted: G      D           5.9.0 #1
NIP:  c000000000456048 LR: c000000000455fd4 CTR: c00000000047b350
REGS: c00006028d1b77a0 TRAP: 0300   Tainted: G      D            (5.9.0)
MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24004228  XER: 00000000
CFAR: c00000000000f1b0 DAR: 0000000000000007 DSISR: 40000000 IRQMASK: 0
GPR00: c000000000455fd4 c00006028d1b7a30 c000000001bec800 0000000000000000
GPR04: 0000000000000dc0 0000000000000000 00000000000374ef c00007c53df99320
GPR08: 000007c53c980000 0000000000000000 000007c53c980000 0000000000000000
GPR12: 0000000000004400 c00000001e8e4400 0000000000000000 0000000000000f6a
GPR16: 0000000000000000 c000000001c25930 c000000001d62528 00000000000000c1
GPR20: c000000001d62538 c00006be469e9000 0000000fffffffe0 c0000000003c0ff8
GPR24: 0000000000000018 0000000000000000 0000000000000dc0 0000000000000000
GPR28: c00007c513755700 c000000001c236a4 c00007bc4001f800 0000000000000001
NIP [c000000000456048] __kmalloc_node+0x108/0x790
LR [c000000000455fd4] __kmalloc_node+0x94/0x790
Call Trace:
[c00006028d1b7a30] [c00007c51af92000] 0xc00007c51af92000 (unreliable)
[c00006028d1b7aa0] [c0000000003c0ff8] kvmalloc_node+0x58/0x110
[c00006028d1b7ae0] [c00000000047b45c] mem_cgroup_css_online+0x10c/0x270
[c00006028d1b7b30] [c000000000241fd8] online_css+0x48/0xd0
[c00006028d1b7b60] [c00000000024af14] cgroup_apply_control_enable+0x2c4/0x470
[c00006028d1b7c40] [c00000000024e838] cgroup_mkdir+0x408/0x5f0
[c00006028d1b7cb0] [c0000000005a4ef0] kernfs_iop_mkdir+0x90/0x100
[c00006028d1b7cf0] [c0000000004b8168] vfs_mkdir+0x138/0x250
[c00006028d1b7d40] [c0000000004baf04] do_mkdirat+0x154/0x1c0
[c00006028d1b7dc0] [c000000000032b38] system_call_exception+0xf8/0x200
[c00006028d1b7e20] [c00000000000c740] system_call_common+0xf0/0x27c
Instruction dump:
e93e0000 e90d0030 39290008 7cc9402a e94d0030 e93e0000 7ce95214 7f89502a
2fbc0000 419e0018 41920230 e9270010 <89290007> 7f994800 419e0220 7ee6bb78

This pointing to the following code:

mm/slub.c:2851
        if (unlikely(!object || !node_match(page, node))) {
c000000000456038:       00 00 bc 2f     cmpdi   cr7,r28,0
c00000000045603c:       18 00 9e 41     beq     cr7,c000000000456054 <__kmalloc_node+0x114>
node_match():
mm/slub.c:2491
        if (node != NUMA_NO_NODE && page_to_nid(page) != node)
c000000000456040:       30 02 92 41     beq     cr4,c000000000456270 <__kmalloc_node+0x330>
page_to_nid():
include/linux/mm.h:1294
c000000000456044:       10 00 27 e9     ld      r9,16(r7)
c000000000456048:       07 00 29 89     lbz     r9,7(r9)	<<<< r9 = NULL
node_match():
mm/slub.c:2491
c00000000045604c:       00 48 99 7f     cmpw    cr7,r25,r9
c000000000456050:       20 02 9e 41     beq     cr7,c000000000456270 <__kmalloc_node+0x330>

The panic occurred in slab_alloc_node() when checking for the page's node:
	object = c->freelist;
	page = c->page;
	if (unlikely(!object || !node_match(page, node))) {
		object = __slab_alloc(s, gfpflags, node, addr, c);
		stat(s, ALLOC_SLOWPATH);

The issue is that object is not NULL while page is NULL which is odd but
may happen if the cache flush happened after loading object but before
loading page. Thus checking for the page pointer is required too.

The cache flush is done through an inter processor interrupt when a piece
of memory is off-lined. That interrupt is triggered when a memory
hot-unplug operation is initiated and offline_pages() is calling the slub's
MEM_GOING_OFFLINE callback slab_mem_going_offline_callback() which is
calling flush_cpu_slab(). If that interrupt is caught between the
reading of c->freelist and the reading of c->page, this could lead to such
a situation. That situation is expected and the later call to
this_cpu_cmpxchg_double() will detect the change to c->freelist and redo
the whole operation.

In commit 6159d0f5c03e ("mm/slub.c: page is always non-NULL in
node_match()") check on the page pointer has been removed assuming that
page is always valid when it is called. It happens that this is not true in
that particular case, so check for page before calling node_match() here.

Fixes: 6159d0f5c03e ("mm/slub.c: page is always non-NULL in node_match()")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8f66de8a5ab3..7dc5c6aaf4b7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2852,7 +2852,7 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node))) {
+	if (unlikely(!object || !page || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
-- 
2.29.1

