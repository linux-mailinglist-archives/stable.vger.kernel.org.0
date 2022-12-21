Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4FF653413
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiLUQdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLUQdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:33:24 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63395E6D
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 08:33:23 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id g14so16156603ljh.10
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 08:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TJ10izGoIOdb0NyolcdFdlWbSwOqjXskc/t42GB7GM4=;
        b=XOXc3xLZszdoWmtt+ZvN8t6m7mKHHmln3SggcrsSIpJTqCPo3ak1WChXAxGlIJ8LTb
         E9gAkCuSbjx6OiEpnRikBwofNfeR/inN37pXG5u2XpDPGSi4KjvxzTok1ljM3lYmfNaK
         cBfcPgjPAGtMKTIy8QQsvs0UGtHYX/AXB2xR3r747DxQtq09NUGqzh4oZJb6pDdPHAza
         MY9u5hkCNSA8EYotWFqXBMLbEl0bjxrCvMCoEFgtkGbD7K0gvtdvkQFL5ABZnANS5842
         fSYAU12aM/p2wAu4UhEdQXbbm0FuYmwuvre7xapYE/Ek1gj/aZzVojy7DtncVq33Up/7
         hdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJ10izGoIOdb0NyolcdFdlWbSwOqjXskc/t42GB7GM4=;
        b=rVj/0WWlJjwxXb1aytZcgfIT8vBN9SHd+C9RpwlaetXqxZQ6Edhs3ookEohO5FJ97j
         3ObQmY+r9RK+cEXBii2csXV/FvOpwzVTbbJ9Ld2wEgIHPZSy5NaxywJyUcbS/GwJ9thz
         RoLvLrY3bb2KPWL7R/8nNiuPx/kuc5iHHRQwLxSLtmzpAO+v0052BL58tcTEP36YYCa5
         I0mJ9Ao//bF679z3vWy0I7J1qZ6hB3EiQXOVgScA8HO7Bz7NTcH0aJbDZR098nVeZsHi
         jATaxQD8nkKvm9HlHnNzHFxHSVZlR9IdTXHAY5hOdeoGZHiYKeew58kFJUQWRgXuS2eJ
         GaZg==
X-Gm-Message-State: AFqh2kpyDGY1mjkpTyX+nkjwzQwJJ923A9TIwIeb0+Dj7Ql+pxSrG9cM
        x1saOXY8bQQaEThbi6IOANetQg==
X-Google-Smtp-Source: AMrXdXslXN21g3hT3ZSbwFjJ3oR740+5jytuxh08Hj5/fXlJoDGFRfh8GmYiU9wrhKNNJdWA9Qfe3A==
X-Received: by 2002:a2e:9dca:0:b0:26f:db34:a14b with SMTP id x10-20020a2e9dca000000b0026fdb34a14bmr740203ljj.14.1671640401761;
        Wed, 21 Dec 2022 08:33:21 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id a7-20020a2eb547000000b0026daf4fc0f7sm1380147ljn.92.2022.12.21.08.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 08:33:21 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Zijun Hu <zijuhu@codeaurora.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc:     Sai Teja Aluvala <quic_saluvala@quicinc.com>,
        Panicker Harish <quic_pharish@quicinc.com>,
        Johan Hovold <johan@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] serdev: ttyport: fix use-after-free on closed TTY
Date:   Wed, 21 Dec 2022 17:32:48 +0100
Message-Id: <20221221163249.1058459-1-krzysztof.kozlowski@linaro.org>
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

use-after-free is visible in serdev-ttyport, e.g. during system reboot
with Qualcomm Atheros Bluetooth.  The TTY is closed, thus "struct
tty_struct" is being released, but the hci_uart_qca driver performs
writes and flushes during system shutdown in qca_serdev_shutdown().

  Unable to handle kernel paging request at virtual address 0072662f67726fd7
  ...
  CPU: 6 PID: 1 Comm: systemd-shutdow Tainted: G        W          6.1.0-rt5-00325-g8a5f56bcfcca #8
  Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
  Call trace:
   tty_driver_flush_buffer+0x4/0x30
   serdev_device_write_flush+0x24/0x34
   qca_serdev_shutdown+0x80/0x130 [hci_uart]
   device_shutdown+0x15c/0x260
   kernel_restart+0x48/0xac

