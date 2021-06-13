Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E025D3A587C
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhFMMx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:53:57 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:54347 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhFMMxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:53:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id C9C461940155;
        Sun, 13 Jun 2021 08:51:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 08:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N/z0c/
        BXX4VTOqv1qLK1HHX3xu28apGau9Gmcc8qf5U=; b=odbK+7OpSFsF541lN8xoZG
        yTmS2ZIbIeMu2feafAlIjoxg6mEDyqyVpx2bYFqA1tsQQnVN4wxmPVxKA86c5FN0
        YKAdHLNVxYrJBWiumQt0p78XafJIduv+81jrY3RqoXR9OV+sbsn/XU/CMbBDctnA
        /tzFvzLBqgX1/a+/GAhSIRnUBh2dbsRf1cGsRbILMyVzHtcRWRM+s/KT0HoDVhoO
        ybeHKcC/OV/mHZp4uWSO+54jXG4DuwVgnksg269CnlYzbRJLGe8Y3U4P20F7tatp
        g+P9djrRjr62oCOxyfWvc6GqJEgFd2594K4kyq9pesUmrcG3hKrDASntwizQIIKw
        ==
X-ME-Sender: <xms:V__FYEllnxq4Bkcj2qx7q9ILzhPfY-vBqnjdXAuzyIhpYQlCaJHZGA>
    <xme:V__FYD3SH4D0HLS848abO8wXzMfdQT42k-UYDoYdTfr5RHxUuKgSH0z7hzkBSltFh
    u1jpGV6YJ4lqA>
X-ME-Received: <xmr:V__FYCqqC9JDOBBuWVxi-dsxMpePZQsCsWx2mgCiF5PFwxPO636iJ5vEmcB06TFBUUm1qLNs7igaE6AgFPDeQSe0Zwjk1jtG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:V__FYAmcdHkLbQ76J79sSPJItX2G7qCXT7386mv94UgMOVstfc07hA>
    <xmx:V__FYC1KZl1kX4fMhtxrHTKT2DtqG90JWYwyOIiQIiweucMbDTqIWA>
    <xmx:V__FYHuflJPN9idiuNhou4I3ttjs_mfi7Dn0dkBDAqiCDtwjrUmHzg>
    <xmx:V__FYACQjfr5BrVdLN9xkAHksg3O3U8-zJO0cCK5kqTFH605bcfquA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:51:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Correct the responses in SVDM Version 2.0" failed to apply to 4.14-stable tree
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:51:33 +0200
Message-ID: <16235886933238@kroah.com>
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

From f41bfc7e9c7c1d721c8752f1853cde43e606ad43 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Tue, 1 Jun 2021 20:31:48 +0800
Subject: [PATCH] usb: typec: tcpm: Correct the responses in SVDM Version 2.0
 DFP

In USB PD Spec Rev 3.1 Ver 1.0, section "6.12.5 Applicability of
Structured VDM Commands", DFP is allowed and recommended to respond to
Discovery Identity with ACK. And in section "6.4.4.2.5.1 Commands other
than Attention", NAK should be returned only when receiving Messages
with invalid fields, Messages in wrong situation, or unrecognize
Messages.

Still keep the original design for SVDM Version 1.0 for backward
compatibilities.

Fixes: 193a68011fdc ("staging: typec: tcpm: Respond to Discover Identity commands")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210601123151.3441914-2-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 9ce8c9af4da5..a1bf0dc5babf 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1547,19 +1547,25 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 			if (PD_VDO_VID(p[0]) != USB_SID_PD)
 				break;
 
-			if (PD_VDO_SVDM_VER(p[0]) < svdm_version)
+			if (PD_VDO_SVDM_VER(p[0]) < svdm_version) {
 				typec_partner_set_svdm_version(port->partner,
 							       PD_VDO_SVDM_VER(p[0]));
+				svdm_version = PD_VDO_SVDM_VER(p[0]);
+			}
 
 			tcpm_ams_start(port, DISCOVER_IDENTITY);
-			/* 6.4.4.3.1: Only respond as UFP (device) */
-			if (port->data_role == TYPEC_DEVICE &&
+			/*
+			 * PD2.0 Spec 6.10.3: respond with NAK as DFP (data host)
+			 * PD3.1 Spec 6.4.4.2.5.1: respond with NAK if "invalid field" or
+			 * "wrong configuation" or "Unrecognized"
+			 */
+			if ((port->data_role == TYPEC_DEVICE || svdm_version >= SVDM_VER_2_0) &&
 			    port->nr_snk_vdo) {
 				/*
 				 * Product Type DFP and Connector Type are not defined in SVDM
 				 * version 1.0 and shall be set to zero.
 				 */
-				if (typec_get_negotiated_svdm_version(typec) < SVDM_VER_2_0)
+				if (svdm_version < SVDM_VER_2_0)
 					response[1] = port->snk_vdo[0] & ~IDH_DFP_MASK
 						      & ~IDH_CONN_MASK;
 				else

