Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8103950A0
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 13:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhE3LS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 07:18:29 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:36197 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3LS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 07:18:29 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id D6C1D194050A;
        Sun, 30 May 2021 07:16:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 30 May 2021 07:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mZCni5
        DIskYcOShYWsNVqzeRw9EjSLpg8XrBl6gnOzE=; b=KZxVPvn7aREkQbrMvXwLow
        NHnDdY8W+dbFpBEVT5PKRsMoDhTRJE6VZXM+lJ19QlLS5qMSmJ6Rdb6gYArOgq8c
        b/aLs7Dq9EnbQAbf6Jy/YfSJs09UcBhG+6AGouDCxrsugitXlRqyCCDAJr/nt569
        oP8XCevB8oXbSv5SjO2fbvHp1qcH3m3JolkwtkpakmV6tDMuMOxL7CUJaM1Tz/Uc
        6/gJ1YF3WCGjSkApm9Q7l3xEdGNzJyhILouPOtj9RmwlsECQfvgITreuedgQExqt
        kFDx/S/yOaYpfFf60840YdYeKsoe3bidO74gYqmxZaJwNZTniszVMOjrfm94J/4A
        ==
X-ME-Sender: <xms:IXSzYJGf_M7x5IodYgdmCNDVQZ-GseTuFnteQ2WhGBo_RE0rCvApLw>
    <xme:IXSzYOVSjjht7HI8mz58Yfi6RNznbRCAFYQyftrhr0nM_EKzY_0gJADdtOnYj9W9r
    CkvhebJ8xO11w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IXSzYLJhj-taKZ1du3JLoguhSb51CxjiDDZ7K1kH8WJjIf23pUdmBw>
    <xmx:IXSzYPHwzc7V5fuSMYTAWGZfKQ68Onxd6wLyWWebSQxXLg81zJ4Tbw>
    <xmx:IXSzYPXgl2zSkeE7eJNzD9WouiITcW1OC0s4Q_CWj3HeOWLxYgugJg>
    <xmx:InSzYKR5FKcMHMHLRDykwdYFCNBE1dUGMVd96i_LENm1qp8ozjFHGA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 07:16:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Respond Not_Supported if no snk_vdo" failed to apply to 5.4-stable tree
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 13:16:47 +0200
Message-ID: <16223734075059@kroah.com>
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

