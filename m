Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF6E3A586A
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhFMMxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:53:16 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:34023 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231873AbhFMMxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:53:11 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 74DBC19401DC;
        Sun, 13 Jun 2021 08:51:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RxplqH
        mGREG73wOFPbsd0w9xuMVImFdS9cA0d/b2w60=; b=n/4bOnd6Z1x/zC5A75fVRy
        KwhNX+t4dO4vSLBWFL3WSScxeI0UOZR01D/98ct7ZSvGY6jKZ2OExAQHSkeESpqB
        IJyDXuqQ2lPrYMBkCFlbMYxKoGLRImhWT+QVBYgJObQYVVhE0gQMNsy2sIJB9hru
        hroElDIddTctMLCcpd0itwUtVRrEjnlXsR+7qe3VvhLSQjGvMNsTULRXvC5P81Xm
        nNYeAlT38XDT2rkJT2FcughTs/LliaNAkk/MRJxc0UxFYDWScJv2TBQqKYIK4bvz
        MsE2u5qPiBiXiwuT2mrAfBNaShfgdlYviFD1X5knSXSHpN0ejAoBsyVayaAEusoQ
        ==
X-ME-Sender: <xms:Pf_FYD37KE-B-eYfTSy-OwFTsPvdgKrcwTKbhV_e_pP4oy0SH4WNbg>
    <xme:Pf_FYCHjXVDoTGWDX7_cnEhLlWHLCn-WflfvNCRtauzdi6LF6uSHJsLpA8v-9Wmhx
    ssipiYjj4bw2g>
X-ME-Received: <xmr:Pf_FYD6z1YkHDOdtCoNE2lEiTvYqAcM7jVGq7QkUpCVpYRTczS3s0LfhULNI38hRNQ-ymgnkXV-QXxb_xfNGyD9MCRY9apLy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Pf_FYI1xEvVS4H5S3z0mxRWjxz1_3vGQT1k57-HLyFn9707cJYRRZA>
    <xmx:Pf_FYGHLHhspycwAxwFAVSRG_u43s-0OV5pp5c0ZXAV0x85xS4Yn2A>
    <xmx:Pf_FYJ9aKFPFxdUUubExmSQBD9JRoUdp1ryC3wOWpHHnWtWOcBwSyg>
    <xmx:Pf_FYLSDGQABZzk-M98VoJs3GwhCa5R7p7k27RF3iqE79SgxrVxvPA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:51:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: cdns3: Enable TDL_CHK only for OUT ep" failed to apply to 5.10-stable tree
To:     sparmar@cadence.com, a-govindraju@ti.com, peter.chen@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:50:58 +0200
Message-ID: <162358865801@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d6eef886903c4bb5af41b9a31d4ba11dc7a6f8e8 Mon Sep 17 00:00:00 2001
From: Sanket Parmar <sparmar@cadence.com>
Date: Mon, 17 May 2021 17:05:12 +0200
Subject: [PATCH] usb: cdns3: Enable TDL_CHK only for OUT ep

ZLP gets stuck if TDL_CHK bit is set and TDL_FROM_TRB is used
as TDL source for IN endpoints. To fix it, TDL_CHK is only
enabled for OUT endpoints.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reported-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Sanket Parmar <sparmar@cadence.com>
Link: https://lore.kernel.org/r/1621263912-13175-1-git-send-email-sparmar@cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index a8b7b50abf64..5281f8d3fb3d 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2007,7 +2007,7 @@ static void cdns3_configure_dmult(struct cdns3_device *priv_dev,
 		else
 			mask = BIT(priv_ep->num);
 
-		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC) {
+		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC  && !priv_ep->dir) {
 			cdns3_set_register_bit(&regs->tdl_from_trb, mask);
 			cdns3_set_register_bit(&regs->tdl_beh, mask);
 			cdns3_set_register_bit(&regs->tdl_beh2, mask);
@@ -2046,15 +2046,13 @@ int cdns3_ep_config(struct cdns3_endpoint *priv_ep, bool enable)
 	case USB_ENDPOINT_XFER_INT:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_INT);
 
-		if ((priv_dev->dev_ver == DEV_VER_V2 && !priv_ep->dir) ||
-		    priv_dev->dev_ver > DEV_VER_V2)
+		if (priv_dev->dev_ver >= DEV_VER_V2 && !priv_ep->dir)
 			ep_cfg |= EP_CFG_TDL_CHK;
 		break;
 	case USB_ENDPOINT_XFER_BULK:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_BULK);
 
-		if ((priv_dev->dev_ver == DEV_VER_V2  && !priv_ep->dir) ||
-		    priv_dev->dev_ver > DEV_VER_V2)
+		if (priv_dev->dev_ver >= DEV_VER_V2 && !priv_ep->dir)
 			ep_cfg |= EP_CFG_TDL_CHK;
 		break;
 	default:

