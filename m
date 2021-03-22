Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1B343BFD
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhCVImy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:42:54 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48847 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhCVImw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:42:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A26FCF9B;
        Mon, 22 Mar 2021 04:42:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 04:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=STMEZY
        3lAhcCnbHS2x+yq3URHY04gCB4mEN4ue334us=; b=nULdc4rp89ZDezmntZ1JVo
        E41q3YSK9T6AfbW05AqTlki9hBuZ89Ttucn6a5j5QqU3dnd9EG3+4Sfx5PwJDbTW
        BqlJVaZX58emsnDZXLMhFlqvsu9j5seguJ/c64XA5CD8spiUqMwX/BRKfsjm0OS2
        f4eOKlILJRMMwuNbPeFGEri7/VQZhF94w9rlKsyg6Vh5K/ZvGgthsJajPzTJ9UB8
        g1rr31lx+AkeAGpO5FbGsToSx1z98NviVTpM9uiRUaNuJhVgPEkPdBtthzh33scB
        MEnOt4QWTDT3NoBhvHofxxJOEplbhAOTINCXWdWiDR1SeXHaYTZWWwTnTsDNOVzg
        ==
X-ME-Sender: <xms:ilhYYISh2cSfOZnAw2PgCd80TiGILkwA3D-HcZBIHiw0YyD7vaam_Q>
    <xme:ilhYYFx5bP0f68ILRDpn_tdJyhNxU6iaTzc9gLoGvV7Bp8n14QpDWPYFqIbIuoS4l
    WubugP0YjnPbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegfedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ilhYYF2saPzf4SEs15aVVHeHC7jqq15XHw8WJxb2_BG75UHh5aiLxA>
    <xmx:ilhYYMBdDFRhQCTLPX7y4MbyI4STLzqVw4CH38AG1NvEZRCkzY31-w>
    <xmx:ilhYYBgvwg6_lnxlhiV_tQYZ_L3nbzCSxdIzgWukuJR3QA4knOchLQ>
    <xmx:i1hYYEsHi_XNmNxMly6sBRi2xssu0EcGArafOSKPKPB8ld_OOx1iEMSRAPY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 579A624041F;
        Mon, 22 Mar 2021 04:42:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Invoke power_supply_changed for" failed to apply to 4.19-stable tree
To:     badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 09:42:48 +0100
Message-ID: <1616402568155162@kroah.com>
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

From 86629e098a077922438efa98dc80917604dfd317 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 17 Mar 2021 11:12:48 -0700
Subject: [PATCH] usb: typec: tcpm: Invoke power_supply_changed for
 tcpm-source-psy-

tcpm-source-psy- does not invoke power_supply_changed API when
one of the published power supply properties is changed.
power_supply_changed needs to be called to notify
userspace clients(uevents) and kernel clients.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210317181249.1062995-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index be0b6469dd3d..92093ea12cff 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -942,6 +942,7 @@ static int tcpm_set_current_limit(struct tcpm_port *port, u32 max_ma, u32 mv)
 
 	port->supply_voltage = mv;
 	port->current_limit = max_ma;
+	power_supply_changed(port->psy);
 
 	if (port->tcpc->set_current_limit)
 		ret = port->tcpc->set_current_limit(port->tcpc, max_ma, mv);
@@ -2928,6 +2929,7 @@ static int tcpm_pd_select_pdo(struct tcpm_port *port, int *sink_pdo,
 
 	port->pps_data.supported = false;
 	port->usb_type = POWER_SUPPLY_USB_TYPE_PD;
+	power_supply_changed(port->psy);
 
 	/*
 	 * Select the source PDO providing the most power which has a
@@ -2952,6 +2954,7 @@ static int tcpm_pd_select_pdo(struct tcpm_port *port, int *sink_pdo,
 				port->pps_data.supported = true;
 				port->usb_type =
 					POWER_SUPPLY_USB_TYPE_PD_PPS;
+				power_supply_changed(port->psy);
 			}
 			continue;
 		default:
@@ -3109,6 +3112,7 @@ static unsigned int tcpm_pd_select_pps_apdo(struct tcpm_port *port)
 						  port->pps_data.out_volt));
 		port->pps_data.op_curr = min(port->pps_data.max_curr,
 					     port->pps_data.op_curr);
+		power_supply_changed(port->psy);
 	}
 
 	return src_pdo;
@@ -3344,6 +3348,7 @@ static int tcpm_set_charge(struct tcpm_port *port, bool charge)
 			return ret;
 	}
 	port->vbus_charge = charge;
+	power_supply_changed(port->psy);
 	return 0;
 }
 
@@ -3523,6 +3528,7 @@ static void tcpm_reset_port(struct tcpm_port *port)
 	port->try_src_count = 0;
 	port->try_snk_count = 0;
 	port->usb_type = POWER_SUPPLY_USB_TYPE_C;
+	power_supply_changed(port->psy);
 	port->nr_sink_caps = 0;
 	port->sink_cap_done = false;
 	if (port->tcpc->enable_frs)
@@ -5905,7 +5911,7 @@ static int tcpm_psy_set_prop(struct power_supply *psy,
 		ret = -EINVAL;
 		break;
 	}
-
+	power_supply_changed(port->psy);
 	return ret;
 }
 
@@ -6058,6 +6064,7 @@ struct tcpm_port *tcpm_register_port(struct device *dev, struct tcpc_dev *tcpc)
 	err = devm_tcpm_psy_register(port);
 	if (err)
 		goto out_role_sw_put;
+	power_supply_changed(port->psy);
 
 	port->typec_port = typec_register_port(port->dev, &port->typec_caps);
 	if (IS_ERR(port->typec_port)) {

