Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D795A96CE
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiIAM3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiIAM3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:07 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E258D126DDC
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so24183561lfr.2
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=b6/7n4e8zK/Rd2CG1tkDN3MVVcYExbIDyO83wAgcJfw=;
        b=uontgwDQLwjZZxISP3N5rKRBa2HbqVccvcO99TMv7mx3ar4y561mtRwBAiqObgRaS/
         3AjDpYgBNESbtVvA6KKSBaa7Iqncll5U5HOO8HgJqNrxu6NIKH5be9tWGjYrIiwUEN1j
         c10zLblHGGS3QH3ZgzuDWBJAdVz4I7vJSqSC4zbbA0I15qNc7RV+vu0SLn+fg0OeVkie
         OToJz2VyMro3c+krOMo/q8fWRlx8put6ThtmUJ8sPLW9HuV1ccMICWesEQ1zKg/ZH+MC
         7gLS7npILcV1mOkWaT/jVxo9+WP5Fq9+WMkHdn4kBsH+axwHMJKaYVTaEdNYCFmTXKw8
         VA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=b6/7n4e8zK/Rd2CG1tkDN3MVVcYExbIDyO83wAgcJfw=;
        b=sQ3+H4ffHuFWAF7NnTr5jKlYMF/Il8mNQCkvPzsklvNeUT4JpWmDTOCT2Aq9p4T979
         W9oCbR6vyhBMpPFJZsa4/PG4MisJt8g6+RGa2ojSMdyzDA2UbZULeWgHa9WtL5YiY0mn
         V3utC1IshiXpdvsY08eoauj1DSqd7MhDhOIixJlWsxc2QZsaPCCsKq//MrhteMQFMvip
         M6QiNnMOfHmFjMsYs9rl+2fvhpuDLvsYqG85ZghFUHBHBcNUMozbMpA2xGw8rRqYxZXc
         dOh/M7WkFOx9EVafjcGAMiiPt1uW6a3cvfdU0l6eNZSy4xtVxIILzOYRIuoMBtB8a8vN
         tKGA==
X-Gm-Message-State: ACgBeo0eSME9E/PkzAZBcsWathPav60yhjpu7qupR467lqL/qOVK6Iza
        pP1YaRGLtt9S2O7ovO6VO9yUfShrUrT2+Zgo
X-Google-Smtp-Source: AA6agR5AePnCvayMv7/FR4zXVi/rTsMGDwn/GjbB7ppgeRvND1p7yeELSajA8s6KaP6alrw2Al15zQ==
X-Received: by 2002:a05:6512:3fa2:b0:48a:16df:266f with SMTP id x34-20020a0565123fa200b0048a16df266fmr10378713lfa.414.1662035304888;
        Thu, 01 Sep 2022 05:28:24 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:24 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 05/15] can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
