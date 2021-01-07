Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0042ED2F8
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbhAGOp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:45:58 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:46647 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727789AbhAGOp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 09:45:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id E48E01804;
        Thu,  7 Jan 2021 09:45:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 09:45:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=hFwjh/ZpvoJpdLxkGcSqLHl/+S
        LEYanliGHFuQMPbQU=; b=bH+4wenJyqRl5SdQii4f/V8Fw8rZ4UzT3N7S3Qt8TL
        rT6W0niqzP07Xsl5w17QiNhCdmL1cIlZRppCkxiSujiefFQcJXcZ9fHRZ7CzFOQy
        zYEugI19/wq4MF2IOcC+2VBmB3SiCpDzULFcbappDTczAYKKK1JUEc8yUkdBy6GH
        bOX2IaGumNpJpFtoqDr5oXMvTpWv0J6roIwWRyOC5zLItN+yVD3M5ZvLmCvz40/i
        tgcz8lrlTWzmUa0cWRL9T/DIKXS+ZYU7dT2gWOM+JacAAS5jArWCoUCayGvBgYcQ
        kf4pZPbh6XbXHbocxHFErLI33UjlEk9tztQN5z8+gFUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hFwjh/ZpvoJpdLxkG
        cSqLHl/+SLEYanliGHFuQMPbQU=; b=AhwK72PA7U/+/L48rgDWTFxLhgYfH7YM/
        kEcLLZ+26Kf0H+LlVYgafk1u7v81GcP7VnY8MuLcYz800Bhwwe14YFTZ3HJJwf9I
        OQuNFj320Nvrv/uvzpWqbqQBE0RF/zDyIko0qNXcBxd+ysdvvYIWWy8FUms9x7lx
        9ve3Ol8a1JcYHD+iqWTMLGfQedt9lsNC8NyScDjQsarL65a8v1sxyX5wKwnIvN1e
        t7SS1I6JOL0Rpd+Ah/mCadPlCxUnmxgHEgZ4+O8rT2UYjhWh7d+V30W1La/Jm5Z+
        eyuCmDmNIt8pigSEu1+0kOr3oe1UYkjTkE1CGfKZlh+iBH3p8hWSg==
X-ME-Sender: <xms:dh73XxdYVRE-q3gA_3dzstC3Ufw9actAJCjEwVTu2kDsnz2BwtILbA>
    <xme:dh73X6JK38Qyt0BjBkiIl3TCBu4urqycqqgC7YViSX57I_D_X_BTQHFg-xCVHXdeu
    cCl3ghNkTl7YgmdDBI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihunhcu
    jggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecuggftrf
    grthhtvghrnhephfejtdektdeuhedtieefteekveffteejteefgeekveegffetvddugfel
    iefhtddunecukfhppedutddurdekgedrgeeirdegudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghho
    rghtrdgtohhm
X-ME-Proxy: <xmx:dh73X5jJgMeFgd8v1A7k89F931qWgwWdArGoY1wOGniCZFEKO6OqUA>
    <xmx:dh73XwRq4k0MJ-HluxcgT6EkyrJNygwNS5LTLGQ_V-ku1Z0nBfWPtw>
    <xmx:dh73X7WXmrOWgJPTT5uKCsAaDmc4FZZ9-c_oZcloNtKHDvP2whbVbA>
    <xmx:dx73X3MFJms5Dw8iBSpa2z1fRpHt2KcBK__qXl3XjVJ1lvK7x6D18b6I9FM>
Received: from localhost.localdomain (unknown [101.84.46.41])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C6BC240064;
        Thu,  7 Jan 2021 09:44:59 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     platform-driver-x86@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH fixes v4] platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634
Date:   Thu,  7 Jan 2021 22:44:38 +0800
Message-Id: <20210107144438.12605-1-jiaxun.yang@flygoat.com>
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
v4: Correct acpi_dev_present usage (Hans)
---
 drivers/platform/x86/ideapad-laptop.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

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
-- 
2.30.0

