Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC89C20C8B9
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgF1Pi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:38:29 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38561 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgF1Pi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:38:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B1A861940620;
        Sun, 28 Jun 2020 11:38:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 11:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eqsqgh
        Xp8Yx8UeeQyLOIPt2NuuMdeSBfKLGvLtRzUeY=; b=uRXmGvuv+wRLp0We/Ctkoi
        3U+UzsTuYqEsDtB3C6TchRI8CLr+9FKYMlbCj6o4y28m2yY2vrIBGl0s63KCU/tr
        CibQ5+p3Ag32EUBdqxCkcssSCrtP0RoQefVdeiKZPNlgeskpT44ye1W2vCoBVW+N
        Yzpk4CNzriG0BKn8LseOiT+qywjM1WS/mAl5jQ47ZsgN+MRO2dKyUWpIMkqa5SHy
        lby5n9S2dslNqtVNG5y6oztthqZmoRJGLhx30RC3xMhNt1Hr7bWR9yp5PsCZhL2Y
        xzA5B+5OzwzQH+i5JjNMxXwYe3fAeO/famd9NVzfGBQnJ1NSdCRVT2DYxeqWLj4Q
        ==
X-ME-Sender: <xms:dLn4Xu-O4JKzZ1QtLEdPmD46OXeeJFEx-Ec-jYmKeJKotvI3rwLy8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dLn4XuuxUZjK3J2cW8u9bll9JSG3vD7eSgR6wuU7DaE_XMzsQmjzYg>
    <xmx:dLn4XkA7pgZckbYPDl3I2Ahodzv7O7fIbiFi4v40vSM1o-Mlj14xUA>
    <xmx:dLn4Xmcm5pH-ss68o_M7LAxRyPCqCwquKIp5a6WG_31Vrav-jrOFhg>
    <xmx:dLn4XlWAx5IIH9VWeoT6KjcemOlCHaoww6kHzXWbvGGDh-ReMFbadg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B34253067B98;
        Sun, 28 Jun 2020 11:38:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xhci: Poll for U0 after disabling USB2 LPM" failed to apply to 4.14-stable tree
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jun 2020 17:38:19 +0200
Message-ID: <1593358699218117@kroah.com>
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

From b3d71abd135e6919ca0b6cab463738472653ddfb Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 24 Jun 2020 16:59:49 +0300
Subject: [PATCH] xhci: Poll for U0 after disabling USB2 LPM

USB2 devices with LPM enabled may interrupt the system suspend:
[  932.510475] usb 1-7: usb suspend, wakeup 0
[  932.510549] hub 1-0:1.0: hub_suspend
[  932.510581] usb usb1: bus suspend, wakeup 0
[  932.510590] xhci_hcd 0000:00:14.0: port 9 not suspended
[  932.510593] xhci_hcd 0000:00:14.0: port 8 not suspended
..
[  932.520323] xhci_hcd 0000:00:14.0: Port change event, 1-7, id 7, portsc: 0x400e03
..
[  932.591405] PM: pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -16
[  932.591414] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x160 returns -16
[  932.591418] PM: Device 0000:00:14.0 failed to suspend async: error -16

During system suspend, USB core will let HC suspends the device if it
doesn't have remote wakeup enabled and doesn't have any children.
However, from the log above we can see that the usb 1-7 doesn't get bus
suspended due to not in U0. After a while the port finished U2 -> U0
transition, interrupts the suspend process.

The observation is that after disabling LPM, port doesn't transit to U0
immediately and can linger in U2. xHCI spec 4.23.5.2 states that the
maximum exit latency for USB2 LPM should be BESL + 10us. The BESL for
the affected device is advertised as 400us, which is still not enough
based on my testing result.

So let's use the maximum permitted latency, 10000, to poll for U0
status to solve the issue.

Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200624135949.22611-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f97106e2860f..ed468eed299c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4475,6 +4475,9 @@ static int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 			mutex_lock(hcd->bandwidth_mutex);
 			xhci_change_max_exit_latency(xhci, udev, 0);
 			mutex_unlock(hcd->bandwidth_mutex);
+			readl_poll_timeout(ports[port_num]->addr, pm_val,
+					   (pm_val & PORT_PLS_MASK) == XDEV_U0,
+					   100, 10000);
 			return 0;
 		}
 	}