Date:   Thu,  1 Sep 2022 14:27:19 +0200
Message-Id: <20220901122729.271-6-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220901122729.271-1-extja@kvaser.com>
References: <20220901122729.271-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prepare for handling CMD_ERROR_EVENT. Rename struct
{leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Reported-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v3:
 - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add stable to CC
 - Add Tested-by Anssi Hannula

Changes in v2:
  - New in v2.

 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 38 +++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 9b688fc0b167..24c474e9d579 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -234,7 +234,7 @@ struct kvaser_cmd_tx_acknowledge_header {
 	u8 tid;
 } __packed;
 
-struct leaf_cmd_error_event {
+struct leaf_cmd_can_error_event {
 	u8 tid;
 	u8 flags;
 	__le16 time[3];
@@ -246,7 +246,7 @@ struct leaf_cmd_error_event {
 	u8 error_factor;
 } __packed;
 
-struct usbcan_cmd_error_event {
+struct usbcan_cmd_can_error_event {
 	u8 tid;
 	u8 padding;
 	u8 tx_errors_count_ch0;
@@ -319,7 +319,7 @@ struct kvaser_cmd {
 			struct leaf_cmd_softinfo softinfo;
 			struct leaf_cmd_rx_can rx_can;
 			struct leaf_cmd_chip_state_event chip_state_event;
-			struct leaf_cmd_error_event error_event;
+			struct leaf_cmd_can_error_event can_error_event;
 			struct leaf_cmd_log_message log_message;
 			struct kvaser_cmd_cap_req cap_req;
 			struct kvaser_cmd_cap_res cap_res;
@@ -329,7 +329,7 @@ struct kvaser_cmd {
 			struct usbcan_cmd_softinfo softinfo;
 			struct usbcan_cmd_rx_can rx_can;
 			struct usbcan_cmd_chip_state_event chip_state_event;
-			struct usbcan_cmd_error_event error_event;
+			struct usbcan_cmd_can_error_event can_error_event;
 		} __packed usbcan;
 
 		struct kvaser_cmd_tx_can tx_can;
@@ -351,7 +351,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
 	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
 	[CMD_LEAF_LOG_MESSAGE]		= kvaser_fsize(u.leaf.log_message),
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
-	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.can_error_event),
 	[CMD_GET_CAPABILITIES_RESP]	= kvaser_fsize(u.leaf.cap_res),
 	/* ignored events: */
 	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
@@ -366,7 +366,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_usbcan[] = {
 	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
 	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.usbcan.chip_state_event),
-	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.error_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.can_error_event),
 	/* ignored events: */
 	[CMD_USBCAN_CLOCK_OVERFLOW_EVENT] = CMD_SIZE_ANY,
 };
@@ -1132,11 +1132,11 @@ static void kvaser_usb_leaf_usbcan_rx_error(const struct kvaser_usb *dev,
 
 	case CMD_CAN_ERROR_EVENT:
 		es.channel = 0;
-		es.status = cmd->u.usbcan.error_event.status_ch0;
-		es.txerr = cmd->u.usbcan.error_event.tx_errors_count_ch0;
-		es.rxerr = cmd->u.usbcan.error_event.rx_errors_count_ch0;
+		es.status = cmd->u.usbcan.can_error_event.status_ch0;
+		es.txerr = cmd->u.usbcan.can_error_event.tx_errors_count_ch0;
+		es.rxerr = cmd->u.usbcan.can_error_event.rx_errors_count_ch0;
 		es.usbcan.other_ch_status =
-			cmd->u.usbcan.error_event.status_ch1;
+			cmd->u.usbcan.can_error_event.status_ch1;
 		kvaser_usb_leaf_usbcan_conditionally_rx_error(dev, &es);
 
 		/* The USBCAN firmware supports up to 2 channels.
@@ -1144,13 +1144,13 @@ static void kvaser_usb_leaf_usbcan_rx_error(const struct kvaser_usb *dev,
 		 */
 		if (dev->nchannels == MAX_USBCAN_NET_DEVICES) {
 			es.channel = 1;
-			es.status = cmd->u.usbcan.error_event.status_ch1;
+			es.status = cmd->u.usbcan.can_error_event.status_ch1;
 			es.txerr =
-				cmd->u.usbcan.error_event.tx_errors_count_ch1;
+				cmd->u.usbcan.can_error_event.tx_errors_count_ch1;
 			es.rxerr =
-				cmd->u.usbcan.error_event.rx_errors_count_ch1;
+				cmd->u.usbcan.can_error_event.rx_errors_count_ch1;
 			es.usbcan.other_ch_status =
-				cmd->u.usbcan.error_event.status_ch0;
+				cmd->u.usbcan.can_error_event.status_ch0;
 			kvaser_usb_leaf_usbcan_conditionally_rx_error(dev, &es);
 		}
 		break;
@@ -1167,11 +1167,11 @@ static void kvaser_usb_leaf_leaf_rx_error(const struct kvaser_usb *dev,
 
 	switch (cmd->id) {
 	case CMD_CAN_ERROR_EVENT:
-		es.channel = cmd->u.leaf.error_event.channel;
-		es.status = cmd->u.leaf.error_event.status;
-		es.txerr = cmd->u.leaf.error_event.tx_errors_count;
-		es.rxerr = cmd->u.leaf.error_event.rx_errors_count;
-		es.leaf.error_factor = cmd->u.leaf.error_event.error_factor;
+		es.channel = cmd->u.leaf.can_error_event.channel;
+		es.status = cmd->u.leaf.can_error_event.status;
+		es.txerr = cmd->u.leaf.can_error_event.tx_errors_count;
+		es.rxerr = cmd->u.leaf.can_error_event.rx_errors_count;
+		es.leaf.error_factor = cmd->u.leaf.can_error_event.error_factor;
 		break;
 	case CMD_LEAF_LOG_MESSAGE:
 		es.channel = cmd->u.leaf.log_message.channel;
-- 
2.37.3

