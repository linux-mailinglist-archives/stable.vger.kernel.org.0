Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE2156C250
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239697AbiGHSrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiGHSrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:47:19 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E218A7C1AA
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:47:14 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j21so37785905lfe.1
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+w1WqI4rSkds6h7nS823uaay+4iOmmXfTuVyJsGpWr4=;
        b=QK+xicIPDox8KpJbDsh51x/CVWoxaBAlgdkFway1Eoarw1EqwA+KYQ6xCxkIQemELA
         iA/bmn0MUcNkSPKG4QPctcZ+JDEEEUOHPWlOApbRbM0La/jb53BpA720kRgqI5xAtzyu
         UswaaL8KEg/6WXTu6kNOAQKWuLNcEBoc4Lr+pItsg/4i0+GNF0wp+mlpFw/3MPJ/tWoF
         5PNLtKsPHjQtBsdFyFOvsvLt4bN2R0yvUeFLlL0OovwdEBOKemzQVTMxkeEs/84iMUNh
         09g2M3pX6Ibb2RuWRfPdqQE8se10B7yCBxgbIyMHE94jYTPkm0IrJmoK0cKlmKZRUO9k
         Yeww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+w1WqI4rSkds6h7nS823uaay+4iOmmXfTuVyJsGpWr4=;
        b=KUq6cXJ7/+UnUuxxbbv6Cb7lj0ngbv8axTdgYw9i0IXJP5Ppj2otbzg2GmRbSy0rOH
         YruoVRFJD068XtEA3djrDTyLwJgFu11hjyjw6hwgzDPn0nOLw4zZ68yYtjrQq1DcMCVD
         2av1CSvZNSZ/ub/Jir7Pb9SAUNk/qHkuIi/dhabfCX8+Vk3oOz7smc+7/VQW+cSNiopL
         jVm2FowUBiP/Qdb6f+mnELU67MJ7bZ+3QdXqrumIy8F22PcNdV8RvwvTxHHr0+M37nOw
         lkpc4V0cmTjErbs6l5WnvpIUQ9PpfqhThJD2TmQ6C9xA1/hgPp65oDoY9z5pYl66QrQR
         srqg==
X-Gm-Message-State: AJIora8AZihdD8H5udLF3INMQ/YHWz6oFxaOueCIqS++MsfoiPJQX98V
        O1QMW2GbLQk7QGWjWZc0CZ5hQDBL3+lPfg==
X-Google-Smtp-Source: AGRyM1tgXV97Sp7uLE5vusOAHraoEyQfTNfwGu/lWKyu7Ypof89PFF2rt1kihXpQXoYgYZ9gsA49TA==
X-Received: by 2002:a05:6512:1691:b0:47f:ae89:906f with SMTP id bu17-20020a056512169100b0047fae89906fmr3240996lfb.229.1657306033243;
        Fri, 08 Jul 2022 11:47:13 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id u22-20020a197916000000b0047fa941067fsm7558386lfc.29.2022.07.08.11.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:47:12 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.14 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg
Date:   Fri,  8 Jul 2022 20:46:50 +0200
Message-Id: <20220708184653.280882-2-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708184653.280882-1-extja@kvaser.com>
References: <20220708184653.280882-1-extja@kvaser.com>
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

Add struct kvaser_usb_dev_cfg to ease backporting of upstream commits:
49f274c72357 (can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info)
e6c80e601053 (can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression)
b3b6df2c56d8 (can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits)

Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
 drivers/net/can/usb/kvaser_usb.c | 76 ++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 9742e32d5cd5..6759868924b2 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -31,10 +31,6 @@
 #define USB_SEND_TIMEOUT		1000 /* msecs */
 #define USB_RECV_TIMEOUT		1000 /* msecs */
 #define RX_BUFFER_SIZE			3072
-#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
-#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
-#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
-#define KVASER_USB_CAN_CLOCK_32MHZ	32000000
 #define MAX_NET_DEVICES			3
 #define MAX_USBCAN_NET_DEVICES		2
 
