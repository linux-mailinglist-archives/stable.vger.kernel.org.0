Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D6327D28
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhCAL05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:26:57 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34997 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233423AbhCAL01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:26:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0F8011941344;
        Mon,  1 Mar 2021 06:25:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Vi/hIl
        szVr+en77NLS8i9EhCzVUcDqMU/MUdu+uY6zQ=; b=AnaHM4OF91C2FXAGSOIyNm
        Ln5LsUjHvoTqMk/YrEV8Xivbs+lA2gyDySPqpHlVvb2uJm+ukJVBm0Z6P8dcC/FG
        by4TEbI1GQJux6UNK2sKAZ4eCvCLDSfVeA8hEsgFh7Nhhyj0nkzE9PX5FJbUDtEj
        VWKxs3zCTeX+brP1FgqUZFtF6eRYD/BuvK9WJIFi7T1rjRvF9u7Uwl3DyJKzsm34
        ILYHjJZ1O3JLjbOKW7EaLiIQS2aSaxBTE7oVROWpDEo/U0InwfBBe9roHKrJ7crp
        YO0RwhpRL5kVLAfT+7XRswmdgw9Cx49nXq+gnAJyCnNfwmWlwf38w9Zs9scg/4Xg
        ==
X-ME-Sender: <xms:MM88YJxmxeOyHiLCdN9Qggkg3xjdQIOEkE1ojM8tuUEp7yDaRUU2yw>
    <xme:MM88YJT0An1H-Dh3KVtrtSSCoyJwGvTIMzcrmsceHFAx2ANPJ3Z0eUFbvJ4lnachZ
    6PegABu3rd94Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:MM88YDVzz6ltbyaAEPoUk1ZaaJPENlNFPRbJzY_7ihw81svJ0Mn1Yw>
    <xmx:MM88YLgXlR7X3ySDT_1n65CsTVCzxgmQrhu-UwzbH0sICPDyzetdEw>
    <xmx:MM88YLAtrqIUTd1v5W5QLHpbI7xMYYAtBnxYOVM86mvt2I_bpwr0mg>
    <xmx:Mc88YOrhQXYOmtUPFyDSH7dHYSKHUcrdohByLSwp6XVqh5LfJThfpw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F07F108005F;
        Mon,  1 Mar 2021 06:25:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] platform/x86: ideapad-laptop: Disable touchpad_switch for" failed to apply to 5.11-stable tree
To:     jiaxun.yang@flygoat.com, hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:25:34 +0100
Message-ID: <161459793460206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d69cd7eea93eb59a93061beeb43e4f5e19afc4ea Mon Sep 17 00:00:00 2001
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Thu, 7 Jan 2021 22:44:38 +0800
Subject: [PATCH] platform/x86: ideapad-laptop: Disable touchpad_switch for
 ELAN0634

Newer ideapads (e.g.: Yoga 14s, 720S 14) come with ELAN0634 touchpad do not
use EC to switch touchpad.

Reading VPCCMD_R_TOUCHPAD will return zero thus touchpad may be blocked
unexpectedly.
Writing VPCCMD_W_TOUCHPAD may cause a spurious key press.

Add has_touchpad_switch to workaround these machines.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org # 5.4+
--
v2: Specify touchpad to ELAN0634
v3: Stupid missing ! in v2
v4: Correct acpi_dev_present usage (Hans)
Link: https://lore.kernel.org/r/20210107144438.12605-1-jiaxun.yang@flygoat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 7598cd46cf60..5b81bafa5c16 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -92,6 +92,7 @@ struct ideapad_private {
 	struct dentry *debug;
 	unsigned long cfg;
 	bool has_hw_rfkill_switch;
+	bool has_touchpad_switch;
 	const char *fnesc_guid;
 };
 
@@ -535,7 +536,9 @@ static umode_t ideapad_is_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_fn_lock.attr) {
 		supported = acpi_has_method(priv->adev->handle, "HALS") &&
 			acpi_has_method(priv->adev->handle, "SALS");
-	} else
+	} else if (attr == &dev_attr_touchpad.attr)
+		supported = priv->has_touchpad_switch;
+	else
 		supported = true;
 
 	return supported ? attr->mode : 0;
@@ -867,6 +870,9 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
 {
 	unsigned long value;
 
+	if (!priv->has_touchpad_switch)
+		return;
+
 	/* Without reading from EC touchpad LED doesn't switch state */
 	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
 		/* Some IdeaPads don't really turn off touchpad - they only
@@ -989,6 +995,9 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	priv->platform_device = pdev;
 	priv->has_hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
+	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
+	priv->has_touchpad_switch = !acpi_dev_present("ELAN0634", NULL, -1);
+
 	ret = ideapad_sysfs_init(priv);
 	if (ret)
 		return ret;
@@ -1006,6 +1015,10 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	if (!priv->has_hw_rfkill_switch)
 		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
 
+	/* The same for Touchpad */
+	if (!priv->has_touchpad_switch)
+		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
+
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
 			ideapad_register_rfkill(priv, i);

