Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9998D6578B5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiL1Oxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiL1OxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F67410046
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B3A5CE1337
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602D1C433D2;
        Wed, 28 Dec 2022 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239192;
        bh=4OSI99v/9e+cEQL6BBMCWzTera6A5CVZvKl3gNqr0W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBcAtSTaJI8y2rV6ITlMNp+7hzk/11OITW8S8FDMdU4W9D27W7iCQx5Omm8jdlcv9
         5y4GpWRU5jc3bTcgtFzykZWhvte/Qw66IJs4OTPhlET5v9JXbdLUrGPGzMVJb2NjIf
         9XijKQr9Z1xLmjt91PKn4g4m0C75WuIrd2UPUor0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/731] can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
Date:   Wed, 28 Dec 2022 15:34:30 +0100
Message-Id: <20221228144301.288409512@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 7ea56128dbf904a3359bcf9289cccdfa3c85c7e8 ]

Prepare for handling CMD_ERROR_EVENT. Rename struct
{leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Reported-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 38 +++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 6c7ee1f0a9d9..d6553d9ee958 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -233,7 +233,7 @@ struct kvaser_cmd_tx_acknowledge_header {
 	u8 tid;
 } __packed;
 
-struct leaf_cmd_error_event {
+struct leaf_cmd_can_error_event {
 	u8 tid;
 	u8 flags;
 	__le16 time[3];
@@ -245,7 +245,7 @@ struct leaf_cmd_error_event {
 	u8 error_factor;
 } __packed;
 
-struct usbcan_cmd_error_event {
+struct usbcan_cmd_can_error_event {
 	u8 tid;
 	u8 padding;
 	u8 tx_errors_count_ch0;
@@ -318,7 +318,7 @@ struct kvaser_cmd {
 			struct leaf_cmd_softinfo softinfo;
 			struct leaf_cmd_rx_can rx_can;
 			struct leaf_cmd_chip_state_event chip_state_event;
-			struct leaf_cmd_error_event error_event;
+			struct leaf_cmd_can_error_event can_error_event;
 			struct leaf_cmd_log_message log_message;
 			struct kvaser_cmd_cap_req cap_req;
 			struct kvaser_cmd_cap_res cap_res;
@@ -328,7 +328,7 @@ struct kvaser_cmd {
 			struct usbcan_cmd_softinfo softinfo;
 			struct usbcan_cmd_rx_can rx_can;
 			struct usbcan_cmd_chip_state_event chip_state_event;
-			struct usbcan_cmd_error_event error_event;
+			struct usbcan_cmd_can_error_event can_error_event;
 		} __packed usbcan;
 
 		struct kvaser_cmd_tx_can tx_can;
@@ -350,7 +350,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
 	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
 	[CMD_LEAF_LOG_MESSAGE]		= kvaser_fsize(u.leaf.log_message),
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
-	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.can_error_event),
 	[CMD_GET_CAPABILITIES_RESP]	= kvaser_fsize(u.leaf.cap_res),
 	/* ignored events: */
 	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
@@ -365,7 +365,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_usbcan[] = {
 	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
 	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.usbcan.chip_state_event),
-	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.error_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.can_error_event),
 	/* ignored events: */
 	[CMD_USBCAN_CLOCK_OVERFLOW_EVENT] = CMD_SIZE_ANY,
 };
@@ -1137,11 +1137,11 @@ static void kvaser_usb_leaf_usbcan_rx_error(const struct kvaser_usb *dev,
 
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
@@ -1149,13 +1149,13 @@ static void kvaser_usb_leaf_usbcan_rx_error(const struct kvaser_usb *dev,
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
@@ -1172,11 +1172,11 @@ static void kvaser_usb_leaf_leaf_rx_error(const struct kvaser_usb *dev,
 
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
2.35.1



