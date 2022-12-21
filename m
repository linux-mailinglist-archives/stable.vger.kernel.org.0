Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32F3653430
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiLUQka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiLUQk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:40:29 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A101FF8B
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 08:40:28 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id y4so16189806ljc.9
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 08:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jeLzGgpWvlXIHM7/m1+VkREz/loKw56kOMYwg3dbCR8=;
        b=A1IZ8NXd4JXsD4fefE0ROucxsbJwAlJc7/L72mU3MDoFLX4summ4UIsA2viSJDN46N
         r89qzqe/2ZudNnaLcHyMHlhbH0xLE9Y2KZ9flgx0Sfmwu/5vxO7Q8lkPzk+a729vDeG8
         jtGDVissye9KuoLBi3fZDGBu+dmTHgMBPq8VHKJNqTvd6QM3/8uLF2gWUYm28zJjGqRK
         9l/xmgATZYg6R1BwoT/z9lIMDmUhX08zlvpXnqhcZoWbhfD1oy6Lx0n/YnXNyBIADd6S
         Ph4q6RFGaFxooLclz0oJaXoZo+Yv+sm4nzjfRyBd18TM/+5smAQ3laX8esMqHP83Zrrd
         FzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jeLzGgpWvlXIHM7/m1+VkREz/loKw56kOMYwg3dbCR8=;
        b=Z4yXOc1oTBWkr/XjpGFR7EGoJaFbiEqXkwjb+Y9yIo8qT7VC6hmwuG1qlWLtxIlZ8c
         /nV1H+mStNNfxThxO0f8mpBvA8kmb/BMsI+jPMK7BiZwC41enY0bel3anAIVUwBUBUOn
         ncf5UKcsfbfEW557qswFYAnT/a4j+IeRTojWbB35mlZWCjbPHSrroieD6x3kylgOL9Ug
         ciX7bAE3mwx2SG2R4yvKVsToatGVHtvDIlfEqBE21KxM2KaBvehH7vM9wdEMYkGAh3+g
         mcILbGELftm9N2OlLYcncQ5uegiX42S5zHL08rcXy0muynM4OBYXyzhNwlUi/NKH2CLj
         98Hw==
X-Gm-Message-State: AFqh2krFtznz3ZXiRpgnn5QL9k30VTyFk72tc/R00B7uYvwTaQ3sXz2a
        p6IMzm4m7Aex7ynSleEqD5dBWw==
X-Google-Smtp-Source: AMrXdXt2wEecReCzFYK/J31HkhHQ45SMF3TideuLewjMN4HF1mZRjGH+Sk2yxdcLllbBUj7t4agYBg==
X-Received: by 2002:a2e:b5c4:0:b0:277:81a3:f6e0 with SMTP id g4-20020a2eb5c4000000b0027781a3f6e0mr748087ljn.19.1671640826498;
        Wed, 21 Dec 2022 08:40:26 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id p5-20020a2eb985000000b0027a00aab48fsm1331889ljp.66.2022.12.21.08.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 08:40:26 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO buffer
Date:   Wed, 21 Dec 2022 17:40:22 +0100
Message-Id: <20221221164022.1087814-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Driver's probe allocates memory for RX FIFO (port->rx_fifo) based on
default RX FIFO depth, e.g. 16.  Later during serial startup the
qcom_geni_serial_port_setup() updates the RX FIFO depth
(port->rx_fifo_depth) to match real device capabilities, e.g. to 32.

The RX UART handle code will read "port->rx_fifo_depth" number of words
into "port->rx_fifo" buffer, thus exceeding the bounds.  This can be
observed in certain configurations with Qualcomm Bluetooth HCI UART
device and KASAN:

  Bluetooth: hci0: QCA Product ID   :0x00000010
  Bluetooth: hci0: QCA SOC Version  :0x400a0200
  Bluetooth: hci0: QCA ROM Version  :0x00000200
  Bluetooth: hci0: QCA Patch Version:0x00000d2b
  Bluetooth: hci0: QCA controller version 0x02000200
  Bluetooth: hci0: QCA Downloading qca/htbtfw20.tlv
  bluetooth hci0: Direct firmware load for qca/htbtfw20.tlv failed with error -2
  Bluetooth: hci0: QCA Failed to request file: qca/htbtfw20.tlv (-2)
  Bluetooth: hci0: QCA Failed to download patch (-2)
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in handle_rx_uart+0xa8/0x18c
  Write of size 4 at addr ffff279347d578c0 by task swapper/0/0

  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.0-rt5-00350-gb2450b7e00be-dirty #26
  Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
  Call trace:
   dump_backtrace.part.0+0xe0/0xf0
   show_stack+0x18/0x40
   dump_stack_lvl+0x8c/0xb8
   print_report+0x188/0x488
   kasan_report+0xb4/0x100
   __asan_store4+0x80/0xa4
   handle_rx_uart+0xa8/0x18c
   qcom_geni_serial_handle_rx+0x84/0x9c
   qcom_geni_serial_isr+0x24c/0x760
   __handle_irq_event_percpu+0x108/0x500
   handle_irq_event+0x6c/0x110
   handle_fasteoi_irq+0x138/0x2cc
   generic_handle_domain_irq+0x48/0x64

If the RX FIFO depth changes after probe, be sure to resize the buffer.

Fixes: f9d690b6ece7 ("tty: serial: qcom_geni_serial: Allocate port->rx_fifo buffer in probe")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>

---

Changes since v1:
1. Rename the function (Jiri)
---
 drivers/tty/serial/qcom_geni_serial.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index b487823f0e61..49b9ffeae676 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -864,9 +864,10 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 	return IRQ_HANDLED;
 }
 
-static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
+static int setup_fifos(struct qcom_geni_serial_port *port)
 {
 	struct uart_port *uport;
+	u32 old_rx_fifo_depth = port->rx_fifo_depth;
 
 	uport = &port->uport;
 	port->tx_fifo_depth = geni_se_get_tx_fifo_depth(&port->se);
@@ -874,6 +875,16 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
 	port->rx_fifo_depth = geni_se_get_rx_fifo_depth(&port->se);
 	uport->fifosize =
 		(port->tx_fifo_depth * port->tx_fifo_width) / BITS_PER_BYTE;
+
+	if (port->rx_fifo && (old_rx_fifo_depth != port->rx_fifo_depth) && port->rx_fifo_depth) {
+		port->rx_fifo = devm_krealloc(uport->dev, port->rx_fifo,
+					      port->rx_fifo_depth * sizeof(u32),
+					      GFP_KERNEL);
+		if (!port->rx_fifo)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 
@@ -888,6 +899,7 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 	u32 rxstale = DEFAULT_BITS_PER_CHAR * STALE_TIMEOUT;
 	u32 proto;
 	u32 pin_swap;
+	int ret;
 
 	proto = geni_se_read_proto(&port->se);
 	if (proto != GENI_SE_UART) {
@@ -897,7 +909,9 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 
 	qcom_geni_serial_stop_rx(uport);
 
-	get_tx_fifo_size(port);
+	ret = setup_fifos(port);
+	if (ret)
+		return ret;
 
 	writel(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
 
-- 
2.34.1

