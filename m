Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0721A2F0E89
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbhAKIu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:50:27 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52547 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727962AbhAKIu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:50:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 424F52576;
        Mon, 11 Jan 2021 03:49:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:49:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pWEEPY
        Fn9I7hnmo4jmJI4gf0fTapywLYk4BpPHyUFFo=; b=SrrTtfnHQMQ7i/ZqlPhVaj
        px+PXguDGEYHAqpz1dvyxkv4h97b4oU4lXo5sPThTazwwcdJ2ErSNo8YxQoUG0A1
        KHKFvfXz1i5AqM6lug1Qrw6K/Hku7qJHpdks8KEQzQORt6oGj9rd/wuVpfiwbXtd
        aUIJ1R8NpG9KbW6jD7+J8fGwCnu3BoB7OGj1u4GAsNlflCJj6fE8ChWHCVBcUHr2
        +LC3Z7wFsRKbopksxCVzpCorx0uOaeUAF1ra4g/PHnzfJRvrPPJQlGCEkrOv3esZ
        ZRCmd+mcp9598Kk3m2sfniz11vjgkiNI+MSAy4yJ/YN80JE9vKuW2Bwjgz0Yld3g
        ==
X-ME-Sender: <xms:EBH8X7KV9Ix2lsbDuQ5dHbRaETq_IeAtzKT6g6d7lRi_JDoM8eQC3w>
    <xme:EBH8X_LEr2ZL0gJkWe3UTmWgXdFqS-sLnyuB0vq5Q1kDFIyPbJXl4uOcrw8W_nIKJ
    jIpbMk44FWkfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EBH8XzufQAZBb5Et7Li6BuDqDYBwE6cbw9GJbE4wFAfTOXw7o09e4A>
    <xmx:EBH8X0Y62vGK7ZdoG43mnQynJc9-TnRKytvJlhhxT_hYnkarkZSTcw>
    <xmx:EBH8XyZ4EbOeMo49fIyWUjzEu6Nv7aJchiiyKecvVvCs-SV6knclYw>
    <xmx:EBH8XyHe_XKTWKZIxhUF05Y_cLr2aqUBZ5VCr2TzpuUAFU2KXo0s6_0yjh0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A984108005B;
        Mon, 11 Jan 2021 03:49:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/resctrl: Don't move a task to the same resource group" failed to apply to 5.4-stable tree
To:     fenghua.yu@intel.com, bp@suse.de, reinette.chatre@intel.com,
        shakeelb@google.com, tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:50:32 +0100
Message-ID: <161035503243210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a0195f314a25582b38993bf30db11c300f4f4611 Mon Sep 17 00:00:00 2001
From: Fenghua Yu <fenghua.yu@intel.com>
Date: Thu, 17 Dec 2020 14:31:19 -0800
Subject: [PATCH] x86/resctrl: Don't move a task to the same resource group

Shakeel Butt reported in [1] that a user can request a task to be moved
to a resource group even if the task is already in the group. It just
wastes time to do the move operation which could be costly to send IPI
to a different CPU.

Add a sanity check to ensure that the move operation only happens when
the task is not already in the resource group.

[1] https://lore.kernel.org/lkml/CALvZod7E9zzHwenzf7objzGKsdBmVwTgEJ0nPgs0LUFU3SN5Pw@mail.gmail.com/

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Reported-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/962ede65d8e95be793cb61102cca37f7bb018e66.1608243147.git.reinette.chatre@intel.com

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 1c6f8a60ac52..460f3e0df106 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -546,6 +546,13 @@ static void update_task_closid_rmid(struct task_struct *t)
 static int __rdtgroup_move_task(struct task_struct *tsk,
 				struct rdtgroup *rdtgrp)
 {
+	/* If the task is already in rdtgrp, no need to move the task. */
+	if ((rdtgrp->type == RDTCTRL_GROUP && tsk->closid == rdtgrp->closid &&
+	     tsk->rmid == rdtgrp->mon.rmid) ||
+	    (rdtgrp->type == RDTMON_GROUP && tsk->rmid == rdtgrp->mon.rmid &&
+	     tsk->closid == rdtgrp->mon.parent->closid))
+		return 0;
+
 	/*
 	 * Set the task's closid/rmid before the PQR_ASSOC MSR can be
 	 * updated by them.

