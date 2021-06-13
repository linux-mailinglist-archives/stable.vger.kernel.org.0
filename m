Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4FF3A5829
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhFMMDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:03:35 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55981 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:03:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5CDB21940653;
        Sun, 13 Jun 2021 08:01:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 08:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9/h4TD
        O8nAKFxGkEJwL9w1ffz3pykBf8JtPM88fav3o=; b=vs1tR0nc63nwiVqxK7Yf9O
        wtl//vMSNGhnAobaoriohy7iNqIDF8P83RUgntr+BOFaJHUOyvO681Tvhu4XULZ4
        gGsClSWbnvgzO1ilHxIwCSDWhm5rM+dFXbPoq14jNyKZiA/3UVnPuup28lh1d3c7
        hxQZcveS/e0DWO3FtR3nlRqrtlVXWyFC9YqIUvRXz1l4u/f1IV0GjG4X2F1B4IUh
        tFhazwjcjpAnREwKVNk5sOx1tlEGNm3POzY1i4DfZDl66rEQq6y9gjvajm/nk2EL
        jOfdkrf+AxqnkUYeCtV90sPGccrUitled5xjZqLkbB6hOMgVlDMVY8oMlvemFjkg
        ==
X-ME-Sender: <xms:nfPFYAM6ExqLxErR_qroitz-ELdMNxwC9MXNHHfz3IvV07DQOiIwAA>
    <xme:nfPFYG-BCL0IystZc1AfVPDdWnNu-X7dHaPsH5wXOs_dlbh_i4nMob5f4iZJtURiP
    9lTIdymRTpMMA>
X-ME-Received: <xmr:nfPFYHQunazndOJqqLyMlphEDYbN1tro9FsLoEgleFPP2NWhHcdzmcqGsJu4aL3q0sphJzAnNoXM8FkQi8XzdypN9XoXtvu4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:nfPFYItrfGY5MHqHHK4ZBaYB5jq4E7LnBMa-VggPmLIwAwbYj4tOuA>
    <xmx:nfPFYIdwAFZ1HgT1JEsum3ooheOhVS0P3mi-Mev84K4w8Ov1ZlTdQw>
    <xmx:nfPFYM3Po1I9gtwpdk8dgoSfDyyJRIwTYsSr_0QjViwPx8b2sViXkA>
    <xmx:nvPFYA6Cd6Z9cL6lHnRHYBw6HCOBpcUxpf3aIV-WisBbHRz2h5BgUQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:01:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: debugfs: Add and remove endpoint dirs dynamically" failed to apply to 4.14-stable tree
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:01:30 +0200
Message-ID: <162358569021671@kroah.com>
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