KASAN report:

  BUG: KASAN: use-after-free in tty_driver_flush_buffer+0x1c/0x50
  Read of size 8 at addr ffff16270c2e0018 by task systemd-shutdow/1

  CPU: 7 PID: 1 Comm: systemd-shutdow Not tainted 6.1.0-next-20221220-00014-gb85aaf97fb01-dirty #28
  Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
  Call trace:
   dump_backtrace.part.0+0xdc/0xf0
   show_stack+0x18/0x30
   dump_stack_lvl+0x68/0x84
   print_report+0x188/0x488
   kasan_report+0xa4/0xf0
   __asan_load8+0x80/0xac
   tty_driver_flush_buffer+0x1c/0x50
   ttyport_write_flush+0x34/0x44
   serdev_device_write_flush+0x48/0x60
   qca_serdev_shutdown+0x124/0x274
   device_shutdown+0x1e8/0x350
   kernel_restart+0x48/0xb0
   __do_sys_reboot+0x244/0x2d0
   __arm64_sys_reboot+0x54/0x70
   invoke_syscall+0x60/0x190
   el0_svc_common.constprop.0+0x7c/0x160
   do_el0_svc+0x44/0xf0
   el0_svc+0x2c/0x6c
   el0t_64_sync_handler+0xbc/0x140
   el0t_64_sync+0x190/0x194

Fixes: bed35c6dfa6a ("serdev: add a tty port controller driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/tty/serdev/serdev-ttyport.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d367803e2044..3d2bab91a988 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -91,6 +91,9 @@ static void ttyport_write_flush(struct serdev_controller *ctrl)
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return;
+
 	tty_driver_flush_buffer(tty);
 }
 
@@ -99,6 +102,9 @@ static int ttyport_write_room(struct serdev_controller *ctrl)
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return 0;
+
 	return tty_write_room(tty);
 }
 
@@ -172,6 +178,9 @@ static unsigned int ttyport_set_baudrate(struct serdev_controller *ctrl, unsigne
 	struct tty_struct *tty = serport->tty;
 	struct ktermios ktermios = tty->termios;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return -ENXIO;
+
 	ktermios.c_cflag &= ~CBAUD;
 	tty_termios_encode_baud_rate(&ktermios, speed, speed);
 
@@ -186,6 +195,9 @@ static void ttyport_set_flow_control(struct serdev_controller *ctrl, bool enable
 	struct tty_struct *tty = serport->tty;
 	struct ktermios ktermios = tty->termios;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return;
+
 	if (enable)
 		ktermios.c_cflag |= CRTSCTS;
 	else
@@ -201,6 +213,9 @@ static int ttyport_set_parity(struct serdev_controller *ctrl,
 	struct tty_struct *tty = serport->tty;
 	struct ktermios ktermios = tty->termios;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return -ENXIO;
+
 	ktermios.c_cflag &= ~(PARENB | PARODD | CMSPAR);
 	if (parity != SERDEV_PARITY_NONE) {
 		ktermios.c_cflag |= PARENB;
@@ -222,6 +237,9 @@ static void ttyport_wait_until_sent(struct serdev_controller *ctrl, long timeout
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return;
+
 	tty_wait_until_sent(tty, timeout);
 }
 
@@ -230,6 +248,9 @@ static int ttyport_get_tiocm(struct serdev_controller *ctrl)
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return -ENXIO;
+
 	if (!tty->ops->tiocmget)
 		return -ENOTSUPP;
 
@@ -241,6 +262,9 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	struct serport *serport = serdev_controller_get_drvdata(ctrl);
 	struct tty_struct *tty = serport->tty;
 
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return -ENXIO;
+
 	if (!tty->ops->tiocmset)
 		return -ENOTSUPP;
 
-- 
2.34.1

