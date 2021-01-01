Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62382E833B
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 07:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbhAAGNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 01:13:04 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:53483 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726322AbhAAGND (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 01:13:03 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 4079AF6C;
        Fri,  1 Jan 2021 01:12:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 01 Jan 2021 01:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=I1lXXepHh7qPnRgGVeB12wxdX+
        RVecLFPZFy7yLCB74=; b=DACcTb4GzlfcUBKDnmJV6y4wiL0Ra9b33BKwJlpzRi
        hAz4QLGtM41crvLvkIftnhMsxL9L3T9lvpzdgfRdM1y3v0rspdKYgRg3sLcmejZL
        TfuEZobpOWEYVq+QiKnVCyB9ViOR/FEpaA9Z9je0GG/SlbOV6u9R/UUHimC3PqW6
        j8WQ42Tch3YeXUJRVVzYgRiwVzaF9+tzkH2Oco7371tLiqDJNFO+00yxSKl3MeJl
        qjJ7TNmgzomz3VaVMgoOf6qFNFhmnacVam9VfeIuV/48DqKMk/31mCkVQAefrISI
        m61UmcAfNf501200WT7orbHqvA/8SJRx2H6PF0q7Lc7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=I1lXXepHh7qPnRgGV
        eB12wxdX+RVecLFPZFy7yLCB74=; b=mqTMC2ylhip+02l+28p0rJ26XyYWff7pI
        abHmguMNwwNzqjuFT3HOmWVRVF6gdE1SvfmO3g9C7FHQ79ZdwF5Y0fm38AfMifAT
        Dw+aB9VFZRmW/Iz8xbASmFySkMMvzLAHqqH7nDKgL5YrO/EpIh0hOOGcl3JdrDL6
        VU5bKDHh/H+guoNORT0EdevRu4QcywfL0FUgO0zdHOlz0rS3YfFmm5F+QGPVh2FR
        dugZFuzoSEMLAwUuyhUN0s8XKLtr+pQ8KxAqAuermmsSABIgIZeKs/aLYKzXNtj6
        xiFz4H4VU01P0NMEica3QDaR/SnDMxOaPJFiMqsh0bydEugnl1XCg==
X-ME-Sender: <xms:P73uX5HZwA_6lRIwk06rY9HHfNdejLBlbh9I3CbWNJfxL12VOSfG3w>
    <xme:P73uX-UEN5C7gzSnm9mQ8WhewM8ioMvGWjdKzpFPnPON8DIW_WTsyo_R7DBPoqDjV
    vFGKq8OhsyF8Utusks>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddviedgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihunhcu
    jggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecuggftrf
    grthhtvghrnhephfejtdektdeuhedtieefteekveffteejteefgeekveegffetvddugfel
    iefhtddunecukfhppeeitddrudejjedrudekledrudejudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:P73uX7IrT-a5QyBrdCEsnpALU6dDU_ceNNrjxjRh0pkLydaYCKT0dQ>
    <xmx:P73uX_Hy8hn-Qt-fs7U0CLHnyVmW0-DAiukP37s6LlxpdSVBrElUTA>
    <xmx:P73uX_W6JYOKqENX0IxqD6ZMVhij9AQbt17cWyaQYa3Aym2TR6YQMw>
    <xmx:QL3uX6SL_m7qNnkG0fNF14VV4cdjJ5W-CZ24ynEHW7on0gR8uKvKqV-HN8o>
Received: from strike.202.net.flygoat.com (unknown [60.177.189.171])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA0F724005A;
        Fri,  1 Jan 2021 01:12:08 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     platform-driver-x86@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] platform/x86: ideapad-laptop: Add has_touchpad_switch
Date:   Fri,  1 Jan 2021 14:11:40 +0800
Message-Id: <20210101061140.27547-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Newer ideapads (e.g.: Yoga 14s, 720S 14) comes with I2C HID
Touchpad and do not use EC to switch touchpad. Reading VPCCMD_R_TOUCHPAD
will return zero thus touchpad may be blocked. Writing VPCCMD_W_TOUCHPAD
may cause a spurious key press.

Add has_touchpad_switch to workaround these machines.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org # 5.4+
---
 drivers/platform/x86/ideapad-laptop.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 7598cd46cf60..b6a4db37d0fc 100644
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
@@ -989,6 +995,12 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	priv->platform_device = pdev;
 	priv->has_hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
+	/* Most ideapads with I2C HID don't use EC touchpad switch */
+	if (acpi_dev_present("PNP0C50", NULL, -1))
+		priv->has_touchpad_switch = false;
+	else
+		priv->has_touchpad_switch = true;
+
 	ret = ideapad_sysfs_init(priv);
 	if (ret)
 		return ret;
@@ -1006,6 +1018,10 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	if (!priv->has_hw_rfkill_switch)
 		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
 
+	/* The same for Touchpad */
+	if (!priv->has_touchpad_switch)
+		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
+
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
 			ideapad_register_rfkill(priv, i);
-- 
2.30.0

