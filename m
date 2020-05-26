Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BBD1AC374
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441602AbgDPNnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441590AbgDPNnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9465B2076D;
        Thu, 16 Apr 2020 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044597;
        bh=1Nbx4WvLj84+n0M/+Kj4ou1MfifW815+ZChWgpnGHsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4urDn53AGDol5NGozc+qsh9dTW0ux53zIvDJPqMokuG9zIbGcOfDTOL5kSsrAN1g
         7kw5EKtH818IMqT4WpcThUItvU2maWOJNRjpMJP+kkworaXoXpPqJKyoxqNmuGlR69
         9VS1r2z7l6cXmAPm8qnin4RRSgCOp8r/lhV1ZCHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Rasim <mohammad.rasim96@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/232] media: rc: add keymap for Videostrong KII Pro
Date:   Thu, 16 Apr 2020 15:21:58 +0200
Message-Id: <20200416131319.287542456@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Rasim <mohammad.rasim96@gmail.com>

[ Upstream commit 30defecb98400575349a7d32f0526e1dc42ea83e ]

This is an NEC remote control device shipped with the Videostrong KII Pro
tv box as well as other devices from videostrong.

Signed-off-by: Mohammad Rasim <mohammad.rasim96@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/keymaps/Makefile             |  1 +
 .../media/rc/keymaps/rc-videostrong-kii-pro.c | 83 +++++++++++++++++++
 include/media/rc-map.h                        |  1 +
 3 files changed, 85 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-videostrong-kii-pro.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index a56fc634d2d68..ea91a9afa6a02 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -117,6 +117,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-videomate-m1f.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
+			rc-videostrong-kii-pro.o \
 			rc-wetek-hub.o \
 			rc-wetek-play2.o \
 			rc-winfast.o \
diff --git a/drivers/media/rc/keymaps/rc-videostrong-kii-pro.c b/drivers/media/rc/keymaps/rc-videostrong-kii-pro.c
new file mode 100644
index 0000000000000..414d4d231e7ed
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-videostrong-kii-pro.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2019 Mohammad Rasim <mohammad.rasim96@gmail.com>
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+//
+// Keytable for the Videostrong KII Pro STB remote control
+//
+
+static struct rc_map_table kii_pro[] = {
+	{ 0x59, KEY_POWER },
+	{ 0x19, KEY_MUTE },
+	{ 0x42, KEY_RED },
+	{ 0x40, KEY_GREEN },
+	{ 0x00, KEY_YELLOW },
+	{ 0x03, KEY_BLUE },
+	{ 0x4a, KEY_BACK },
+	{ 0x48, KEY_FORWARD },
+	{ 0x08, KEY_PREVIOUSSONG},
+	{ 0x0b, KEY_NEXTSONG},
+	{ 0x46, KEY_PLAYPAUSE },
+	{ 0x44, KEY_STOP },
+	{ 0x1f, KEY_FAVORITES},	//KEY_F5?
+	{ 0x04, KEY_PVR },
+	{ 0x4d, KEY_EPG },
+	{ 0x02, KEY_INFO },
+	{ 0x09, KEY_SUBTITLE },
+	{ 0x01, KEY_AUDIO },
+	{ 0x0d, KEY_HOMEPAGE },
+	{ 0x11, KEY_TV },	// DTV ?
+	{ 0x06, KEY_UP },
+	{ 0x5a, KEY_LEFT },
+	{ 0x1a, KEY_ENTER },	// KEY_OK ?
+	{ 0x1b, KEY_RIGHT },
+	{ 0x16, KEY_DOWN },
+	{ 0x45, KEY_MENU },
+	{ 0x05, KEY_ESC },
+	{ 0x13, KEY_VOLUMEUP },
+	{ 0x17, KEY_VOLUMEDOWN },
+	{ 0x58, KEY_APPSELECT },
+	{ 0x12, KEY_VENDOR },	// mouse
+	{ 0x55, KEY_PAGEUP },	// KEY_CHANNELUP ?
+	{ 0x15, KEY_PAGEDOWN },	// KEY_CHANNELDOWN ?
+	{ 0x52, KEY_1 },
+	{ 0x50, KEY_2 },
+	{ 0x10, KEY_3 },
+	{ 0x56, KEY_4 },
+	{ 0x54, KEY_5 },
+	{ 0x14, KEY_6 },
+	{ 0x4e, KEY_7 },
+	{ 0x4c, KEY_8 },
+	{ 0x0c, KEY_9 },
+	{ 0x18, KEY_WWW },	// KEY_F7
+	{ 0x0f, KEY_0 },
+	{ 0x51, KEY_BACKSPACE },
+};
+
+static struct rc_map_list kii_pro_map = {
+	.map = {
+		.scan     = kii_pro,
+		.size     = ARRAY_SIZE(kii_pro),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_KII_PRO,
+	}
+};
+
+static int __init init_rc_map_kii_pro(void)
+{
+	return rc_map_register(&kii_pro_map);
+}
+
+static void __exit exit_rc_map_kii_pro(void)
+{
+	rc_map_unregister(&kii_pro_map);
+}
+
+module_init(init_rc_map_kii_pro)
+module_exit(exit_rc_map_kii_pro)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mohammad Rasim <mohammad.rasim96@gmail.com>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index afd2ab31bdf2d..c2ef3906e1cd1 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -271,6 +271,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_VIDEOMATE_K100            "rc-videomate-k100"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
+#define RC_MAP_KII_PRO                   "rc-videostrong-kii-pro"
 #define RC_MAP_WETEK_HUB                 "rc-wetek-hub"
 #define RC_MAP_WETEK_PLAY2               "rc-wetek-play2"
 #define RC_MAP_WINFAST                   "rc-winfast"
-- 
2.20.1



