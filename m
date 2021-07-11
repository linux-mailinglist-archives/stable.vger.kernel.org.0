Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5858C3C3DC8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhGKQBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 12:01:52 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37307 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232719AbhGKQBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 12:01:51 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 616EA1AC0CD4;
        Sun, 11 Jul 2021 11:59:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 11:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rEJoNj
        lX5VMRxFW4H3Ou5BIzZ9/Lx9q+eqkAFgQ3S2s=; b=DCCI6kUSGIVU7F+/e+4S5c
        rPfvpOJrfqpxmx4QkVy/viyBK56kU8CEHN3rz6AIblN5L66WW1wWMkDEmy9y2CUG
        fHVx03iOa3D45knxOjGh/Q4dpYptl3x+tDjImkmOj5Xm1B7FVipZSTeTZSaXGNYn
        KqCzA9ZWSCOsG6OYa+ZLpn1LHrE6HrW9awVZzBQUt5iMF2fla7rI8JqlD/06Nm2k
        iRnV5HL7PqMZOfHy7OcAbOs3IshNX435ZFuImT3ynj07h1bdz6ygn24oKep+dWn1
        GnjvkPQ7PPJfk0kPm9mU8FUOjVj3KQac9P9jApyOJjtYicSEYAhzUkeilkUmNAtw
        ==
X-ME-Sender: <xms:RxXrYHD-KlDZ4pm_6TgrWfb0-vg7LBKIBuKrD6dHj0ebVcSi0jvYlA>
    <xme:RxXrYNgRHbq9hrcbn-9Gu0BopDTrs3B8jTvNRzCkWIxyEu0P1Pd3sfRZppSTJpLMv
    5nJo0VmZc5EMg>
X-ME-Received: <xmr:RxXrYCkB6RaznXKhCl5AZd1yVQGfQ2MLm_MKElJ7mA_6UqGtbY2Dx9z3fmZhhcv5bdD3HORVZm5pNj-y1T-FI5YmLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:RxXrYJzA7_zz6-MBP7ZQpcjG7WbuX6jPzFa7hk54fWn6fS-u6l22kQ>
    <xmx:RxXrYMTuNC2rzbEu6a7czBloXYC2eVicFbSV_UlPBgt7vtTpqFPYjg>
    <xmx:RxXrYMZdpGO32pJY5M9sDaIducLMjU31s5OhSwZShL8XNkDqzFWpDQ>
    <xmx:SBXrYCP4hMRpu_dI2AevhX0weGcyTWD8mV5hXFfuOmyvbD4ISEnysZVBdN0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 11:59:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bus: mhi: core: Fix power down latency" failed to apply to 5.12-stable tree
To:     loic.poulain@linaro.org, bbhatt@codeaurora.org,
        gregkh@linuxfoundation.org, hemantk@codeaurora.org,
        manivannan.sadhasivam@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 17:59:00 +0200
Message-ID: <1626019140114105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 44b1eba44dc537edf076f131f1eeee7544d0e04f Mon Sep 17 00:00:00 2001
From: Loic Poulain <loic.poulain@linaro.org>
Date: Mon, 21 Jun 2021 21:46:10 +0530
Subject: [PATCH] bus: mhi: core: Fix power down latency

On graceful power-down/disable transition, when an MHI reset is
performed, the MHI device loses its context, including interrupt
configuration. However, the current implementation is waiting for
event(irq) driven state change to confirm reset has been completed,
which never happens, and causes reset timeout, leading to unexpected
high latency of the mhi_power_down procedure (up to 45 seconds).

Fix that by moving to the recently introduced poll_reg_field method,
waiting for the reset bit to be cleared, in the same way as the
power_on procedure.

Cc: stable@vger.kernel.org
Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Link: https://lore.kernel.org/r/1620029090-8975-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210621161616.77524-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index e2e59a341fef..704a5e225097 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -465,23 +465,15 @@ static void mhi_pm_disable_transition(struct mhi_controller *mhi_cntrl)
 
 	/* Trigger MHI RESET so that the device will not access host memory */
 	if (!MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state)) {
-		u32 in_reset = -1;
-		unsigned long timeout = msecs_to_jiffies(mhi_cntrl->timeout_ms);
-
 		dev_dbg(dev, "Triggering MHI Reset in device\n");
 		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
 
 		/* Wait for the reset bit to be cleared by the device */
-		ret = wait_event_timeout(mhi_cntrl->state_event,
-					 mhi_read_reg_field(mhi_cntrl,
-							    mhi_cntrl->regs,
-							    MHICTRL,
-							    MHICTRL_RESET_MASK,
-							    MHICTRL_RESET_SHIFT,
-							    &in_reset) ||
-					!in_reset, timeout);
-		if (!ret || in_reset)
-			dev_err(dev, "Device failed to exit MHI Reset state\n");
+		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				 MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 0,
+				 25000);
+		if (ret)
+			dev_err(dev, "Device failed to clear MHI Reset\n");
 
 		/*
 		 * Device will clear BHI_INTVEC as a part of RESET processing,

