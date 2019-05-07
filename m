Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1412416ABD
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfEGSx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:53:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41719 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfEGSx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:53:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id z3so5051724pgp.8;
        Tue, 07 May 2019 11:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXrjZyI3zkrddTH2jXfU6DTNpkL2FJKBOlWlMqHcmC8=;
        b=GBuj+tgmXa5/s1NYjDwoz5pAxoVfUfFh9XEMdgaGneb26j7IoLtJwEqWNbizUMEhDc
         sRC6cGzA/aScrE62z/8c9inskY95BXcPRG/2L8Yenj/euk4h/74dbivWxEcbC5uArAd1
         8cYLu8WFmR5KpwwYZ3btj3KbIU8J14dr/Wttu426GpKsToW9CwV4L4kkCo3N9rMS5Pnq
         PxC6PEuRZD4CA1IFsjAacsNPI5evPX7KSBh3pB1KU5tmpzBU/JvVp/QgRzGRJ2Vu3xf1
         RMYaoRpqZ9Cd0s7ACNwGlR+ydK4oIb+r7W9G3S/1tpHjqFp5IjU1tmk56PCTZy8zeS/2
         M7vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXrjZyI3zkrddTH2jXfU6DTNpkL2FJKBOlWlMqHcmC8=;
        b=ooBEH9KLiDs0Uw4SFJA/Av1pz9mzV16zNyqPvk7TZd1u80KjasnEmIRN9UU4FDnefR
         o9Bak7Rg15FJDqskDwnhB+ergsAnDqQVfPSbJ+9C6gtmvx2dvhLfVhkrzMjfviYyMatw
         YyGUJr+J/wQ0+i904cg6QFclcRWy8vc2lXljCdyPOuyex7tf4mh1phgs61NhMZD9zZES
         xwcZlNxJOqmPRHmdmaBxefUDwUQryucCBdodUu64pG4j1DXicCqvLGNQXWb5CXdWJ0fQ
         TNmfsApISik4mwx7U7WAx+i/bVmaHp4iQZwDq+Zrnb9kBbriZJs4fJjlR1fSUPYpTop9
         sZCQ==
X-Gm-Message-State: APjAAAVuuJ3NfJAXdLmiiczNL2TE6L0ydkXmiqJdabslK894bb2L3N2H
        dU/qaw1wQMauHt+GPiov9ToZWam/
X-Google-Smtp-Source: APXvYqxFaczlhP4zjYw0VoWBQEdUx7il02UF2a56ByVu6lbe5B4V3NrvOsUw4tA6yjD1eEtu40yAuw==
X-Received: by 2002:a63:f843:: with SMTP id v3mr41254597pgj.69.1557255207917;
        Tue, 07 May 2019 11:53:27 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id w189sm20085506pfw.147.2019.05.07.11.53.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 11:53:26 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Aaron Skomra <aaron.skomra@wacom.com>
Subject: [PATCH 2/3] HID: wacom: Correct button numbering 2nd-gen Intuos Pro over Bluetooth
Date:   Tue,  7 May 2019 11:53:21 -0700
Message-Id: <20190507185322.7168-2-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507185322.7168-1-jason.gerecke@wacom.com>
References: <20190507185322.7168-1-jason.gerecke@wacom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

The button numbering of the 2nd-gen Intuos Pro is not consistent between
the USB and Bluetooth interfaces. Over USB, the HID_GENERIC codepath
enumerates the eight ExpressKeys first (BTN_0 - BTN_7) followed by the
center modeswitch button (BTN_8). The Bluetooth codepath, however, has
the center modeswitch button as BTN_0 and the the eight ExpressKeys as
BTN_1 - BTN_8. To ensure userspace button mappings do not change
depending on how the tablet is connected, modify the Bluetooth codepath
to report buttons in the same order as USB.

To ensure the mode switch LED continues to toggle in response to the
mode switch button, the `wacom_is_led_toggled` function also requires
a small update.

Link: https://github.com/linuxwacom/input-wacom/pull/79
Fixes: 4922cd26f0 ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Skomra <aaron.skomra@wacom.com>
---
 drivers/hid/wacom_wac.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index af62a630fee9..e848445236d8 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1383,7 +1383,7 @@ static void wacom_intuos_pro2_bt_pad(struct wacom_wac *wacom)
 	struct input_dev *pad_input = wacom->pad_input;
 	unsigned char *data = wacom->data;
 
-	int buttons = (data[282] << 1) | ((data[281] >> 6) & 0x01);
+	int buttons = data[282] | ((data[281] & 0x40) << 2);
 	int ring = data[285] & 0x7F;
 	bool ringstatus = data[285] & 0x80;
 	bool prox = buttons || ringstatus;
@@ -3832,7 +3832,7 @@ static void wacom_24hd_update_leds(struct wacom *wacom, int mask, int group)
 static bool wacom_is_led_toggled(struct wacom *wacom, int button_count,
 				 int mask, int group)
 {
-	int button_per_group;
+	int group_button;
 
 	/*
 	 * 21UX2 has LED group 1 to the left and LED group 0
@@ -3842,9 +3842,12 @@ static bool wacom_is_led_toggled(struct wacom *wacom, int button_count,
 	if (wacom->wacom_wac.features.type == WACOM_21UX2)
 		group = 1 - group;
 
-	button_per_group = button_count/wacom->led.count;
+	group_button = group * (button_count/wacom->led.count);
 
-	return mask & (1 << (group * button_per_group));
+	if (wacom->wacom_wac.features.type == INTUOSP2_BT)
+		group_button = 8;
+
+	return mask & (1 << group_button);
 }
 
 static void wacom_update_led(struct wacom *wacom, int button_count, int mask,
-- 
2.21.0

