Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135DC257936
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgHaM1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:27:41 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:42635 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726468AbgHaM1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:27:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 52024A17;
        Mon, 31 Aug 2020 08:27:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aU/Qno
        TtzgU2LuNXwAN1aRVz6wDQ59t+TbfCMgX4Dr8=; b=B3kwue10gvTwNzEfVpY+mQ
        hFT0aGZ/DPiXmqXwiETEghWJFIhiWUvbfdtTffhPRPXEtHSvix3V/hhhMPRi8SOe
        STZ+b6bNMmjv5PmLlIJIVgAS/hjMxqJGGqvXSjO3OPe8FMKuzcySuJnPvVA/OwgP
        kpD3WSq0865X6WM0P3fEngngLTjjZsCV3ROJm7h0hrZ0+XM9IvxFGO+NXkU40DX1
        NYpcUyO6kJTIxehMsamT3C9zUrxWRoihnrtyvNdUeIcQVqmR3MKVOT+XdC0vkNM9
        rgNycCUiuxA/ygz/y5/IOOx3YfQIx/VUN50L++vkA2DmW+RH/p7zs5TzzpKBCUVA
        ==
X-ME-Sender: <xms:uuxMX9Uu1lj0GwYRv62mNdjmYAUc23LXaNUrb3DFv2QZ6rsChvStHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:uuxMX9lql2seTGUrVB8e59acfzTL0H-d3WhTtPre1D03N1UcLEJ-uA>
    <xmx:uuxMX5bM436_WPeFB3nZ_SDEnerszIZqPRGqCes8WjTK_3cR3tq9hw>
    <xmx:uuxMXwVM-KOH7FezWYsuGWZZdMDjMBnah9FCdmI1dmJdL4gp5fxIYQ>
    <xmx:uuxMX_vySI3AuTUcewC1Q9NjZa6NnubgxmNP2E5-F6tsng1uuv2iTsVcMTs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2EC130600A9;
        Mon, 31 Aug 2020 08:27:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: ucsi: Hold con->lock for the entire duration of" failed to apply to 5.4-stable tree
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:27:46 +0200
Message-ID: <1598876866196148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From bed97b30968ba354035a020989df0623e52b5536 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 9 Aug 2020 16:19:04 +0200
Subject: [PATCH] usb: typec: ucsi: Hold con->lock for the entire duration of
 ucsi_register_port()

Commit 081da1325d35 ("usb: typec: ucsi: displayport: Fix a potential race
during registration") made the ucsi code hold con->lock in
ucsi_register_displayport(). But we really don't want any interactions
with the connector to run before the port-registration process is fully
complete.

This commit moves the taking of con->lock from ucsi_register_displayport()
into ucsi_register_port() to achieve this.

Cc: stable@vger.kernel.org
Fixes: 081da1325d35 ("usb: typec: ucsi: displayport: Fix a potential race during registration")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200809141904.4317-5-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/ucsi/displayport.c b/drivers/usb/typec/ucsi/displayport.c
index 048381c058a5..261131c9e37c 100644
--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -288,8 +288,6 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	struct typec_altmode *alt;
 	struct ucsi_dp *dp;
 
-	mutex_lock(&con->lock);
-
 	/* We can't rely on the firmware with the capabilities. */
 	desc->vdo |= DP_CAP_DP_SIGNALING | DP_CAP_RECEPTACLE;
 
@@ -298,15 +296,12 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	desc->vdo |= all_assignments << 16;
 
 	alt = typec_port_register_altmode(con->port, desc);
-	if (IS_ERR(alt)) {
-		mutex_unlock(&con->lock);
+	if (IS_ERR(alt))
 		return alt;
-	}
 
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp) {
 		typec_unregister_altmode(alt);
-		mutex_unlock(&con->lock);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -319,7 +314,5 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	alt->ops = &ucsi_displayport_ops;
 	typec_altmode_set_drvdata(alt, dp);
 
-	mutex_unlock(&con->lock);
-
 	return alt;
 }
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 8a35144211e5..e680fcfdee60 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -898,12 +898,15 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	con->num = index + 1;
 	con->ucsi = ucsi;
 
+	/* Delay other interactions with the con until registration is complete */
+	mutex_lock(&con->lock);
+
 	/* Get connector capability */
 	command = UCSI_GET_CONNECTOR_CAPABILITY;
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	if (con->cap.op_mode & UCSI_CONCAP_OPMODE_DRP)
 		cap->data = TYPEC_PORT_DRD;
@@ -935,26 +938,32 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
 	ret = ucsi_register_port_psy(con);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Register the connector */
 	con->port = typec_register_port(ucsi->dev, cap);
-	if (IS_ERR(con->port))
-		return PTR_ERR(con->port);
+	if (IS_ERR(con->port)) {
+		ret = PTR_ERR(con->port);
+		goto out;
+	}
 
 	/* Alternate modes */
 	ret = ucsi_register_altmodes(con, UCSI_RECIPIENT_CON);
-	if (ret)
+	if (ret) {
 		dev_err(ucsi->dev, "con%d: failed to register alt modes\n",
 			con->num);
+		goto out;
+	}
 
 	/* Get the status */
 	command = UCSI_GET_CONNECTOR_STATUS | UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->status, sizeof(con->status));
 	if (ret < 0) {
 		dev_err(ucsi->dev, "con%d: failed to get status\n", con->num);
-		return 0;
+		ret = 0;
+		goto out;
 	}
+	ret = 0; /* ucsi_send_command() returns length on success */
 
 	switch (UCSI_CONSTAT_PARTNER_TYPE(con->status.flags)) {
 	case UCSI_CONSTAT_PARTNER_TYPE_UFP:
@@ -979,17 +988,21 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
 	if (con->partner) {
 		ret = ucsi_register_altmodes(con, UCSI_RECIPIENT_SOP);
-		if (ret)
+		if (ret) {
 			dev_err(ucsi->dev,
 				"con%d: failed to register alternate modes\n",
 				con->num);
-		else
+			ret = 0;
+		} else {
 			ucsi_altmode_update_active(con);
+		}
 	}
 
 	trace_ucsi_register_port(con->num, &con->status);
 
-	return 0;
+out:
+	mutex_unlock(&con->lock);
+	return ret;
 }
 
 /**

