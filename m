Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED221C3A9B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgEDM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 08:57:59 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47433 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbgEDM56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 08:57:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id AAB78547;
        Mon,  4 May 2020 08:57:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 08:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qdAHwR
        njQA3xMNTI+7+HHmUUmuNoh/VK4XwhBP3yzXI=; b=lSnM3RBq89Aoq4ZbTxmZ4f
        9Q0Q5/DHjjjUnUuCcLt1npSX9Vxw51ajnZ6anFhPUg3BBtZQmI487di1YER/F+FL
        a65uE1Wy0REgfBweU3yW9b8jsgQ5F7FT5tyB3Zk8/Tl8b093gMoG5o+DGpbOLAZB
        kuVoeBcQ6VV43j6g74ZeBvLOvAqgFvliIIHcfmB4zFI/A/PRBcdNgBcvJli7zXfB
        MuqVZkqLNFdBWYliyqDd7fCqUTixRtI/ERUStaYP1rAqIojXsgS2HVXeihXoGD+g
        7KP1bl5ZL9hIrVfUh4OagpZ+iYHHFNa/CagT5IzY5q6OEeTUiG3z8MGlwLoX7mqQ
        ==
X-ME-Sender: <xms:VRGwXnDtkTgwMCjVgsbOi2Hw6ve3Wb7JTrVkM3hrjqkywzg6riLBcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiudevuedtueeggfevteeitdduheelkefgleejffeghf
    fgjeefvddugeelvedutdenucffohhmrghinhepqhgvmhhurdhorhhgpdhkvghrnhgvlhdr
    ohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:VRGwXg8Xlmmww6gXyRAOqbUP7eMr_r1vUO50Kp4nsVo9oHVI7X9vlA>
    <xmx:VRGwXu0nRq_xCej2zk4p_SnarjCJgR1a0P3JorDyPZHNmqnzhJ4DtQ>
    <xmx:VRGwXiydh-KwFl0ltcUwlMkjUMsZec1z-kK82lBIO5KIq0wGvPYUsQ>
    <xmx:VRGwXunf1uEDo7oNVnkpUWq2NOuWdnXOx-OoMNdBrnNiHMtsOmm7oeQMh5M>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E075A3066016;
        Mon,  4 May 2020 08:57:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/core: Prevent mixed use of FDs between shared ufiles" failed to apply to 4.14-stable tree
To:     leonro@mellanox.com, jgg@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 14:57:53 +0200
Message-ID: <158859707369223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0fb00941dc63990a10951146df216fc7b0e20bc2 Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leonro@mellanox.com>
Date: Tue, 21 Apr 2020 11:29:28 +0300
Subject: [PATCH] RDMA/core: Prevent mixed use of FDs between shared ufiles

FDs can only be used on the ufile that created them, they cannot be mixed
to other ufiles. We are lacking a check to prevent it.

  BUG: KASAN: null-ptr-deref in atomic64_sub_and_test include/asm-generic/atomic-instrumented.h:1547 [inline]
  BUG: KASAN: null-ptr-deref in atomic_long_sub_and_test include/asm-generic/atomic-long.h:460 [inline]
  BUG: KASAN: null-ptr-deref in fput_many+0x1a/0x140 fs/file_table.c:336
  Write of size 8 at addr 0000000000000038 by task syz-executor179/284

  CPU: 0 PID: 284 Comm: syz-executor179 Not tainted 5.5.0-rc5+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  Call Trace:
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x94/0xce lib/dump_stack.c:118
   __kasan_report+0x18f/0x1b7 mm/kasan/report.c:510
   kasan_report+0xe/0x20 mm/kasan/common.c:639
   check_memory_region_inline mm/kasan/generic.c:185 [inline]
   check_memory_region+0x15d/0x1b0 mm/kasan/generic.c:192
   atomic64_sub_and_test include/asm-generic/atomic-instrumented.h:1547 [inline]
   atomic_long_sub_and_test include/asm-generic/atomic-long.h:460 [inline]
   fput_many+0x1a/0x140 fs/file_table.c:336
   rdma_lookup_put_uobject+0x85/0x130 drivers/infiniband/core/rdma_core.c:692
   uobj_put_read include/rdma/uverbs_std_types.h:96 [inline]
   _ib_uverbs_lookup_comp_file drivers/infiniband/core/uverbs_cmd.c:198 [inline]
   create_cq+0x375/0xba0 drivers/infiniband/core/uverbs_cmd.c:1006
   ib_uverbs_create_cq+0x114/0x140 drivers/infiniband/core/uverbs_cmd.c:1089
   ib_uverbs_write+0xaa5/0xdf0 drivers/infiniband/core/uverbs_main.c:769
   __vfs_write+0x7c/0x100 fs/read_write.c:494
   vfs_write+0x168/0x4a0 fs/read_write.c:558
   ksys_write+0xc8/0x200 fs/read_write.c:611
   do_syscall_64+0x9c/0x390 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x44ef99
  Code: 00 b8 00 01 00 00 eb e1 e8 74 1c 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007ffc0b74c028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 00007ffc0b74c030 RCX: 000000000044ef99
  RDX: 0000000000000040 RSI: 0000000020000040 RDI: 0000000000000005
  RBP: 00007ffc0b74c038 R08: 0000000000401830 R09: 0000000000401830
  R10: 00007ffc0b74c038 R11: 0000000000000246 R12: 0000000000000000
  R13: 0000000000000000 R14: 00000000006be018 R15: 0000000000000000

Fixes: cf8966b3477d ("IB/core: Add support for fd objects")
Link: https://lore.kernel.org/r/20200421082929.311931-2-leon@kernel.org
Suggested-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 5128cb16bb48..8f480de5596a 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -360,7 +360,7 @@ lookup_get_fd_uobject(const struct uverbs_api_object *obj,
 	 * uverbs_uobject_fd_release(), and the caller is expected to ensure
 	 * that release is never done while a call to lookup is possible.
 	 */
-	if (f->f_op != fd_type->fops) {
+	if (f->f_op != fd_type->fops || uobject->ufile != ufile) {
 		fput(f);
 		return ERR_PTR(-EBADF);
 	}

