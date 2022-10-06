Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA385F5E8E
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJFCCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJFCCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:02:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3AE3C144
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 19:02:07 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g28so740133pfk.8
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 19:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaikai-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/bJ6Ot7VHNqG6fD6NCI1uSX1c2aopkFB+w2rPel+p1s=;
        b=40JiXyEh9vQbl/LhcnRw7kqkEY1S10Uo4lBInQ+LUOcpFKxN94kVJTDAX06twrA1hK
         8wSo58pBWJHfgxzN83cA0GrGCc3I0kATmI5TZaXjiup4m8tmVofQRFc9LmnJuGVnW0jq
         AZ43LjLE63aauoem+vXdKWeUFHOvJhrtC5C8GIaEGRLg7Eu/uxRXVSm+Y7BELTi5Z2iO
         AOJOgWlEICq7QugDLxVOadPjk20hhgI9oyOPZbq5rWB1souw52ddka1NqtVYUIGWEzTP
         O7oLO/+g1AC0cJWXdM1Fva2Y8z6x3LGsjY1ZNQ6dN3lViabt+X9kSPuBWfbq3Fa4EjWp
         3lYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/bJ6Ot7VHNqG6fD6NCI1uSX1c2aopkFB+w2rPel+p1s=;
        b=GUyezrORsrk2ufCNFa1mvfvV2vkXtAjbQJMvTEdiyfNe7mx+279OPAmzD4cIASIY/4
         TrgP+CR1P9HeOyTcLf0dG7MGyxC0QWKCcglWncnB7gteAfYSZpGoqwDRZXODzjoiHm0o
         deK3hyQ1RT4bSkq3iKSHoj+4Es6wvUDR93bRLgb7ypzumImj+b7URjdfyZM9DkhgCCBx
         /QhMmsyGT3aOaTHvcsHo6VKRvzMJ6IDDufWctHoNn6ycFFIIlyJbMwaK/Jzy68+UzAmd
         utHePu0k5ev4Ab4g3XaNa2qpOFRB+ENU3ZnEZG+U6r/TtCEcK9ncDNSYEVAsI8mHuGqB
         pEpg==
X-Gm-Message-State: ACrzQf25jBbNNhHCfL7DtTzFIjtrAM3ktVPk9B3jQyn1Frmk0QgWT+ql
        4tLNfPCuaCDsf48lXi/dAmZQEv+7Fs1s8g==
X-Google-Smtp-Source: AMsMyM43rOQmt3i2CiAZoMQxxV8CVsJrYTe+3ZgJzeOysAs2NfFdd5bLtOPBWMR6U5BcFlZK9kw6VQ==
X-Received: by 2002:a63:186:0:b0:442:ee11:48a5 with SMTP id 128-20020a630186000000b00442ee1148a5mr2348422pgb.284.1665021726551;
        Wed, 05 Oct 2022 19:02:06 -0700 (PDT)
Received: from localhost.localdomain (23-122-157-100.lightspeed.irvnca.sbcglobal.net. [23.122.157.100])
        by smtp.gmail.com with ESMTPSA id w13-20020a63d74d000000b0043be67b6304sm482768pgi.0.2022.10.05.19.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 19:02:05 -0700 (PDT)
From:   Roderick Colenbrander <roderick@gaikai.com>
X-Google-Original-From: Roderick Colenbrander <roderick.colenbrander@sony.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] HID: playstation: stop DualSense output work on remove.
Date:   Wed,  5 Oct 2022 19:01:49 -0700
Message-Id: <20221006020151.132434-2-roderick.colenbrander@sony.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221006020151.132434-1-roderick.colenbrander@sony.com>
References: <20221006020151.132434-1-roderick.colenbrander@sony.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure we don't schedule any new output work on removal and wait
for any existing work to complete. If we don't do this e.g. rumble
work can get queued during deletion and we trigger a kernel crash.

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
---
 drivers/hid/hid-playstation.c | 41 ++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 40050eb85c0a..d727cd2bf44e 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -46,6 +46,7 @@ struct ps_device {
 	uint32_t fw_version;
 
 	int (*parse_report)(struct ps_device *dev, struct hid_report *report, u8 *data, int size);
+	void (*remove)(struct ps_device *dev);
 };
 
 /* Calibration data for playstation motion sensors. */
