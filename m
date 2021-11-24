Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2835045BEFF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbhKXMy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:54:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345588AbhKXMud (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:50:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A3566135E;
        Wed, 24 Nov 2021 12:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756970;
        bh=zs3y7/UwMDHGcVsbwdhIOhK7Nehmn9XCw0Gd6mMCnX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdKmZW55D0iJw/0ZVx33mNHEbqq9gPYbf4jTq9DCdcfvX2ZkhRfj5DPpi93wuQa2I
         ak1fJNqU2i6n9qi3GkJ1Ilamkw+W768h3GwPWft3AGpXe/4CR6HDv2N39gBAICwFLb
         WF22qP8ZoJ5o335OZaayS9yBdqAbLfaZrsJF/qzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Gompa <ngompa13@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 005/323] Input: i8042 - Add quirk for Fujitsu Lifebook T725
Date:   Wed, 24 Nov 2021 12:53:15 +0100
Message-Id: <20211124115719.005058545@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 16e28abb7290c4ca3b3a0f333ba067f34bb18c86 upstream.

Fujitsu Lifebook T725 laptop requires, like a few other similar
models, the nomux and notimeout options to probe the touchpad
properly.  This patch adds the corresponding quirk entries.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1191980
Tested-by: Neal Gompa <ngompa13@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211103070019.13374-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -277,6 +277,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Fujitsu Lifebook T725 laptop */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
+		},
+	},
+	{
 		/* Fujitsu Lifebook U745 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
@@ -845,6 +852,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Fujitsu Lifebook T725 laptop */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK T725"),
+		},
+	},
+	{
 		/* Fujitsu U574 laptop */
 		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {


