Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E308335B22F
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhDKHXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 03:23:17 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33237 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhDKHXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 03:23:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7DC2614BF;
        Sun, 11 Apr 2021 03:22:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Apr 2021 03:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sDVmb5
        j/85MhHTK2t5JR8AFCysMk1CprnOXAKD0MV40=; b=dpYOznaFfnp1qyQS2zA7P/
        tcoCiiDFrdbvB2ymHscg63Vrnq4DSocMtIUGlovj51cmCO/rfidyIT2lO4x0gPPY
        0tZqiRcBLOo0BJbqsNZqK5W9jF/4Y/iME2cMJlLQlqFCzwuUC1xkaQZEZyolPfLa
        sQZqrjLHKZjrixqphZwHt8V/GvPUbSGLFNHw9d0MtXLYtjTDpf7Y6S3R1exemFcs
        oqb00SDyidmIOWzwY5Lzqxy3OHdL7vTRRLNDMrhigZry2At9nwH4Ux1/w4XFG/ty
        s20zznDKELdFYq5BFWI6jC5YXpFQx6OtWDaQE+L4WNG7LkjA7zMnOG9BQVFi9htA
        ==
X-ME-Sender: <xms:06NyYPeY5Hk3SXvGmVBuk2uJZlUyd4KQOufaxIX80G6seuCB4akJZA>
    <xme:06NyYFMnbcVxWNTE4IViNqTdJ8By5kxQ-oY2zmshLVn4bfQMjbCSXlC8DS2TNBr9d
    BD7WDvvnru3Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:06NyYIioslJKuxOY7sGEG4jitzgUgL4uNyMCptPvz6-hoPaW-_JNbw>
    <xmx:06NyYA9ev0v9xBNYyVpMTo0Xg1kH_Z5Bt5-Bv8BEQJdc9pL5Y0J0cg>
    <xmx:06NyYLtKFCPL_F8YnE3uwnHW9ikpqaefBSkbjKZfzUJ_MhONuetCIQ>
    <xmx:06NyYJ1OqZt1_wDCSL0hhiFskXvVrUpVlMEcnV7orPPC-mWvRv91vahfUsg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBBD324005C;
        Sun, 11 Apr 2021 03:22:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] driver core: Fix locking bug in" failed to apply to 4.19-stable tree
To:     saravanak@google.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Apr 2021 09:22:56 +0200
Message-ID: <1618125776191186@kroah.com>
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

From eed6e41813deb9ee622cd9242341f21430d7789f Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Thu, 1 Apr 2021 21:03:40 -0700
Subject: [PATCH] driver core: Fix locking bug in
 deferred_probe_timeout_work_func()

list_for_each_entry_safe() is only useful if we are deleting nodes in a
linked list within the loop. It doesn't protect against other threads
adding/deleting nodes to the list in parallel. We need to grab
deferred_probe_mutex when traversing the deferred_probe_pending_list.

Cc: stable@vger.kernel.org
Fixes: 25b4e70dcce9 ("driver core: allow stopping deferred probe after init")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210402040342.2944858-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e2cf3b29123e..37a5e5f8b221 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -292,14 +292,16 @@ int driver_deferred_probe_check_state(struct device *dev)
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
-	struct device_private *private, *p;
+	struct device_private *p;
 
 	driver_deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
-	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
-		dev_info(private->device, "deferred probe pending\n");
+	mutex_lock(&deferred_probe_mutex);
+	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
+		dev_info(p->device, "deferred probe pending\n");
+	mutex_unlock(&deferred_probe_mutex);
 	wake_up_all(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);

