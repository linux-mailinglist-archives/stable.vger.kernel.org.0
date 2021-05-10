Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26817377E0D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhEJIXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:23:43 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44371 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhEJIXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:23:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id A1B681940B54;
        Mon, 10 May 2021 04:22:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 May 2021 04:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fvKemO
        XAL/LU1G7Rct3/rg9FUjoW3A+0CGFcAV+Mi9o=; b=ViNXOqJCTMDqYcKkM8vIX3
        ey4SQs0/2wK/xo7jydsRHIQeZRUI5TMEPzDbtpmHCuTS392FWdDs3WKNUZA+UfT6
        gPxE5QSC6TT3WTINGT/O+/gLndhsUHTt/lThijOzbysBadCzYoVvghfbAKFoqFU7
        b3hm8NY4xLdsgqBtmHOydQP7Mz8rsJRXYkvAnLpDrZPht020ypUPz7squo8cMYyf
        SXloJIQWukjhZWQDbpcGIRcbpJyD7fYBwje6koCRubExXPBEDHf2wq2DxQQwoomG
        QPqYAtGo8J65X4/czuLxeCtPGJd1C+dV8lIYzC2toGV2RmAobZGZm+SqV3QUusoQ
        ==
X-ME-Sender: <xms:Tu2YYM9i_dTgsVXq5TW_mZma5WOFP-j3gBR4WWuztajx1L3Oqyg2IA>
    <xme:Tu2YYEsoczdnBOQ3C0Lp1IrAw2ugTal-LMjVw5HDXi6yqWlgfuxWggaSq7SQgeVw_
    CX2m_XtTFAIqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Tu2YYCDivzjpYnzizF4FVPaCQ1xb9MQlUDfwU80lMjViHLVVN9ANBQ>
    <xmx:Tu2YYMdzPwk8Jp9nju4PjEI8m1bK0Krb_I57VbB2byV3g_pNVXbtLQ>
    <xmx:Tu2YYBPawHsamkPhVWS2fq5e-Rn_CmIL6ZTbeSCbiM7Kst0xQdAQxQ>
    <xmx:Tu2YYKb218lMsusHMYl-LvyWvyTY9VHWnn16XgOIqmBF7mIpx_zOug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:22:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc2: Fix partial power down exiting by system resume" failed to apply to 5.4-stable tree
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:22:26 +0200
Message-ID: <1620634946143151@kroah.com>
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

From c74c26f6e398387cc953b3fdb54858f09bfb696b Mon Sep 17 00:00:00 2001
From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Date: Thu, 8 Apr 2021 13:46:06 +0400
Subject: [PATCH] usb: dwc2: Fix partial power down exiting by system resume

Fixes the implementation of exiting from partial power down
power saving mode when PC is resumed.

Added port connection status checking which prevents exiting from
Partial Power Down mode from _dwc2_hcd_resume() if not in Partial
Power Down mode.

Rearranged the implementation to get rid of many "if"
statements.