@@ -174,6 +175,7 @@ struct dualsense {
 	struct led_classdev player_leds[5];
 
 	struct work_struct output_worker;
+	bool output_worker_initialized;
 	void *output_report_dmabuf;
 	uint8_t output_seq; /* Sequence number for output report. */
 };
@@ -299,6 +301,7 @@ static const struct {int x; int y; } ps_gamepad_hat_mapping[] = {
 	{0, 0},
 };
 
+static inline void dualsense_schedule_work(struct dualsense *ds);
 static void dualsense_set_lightbar(struct dualsense *ds, uint8_t red, uint8_t green, uint8_t blue);
 
 /*
@@ -789,6 +792,7 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	return ret;
 }
 
+
 static int dualsense_get_firmware_info(struct dualsense *ds)
 {
 	uint8_t *buf;
@@ -878,7 +882,7 @@ static int dualsense_player_led_set_brightness(struct led_classdev *led, enum le
 	ds->update_player_leds = true;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 
 	return 0;
 }
@@ -922,6 +926,16 @@ static void dualsense_init_output_report(struct dualsense *ds, struct dualsense_
 	}
 }
 
+static inline void dualsense_schedule_work(struct dualsense *ds)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ds->base.lock, flags);
+	if (ds->output_worker_initialized)
+		schedule_work(&ds->output_worker);
+	spin_unlock_irqrestore(&ds->base.lock, flags);
+}
+
 /*
  * Helper function to send DualSense output reports. Applies a CRC at the end of a report
  * for Bluetooth reports.
@@ -1082,7 +1096,7 @@ static int dualsense_parse_report(struct ps_device *ps_dev, struct hid_report *r
 		spin_unlock_irqrestore(&ps_dev->lock, flags);
 
 		/* Schedule updating of microphone state at hardware level. */
-		schedule_work(&ds->output_worker);
+		dualsense_schedule_work(ds);
 	}
 	ds->last_btn_mic_state = btn_mic_state;
 
@@ -1197,10 +1211,22 @@ static int dualsense_play_effect(struct input_dev *dev, void *data, struct ff_ef
 	ds->motor_right = effect->u.rumble.weak_magnitude / 256;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 	return 0;
 }
 
+static void dualsense_remove(struct ps_device *ps_dev)
+{
+	struct dualsense *ds = container_of(ps_dev, struct dualsense, base);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ds->base.lock, flags);
+	ds->output_worker_initialized = false;
+	spin_unlock_irqrestore(&ds->base.lock, flags);
+
+	cancel_work_sync(&ds->output_worker);
+}
+
 static int dualsense_reset_leds(struct dualsense *ds)
 {
 	struct dualsense_output_report report;
@@ -1237,7 +1263,7 @@ static void dualsense_set_lightbar(struct dualsense *ds, uint8_t red, uint8_t gr
 	ds->lightbar_blue = blue;
 	spin_unlock_irqrestore(&ds->base.lock, flags);
 
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 }
 
 static void dualsense_set_player_leds(struct dualsense *ds)
@@ -1260,7 +1286,7 @@ static void dualsense_set_player_leds(struct dualsense *ds)
 
 	ds->update_player_leds = true;
 	ds->player_leds_state = player_ids[player_id];
-	schedule_work(&ds->output_worker);
+	dualsense_schedule_work(ds);
 }
 
 static struct ps_device *dualsense_create(struct hid_device *hdev)
@@ -1299,7 +1325,9 @@ static struct ps_device *dualsense_create(struct hid_device *hdev)
 	ps_dev->battery_capacity = 100; /* initial value until parse_report. */
 	ps_dev->battery_status = POWER_SUPPLY_STATUS_UNKNOWN;
 	ps_dev->parse_report = dualsense_parse_report;
+	ps_dev->remove = dualsense_remove;
 	INIT_WORK(&ds->output_worker, dualsense_output_worker);
+	ds->output_worker_initialized = true;
 	hid_set_drvdata(hdev, ds);
 
 	max_output_report_size = sizeof(struct dualsense_output_report_bt);
@@ -1461,6 +1489,9 @@ static void ps_remove(struct hid_device *hdev)
 	ps_devices_list_remove(dev);
 	ps_device_release_player_id(dev);
 
+	if (dev->remove)
+		dev->remove(dev);
+
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }
-- 
2.37.3

