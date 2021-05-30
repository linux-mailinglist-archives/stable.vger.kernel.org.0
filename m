Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C383A39509F
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 13:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhE3LOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 07:14:15 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60697 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3LOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 07:14:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id CE87619405BC;
        Sun, 30 May 2021 07:12:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 May 2021 07:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yC++iq
        4bsJzbHHR/94nZBuvW5bq4znlL9+iD6n0y7QI=; b=hbLoiBR/gcQOOrYrC1St65
        t9Ax7QT3tyXm4QwoZvHnoITNbPsu5Oh9yh7GXnSAFt+Gm0JUwzIjv6ne29Rg3Fem
        6XkCBlL3MNMak48wOIY3x+ZEh4xzyq9Z5YDJGjLieE5sC3JTPefJuqR2PNo5CePk
        tzggW80h9WhlVPqBu2/giEZhjRsc4gjvbm9BK8lakjvXI64SAflVbwxQZpxeuMSA
        2hXlmLxdxR2Qk5CeNpVl4ZmvUZzNwY4YH2yThDM1NiR0Lk4xFnbhF9XJ+fqIzYrj
        GXOWPinZGJwjI9wSaRSGpLfq3+rIS5jcaUVcO81jkmnjCF1aZvDqlnRcH320URgg
        ==
X-ME-Sender: <xms:JHOzYBL0tCgM_WFG2vLo8vjQO4DfI6wMKSYiU59jsYVNdy2bAk9ySg>
    <xme:JHOzYNIz4sw0ORw0J3muf6V1nAfCEJo-pMs5qelaFcib1bDOxYd_mxiX97LuZiHOd
    qsS3oosFoWr4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JHOzYJsU109Jqq5YpGTm0GUzixT6FhGU0WNGUryYbQRlnClPJtviiA>
    <xmx:JHOzYCZ03ugap8suEUW9azmvUHNVIIKTV4Kt86NzP7ce0eItbrjqCQ>
    <xmx:JHOzYIZcXUYLzCxGiCVUzAJyNj9q8CvoaxG9zDGWuHH492A4qaoedw>
    <xmx:JHOzYAEXuz38Ko_jR6At0yWdVfl5SRD4VMSq0aZ3dAI5WJfD87l3CQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 07:12:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Respond Not_Supported if no snk_vdo" failed to apply to 4.19-stable tree
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 13:12:34 +0200
Message-ID: <1622373154752@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a20dcf53ea9836387b229c4878f9559cf1b55b71 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Sun, 23 May 2021 09:58:55 +0800
Subject: [PATCH] usb: typec: tcpm: Respond Not_Supported if no snk_vdo

If snk_vdo is not populated from fwnode, it implies the port does not
support responding to SVDM commands. Not_Supported Message shall be sent
if the contract is in PD3. And for PD2, the port shall ignore the
commands.

Fixes: 193a68011fdc ("staging: typec: tcpm: Respond to Discover Identity commands")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210523015855.1785484-3-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 6ea5df3782cf..9ce8c9af4da5 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2430,7 +2430,10 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 					   NONE_AMS);
 		break;
 	case PD_DATA_VENDOR_DEF:
-		tcpm_handle_vdm_request(port, msg->payload, cnt);
+		if (tcpm_vdm_ams(port) || port->nr_snk_vdo)
+			tcpm_handle_vdm_request(port, msg->payload, cnt);
+		else if (port->negotiated_rev > PD_REV20)
+			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 		break;
 	case PD_DATA_BIST:
 		port->bist_request = le32_to_cpu(msg->payload[0]);

