Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C973C35B22D
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 09:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhDKHWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 03:22:12 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51967 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhDKHWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 03:22:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A8FCE14F0;
        Sun, 11 Apr 2021 03:21:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Apr 2021 03:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8hO+lT
        U+EH+jQH+/7IiM1vP4rW5Mfirxd0HRBcjOLLw=; b=tsonJK0ouJv8vGclL9jBaX
        I7Xgj9lf6ARHKJcUBGwfYsGyZr9As4x00bSMKt6sC7tvo1+NdieP3Hj4xtIS3cQA
        lPLjHaCnHgExIIdbTXqXop4/cnRTGVt+dncttNMOGwWfrf4mNznMCBEL+sdvgLAF
        dFxM07eBV0TeHVMHYsnlxAguz9iXyFI98ahFEsvwRKzZJcxpcO2lpuBTjhMa9wRL
        ctRsTLCXOtLBv90K9d73VyubwSxhskRPjJZVl8I88IJkHSLqFIafNc7Zj51wKX2/
        /HFDS7bvkSRlCcUAuvwSS2hAwG5MEQ9/mOboBQkR0ikb/2EQ5Ic9G0MvGvEytYKg
        ==
X-ME-Sender: <xms:lKNyYFJ1vpD9a67DbpAtRnWN9NPu3SGFTNI9G-E1gW_2qrIn9OTzxA>
    <xme:lKNyYBK8DUpTArwYnc2Q801Jp4-udH48kZCPkHcm_yS_eTASmOstavGQ935HjjNZo
    9ACZspJU8tSrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lKNyYNuXydKFpGVY6SDrO4SzUjTDsp-KHPtFo6VeZhoYiVHleol2og>
    <xmx:lKNyYGbWCwvFD0MpomGD_uHzIOo-4_rKjvUwtY8RNZUj_67VCPy8YA>
    <xmx:lKNyYMax9axZCrioh6qOoXQQPeCo61pdhy7PTh9_a5t0rjbqHiTNAQ>
    <xmx:lKNyYFC1QYGQmFz41o_84DztJ6sicfMSFf5d-MtrUn_bRjzZcjnVz7BUe2Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDD7124005C;
        Sun, 11 Apr 2021 03:21:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: synchronize event handler with sysfs code paths" failed to apply to 4.4-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Apr 2021 09:21:53 +0200
Message-ID: <1618125713122194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814 Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Mon, 29 Mar 2021 19:36:51 -0600
Subject: [PATCH] usbip: synchronize event handler with sysfs code paths

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to synchronize event handler with sysfs paths
in usbip drivers.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/c5c8723d3f29dfe3d759cfaafa7dd16b0dfe2918.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
index 5d88917c9631..086ca76dd053 100644
--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -70,6 +70,7 @@ static void event_handler(struct work_struct *work)
 	while ((ud = get_event()) != NULL) {
 		usbip_dbg_eh("pending event %lx\n", ud->event);
 
+		mutex_lock(&ud->sysfs_lock);
 		/*
 		 * NOTE: shutdown must come first.
 		 * Shutdown the device.
@@ -90,6 +91,7 @@ static void event_handler(struct work_struct *work)
 			ud->eh_ops.unusable(ud);
 			unset_event(ud, USBIP_EH_UNUSABLE);
 		}
+		mutex_unlock(&ud->sysfs_lock);
 
 		wake_up(&ud->eh_waitq);
 	}

