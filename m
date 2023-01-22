Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C929676D17
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjAVNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVNQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:16:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BF81631C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C7A60C15
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9791DC433D2;
        Sun, 22 Jan 2023 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393404;
        bh=MsFFZ3w8uIeVWjETmeMNynJt/zObjh+bDPpwlLKUtlM=;
        h=Subject:To:Cc:From:Date:From;
        b=Mv7hsWK+d1PBHx1JqUKBCDUO1nfGEn/YEHIjBxaXprz0MDwT7Ou26GPyfIoFLOlky
         9uwvGCHoLIDiFC1J4jvJ+NsFpn+nbwY/qxdLTci+vcX+/YB5kF0UmF5yTA5xdnEezl
         6DCnK218M4Ho1nwZmY+677AaCNjrLx4+nnkInSsk=
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Fix altmode re-registration causes sysfs" failed to apply to 5.4-stable tree
To:     cy_huang@richtek.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, macpaul.lin@mediatek.com,
        tommyyl.chen@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:16:33 +0100
Message-ID: <167439339320236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

36f78477ac2c ("usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail")
ef52b4a9fcc2 ("usb: typec: tcpm: Raise vdm_sm_running flag only when VDM SM is running")
5571ea3117ca ("usb: typec: tcpm: Fix VDMs sometimes not being forwarded to alt-mode drivers")
2b537cf877ea ("usb: typec: tcpm: Relax disconnect threshold during power negotiation")
c34e85fa69b9 ("usb: typec: tcpm: Send DISCOVER_IDENTITY from dedicated work")
e00943e91678 ("usb: typec: tcpm: PD3.0 sinks can send Discover Identity even in device mode")
5e1d4c49fbc8 ("usb: typec: tcpm: Determine common SVDM Version")
31737c27d665 ("usb: pd: Make SVDM Version configurable in VDM header")
8d3a0578ad1a ("usb: typec: tcpm: Respond Wait if VDM state machine is running")
8dea75e11380 ("usb: typec: tcpm: Protocol Error handling")
0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
60e998d1c6d9 ("USB: typec: tcpm: Hard Reset after not receiving a Request")
3bac42f02d41 ("usb: typec: tcpm: Clear send_discover in tcpm_check_send_discover")
f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
a30a00e37ceb ("usb: typec: tcpm: frs sourcing vbus callback")
8dc4bd073663 ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
3ed8e1c2ac99 ("usb: typec: tcpm: Migrate workqueue to RT priority for processing events")
aefc66afe42b ("usb: typec: pd: Fix formatting in pd.h header")
6bbe2a90a0bb ("usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart")
95b4d51c96a8 ("usb: typec: tcpm: Refactor tcpm_handle_vdm_request")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 36f78477ac2c89e9a2eed4a31404a291a3450b5d Mon Sep 17 00:00:00 2001
From: ChiYuan Huang <cy_huang@richtek.com>
Date: Mon, 9 Jan 2023 15:19:50 +0800
Subject: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes sysfs
 create fail

There's the altmode re-registeration issue after data role
swap (DR_SWAP).

Comparing to USBPD 2.0, in USBPD 3.0, it loose the limit that only DFP
can initiate the VDM command to get partner identity information.

For a USBPD 3.0 UFP device, it may already get the identity information
from its port partner before DR_SWAP. If DR_SWAP send or receive at the
mean time, 'send_discover' flag will be raised again. It causes discover
identify action restart while entering ready state. And after all
discover actions are done, the 'tcpm_register_altmodes' will be called.
If old altmode is not unregistered, this sysfs create fail can be found.

In 'DR_SWAP_CHANGE_DR' state case, only DFP will unregister altmodes.
For UFP, the original altmodes keep registered.

This patch fix the logic that after DR_SWAP, 'tcpm_unregister_altmodes'
must be called whatever the current data role is.

Reviewed-by: Macpaul Lin <macpaul.lin@mediatek.com>
Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Reported-by: TommyYl Chen <tommyyl.chen@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/1673248790-15794-1-git-send-email-cy_huang@richtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 904c7b4ce2f0..59b366b5c614 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4594,14 +4594,13 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case DR_SWAP_CHANGE_DR:
-		if (port->data_role == TYPEC_HOST) {
-			tcpm_unregister_altmodes(port);
+		tcpm_unregister_altmodes(port);
+		if (port->data_role == TYPEC_HOST)
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_DEVICE);
-		} else {
+		else
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_HOST);
-		}
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
 		break;

