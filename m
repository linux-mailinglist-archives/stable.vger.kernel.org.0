Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3481A2469
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgDHO7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:59:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44695 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDHO7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 10:59:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id b72so2496825pfb.11;
        Wed, 08 Apr 2020 07:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iErtI+DbxKTgj+x4PqFz5xOX1uJj43iKC4UnTZq4iQs=;
        b=eHd/Z/tZIHWzXX4nfIMZ/8KXkT0Yex/eR0DMpGDIkeifdODcZdvlnl8P5PxF44Ge8h
         e5YdZfFJSHHzje2TZgdTInToUGYmDQlIGKePZ3WsS35xNWid9jkZ0kkMGtPe79Y7MX+F
         qflcKeATsXfX0jBg7W3iSGHRdtjnJiWMyt2a2mITWedoWPgrCBn7IVfsu2LtVNqeYwil
         skqMLZ3nDJ9XdiiFDPnSY/fyWy/FnM+q/lEDTyAYgWOE8DVaG1b1vhnVWjpTVGAvoG1n
         nbleRWG5GE0/2NPGeuS5UL/Y2XsYG3zBWE1ngdKlm6qDPLuDxoXoAejS2YBgT29goZUu
         5pzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iErtI+DbxKTgj+x4PqFz5xOX1uJj43iKC4UnTZq4iQs=;
        b=MI6HtACX+yR+zUfbjFa9E2n6zY88sWRrQTnuByG7+Jl2D5+bUtInpeim/w4j7MWl/W
         lCcpHOUqty1YfT0drC/qojxK5cfdshYEx1jCWelRFH7qwlIR4AV5JDAcKnK+dPcI/OAq
         X3oqetr633T6UGQI4TLxZ9Qlp2OvWAfTkxETDJHy99QnvLG+bH7z7SeN6s+h//7lP4ht
         u+hNRe7b6z0i2I3p8ZwDdUeEEWjmOSULHeoywj+h0lNhceXVcUIpq5FiO0iZraPn57Un
         nqzDl+tex/17UCj44SWJVcYonziwK4wJkmDwMD+Ai3YUwSp5l7/oW8HIxyYDxxH2ONOX
         1pPQ==
X-Gm-Message-State: AGi0PuaUOdYpWlKjs9n/9VS9qVTNiBZtFGYY+MsnY7DKaV+WCf9iAtmw
        3hLA6S0Iu4DgJYRh4OeTzeCVEinAdlE=
X-Google-Smtp-Source: APiQypKt2ZrF57hA1wR3DlWK1Z6mTWQUTXLcFgMTpN+uhfutP+7Z1CbIKyUmP/QGvR52TWc2sKOqLQ==
X-Received: by 2002:a65:5189:: with SMTP id h9mr7141339pgq.296.1586357949547;
        Wed, 08 Apr 2020 07:59:09 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com (75-164-203-136.ptld.qwest.net. [75.164.203.136])
        by smtp.gmail.com with ESMTPSA id m29sm15594256pgl.35.2020.04.08.07.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 07:59:08 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        stable@vger.kernel.org
Subject: [PATCH] Revert "HID: wacom: generic: read the number of expected touches on a per collection basis"
Date:   Wed,  8 Apr 2020 07:58:37 -0700
Message-Id: <20200408145837.21961-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

This reverts commit 15893fa40109f5e7c67eeb8da62267d0fdf0be9d.

The referenced commit broke pen and touch input for a variety of devices
such as the Cintiq Pro 32. Affected devices may appear to work normally
for a short amount of time, but eventually loose track of actual touch
state and can leave touch arbitration enabled which prevents the pen
from working. The commit is not itself required for any currently-available
Bluetooth device, and so we revert it to correct the behavior of broken
devices.

This breakage occurs due to a mismatch between the order of collections
and the order of usages on some devices. This commit tries to read the
contact count before processing events, but will fail if the contact
count does not occur prior to the first logical finger collection. This
is the case for devices like the Cintiq Pro 32 which place the contact
count at the very end of the report.

Without the contact count set, touches will only be partially processed.
The `wacom_wac_finger_slot` function will not open any slots since the
number of contacts seen is greater than the expectation of 0, but we will
still end up calling `input_mt_sync_frame` for each finger anyway. This
can cause problems for userspace separate from the issue currently taking
place in the kernel. Only once all of the individual finger collections
have been processed do we finally get to the enclosing collection which
contains the contact count. The value ends up being used for the *next*
report, however.

This delayed use of the contact count can cause the driver to loose track
of the actual touch state and believe that there are contacts down when
there aren't. This leaves touch arbitration enabled and prevents the pen
from working. It can also cause userspace to incorrectly treat single-
finger input as gestures.

