Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A75312F61
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhBHKp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:45:28 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:43875 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232680AbhBHKnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:43:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 14A811940F69;
        Mon,  8 Feb 2021 05:42:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FDtqn/
        0gin9Vb09ZAJGRhznYIVRbpkX1xwxTz8N2PW0=; b=TJj9larj4B9RyER/5eymMe
        vKvh6Uq0gr5l2v/Tdq7N/i3QbNbfgaUU3VOq0/LZAjDsWiAm/y/689FAbq/eqfer
        BZ5wICFPt2drFAxEeft1P08mWzC4YKlxYlt7S5LEEAGmDMPDvRX+ov0y5COi2IjD
        gnTZ8AqiGSQcXtJWCwOdKi6juLZnwAwbViD072mGejybdZ3mo7leW/DEpD18GmaX
        1hh4aOdFB8BFUtLpc3ITR6Wwmjx9wLkyk1ZDGOPreF7OQNEMOTWtuTW3Epx/R8LQ
        0NGvL5phd1mte8QcV/qaNEiGHGZKbueZGGo9p4ZpPzmDCvjNofkYJ/4CJgD9tcog
        ==
X-ME-Sender: <xms:dxUhYIraoSzvrJhDCaOdbkVmmLVtKn4GjHCW74LcXZAJv5u0dUsBGQ>
    <xme:dxUhYOokcNbB31i2rxGl2OA51UPrz_SY_hP9KwSUElOhMPZBXdNR7YuhNf1F9OiwM
    -VDnHRBZ-wqcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:dxUhYNNLAvpipKAw_wVxFiB-LMXme0mKS3ujabvXezuo5l1ak8crLg>
    <xmx:dxUhYP5GgagpxKRSi5BUkukZfcW7yuayLE-YqYOaCnJF9VA_6qhvyA>
    <xmx:dxUhYH4yP9dKhPnrlv5hQhTfXMNeF4g13jBaXhfXmwyYFrmUCgDreQ>
    <xmx:eBUhYHHRgkoyx9CvQez-4mbH6h-CBgcxz-D1hGjCJttPvrM-GlB5fg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B37ED108005F;
        Mon,  8 Feb 2021 05:41:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdkfd: fix null pointer panic while free buffer in kfd" failed to apply to 5.10-stable tree
To:     ray.huang@amd.com, Felix.Kuehling@amd.com,
        alexander.deucher@amd.com, changzhu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:41:58 +0100
Message-ID: <1612780918127252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b99a8c8f239d76820bbed33c1a42c381cc1f16db Mon Sep 17 00:00:00 2001
From: Huang Rui <ray.huang@amd.com>
Date: Mon, 1 Feb 2021 18:39:16 +0800
Subject: [PATCH] drm/amdkfd: fix null pointer panic while free buffer in kfd

In drm_gem_object_free, it will call funcs of drm buffer obj. So
kfd_alloc should use amdgpu_gem_object_create instead of
amdgpu_bo_create to initialize the funcs as amdgpu_gem_object_funcs.

[  396.231390] amdgpu: Release VA 0x7f76b4ada000 - 0x7f76b4add000
[  396.231394] amdgpu:   remove VA 0x7f76b4ada000 - 0x7f76b4add000 in entry 0000000085c24a47
[  396.231408] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  396.231445] #PF: supervisor read access in kernel mode
[  396.231466] #PF: error_code(0x0000) - not-present page
[  396.231484] PGD 0 P4D 0
[  396.231495] Oops: 0000 [#1] SMP NOPTI
[  396.231509] CPU: 7 PID: 1352 Comm: clinfo Tainted: G           OE     5.11.0-rc2-custom #1
[  396.231537] Hardware name: AMD Celadon-RN/Celadon-RN, BIOS WCD0401N_Weekly_20_04_0 04/01/2020
[  396.231563] RIP: 0010:drm_gem_object_free+0xc/0x22 [drm]
[  396.231606] Code: eb ec 48 89 c3 eb e7 0f 1f 44 00 00 55 48 89 e5 48 8b bf 00 06 00 00 e8 72 0d 01 00 5d c3 0f 1f 44 00 00 48 8b 87 40 01 00 00 <48> 8b 00 48 85 c0 74 0b 55 48 89 e5 e8 54 37 7c db 5d c3 0f 0b c3
[  396.231666] RSP: 0018:ffffb4704177fcf8 EFLAGS: 00010246
[  396.231686] RAX: 0000000000000000 RBX: ffff993a0d0cc400 RCX: 0000000000003113
[  396.231711] RDX: 0000000000000001 RSI: e9cda7a5d0791c6d RDI: ffff993a333a9058
[  396.231736] RBP: ffffb4704177fdd0 R08: ffff993a03855858 R09: 0000000000000000
[  396.231761] R10: ffff993a0d1f7158 R11: 0000000000000001 R12: 0000000000000000
[  396.231785] R13: ffff993a0d0cc428 R14: 0000000000003000 R15: ffffb4704177fde0
[  396.231811] FS:  00007f76b5730740(0000) GS:ffff993b275c0000(0000) knlGS:0000000000000000
[  396.231840] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  396.231860] CR2: 0000000000000000 CR3: 000000016d2e2000 CR4: 0000000000350ee0
[  396.231885] Call Trace:
[  396.231897]  ? amdgpu_amdkfd_gpuvm_free_memory_of_gpu+0x24c/0x25f [amdgpu]
[  396.232056]  ? __dynamic_dev_dbg+0xcd/0x100
[  396.232076]  kfd_ioctl_free_memory_of_gpu+0x91/0x102 [amdgpu]
[  396.232214]  kfd_ioctl+0x211/0x35b [amdgpu]
[  396.232341]  ? kfd_ioctl_get_queue_wave_state+0x52/0x52 [amdgpu]

Fixes: 246cb7e49a70 ("drm/amdgpu: Introduce GEM object functions")
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Changfeng <changzhu@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 2d991da2cead..d1ed4f8df2b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -26,6 +26,7 @@
 #include <linux/sched/task.h>
 
 #include "amdgpu_object.h"
+#include "amdgpu_gem.h"
 #include "amdgpu_vm.h"
 #include "amdgpu_amdkfd.h"
 #include "amdgpu_dma_buf.h"
@@ -1152,7 +1153,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	struct sg_table *sg = NULL;
 	uint64_t user_addr = 0;
 	struct amdgpu_bo *bo;
-	struct amdgpu_bo_param bp;
+	struct drm_gem_object *gobj;
 	u32 domain, alloc_domain;
 	u64 alloc_flags;
 	int ret;
@@ -1220,19 +1221,14 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	pr_debug("\tcreate BO VA 0x%llx size 0x%llx domain %s\n",
 			va, size, domain_string(alloc_domain));
 
-	memset(&bp, 0, sizeof(bp));
-	bp.size = size;
-	bp.byte_align = 1;
-	bp.domain = alloc_domain;
-	bp.flags = alloc_flags;
-	bp.type = bo_type;
-	bp.resv = NULL;
-	ret = amdgpu_bo_create(adev, &bp, &bo);
+	ret = amdgpu_gem_object_create(adev, size, 1, alloc_domain, alloc_flags,
+				       bo_type, NULL, &gobj);
 	if (ret) {
 		pr_debug("Failed to create BO on domain %s. ret %d\n",
-				domain_string(alloc_domain), ret);
+			 domain_string(alloc_domain), ret);
 		goto err_bo_create;
 	}
+	bo = gem_to_amdgpu_bo(gobj);
 	if (bo_type == ttm_bo_type_sg) {
 		bo->tbo.sg = sg;
 		bo->tbo.ttm->sg = sg;

