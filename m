Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC3269CAE
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 22:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbfGOUVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 16:21:32 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43830 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731311AbfGOUVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 16:21:31 -0400
Received: by mail-lf1-f65.google.com with SMTP id c19so11937264lfm.10
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmI+G2a+MFeCwy7Tg4jhuurPd3QAR7gfjXDfp90OmJ4=;
        b=zCHEVbz3de112jKAkxnHwrnP0+O195aIi01mGmwiCJZJR79megYl1oTWLY31QsQ6ko
         rQuidw/9mmeOF31WBxm2YoEzuqAbslsrQjNeKAHKsrWi/f1PHDokJmOkQY07P+QC1Zmk
         JChG7QGfCn6XZqrTCbNEjcFxKq4yg8cJlbMCEuvyQJYUB+FRF1djqla+Q3oJcrYt7R4j
         eYxhn9tDLbR6IfRkXJ4lAsFs/7vjzC6xzCp58D+cyMOfGqOx6XE73ApP1xYR3NlvDk29
         Zzhc72l0STaZZxBF7S2kVrr+ljBKoutvDL8I/TjSQf/ER/HjFtiwdrvYtUJX8tHCvyJg
         lfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmI+G2a+MFeCwy7Tg4jhuurPd3QAR7gfjXDfp90OmJ4=;
        b=T/St1xmxwCeO4RKB5I45l6gsmWt0bUaeYBWmWaVVQbhYKeY5H/gu6Xa5HImFgYQYRA
         i6dL2PqlXNKVU5889leJrN8r/S8gb/44NgT0wFTxSG/pW4ckhCbETPMFuwI63MxuN7kL
         RnbfnDwNP1LZCcmONg81g4EsCf7N1zQIAs+LEf/oEvL8ECUxLC5RTp1XhlbOHYnmE5pZ
         NlexIbAkXq8ms/Yf6XOQg748JF/9s6LzyJwfAdzFwtUFOAhz6jcPnI328RKIhhN02clF
         Zx1y+rrJwVUcV5dOF66RTHYu94sHCd/FCOUJMBO4DzQMIi032TEhJ804a2C64fGqubgR
         QALQ==
X-Gm-Message-State: APjAAAWm6PZyvSMWCwPbUBTgxgM+H6nRiqQl4c9pqUEXs8Cfy+5jIG9f
        d7o3TvvSi7/BqJE9DLLYrF0B2Q==
X-Google-Smtp-Source: APXvYqwto8+oJFMSqk5I71ZjxP1wmCB1V1rXX/WOgWuB0k6JHXCBv6CuVMboKfddL9hOVFpH/J1AUQ==
X-Received: by 2002:a19:f711:: with SMTP id z17mr12375881lfe.4.1563222089627;
        Mon, 15 Jul 2019 13:21:29 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-22cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.34])
        by smtp.gmail.com with ESMTPSA id s7sm3302729lje.95.2019.07.15.13.21.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:21:28 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: gemini: Set DIR-685 SPI CS as active low
Date:   Mon, 15 Jul 2019 22:21:01 +0200
Message-Id: <20190715202101.16060-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SPI to the display on the DIR-685 is active low, we were
just saved by the SPI library enforcing active low on everything
before, so set it as active low to avoid ambiguity.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ARM SoC folks: please apply this directly to fixes.
---
 arch/arm/boot/dts/gemini-dlink-dir-685.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini-dlink-dir-685.dts b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
index 3613f05f8a80..bfaa2de63a10 100644
--- a/arch/arm/boot/dts/gemini-dlink-dir-685.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
@@ -64,7 +64,7 @@
 		gpio-sck = <&gpio1 5 GPIO_ACTIVE_HIGH>;
 		gpio-miso = <&gpio1 8 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpio1 7 GPIO_ACTIVE_HIGH>;
-		cs-gpios = <&gpio0 20 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpio0 20 GPIO_ACTIVE_LOW>;
 		num-chipselects = <1>;
 
 		panel: display@0 {
-- 
2.21.0