Link: https://github.com/linuxwacom/input-wacom/issues/146
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Fixes: 15893fa40109 ("HID: wacom: generic: read the number of expected touches on a per collection basis")
Cc: stable@vger.kernel.org # 5.3+
---
 drivers/hid/wacom_wac.c | 79 +++++++++--------------------------------
 1 file changed, 16 insertions(+), 63 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index d99a9d407671..96d00eba99c0 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2637,9 +2637,25 @@ static void wacom_wac_finger_pre_report(struct hid_device *hdev,
 			case HID_DG_TIPSWITCH:
 				hid_data->last_slot_field = equivalent_usage;
 				break;
+			case HID_DG_CONTACTCOUNT:
+				hid_data->cc_report = report->id;
+				hid_data->cc_index = i;
+				hid_data->cc_value_index = j;
+				break;
 			}
 		}
 	}
+
+	if (hid_data->cc_report != 0 &&
+	    hid_data->cc_index >= 0) {
+		struct hid_field *field = report->field[hid_data->cc_index];
+		int value = field->value[hid_data->cc_value_index];
+		if (value)
+			hid_data->num_expected = value;
+	}
+	else {
+		hid_data->num_expected = wacom_wac->features.touch_max;
+	}
 }
 
 static void wacom_wac_finger_report(struct hid_device *hdev,
@@ -2649,7 +2665,6 @@ static void wacom_wac_finger_report(struct hid_device *hdev,
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
 	struct input_dev *input = wacom_wac->touch_input;
 	unsigned touch_max = wacom_wac->features.touch_max;
-	struct hid_data *hid_data = &wacom_wac->hid_data;
 
 	/* If more packets of data are expected, give us a chance to
 	 * process them rather than immediately syncing a partial
@@ -2663,7 +2678,6 @@ static void wacom_wac_finger_report(struct hid_device *hdev,
 
 	input_sync(input);
 	wacom_wac->hid_data.num_received = 0;
-	hid_data->num_expected = 0;
 
 	/* keep touch state for pen event */
 	wacom_wac->shared->touch_down = wacom_wac_finger_count_touches(wacom_wac);
@@ -2738,73 +2752,12 @@ static void wacom_report_events(struct hid_device *hdev,
 	}
 }
 
-static void wacom_set_num_expected(struct hid_device *hdev,
-				   struct hid_report *report,
-				   int collection_index,
-				   struct hid_field *field,
-				   int field_index)
-{
-	struct wacom *wacom = hid_get_drvdata(hdev);
-	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
-	struct hid_data *hid_data = &wacom_wac->hid_data;
-	unsigned int original_collection_level =
-		hdev->collection[collection_index].level;
-	bool end_collection = false;
-	int i;
-
-	if (hid_data->num_expected)
-		return;
-
-	// find the contact count value for this segment
-	for (i = field_index; i < report->maxfield && !end_collection; i++) {
-		struct hid_field *field = report->field[i];
-		unsigned int field_level =
-			hdev->collection[field->usage[0].collection_index].level;
-		unsigned int j;
-
-		if (field_level != original_collection_level)
-			continue;
-
-		for (j = 0; j < field->maxusage; j++) {
-			struct hid_usage *usage = &field->usage[j];
-
-			if (usage->collection_index != collection_index) {
-				end_collection = true;
-				break;
-			}
-			if (wacom_equivalent_usage(usage->hid) == HID_DG_CONTACTCOUNT) {
-				hid_data->cc_report = report->id;
-				hid_data->cc_index = i;
-				hid_data->cc_value_index = j;
-
-				if (hid_data->cc_report != 0 &&
-				    hid_data->cc_index >= 0) {
-
-					struct hid_field *field =
-						report->field[hid_data->cc_index];
-					int value =
-						field->value[hid_data->cc_value_index];
-
-					if (value)
-						hid_data->num_expected = value;
-				}
-			}
-		}
-	}
-
-	if (hid_data->cc_report == 0 || hid_data->cc_index < 0)
-		hid_data->num_expected = wacom_wac->features.touch_max;
-}
-
 static int wacom_wac_collection(struct hid_device *hdev, struct hid_report *report,
 			 int collection_index, struct hid_field *field,
 			 int field_index)
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 
-	if (WACOM_FINGER_FIELD(field))
-		wacom_set_num_expected(hdev, report, collection_index, field,
-				       field_index);
 	wacom_report_events(hdev, report, collection_index, field_index);
 
 	/*
-- 
2.26.0

