Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704016004E0
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 03:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJQBjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 21:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiJQBjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 21:39:24 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C799BB6
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 18:39:21 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id BA6986010A
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:39:20 +0900 (JST)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 9F830600F1
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:39:19 +0900 (JST)
Received: by mail-pj1-f69.google.com with SMTP id pj13-20020a17090b4f4d00b0020b0a13cba4so7568133pjb.0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 18:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kG7//arFpFAwMfnhlax+scf/1fpMFahAT0i4COuQlG0=;
        b=uMlC83JqvPlO91BSFmHvSqA5MbTqP8IoJPoHJDcfxMqqYJSMnTY07cISPOwmYKuQ1y
         NiOzfsRZr+qqa27MlnSDfEfxS4o6IuvZxTl/5RbupRWP3vgegG1UdXjqBnFSGESynfGL
         2JQrhL+ALZiT4J50M4CbhjvBaTmWPav832U73KBHWm5yh/8KjT2BCK0ymLNwf9ZU9cSs
         0eU3gtf3INNhFLNRVYVcUXBXkPyWKNXZH964rGf9+2d2E9+fe/Hm4n/D2Qjzth5WsWx9
         YMTjPo8mCCoXWsfuJ0jVCk34BqihWjyYPaLoRJmbWhmna3nvIgU3DWN1s215sAy94CT2
         89Kw==
X-Gm-Message-State: ACrzQf3VNKg9OeXYEJDw+fYBSlfQT7WY1T3HGG9l+PKxTiFv3e5CcSqd
        3gC5AJXkIu+GbdXSXdszKFp4j+3neacIkt4p4VGCnJA+ulepIRTlhY6mN00XQw7pdN8AgHnwSu4
        05xJDDR8YI2hlzQ1a+hDx
X-Received: by 2002:a05:6a00:1796:b0:563:723f:7909 with SMTP id s22-20020a056a00179600b00563723f7909mr9933848pfg.76.1665970758712;
        Sun, 16 Oct 2022 18:39:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM78cE8arQ8BBYF3JBLtVFIFRsOB2Aeu5g6Pre4yrN9MIlfXjp1N8WAC6ktKyUV7mm55KevWnw==
X-Received: by 2002:a05:6a00:1796:b0:563:723f:7909 with SMTP id s22-20020a056a00179600b00563723f7909mr9933827pfg.76.1665970758426;
        Sun, 16 Oct 2022 18:39:18 -0700 (PDT)
Received: from pc-0115 (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id m34-20020a634c62000000b004561e7569f8sm5037807pgl.8.2022.10.16.18.39.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Oct 2022 18:39:18 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.96)
        (envelope-from <martinet@pc-0115>)
        id 1okF63-00093d-2q;
        Mon, 17 Oct 2022 10:39:15 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 1/2] serial: core: move RS485 configuration tasks from drivers into core
Date:   Mon, 17 Oct 2022 10:39:08 +0900
Message-Id: <20221017013908.34770-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221017013807.34614-1-dominique.martinet@atmark-techno.com>
References: <20221017013807.34614-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Several drivers that support setting the RS485 configuration via userspace
implement one or more of the following tasks:

- in case of an invalid RTS configuration (both RTS after send and RTS on
  send set or both unset) fall back to enable RTS on send and disable RTS
  after send

- nullify the padding field of the returned serial_rs485 struct

- copy the configuration into the uart port struct

- limit RTS delays to 100 ms

Move these tasks into the serial core to make them generic and to provide
a consistent behaviour among all drivers.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Link: https://lore.kernel.org/r/20220410104642.32195-2-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Upstream commit 0ed12afa5655512ee418047fb3546d229df20aa1 ]
Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---

This has been picked up as it makes the next patch easier to apply

 drivers/tty/serial/serial_core.c | 33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b578f7090b63..6cc909d44a81 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -42,6 +42,11 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
+/*
+ * Max time with active RTS before/after data is sent.
+ */
+#define RS485_MAX_RTS_DELAY	100 /* msecs */
+
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -1326,8 +1331,36 @@ static int uart_set_rs485_config(struct uart_port *port,
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))
 		return -EFAULT;
 
+	/* pick sane settings if the user hasn't */
+	if (!(rs485.flags & SER_RS485_RTS_ON_SEND) ==
+	    !(rs485.flags & SER_RS485_RTS_AFTER_SEND)) {
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
+			port->name, port->line);
+		rs485.flags |= SER_RS485_RTS_ON_SEND;
+		rs485.flags &= ~SER_RS485_RTS_AFTER_SEND;
+	}
+
+	if (rs485.delay_rts_before_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_before_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay before sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_before_send);
+	}
+
+	if (rs485.delay_rts_after_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_after_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay after sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_after_send);
+	}
+	/* Return clean padding area to userspace */
+	memset(rs485.padding, 0, sizeof(rs485.padding));
+
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
+	if (!ret)
+		port->rs485 = rs485;
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;
-- 
2.35.1


