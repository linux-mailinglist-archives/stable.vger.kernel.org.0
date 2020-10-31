Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C012A1500
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 10:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgJaJ4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 05:56:03 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:44241 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726621AbgJaJ4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 05:56:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 865D81940FA4;
        Sat, 31 Oct 2020 05:56:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 31 Oct 2020 05:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LDpQN+
        62IbM0E2MIKYIWKVc+XNd/TCk5e+f5xs6Uzl4=; b=USYaTPiKjWFcCatb+LV9x/
        TOI9d+IUT77yW5ksK+dKuxKZjWIHfrKHZnO12vpGeZGeeBkdla1A9H+UTaeWN+f8
        v3cYoKY+ci6N6Iqb4Qf8tVildvEOqCV5xHXDAAw7OSAksilIoBS4sHgYhowZP17+
        l73mbvv8T8RWPotfVAmpJ9iNrcxZC6ju2rQgBTDbf5BLNHaoVq1Ve0XRoZFDoTXp
        LS5WnKGOXtQpsYtqOWsJYSb7NLS/q0GxHKIlPn8U7+Hwu5r7nk8O3G5IqFYRmskw
        KVzBOnGfxLTHSjjZbryjl82kMa4H2mw1H8PVRa1RUrWBuMKFX592hBEBFtSnhbQw
        ==
X-ME-Sender: <xms:sDSdXz5YACZD5W2XXiYO_PtKilr_KxsLpMtA-ZN_NoZd9m15dssE6Q>
    <xme:sDSdX45ii-KTKVE3T2XVvyDYLNnV_0DcCwMCtiy5cnbcIKBmtBjgI9RLDt2DBSH5U
    W099xWO7VD8yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleejgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:sDSdX6fiLKYULDqUuW4O-Qsi506T-uCf6JWkGFAFoXjWpnvJk3NqSA>
    <xmx:sDSdX0L3lR11oJnpckYula5eX-8pUUqnav8aEc5leC4KtkD-PcShkw>
    <xmx:sDSdX3JXG75LvmqU22OSehytDf5a_zNnXbivSVm8ilD0UvMTOlhC7g>
    <xmx:sTSdX5wN_--duNd7PUzh8AAF9AmFW-uAW1ZSA5ZZqjqjOGpC42Mq4A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1FB84328005A;
        Sat, 31 Oct 2020 05:56:00 -0400 (EDT)
Subject: WTF: patch "[PATCH] ima: Remove semicolon at the end of" was seriously submitted to be applied to the 5.9-stable tree?
To:     roberto.sassu@huawei.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Oct 2020 10:55:59 +0100
Message-ID: <160413815912161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.9-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4be92db3b5667f3a5c874a04635b037dc5e3f373 Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Fri, 4 Sep 2020 11:23:29 +0200
Subject: [PATCH] ima: Remove semicolon at the end of
 ima_get_binary_runtime_size()

This patch removes the unnecessary semicolon at the end of
ima_get_binary_runtime_size().

Cc: stable@vger.kernel.org
Fixes: d158847ae89a2 ("ima: maintain memory size needed for serializing the measurement list")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index fb4ec270f620..c096ef8945c7 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -133,7 +133,7 @@ unsigned long ima_get_binary_runtime_size(void)
 		return ULONG_MAX;
 	else
 		return binary_runtime_size + sizeof(struct ima_kexec_hdr);
-};
+}
 
 static int ima_pcr_extend(struct tpm_digest *digests_arg, int pcr)
 {

