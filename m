Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CD96B6165
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 23:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCKWMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 17:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCKWMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 17:12:16 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319292CFF7
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 14:12:15 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id d41-20020a05600c4c2900b003e9e066550fso5571346wmp.4
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 14:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678572733;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FCOIu73ieFZT7l57rTHSGjsvndfRQh9rE9xLRIPzP0=;
        b=F6HSFs0CHP0Y9JQyNDDMMvWZ8nA/HNA/ve4DMpp4WDjMXg/tdz8RqQPABT1cdQetKh
         KahQ8T5Hkcq1ng0jZ8PdLQ2fJVo7gi88kK9qNObEaNjQz136iwFMcMsmhfx6rTG3aeJ/
         U0XPWZCOt9oaVuu8rH9SxdvWrxqCxadJeS7KOWJAftvj8uMJGboUF1qaaAl0mNGHzHSH
         RUSGxaZwcjWkPIZELOpI86GIhjI4CD4K9J6C1PQJm3nBpG2hSxWx8X4GIPzgdG3xWrQn
         nsZcV/t5k7Llj13oPPXUVkNchyTeNLmTwC5OF287oLgmGaTKYaXVfeGbKFyopRVgacwh
         /mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678572733;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3FCOIu73ieFZT7l57rTHSGjsvndfRQh9rE9xLRIPzP0=;
        b=pkQFVhar0fsX709kz9iT/kWx+Xf7X/HjzWRElYv3PnYLJqJNry5IYwCzMtmL0xMibz
         AxqX/h/EgnKtvNWIxKihQqhNmEcmGBWFxqiuQeO1Jq9rI3ZdirhOuXNDDlOizxw5hAHD
         gJpNvfqaQwOL2P95Z2lxGyy8sVYICVwrX7bJWkggMkjZhND6n5PrsP+6HXn4kyKWa3xt
         iXoNA+HqkHwUVmlJct8CifR0yoPmDt5QJqzbxObcWW6YsGFn73SKuZwsWi/Tk8o1sTNi
         NtY8XFb+kfKTasTHsKteHc7vCP4J05xc8XTj7O2vfpDKt80a8pMQhoqnlBf7XaR/BW9J
         3NDg==
X-Gm-Message-State: AO0yUKWGMBoBK+uA18xUIfnGx0WO1qZSPvo/k7RBGqT9efujWqOH39Cl
        QGwNyHOlUh0FpUAnmcWnhZd/1KW/sRs=
X-Google-Smtp-Source: AK7set+jX1vDFiQRVM8nVueik3ZLKgvqpRX+0XAOaNMrHHF/di/JPiSuJR1KxebU+zfAzwq8bWyj9g==
X-Received: by 2002:a05:600c:198a:b0:3e2:1368:e395 with SMTP id t10-20020a05600c198a00b003e21368e395mr6926041wmq.33.1678572733633;
        Sat, 11 Mar 2023 14:12:13 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.25])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c020800b003e203681b26sm3874256wmi.29.2023.03.11.14.12.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 14:12:13 -0800 (PST)
Message-ID: <33adb1b9-37c3-76ac-687f-97383f2101ec@gmail.com>
Date:   Sun, 12 Mar 2023 00:12:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
To:     stable@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun ASAKA <JunASAKA@zzy040330.moe>

[ Upstream commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 ]

Fixing transmission failure which results in
"authentication with ... timed out". This can be
fixed by disable the REG_TXPAUSE.

Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
Hi, this is my first time here. I'm not sure if I did everything
correctly.

This patch should go to all the stable kernels. Without it the
USB wifi adapters with RTL8192EU chip are unusable more often
than not. They can't connect to any network.

There's a small problem: the last line of context in this patch
is only found in 6.2. The older kernels have something else
there. Will it still work or should I send one more version
of the patch?
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
 	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	/*
+	 * Fix transmission failure of rtl8192e.
+	 */
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
 static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
-- 
2.31.1

