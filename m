Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49B137B839
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhELIor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:44:47 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60269 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229968AbhELIoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:44:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CDDFB194041E;
        Wed, 12 May 2021 04:43:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VMr+WC
        kv3Ozhl/NpnizzEI4rL+gflnPsTMvbGWhZf6I=; b=br5JtKt3EPbdwhAjh5xEJv
        fArMrmO7uwR0At/uNZ84GyVtu4lE5XFVNAZ4IIk0HVTdqbx3yrtjyzUBxpKynq10
        phhOFvieun6ENwtmY2JJw4UnKBELkOi8YSiWM43cryjHLfpZtBuNhVZ3+mhfElRA
        hBsc730vf4515hz+pciCkSGCPQj3hVcvH1Q3afA636ebMeMZgdsUpaSwzCCAxeq8
        N/0+RujnPsGeVbuyrFt0xN2W56vjQct8l/m9urVQigIU3BkShku3o6/PPD62hjAl
        20DfSbzEu8F/RcW8465bt/5x+Kq9z4WvAenohOK1YyjYHIpUhkypsM0tTfRPOHug
        ==
X-ME-Sender: <xms:OZWbYIXuG5HsXaUkWFgwLdnDfTebVYmXxNE3blXrPWo6_3lEV5TTOw>
    <xme:OZWbYMkowmFQBwSnEy1qBk1LxRyvuSU1iKiHxPSfu__2euwRNq38r8w38QjC0YiNG
    g03p1coVhuJ9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OZWbYMZL_O5IKAyAVGC9DDs0rQptYSxrn-d1dsc5FSSMvLceagk-UQ>
    <xmx:OZWbYHWT60Bc6z9anX5yUHa6TSnGO01q66eMAEhWvp93DfCVy-OODg>
    <xmx:OZWbYCmr6OzhnT6p996Do0V0QNnMBRr7djyLz1tnHboNhEqr-q9iLw>
    <xmx:OZWbYDDQLXfujdUbJ389UP6zZ2YIfCd1p6DuH-s2hVrwhCSO02c2QA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:43:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Address incorrect values of tcpm psy for" failed to apply to 4.19-stable tree
To:     badhri@google.com, Adam.Thomson.Opensource@diasemi.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        linux@roeck-us.net, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:43:35 +0200
Message-ID: <1620809015217252@kroah.com>
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

From f3dedafb8263ca4791a92a23f5230068f5bde008 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 7 Apr 2021 13:07:18 -0700
Subject: [PATCH] usb: typec: tcpm: Address incorrect values of tcpm psy for
 fixed supply

tcpm_pd_build_request overwrites current_limit and supply_voltage
even before port partner accepts the requests. This leaves stale
values in current_limit and supply_voltage that get exported by
"tcpm-source-psy-". Solving this problem by caching the request
values of current limit/supply voltage in req_current_limit
and req_supply_voltage. current_limit/supply_voltage gets updated
once the port partner accepts the request.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210407200723.1914388-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index ca1fc77697fc..4ea4b30ae885 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -389,7 +389,10 @@ struct tcpm_port {
 	unsigned int operating_snk_mw;
 	bool update_sink_caps;
 
-	/* Requested current / voltage */
+	/* Requested current / voltage to the port partner */
+	u32 req_current_limit;
+	u32 req_supply_voltage;
+	/* Actual current / voltage limit of the local port */
 	u32 current_limit;
 	u32 supply_voltage;
 
@@ -2435,8 +2438,8 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 		case SNK_TRANSITION_SINK:
 			if (port->vbus_present) {
 				tcpm_set_current_limit(port,
-						       port->current_limit,
-						       port->supply_voltage);
+						       port->req_current_limit,
+						       port->req_supply_voltage);
 				port->explicit_contract = true;
 				tcpm_set_auto_vbus_discharge_threshold(port,
 								       TYPEC_PWR_MODE_PD,
@@ -2545,8 +2548,8 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			break;
 		case SNK_NEGOTIATE_PPS_CAPABILITIES:
 			port->pps_data.active = true;
-			port->supply_voltage = port->pps_data.out_volt;
-			port->current_limit = port->pps_data.op_curr;
+			port->req_supply_voltage = port->pps_data.out_volt;
+			port->req_current_limit = port->pps_data.op_curr;
 			tcpm_set_state(port, SNK_TRANSITION_SINK, 0);
 			break;
 		case SOFT_RESET_SEND:
@@ -3195,8 +3198,8 @@ static int tcpm_pd_build_request(struct tcpm_port *port, u32 *rdo)
 			 flags & RDO_CAP_MISMATCH ? " [mismatch]" : "");
 	}
 
-	port->current_limit = ma;
-	port->supply_voltage = mv;
+	port->req_current_limit = ma;
+	port->req_supply_voltage = mv;
 
 	return 0;
 }

