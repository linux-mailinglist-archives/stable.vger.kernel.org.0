Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1913A587E
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhFMMyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:54:03 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:37275 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231971AbhFMMxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:53:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id C6F3119406E5;
        Sun, 13 Jun 2021 08:51:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 13 Jun 2021 08:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=h9ptna
        /xXt0jjU94lirNibMaosPZQEPrXfKuQthpszY=; b=ISqAjRV0ocAUFs2zMgcFV/
        8twLbWBZixtwER1il3vcLEYO2kzsCVoSt8/s9WpmgW2zCJQ2S+ysKMcpwXiB3XVw
        aiRu7EGD7CCqG4eRxIBoxi5838JAF8K36o38mS8Rs+R9uD0uJYZjoyyV5wXeFP/h
        StuEOGoq1nYNuVKUBZFssMYcF5/9CJLn4tVtVF7cJQa4SaAZ93SJKIJffEWi2nRn
        lykVm3nwpzkwJm/ASUuM+6XKqAjEkwhdME0inDPQ0m9SBpoyCm1BMPLeiwDH7HCL
        /TS+0W7BM9scHs7zHcbOClIrwjmX6uVdpMiYeuNPcRBPJdS4BldXwnK4VZnPKW6A
        ==
X-ME-Sender: <xms:Yv_FYOd4k4FCYTZ1nk-TiyWuB9ldHkZ6eMEzgTgryb7HYrG_vFTdBg>
    <xme:Yv_FYIMgVLmPYZCukQRs_ewPcKtS68uwtLg4kR45mi0h9fmRwwokIa3EOBSq9eDpa
    uySqyEF2Nhl_Q>
X-ME-Received: <xmr:Yv_FYPjhKwitk8r5dIVfKkZof61C6A0DwYAHk_N6FTT-nmco8WYcmOKu0JB2nobrAEmGfTq55ASnaMBlJaZG1kYL-2_8sQuX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Yv_FYL9yN42kTjknVhokWIwj5qLgtyKtbMeSKmEMlJsHa4gHWz6HAA>
    <xmx:Yv_FYKs5C5iO3smSfnpjnmlSRmwdRVvqQn8SL4EdtCLnlPJNfZvwmg>
    <xmx:Yv_FYCHMIcc_fsRL0RhNZIYAtzL72zx6CQbHSw5fuBeRQHyD1cQj9w>
    <xmx:Yv_FYD6xxdlb61uvFUNR5zg0BFre9yseGiocRNUGcjlAwWYeM8XpYw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:51:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Correct the responses in SVDM Version 2.0" failed to apply to 5.10-stable tree
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:51:34 +0200
Message-ID: <162358869470193@kroah.com>
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

