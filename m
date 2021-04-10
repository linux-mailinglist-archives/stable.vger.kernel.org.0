Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B213E35AFC4
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhDJSzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 14:55:11 -0400
Received: from out28-124.mail.aliyun.com ([115.124.28.124]:41383 "EHLO
        out28-124.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhDJSzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 14:55:10 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07769772|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.00226315-0.000191175-0.997546;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.Jy13RN2_1618080886;
Received: from zhouyanjie-virtual-machine.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.Jy13RN2_1618080886)
          by smtp.aliyun-inc.com(10.147.42.241);
          Sun, 11 Apr 2021 02:54:52 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     linus.walleij@linaro.org, robh+dt@kernel.org, paul@crapouillou.net
Cc:     linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        hns@goldelico.com, paul@boddie.org.uk, andy.shevchenko@gmail.com,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, sernia.zhou@foxmail.com,
        stable@vger.kernel.org
Subject: [PATCH v4 01/11] pinctrl: Ingenic: Add missing pins to the JZ4770 MAC MII group.
Date:   Sun, 11 Apr 2021 02:54:36 +0800
Message-Id: <1618080886-32061-2-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618080886-32061-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1618080886-32061-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The MII group of JZ4770's MAC should have 7 pins, add missing
pins to the MII group.

Fixes: 5de1a73e78ed ("Pinctrl: Ingenic: Add missing parts for JZ4770 and JZ4780.")
Cc: <stable@vger.kernel.org>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    v2:
    New patch.
    
    v2->v3:
    Add fixes tag.
    
    v3->v4:
    1.Add Cc: <stable@vger.kernel.org>.
    2.Add Andy Shevchenko's Reviewed-by.
    3.Add Paul Cercueil's Reviewed-by.

 drivers/pinctrl/pinctrl-ingenic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index f274612..05dfa0a 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -667,7 +667,9 @@ static int jz4770_pwm_pwm7_pins[] = { 0x6b, };
 static int jz4770_mac_rmii_pins[] = {
 	0xa9, 0xab, 0xaa, 0xac, 0xa5, 0xa4, 0xad, 0xae, 0xa6, 0xa8,
 };
-static int jz4770_mac_mii_pins[] = { 0xa7, 0xaf, };
+static int jz4770_mac_mii_pins[] = {
+	0x7b, 0x7a, 0x7d, 0x7c, 0xa7, 0x24, 0xaf,
+};
 
 static const struct group_desc jz4770_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4770_uart0_data, 0),
-- 
2.7.4

