Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8D377DFD
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhEJIWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:22:02 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:46683 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230208AbhEJIWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:22:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E439F1940BCD;
        Mon, 10 May 2021 04:20:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B6zqUG
        2dlI9QOtMe+mcr81OKKHtSjV7gGQCc2M0WWZM=; b=Ui1n45HuDcl2S8tJp6lGP9
        +dpitkPxFsN61pY1MvLS7YrKxNTbJBOulGMFpwKbVSXBgigKRxCAowoYk/D7OZYV
        6eOag4uTAKNCgJaFlrdM22MXt5j+H3Aznh1B+M6PGbfnhz8sTHEjczGoSE7Q7j6y
        6v6s1+K94NRG0su3v+Lq7WKYlXJ4vG2c+jaYkU/ubpClCuWmb2Ngcl2p6YuUp2eP
        NOMefskTHKTHHKSYgA6Wfw4Bv4zP5aHobJ2ECK8ME+MRnHXnQjTZ0I6kPZxLoTRL
        S3dRuHOH63DVjTpN5/Ivl9x4H49CXLHq0zoIN9XUTzsCO1OyLUWHRs8TPwdg6zUQ
        ==
X-ME-Sender: <xms:6OyYYGV2f7JOrM8vy9jiN9jSmTNXk_Jol63kaTXag0isobwAwWiCJw>
    <xme:6OyYYClDtodZOpxYAlpFyiHyn8Qy8yNbCGUBOfjNCt-dvLSECeZHCitMqqVAq_omC
    dt47-6KV5begw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6OyYYKbGHfhj41i04BrPiqVckZervJ_0qvHpxaMf7v8ZjlcKm9ytgg>
    <xmx:6OyYYNUkEr_XYEOz98jH_SoZ_CKVqywL_bvmeXGrIa7lYmlAJ4_ZVw>
    <xmx:6OyYYAnRcI5udHbCD6TYeCY-_nVhkKlbdT1HuwivgS-D3YdWcj7Qsg>
    <xmx:6OyYYFyWd_gNaHFZbmBVSmsy5JOU625tboQt5rgQxyOObk0nKjNsPg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:20:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Remove FS bInterval_m1 limitation" failed to apply to 4.9-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:20:45 +0200
Message-ID: <162063484537173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3232a3ce55edfc0d7f8904543b4088a5339c2b2b Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 15 Apr 2021 00:41:58 -0700
Subject: [PATCH] usb: dwc3: gadget: Remove FS bInterval_m1 limitation

The programming guide incorrectly stated that the DCFG.bInterval_m1 must
be set to 0 when operating in fullspeed. There's no such limitation for
all IPs. See DWC_usb3x programming guide section 3.2.2.1.

Fixes: a1679af85b2a ("usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1")
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/5d4139ae89d810eb0a2d8577fb096fc88e87bfab.1618472454.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1a632a3faf7f..90f4f9e69b22 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -607,12 +607,14 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep *dep, unsigned int action)
 		u8 bInterval_m1;
 
 		/*
-		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
-		 * must be set to 0 when the controller operates in full-speed.
+		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13.
+		 *
+		 * NOTE: The programming guide incorrectly stated bInterval_m1
+		 * must be set to 0 when operating in fullspeed. Internally the
+		 * controller does not have this limitation. See DWC_usb3x
+		 * programming guide section 3.2.2.1.
 		 */
 		bInterval_m1 = min_t(u8, desc->bInterval - 1, 13);
-		if (dwc->gadget->speed == USB_SPEED_FULL)
-			bInterval_m1 = 0;
 
 		if (usb_endpoint_type(desc) == USB_ENDPOINT_XFER_INT &&
 		    dwc->gadget->speed == USB_SPEED_FULL)

