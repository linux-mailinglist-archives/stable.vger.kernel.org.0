Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22BB2E8A13
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 04:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbhACDEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jan 2021 22:04:54 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44339 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbhACDEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jan 2021 22:04:53 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 63F21580300;
        Sat,  2 Jan 2021 22:03:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 02 Jan 2021 22:03:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=34DA642wIHVqOSnPLGDFVK5mdJ
        RElXLDheOtXgf+oEQ=; b=ffYAd7eZNCSOxKrBZq07D6PvrDNyihf43Q5gFJAwYW
        FhcCXyLBXfBE792kb8/AWc3QM0Cs7vBUMMoqyLuSiDEkhuNK/mU9Ic+wIPgy0Kux
        /h0NobUwclq7B3TXdaKXzIOHgtX/V5d5qc+yiejuoIb6kybCVp7vW6pUm+uRzAzd
        ZFqprZ9Qrlo9yJBruB76gXhULhkW0LnOqnajC7uw/PrK2jPg/RLvR9LN+AbSBMhD
        xmNKQONp1vHQbjRGZnsf1hiSG3IsCOoTVsn9vtObbYzkJu9Lm3TV4YDPcA98YvXV
        0ctNAIE+S4ILydDWpl8yAHLBrrgErl9JRhtJjGyGOE9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=34DA642wIHVqOSnPL
        GDFVK5mdJRElXLDheOtXgf+oEQ=; b=GMuyjLsmOyh2umDyQK0HVarSHbWdH3pij
        XIJoex0K/XV6XEp5K3y/QhMeLYPXwx/24bmoWSnnvVcmO+6XQJcjBzL0sHtDB86/
        QR4tavNcdwaRN8F7+B4LFIouQTMKrL1ZjabTj8h3opTtf62F/uTvHmh22ijBk7bY
        hE7qwkVNBuqXmBfshEfLjiLkLTcV4dQMitLAfokzAfH22qvhdp0ai9kPgN+bOpCW
        Afpx1mUsIu/bsEIBN4jaRNKzgTJKy07DcuL7bvlCfUTtM9DtVwFqBDeKs92OHFJl
        mahq/8cf/dMAukSDzj4QtfHi+Lk4yQ7atcX5vT4DzpqpKTlWKzPDw==
X-ME-Sender: <xms:ETTxX15gcYPWMVlAR60x2PobIaItK8V12XS3NNOJiy_28HdDLdDGbg>
    <xme:ETTxXy6YeHbXNuiLLOwD7ew81zwMScL7LGyXXEweK69smH3DVxsNIPqbcu0rskJfO
    i_R9QHAiG-c5ZDbPxM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeftddgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihunhcu
    jggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecuggftrf
    grthhtvghrnhephfejtdektdeuhedtieefteekveffteejteefgeekveegffetvddugfel
    iefhtddunecukfhppedukeefrdduheejrdefvddruddtudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:ETTxX8d32u_q9DJpKVD6ONTB-BK_4ySga-wywdzAf3JIJkE4tthyHA>
    <xmx:ETTxX-I1-alLNQ3qDFFIVcpPJEAE7vEyMRIOvLGnCffmSZ5iFryt4w>
    <xmx:ETTxX5LBICr2SSeJSqYhmW_FhTrE5o9q3uAclNf_uxqCG0WWpU8B1w>
    <xmx:EjTxX50ML_lH0uHvz6mKIBUx_RWPCHxbf8gxIWwedJpYhedrA8sKzw>
Received: from strike.202.net.flygoat.com (unknown [183.157.32.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A64824005C;
        Sat,  2 Jan 2021 22:03:41 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     platform-driver-x86@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH fixes v2] platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634
Date:   Sun,  3 Jan 2021 11:03:32 +0800
Message-Id: <20210103030332.34185-1-jiaxun.yang@flygoat.com>
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
---
 drivers/platform/x86/ideapad-laptop.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 7598cd46cf60..3bd29eb956d2 100644
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
+	priv->has_touchpad_switch = acpi_dev_present("PNP0C50", "ELAN0634", -1);
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

