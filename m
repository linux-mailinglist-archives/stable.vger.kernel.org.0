Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2E92F0E88
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbhAKIu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:50:26 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36015 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727962AbhAKIu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:50:26 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E60A92585;
        Mon, 11 Jan 2021 03:49:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 11 Jan 2021 03:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=elErUP
        QDEOOC06LNgYQ/Js6cpMQVpHLyZrtGeb6Qevw=; b=G57q9gJGFwyATMVySGNaP/
        R+Aq4G8Yi4ftOPqSKwws6P9fJQ84UmW6J616FWjV0mhGOWbkxxAsr9i2K3g72QOh
        PZX6+bG1TY/tTlCaQLCCy53XXmgadk1Amd40sJeI3U4nKGTb2B7pNpklRcP4eGkD
        x5asrwWCHstYPcuv637Xzn0l80B2N6pB2LDgbsO9lg8ZsJob0hEQ8WrcRH5GZMyz
        9V/tgi2/BJP9BomRaVb1P/aldD1tFUMRdTMPbUUgKXblxUL/EHCeT9uD0Qmcbnff
        0m4Qj40bwzxdVghnWOyGJRO8sxZ3kwSdOFuTr2JAQ5STHcJe0fabmideDHfKtCow
        ==
X-ME-Sender: <xms:DxH8X09ItOgw4vtlZ5yvSBmaF8sJF2S-nwFvcuCtAiCMqv8lVs93kw>
    <xme:DxH8X8pEA6FS5XxUc0Qsc-aC_tAPMj8_vrOmQtWLGRKxCP2-kD8Jz04plnA4F8S3T
    TYKl0_vxMnTqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DxH8X267jrVcFN5BDFCztHagfckyNdqXPJqay35mq92aPDwX-Ea4gA>
    <xmx:DxH8X8OOPXn8aCUq9L2o9sXC01gmVZFKMerexUnoi2372Q7Xy0OL6Q>
    <xmx:DxH8X4MEPLLsOB9NDV33NGXM5U2q8i1uXgRLjCeQg4fnvPRdCCF_YA>
    <xmx:DxH8X97-xEAyazKMCA4SVF2d0EXZrhowgeqxvmjIiLrezjEiGT3z-pVi67o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A09924005E;
        Mon, 11 Jan 2021 03:49:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/resctrl: Don't move a task to the same resource group" failed to apply to 4.19-stable tree
To:     fenghua.yu@intel.com, bp@suse.de, reinette.chatre@intel.com,
        shakeelb@google.com, tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:50:31 +0100
Message-ID: <16103550316795@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

