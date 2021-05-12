Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9095637B852
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhELIrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:47:18 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44951 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhELIrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:47:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2827C19403E2;
        Wed, 12 May 2021 04:45:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+XN7Q+
        R+/u6S3lC/MGCo9rj1NuCKAoOrBFRHdGQIdOo=; b=dwzJatPsYeojNXVzME3thh
        3NrCvFABAwLvpw/MDiK9hDpCeMynZBG8P70QONAUPov4kq4BcFXDoW+UCXMDk2dX
        6V48GXxJbwPwmrNKkxYk9yXa3Yjn9V+g8lD1oZBw2Bn4WkPXWGdq0yhbT0c927kv
        FAj1NCHmxaa/SdEO0dJqfEkLeg4Y9cqcKk9QTNA4UdVIf6zRAaCnvzKToQZIPpxZ
        v2QPrBeB7YmkXPCVhXtljt1HQ2laEVm4tRUF/MBQPrRe66c0qwvogvM6BCVNDKPE
        TGBb34dN1u+KR9lSBnxSFrYx3oAUlBoCr/Nm941rHWB0Pko5EB50E7woiwyNkhNQ
        ==
X-ME-Sender: <xms:w5WbYFR9rnQp_e0FcDf-gVuHpbCqhoBH2UPs3gKvaxGHp8PjvVUnxg>
    <xme:w5WbYOzwShw3bDOK5wl_hAN5_wwrSppRpDKXONfTGOxIsfgMrbE-QUg1G0pxkyFcW
    BBu5JVz5E4kSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:w5WbYK30TBnJwCZHLUW2uWxENWI07m8LefqBz3RhjOlDiHpKptCUyQ>
    <xmx:w5WbYNAH98OXKg2-HVG7cbIFziBoyDMGDeI9X_lr0Q874N6-u6Yl7w>
    <xmx:w5WbYOj3NjGUwwoTs2JyXH5NFbzqiTB40x8r1UXf5AmjsYUkoyzQdA>
    <xmx:xJWbYPtoHJgie7isaCUW7SdobCmOmVUJU7jN8smZIWXZ8XGrQCMd2Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:45:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: update power supply once partner accepts" failed to apply to 4.19-stable tree
To:     badhri@google.com, Adam.Thomson.Opensource@diasemi.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:45:53 +0200
Message-ID: <162080915340184@kroah.com>
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

From 4050f2683f2c3151dc3dd1501ac88c57caf810ff Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 7 Apr 2021 13:07:20 -0700
Subject: [PATCH] usb: typec: tcpm: update power supply once partner accepts

power_supply_changed needs to be called to notify clients
after the partner accepts the requested values for the pps
case.

Also, remove the redundant power_supply_changed at the end
of the tcpm_reset_port as power_supply_changed is already
called right after usb_type is changed.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210407200723.1914388-3-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b4a40099d7e9..d1d03ee90d8f 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2568,6 +2568,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			port->pps_data.max_curr = port->pps_data.req_max_curr;
 			port->req_supply_voltage = port->pps_data.req_out_volt;
 			port->req_current_limit = port->pps_data.req_op_curr;
+			power_supply_changed(port->psy);
 			tcpm_set_state(port, SNK_TRANSITION_SINK, 0);
 			break;
 		case SOFT_RESET_SEND:
@@ -3136,7 +3137,6 @@ static unsigned int tcpm_pd_select_pps_apdo(struct tcpm_port *port)
 						      port->pps_data.req_out_volt));
 		port->pps_data.req_op_curr = min(port->pps_data.max_curr,
 						 port->pps_data.req_op_curr);
-		power_supply_changed(port->psy);
 	}
 
 	return src_pdo;
@@ -3561,8 +3561,6 @@ static void tcpm_reset_port(struct tcpm_port *port)
 	port->sink_cap_done = false;
 	if (port->tcpc->enable_frs)
 		port->tcpc->enable_frs(port->tcpc, false);
-
-	power_supply_changed(port->psy);
 }
 
 static void tcpm_detach(struct tcpm_port *port)

