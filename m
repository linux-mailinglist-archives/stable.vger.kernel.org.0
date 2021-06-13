Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689163A5863
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhFMMxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:53:05 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57745 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231863AbhFMMxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:53:01 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 79A351940193;
        Sun, 13 Jun 2021 08:51:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 13 Jun 2021 08:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BlcckS
        TbNYm94wm93vZ/LpT/fhFHnnczQgioXAvD6L4=; b=J+UR0decA0twpmPr8aGPvf
        uDcxn8ZJx/W061BZBwK4n3s3ud7ks8AH5/+r+wHsgM960WDSSOfzsPjtUxrcYGs6
        lcA9vwK4aDoF7CgfO21sf87nhAIt+Z78b928yEsxtlWZEAr7LCK9tIZgImjYJ5Og
        /mdGjuBikQvyr2DGqnXztqopoyK3+IwWOztGNu0nECwfR5j82M3AAMtyQ3CGVKum
        1sIhrlkx0DG16AAdS3jSO/BY+st8v7DCrL/x2ZSxv99I83TQFydy/iUqC6e1MfUb
        7q0crCFzu/aQNDdoJU8tmECWayJLrOv6HFgNlyhQzsttGsno4PaqGC7010hiTMdA
        ==
X-ME-Sender: <xms:NP_FYGTOuuQWZzO3pFlplJkUiVe_kYcilcuGlrqoPdN_Z43P1IgUHA>
    <xme:NP_FYLzUHX1S7iVXcFXqCxaNdGNde80vovNh1NAMvPGxCA80RgGDxMxeMjThORRs_
    hmRHxnayOnydA>
X-ME-Received: <xmr:NP_FYD3UhC-s3zUhs6w7e1Ms9nYkxrd-CbKHhWsLxTmedAw3g2pWFxRjcCOl_QfwpamHuGMgGUDnR6CXx_ii79FmUS4fQDuK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:NP_FYCCYXGW4bDfG3hrL2OSMVnyDUQWIBMy-h86P_Ey8lJaixW2ZPA>
    <xmx:NP_FYPhJ3ZJh53Jsx3BkmZWLpsZfU1fSUNLJ6D1yWDr0CYdvFvMtwA>
    <xmx:NP_FYOrqMxoGPRAEE2w11bgbw23o8aELB3JBb5UrlDvSPE1yDLKBoQ>
    <xmx:NP_FYCueGtWCtfSpbL_q4dLvuaV5cVPxAfyEb0uya2ECILlDHK-1SA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:50:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: cdns3: Enable TDL_CHK only for OUT ep" failed to apply to 5.4-stable tree
To:     sparmar@cadence.com, a-govindraju@ti.com, peter.chen@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:50:57 +0200
Message-ID: <162358865720072@kroah.com>
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