NOTE: Switch case statement is used for hibernation partial
power down and clock gating mode determination. In this patch
only Partial Power Down is implemented the Hibernation and
clock gating implementations are planned to be added.

Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with DWC2_POWER_DOWN_PARAM_NONE")
Cc: <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210408094607.1A9BAA0094@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 34030bafdff4..f096006df96f 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4427,7 +4427,7 @@ static int _dwc2_hcd_resume(struct usb_hcd *hcd)
 {
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	unsigned long flags;
-	u32 pcgctl;
+	u32 hprt0;
 	int ret = 0;
 
 	spin_lock_irqsave(&hsotg->lock, flags);
@@ -4438,11 +4438,40 @@ static int _dwc2_hcd_resume(struct usb_hcd *hcd)
 	if (hsotg->lx_state != DWC2_L2)
 		goto unlock;
 
-	if (hsotg->params.power_down > DWC2_POWER_DOWN_PARAM_PARTIAL) {
+	hprt0 = dwc2_read_hprt0(hsotg);
+
+	/*
+	 * Added port connection status checking which prevents exiting from
+	 * Partial Power Down mode from _dwc2_hcd_resume() if not in Partial
+	 * Power Down mode.
+	 */
+	if (hprt0 & HPRT0_CONNSTS) {
+		hsotg->lx_state = DWC2_L0;
+		goto unlock;
+	}
+
+	switch (hsotg->params.power_down) {
+	case DWC2_POWER_DOWN_PARAM_PARTIAL:
+		ret = dwc2_exit_partial_power_down(hsotg, 0, true);
+		if (ret)
+			dev_err(hsotg->dev,
+				"exit partial_power_down failed\n");
+		/*
+		 * Set HW accessible bit before powering on the controller
+		 * since an interrupt may rise.
+		 */
+		set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+		break;
+	case DWC2_POWER_DOWN_PARAM_HIBERNATION:
+	case DWC2_POWER_DOWN_PARAM_NONE:
+	default:
 		hsotg->lx_state = DWC2_L0;
 		goto unlock;
 	}
 
+	/* Change Root port status, as port status change occurred after resume.*/
+	hsotg->flags.b.port_suspend_change = 1;
+
 	/*
 	 * Enable power if not already done.
 	 * This must not be spinlocked since duration
@@ -4454,52 +4483,25 @@ static int _dwc2_hcd_resume(struct usb_hcd *hcd)
 		spin_lock_irqsave(&hsotg->lock, flags);
 	}
 
-	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_PARTIAL) {
-		/*
-		 * Set HW accessible bit before powering on the controller
-		 * since an interrupt may rise.
-		 */
-		set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-
-
-		/* Exit partial_power_down */
-		ret = dwc2_exit_partial_power_down(hsotg, 0, true);
-		if (ret && (ret != -ENOTSUPP))
-			dev_err(hsotg->dev, "exit partial_power_down failed\n");
-	} else {
-		pcgctl = readl(hsotg->regs + PCGCTL);
-		pcgctl &= ~PCGCTL_STOPPCLK;
-		writel(pcgctl, hsotg->regs + PCGCTL);
-	}
-
-	hsotg->lx_state = DWC2_L0;
-
+	/* Enable external vbus supply after resuming the port. */
 	spin_unlock_irqrestore(&hsotg->lock, flags);
+	dwc2_vbus_supply_init(hsotg);
 
-	if (hsotg->bus_suspended) {
-		spin_lock_irqsave(&hsotg->lock, flags);
-		hsotg->flags.b.port_suspend_change = 1;
-		spin_unlock_irqrestore(&hsotg->lock, flags);
-		dwc2_port_resume(hsotg);
-	} else {
-		if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_PARTIAL) {
-			dwc2_vbus_supply_init(hsotg);
-
-			/* Wait for controller to correctly update D+/D- level */
-			usleep_range(3000, 5000);
-		}
+	/* Wait for controller to correctly update D+/D- level */
+	usleep_range(3000, 5000);
+	spin_lock_irqsave(&hsotg->lock, flags);
 
-		/*
-		 * Clear Port Enable and Port Status changes.
-		 * Enable Port Power.
-		 */
-		dwc2_writel(hsotg, HPRT0_PWR | HPRT0_CONNDET |
-				HPRT0_ENACHG, HPRT0);
-		/* Wait for controller to detect Port Connect */
-		usleep_range(5000, 7000);
-	}
+	/*
+	 * Clear Port Enable and Port Status changes.
+	 * Enable Port Power.
+	 */
+	dwc2_writel(hsotg, HPRT0_PWR | HPRT0_CONNDET |
+			HPRT0_ENACHG, HPRT0);
 
-	return ret;
+	/* Wait for controller to detect Port Connect */
+	spin_unlock_irqrestore(&hsotg->lock, flags);
+	usleep_range(5000, 7000);
+	spin_lock_irqsave(&hsotg->lock, flags);
 unlock:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 