@@ -465,6 +461,7 @@ struct kvaser_usb_tx_urb_context {
 struct kvaser_usb {
 	struct usb_device *udev;
 	struct kvaser_usb_net_priv *nets[MAX_NET_DEVICES];
+	const struct kvaser_usb_dev_cfg *cfg;
 
 	struct usb_endpoint_descriptor *bulk_in, *bulk_out;
 	struct usb_anchor rx_submitted;
@@ -481,8 +478,6 @@ struct kvaser_usb {
 	bool rxinitdone;
 	void *rxbuf[MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MAX_RX_URBS];
-
-	struct can_clock clock;
 };
 
 struct kvaser_usb_net_priv {
@@ -501,6 +496,51 @@ struct kvaser_usb_net_priv {
 	struct kvaser_usb_tx_urb_context tx_contexts[];
 };
 
+struct kvaser_usb_dev_cfg {
+	const struct can_clock clock;
+	const struct can_bittiming_const * const bittiming_const;
+};
+
+static const struct can_bittiming_const kvaser_usb_bittiming_const = {
+	.name = "kvaser_usb",
+	.tseg1_min = KVASER_USB_TSEG1_MIN,
+	.tseg1_max = KVASER_USB_TSEG1_MAX,
+	.tseg2_min = KVASER_USB_TSEG2_MIN,
+	.tseg2_max = KVASER_USB_TSEG2_MAX,
+	.sjw_max = KVASER_USB_SJW_MAX,
+	.brp_min = KVASER_USB_BRP_MIN,
+	.brp_max = KVASER_USB_BRP_MAX,
+	.brp_inc = KVASER_USB_BRP_INC,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+	.clock = {
+		.freq = 8000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+	.clock = {
+		.freq = 24000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+	.clock = {
+		.freq = 32000000,
+	},
+	.bittiming_const = &kvaser_usb_bittiming_const,
+};
+
 static const struct usb_device_id kvaser_usb_table[] = {
 	/* Leaf family IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID) },
@@ -673,13 +713,13 @@ static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
 
 	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
 	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_16MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
 		break;
 	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_24MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
 		break;
 	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_32MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
 		break;
 	}
 }
@@ -705,7 +745,7 @@ static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 		dev->fw_version = le32_to_cpu(msg.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(msg.u.usbcan.softinfo.max_outstanding_tx);
-		dev->clock.freq = KVASER_USB_CAN_CLOCK_8MHZ;
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
 		break;
 	}
 
@@ -1829,18 +1869,6 @@ static const struct net_device_ops kvaser_usb_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
-static const struct can_bittiming_const kvaser_usb_bittiming_const = {
-	.name = "kvaser_usb",
-	.tseg1_min = KVASER_USB_TSEG1_MIN,
-	.tseg1_max = KVASER_USB_TSEG1_MAX,
-	.tseg2_min = KVASER_USB_TSEG2_MIN,
-	.tseg2_max = KVASER_USB_TSEG2_MAX,
-	.sjw_max = KVASER_USB_SJW_MAX,
-	.brp_min = KVASER_USB_BRP_MIN,
-	.brp_max = KVASER_USB_BRP_MAX,
-	.brp_inc = KVASER_USB_BRP_INC,
-};
-
 static int kvaser_usb_set_bittiming(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
@@ -1957,8 +1985,8 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
 	kvaser_usb_reset_tx_urb_contexts(priv);
 
 	priv->can.state = CAN_STATE_STOPPED;
-	priv->can.clock.freq = dev->clock.freq;
-	priv->can.bittiming_const = &kvaser_usb_bittiming_const;
+	priv->can.clock.freq = dev->cfg->clock.freq;
+	priv->can.bittiming_const = dev->cfg->bittiming_const;
 	priv->can.do_set_bittiming = kvaser_usb_set_bittiming;
 	priv->can.do_set_mode = kvaser_usb_set_mode;
 	if (id->driver_info & KVASER_HAS_TXRX_ERRORS)
-- 
2.36.1

