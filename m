Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75475470E5
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfFOPb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:31:26 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47299 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfFOPb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:31:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5132B20CCC;
        Sat, 15 Jun 2019 11:31:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 11:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tCzCax
        0mNwmnTEEc9/ltX6fZGlcPpmEWV+3K4LcPUNQ=; b=fcHK8Qt8y2t0e8L7nlh+d7
        DnruG/cp83mP41U1hGw9jBxmxoxPzR54XHV35lglkvc8v5ahNynajSeVtXskLvs3
        c7gzL9HGoq7Tgsr/b9O8p+agoD9VRzJVULDlIFklDU/iNgGM6cUdRgjQ6NeENJbH
        Ram06dptLLM0iH0ZB/pBGAl5foBSTqBqsiBUORwGVbWuASUWxmDahoIlXbHDKlkY
        snsLxBuKWlcbOy1wkIDHTjgSk5VB79kWZTvzo9J2DfxobkBc9R4kTjhpSVr20Pev
        JLitEFcGzh/ZjHbfv8cEDcrhK7J3Vm30/BzWrNJDfbCu7hKf3I64Sdo1xCjCM0uw
        ==
X-ME-Sender: <xms:TQ8FXeV6Az9zqccM9-IVLhwhXoLZfXURUKYVjEWDsgg9rYAVp2ZzOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:TQ8FXW5LgR1bBb_GuPhQAFOqlS5rpKxBfOV-_RaYF0dcu-_Zntr0IQ>
    <xmx:TQ8FXXE3FWr2JQzo_4h0_G4Ii4jIbEaNudtf_FsXySoi19uF7xmStg>
    <xmx:TQ8FXZ0XY_0ErZg5Ht_4UCa-rE8UOfqjKyVCnJxLZqQ24Er6BC-VeQ>
    <xmx:TQ8FXSk9Zp0dIXVPTGXapyyQN1xEolq_L_NfI4q6LhKQLIXnq5Xtnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADD1380059;
        Sat, 15 Jun 2019 11:31:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] HID: wacom: Don't report anything prior to the tool entering" failed to apply to 4.14-stable tree
To:     jason.gerecke@wacom.com, aaron.skomra@wacom.com,
        benjamin.tissoires@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 17:31:23 +0200
Message-ID: <15606126834326@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc Mon Sep 17 00:00:00 2001
From: Jason Gerecke <jason.gerecke@wacom.com>
Date: Wed, 24 Apr 2019 15:12:58 -0700
Subject: [PATCH] HID: wacom: Don't report anything prior to the tool entering
 range

If the tool spends some time in prox before entering range, a series of
events (e.g. ABS_DISTANCE, MSC_SERIAL) can be sent before we or userspace
have any clue about the pen whose data is being reported. We need to hold
off on reporting anything until the pen has entered range. Since we still
want to report events that occur "in prox" after the pen has *left* range
we use 'wacom-tool[0]' as the indicator that the pen did at one point
enter range and provide us/userspace with tool type and serial number
information.

Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 4c1bc239207e..613342bb9d6b 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1290,23 +1290,26 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 						 get_unaligned_le16(&frame[11]));
 			}
 		}
-		input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
-		if (wacom->features.type == INTUOSP2_BT) {
-			input_report_abs(pen_input, ABS_DISTANCE,
-					 range ? frame[13] : wacom->features.distance_max);
-		} else {
-			input_report_abs(pen_input, ABS_DISTANCE,
-					 range ? frame[7] : wacom->features.distance_max);
-		}
 
-		input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
-		input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
-		input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
+		if (wacom->tool[0]) {
+			input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
+			if (wacom->features.type == INTUOSP2_BT) {
+				input_report_abs(pen_input, ABS_DISTANCE,
+						 range ? frame[13] : wacom->features.distance_max);
+			} else {
+				input_report_abs(pen_input, ABS_DISTANCE,
+						 range ? frame[7] : wacom->features.distance_max);
+			}
+
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
+			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
 
-		input_report_key(pen_input, wacom->tool[0], prox);
-		input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
-		input_report_abs(pen_input, ABS_MISC,
-				 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+			input_report_key(pen_input, wacom->tool[0], prox);
+			input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
+			input_report_abs(pen_input, ABS_MISC,
+					 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+		}
 
 		wacom->shared->stylus_in_proximity = prox;
 

