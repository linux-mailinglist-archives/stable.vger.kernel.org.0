Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05455FA6E6
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 23:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiJJVXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 17:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJJVXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 17:23:21 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF136B8CC
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:23:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b15so10835428pje.1
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaikai-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/bJ6Ot7VHNqG6fD6NCI1uSX1c2aopkFB+w2rPel+p1s=;
        b=Ql7z56C2vnkkqAHuGV+MWeBLrVTi9xJt1//Gznt4AguI/dgRZdufRBq22PimF8786i
         XT7KfR2lkx/DdYgeVZHhSeD0jcBLO8vZbe1B4LhBDnqLny5pJtElYyFquUXjvtNPDUQp
         9NV8jGFKMjyjh976QOhmMQeJm+jwCpTe7uVTkUR8vdLFK3/tZivOK/pAYRrxNUi2Yfj4
         IcfqlJtg9GqEkXvFDyBQZSmpRRDzPbsIeY6ZnnUU/YKjs7HwHHHga/boxuyM50h4aAGv
         7dUkFx5pR5NcclZPnqG7Fc+wLszDmkwA5l2G4liP9b+JeHNBiw16cHnPp/tqA30lZpgh
         /mqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bJ6Ot7VHNqG6fD6NCI1uSX1c2aopkFB+w2rPel+p1s=;
        b=7YnNmyq0BWBehpS8wUvWog5BwXd8jgK9jimC4dE/Rm28lO/BRcLgAf0Q6/EQvYuOx+
         yhahzay4HUKWjlZz4Q751Hw++Lfdm0UodSLjb5DMQSNQZ+Gtl0WT6NIW38vWK/pKATGm
         ZPkCPH5j+vGr0dRNEUKkNBSoscL+g8mop8leT7BAfEQfQsLd2EMK5VBGP7HSjRPdtBWF
         M4zRB8bJzywwAEpfSMLyfClDzRTs9Y8X75GW3ewdCQw4KCq0/5izN+FM7TU547NEWQ/y
         FSukrSt+8Ahu+C+yNUWS0epYHRWkQuWLGPWChAIa2i9/bXVNqKXCNQIdubyVQaOi8biJ
         6RYA==
X-Gm-Message-State: ACrzQf20v0UeRnMwae3NhtjisjP8p51rgowfbOoqt/vpliH89nF1BhrO
        uRYpr+tVJIhPOqDR/Jmxm+rTldG/6BF7LA==
X-Google-Smtp-Source: AMsMyM72NSFKNiyUjFQsfybNzV8bKc0sF8mTOHn8rInNO52y1PgXoHpHll1orUvAh6xn/38OUitRbQ==
X-Received: by 2002:a17:90b:17ce:b0:20b:7cb:9397 with SMTP id me14-20020a17090b17ce00b0020b07cb9397mr27137312pjb.191.1665436999910;
        Mon, 10 Oct 2022 14:23:19 -0700 (PDT)
Received: from localhost.localdomain (23-122-157-100.lightspeed.irvnca.sbcglobal.net. [23.122.157.100])
        by smtp.gmail.com with ESMTPSA id d17-20020a621d11000000b0054097cb2da6sm7383876pfd.38.2022.10.10.14.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 14:23:19 -0700 (PDT)
From:   Roderick Colenbrander <roderick@gaikai.com>
X-Google-Original-From: Roderick Colenbrander <roderick.colenbrander@sony.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] HID: playstation: stop DualSense output work on remove.
Date:   Mon, 10 Oct 2022 14:23:11 -0700
Message-Id: <20221010212313.78275-2-roderick.colenbrander@sony.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221010212313.78275-1-roderick.colenbrander@sony.com>
References: <20221010212313.78275-1-roderick.colenbrander@sony.com>
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

