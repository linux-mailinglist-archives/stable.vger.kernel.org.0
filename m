Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968E82E8A1E
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 04:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhACDiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jan 2021 22:38:10 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49733 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbhACDiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jan 2021 22:38:10 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A1477580138;
        Sat,  2 Jan 2021 22:37:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 02 Jan 2021 22:37:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=prgSBV48sskv7qoxiNhz9ZZefl
        FHExPWuOS3tRXXsD4=; b=pOL86OOf8Sse/XpCRDO7WxZlF0nUWkQS0kOYz3VnVt
        p7ZbOpcZoIzW3FLZ1woAIzB66pPQpcJtzCCyhPKbyN07eAdPun8Ers26BpSwVgl1
        mOEZprjot9rVZikuSXGCjp1WeI6E98JK7jLUe7Rcttqqtbi3Fp4KNb2pp9fZfEh0
        M46VvrYB1HwmSerPHaA5dbDWVVCwUX10CmMyYQge8X0rf+6+mlSl68J5Ii9zjNTZ
        NLzMGFzQdSI3B21s2SxOq7qFojMyi/FDAqc34RcBXyTgTZb1oYChgXIhJgKAkEOW
        KUR/orGsJkQJ5Qtatf6Fq/KQFsGCttDR/Sy+cbv1pGOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=prgSBV48sskv7qoxi
        Nhz9ZZeflFHExPWuOS3tRXXsD4=; b=EqSRDVmO5ORlac/JfYspOykp5MklJr6jD
        4FwlCJAsZT8yvWtFgq/t66+mtcXLuTxO9caXzz4eoIySslhrl9mg5DQ472tXgQL/
        O7rrrLHpPMplsEJ1o5IGb9rD146MT/6z0JqvQJbR4Hao+pFuKsvgufr9mlmVa4De
        yOboEUD9Zw6CVa3Ko6Ur7nXsO5CjcT+5jIxGd7DfzV0/EzOIaVrnli0Dyjb2ts8t
        +fiLayEvPwh5I/jB9QEpDr8J+cwe5N6yHugwyvIiLgmzgEjqLjWQPii8yPoLU4Bv
        so/6aPGJuyuBWoqxn1W+mTVCaB0rgdaYDcIlp/MyTRDAdea03WPIw==
X-ME-Sender: <xms:3jvxXzpfYJH_623Gg9ogqSh_3WzImlQ0xjq_BJ-qMmnUF8vPD86bzg>
    <xme:3jvxX9rDBNndy8QaOEIxqBDmz1YGD3Fuyihn_17xwEcfZrn9EDrnZkQ_UbD9zcRhT
    8lfFW4C0g2znqSPqNE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeftddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihunhcu
    jggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecuggftrf
    grthhtvghrnhephfejtdektdeuhedtieefteekveffteejteefgeekveegffetvddugfel
    iefhtddunecukfhppedukeefrdduheejrdefvddruddtudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:3jvxXwOYVT-KAm-zUs-LQFYGGpeYFAuF2kYf5in6l8TvYcSE9pspLQ>
    <xmx:3jvxX27Xq99Dpo818kxbNHeEIHIYdrmLQ7lC9RqjjsQ-J8LbJzSFgg>
    <xmx:3jvxXy5SY9lQwCXmZB-ZFAJoiezviBA7K8Z3EhlbG_F4ljq3p2xZQA>
    <xmx:3zvxX4koH-f0TtwSyAE6HwW_e1JEGTXt9piBCeZoY6SDdqu8Z52oyw>
Received: from strike.202.net.flygoat.com (unknown [183.157.32.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78217108005C;
        Sat,  2 Jan 2021 22:36:58 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     platform-driver-x86@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH fixes v3] platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634
Date:   Sun,  3 Jan 2021 11:36:51 +0800
Message-Id: <20210103033651.47580-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/platform/x86/ideapad-laptop.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 7598cd46cf60..427970b3b0da 100644
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
+	priv->has_touchpad_switch = !acpi_dev_present("PNP0C50", "ELAN0634", -1);
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
-- 
2.30.0

