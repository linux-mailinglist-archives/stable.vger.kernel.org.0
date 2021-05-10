Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD08377E04
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEJIW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:22:57 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:46215 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230140AbhEJIW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:22:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C645319401AA;
        Mon, 10 May 2021 04:21:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 04:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=c8RvKZ
        NERcFthOvpI1hK16pnKXt6ALjkVHJT678D8f0=; b=KTLrm52SDzjaETmS5hjL54
        ryCqKavvCXprEj/7roc0IRCKM4d3adpdoi80vP7ajOvPfrkU4z2l/FuXfrtOILVe
        sqBGbefnmWbKLT43m92hk5jEh3+agHK8vJkNM/8VSkXOrPewRmpwk/ZmNlASnNsV
        y5EoXXBLSkOmB2YlUNFuP1wsWEBfqFRxSCoAacY64nWBDKYx28sFY67Rv0/zNv7N
        5bMlXrAJYKBhxQOdKgcNhCz0vDatj2bRYGWmhHYEA4/wHcmFwwE5uFA1IDyDEr28
        WY+Ek7l0VCdrE3n0cXbUKXVfDoEDTCKLSidCNHvucDfQrfWeUMH01WhDIoRfcGOA
        ==
X-ME-Sender: <xms:H-2YYM624m9YDp_ArWVqFDOCZe6-yeoy-8T-FZp5gOUH8zEd5lwSog>
    <xme:H-2YYN4Fo8VLh_riHJ9iJ64PDx8jYT8WrUdOITBw6QkA4XqN4BCOPSvE56XYAWQoC
    oXGW50RByrUgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:H-2YYLdLt4GjTpzOp_parPhYdflMl1MpW50F0JZ5KOr8tobN2odYZg>
    <xmx:H-2YYBITqazLCgTOcEe9YA1IiQlNUUJQGjny4ANpr-r4JoyT4cfNBg>
    <xmx:H-2YYAIP-9cGo3QPdMJXIVyNwdCx8_KCbRHVLWtEiwfn9ULCzyf3Lw>
    <xmx:H-2YYI9rw-441qvCsV2GVZ_UupEtRY7cMEYDFHK91scg0WCaD8uKfA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:21:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: core: Do core softreset when switch mode" failed to apply to 4.14-stable tree
To:     chenyu56@huawei.com, Thinh.Nguyen@synopsys.com,
        andy.shevchenko@gmail.com, fntoth@gmail.com,
        gregkh@linuxfoundation.org, john.stultz@linaro.org,
        stable@vger.kernel.org, wcheng@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:21:40 +0200
Message-ID: <1620634900144151@kroah.com>
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

From f88359e1588b85cf0e8209ab7d6620085f3441d9 Mon Sep 17 00:00:00 2001
From: Yu Chen <chenyu56@huawei.com>
Date: Thu, 15 Apr 2021 15:20:30 -0700
Subject: [PATCH] usb: dwc3: core: Do core softreset when switch mode

From: John Stultz <john.stultz@linaro.org>

According to the programming guide, to switch mode for DRD controller,
the driver needs to do the following.

To switch from device to host:
1. Reset controller with GCTL.CoreSoftReset
2. Set GCTL.PrtCapDir(host mode)
3. Reset the host with USBCMD.HCRESET
4. Then follow up with the initializing host registers sequence

To switch from host to device:
1. Reset controller with GCTL.CoreSoftReset
2. Set GCTL.PrtCapDir(device mode)
3. Reset the device with DCTL.CSftRst
4. Then follow up with the initializing registers sequence

Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
switching from host to device. John Stult reported a lockup issue seen
with HiKey960 platform without these steps[1]. Similar issue is observed
with Ferry's testing platform[2].

So, apply the required steps along with some fixes to Yu Chen's and John
Stultz's version. The main fixes to their versions are the missing wait
for clocks synchronization before clearing GCTL.CoreSoftReset and only
apply DCTL.CSftRst when switching from host to device.

[1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
[2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/

Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Wesley Cheng <wcheng@codeaurora.org>
Cc: <stable@vger.kernel.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Tested-by: Wesley Cheng <wcheng@codeaurora.org>
Signed-off-by: Yu Chen <chenyu56@huawei.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 5c25e6a72dbd..2f118ad43571 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -114,6 +114,8 @@ void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode)
 	dwc->current_dr_role = mode;
 }
 
+static int dwc3_core_soft_reset(struct dwc3 *dwc);
+
 static void __dwc3_set_mode(struct work_struct *work)
 {
 	struct dwc3 *dwc = work_to_dwc(work);
@@ -121,6 +123,8 @@ static void __dwc3_set_mode(struct work_struct *work)
 	int ret;
 	u32 reg;
 
+	mutex_lock(&dwc->mutex);
+
 	pm_runtime_get_sync(dwc->dev);
 
 	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
@@ -154,6 +158,25 @@ static void __dwc3_set_mode(struct work_struct *work)
 		break;
 	}
 
+	/* For DRD host or device mode only */
+	if (dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG) {
+		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
+		reg |= DWC3_GCTL_CORESOFTRESET;
+		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
+
+		/*
+		 * Wait for internal clocks to synchronized. DWC_usb31 and
+		 * DWC_usb32 may need at least 50ms (less for DWC_usb3). To
+		 * keep it consistent across different IPs, let's wait up to
+		 * 100ms before clearing GCTL.CORESOFTRESET.
+		 */
+		msleep(100);
+
+		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
+		reg &= ~DWC3_GCTL_CORESOFTRESET;
+		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
+	}
+
 	spin_lock_irqsave(&dwc->lock, flags);
 
 	dwc3_set_prtcap(dwc, dwc->desired_dr_role);
@@ -178,6 +201,8 @@ static void __dwc3_set_mode(struct work_struct *work)
 		}
 		break;
 	case DWC3_GCTL_PRTCAP_DEVICE:
+		dwc3_core_soft_reset(dwc);
+
 		dwc3_event_buffers_setup(dwc);
 
 		if (dwc->usb2_phy)
@@ -200,6 +225,7 @@ static void __dwc3_set_mode(struct work_struct *work)
 out:
 	pm_runtime_mark_last_busy(dwc->dev);
 	pm_runtime_put_autosuspend(dwc->dev);
+	mutex_unlock(&dwc->mutex);
 }
 
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
@@ -1553,6 +1579,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_cache_hwparams(dwc);
 
 	spin_lock_init(&dwc->lock);
+	mutex_init(&dwc->mutex);
 
 	pm_runtime_set_active(dev);
 	pm_runtime_use_autosuspend(dev);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 695ff2d791e4..7e3afa5378e8 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/bitops.h>
@@ -947,6 +948,7 @@ struct dwc3_scratchpad_array {
  * @scratch_addr: dma address of scratchbuf
  * @ep0_in_setup: one control transfer is completed and enter setup phase
  * @lock: for synchronizing
+ * @mutex: for mode switching
  * @dev: pointer to our struct device
  * @sysdev: pointer to the DMA-capable device
  * @xhci: pointer to our xHCI child
@@ -1088,6 +1090,9 @@ struct dwc3 {
 	/* device lock */
 	spinlock_t		lock;
 
+	/* mode switching lock */
+	struct mutex		mutex;
+
 	struct device		*dev;
 	struct device		*sysdev;
 

