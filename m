Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478BE3AEC6F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFUPeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:34:12 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:54185 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230312AbhFUPeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 11:34:12 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4B72C19403DE;
        Mon, 21 Jun 2021 11:31:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 21 Jun 2021 11:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9/h4TD
        O8nAKFxGkEJwL9w1ffz3pykBf8JtPM88fav3o=; b=BUbIdQAMQB5nlIfM93GJf6
        U996E+lNYSbFIeSIvpA7q9u0Itxd8Dz7iJKFnteFN+/n2vRbaZGuys8AlN/V66WR
        wH3FxBagFHC/rdspRiYl7F0pRDxrtIGV2UpQC3NVWVIEI8LtU1IrvUQW4WtK5pDC
        VmsI4xdjTwdNy/3GexVmPYRc8Wwrj3yj86VNliXxriD6BIOuQMZwO+9f9POmOkb9
        h09N8UFOK+7dBCjHfc6m8qmFu+n4s8QAjSpGjPCY6BgrI3j3srAIMra+dB3RStIU
        +az8SM0F3u4Z9GwlzH4lDGyOndkQhsPMQqUEmgs7UjO8ulCc91XJlEpmPUREnbmQ
        ==
X-ME-Sender: <xms:7bDQYH01xvZRIVhoDjfI_Gg2tAno_4gPz9b4lO8OjRf2duEfP5wGmw>
    <xme:7bDQYGEwpSMfoFShSG9hJ8E4cB8J60tNoiOUYq_gLoPLs5bf_3qlvpE4l6QA_sH0E
    -3aIO6tfGOXNQ>
X-ME-Received: <xmr:7bDQYH4XmUVtmvav4o-mvGQeYtTP_GJFv9ODtRIi56IVg-gnzJ079BthxkbJg0_iGcV1wsq0J73iDlQh5ABqovuUmBmZJtNi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:7bDQYM2gVV6oEdDsRWnP5d_rsrwsZcQy67RLQ66012jShtm7YWIv6A>
    <xmx:7bDQYKFpLVgI0uHPnPV7wybsVoNEtUubdDZJWDzBYgbjkssv95aYMQ>
    <xmx:7bDQYN87j9fmLjGCovo1uf67C--U-GQf7Zu8WbYCN6UC7be-TOkHfw>
    <xmx:7bDQYGCeic02Jya-AnWmqDyMJa0KuoYFHpT6KIwRv_6-M4F88rJfyQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 11:31:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: debugfs: Add and remove endpoint dirs dynamically" failed to apply to 4.14-stable tree
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 17:31:53 +0200
Message-ID: <1624289513235110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 8d396bb0a5b62b326f6be7594d8bd46b088296bd Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Sat, 29 May 2021 12:29:32 -0700
Subject: [PATCH] usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

The DWC3 DebugFS directory and files are currently created once
during probe.  This includes creation of subdirectories for each
of the gadget's endpoints.  This works fine for peripheral-only
controllers, as dwc3_core_init_mode() calls dwc3_gadget_init()
just prior to calling dwc3_debugfs_init().

However, for dual-role controllers, dwc3_core_init_mode() will
instead call dwc3_drd_init() which is problematic in a few ways.
First, the initial state must be determined, then dwc3_set_mode()
will have to schedule drd_work and by then dwc3_debugfs_init()
could have already been invoked.  Even if the initial mode is
peripheral, dwc3_gadget_init() happens after the DebugFS files
are created, and worse so if the initial state is host and the
controller switches to peripheral much later.  And secondly,
even if the gadget endpoints' debug entries were successfully
created, if the controller exits peripheral mode, its dwc3_eps
are freed so the debug files would now hold stale references.

So it is best if the DebugFS endpoint entries are created and
removed dynamically at the same time the underlying dwc3_eps are.
Do this by calling dwc3_debugfs_create_endpoint_dir() as each
endpoint is created, and conversely remove the DebugFS entry when
the endpoint is freed.

Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210529192932.22912-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index d0ac89c5b317..d223c54115f4 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -413,9 +413,12 @@ static inline const char *dwc3_gadget_generic_cmd_status_string(int status)
 
 
 #ifdef CONFIG_DEBUG_FS
+extern void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep);
 extern void dwc3_debugfs_init(struct dwc3 *d);
 extern void dwc3_debugfs_exit(struct dwc3 *d);
 #else
+static inline void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
+{  }
 static inline void dwc3_debugfs_init(struct dwc3 *d)
 {  }
 static inline void dwc3_debugfs_exit(struct dwc3 *d)
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index 7146ee2ac057..5dbbe53269d3 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -886,30 +886,14 @@ static void dwc3_debugfs_create_endpoint_files(struct dwc3_ep *dep,
 	}
 }
 
-static void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep,
-		struct dentry *parent)
+void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
 {
 	struct dentry		*dir;
 
-	dir = debugfs_create_dir(dep->name, parent);
+	dir = debugfs_create_dir(dep->name, dep->dwc->root);
 	dwc3_debugfs_create_endpoint_files(dep, dir);
 }
 
-static void dwc3_debugfs_create_endpoint_dirs(struct dwc3 *dwc,
-		struct dentry *parent)
-{
-	int			i;
-
-	for (i = 0; i < dwc->num_eps; i++) {
-		struct dwc3_ep	*dep = dwc->eps[i];
-
-		if (!dep)
-			continue;
-
-		dwc3_debugfs_create_endpoint_dir(dep, parent);
-	}
-}
-
 void dwc3_debugfs_init(struct dwc3 *dwc)
 {
 	struct dentry		*root;
@@ -940,7 +924,6 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 				&dwc3_testmode_fops);
 		debugfs_create_file("link_state", 0644, root, dwc,
 				    &dwc3_link_state_fops);
-		dwc3_debugfs_create_endpoint_dirs(dwc, root);
 	}
 }
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 88270eee8a48..f14c2aa83759 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2753,6 +2753,8 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
 	INIT_LIST_HEAD(&dep->started_list);
 	INIT_LIST_HEAD(&dep->cancelled_list);
 
+	dwc3_debugfs_create_endpoint_dir(dep);
+
 	return 0;
 }
 
@@ -2796,6 +2798,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 			list_del(&dep->endpoint.ep_list);
 		}
 
+		debugfs_remove_recursive(debugfs_lookup(dep->name, dwc->root));
 		kfree(dep);
 	}
 }

