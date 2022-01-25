Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D1549BC65
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiAYTnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiAYTmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:43 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3FFC061744;
        Tue, 25 Jan 2022 11:42:42 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c9so20366778plg.11;
        Tue, 25 Jan 2022 11:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cB0U/qTfVrjxCk13SDAIYBFzvkQfg0+clBVJtK1GVQ=;
        b=V+4pHlEgFyQF/CyHl5QAShWssnm5bfbswQeFfGT9QiSmf/Qgpw8lPXaoSqd6e+3ddM
         GqJgXOrwSUOSGjYrn6Fteap+nOwM04d65keB+ADBqbSsrKEiNNvrenMFrYS8U1Abec1o
         Vzl/v4gHk7E3hwJoeaF66ut9hy6Rw3p+VHD5tDfCahzM4SkOir325efKHkb3nqobkgW7
         hhVCN+DdQ9Tjx8cQ+ns8/y006xj9qcDi0rfncmLtX0X/MzIYhZoG09XUWo2Hqkv6I0Ia
         jA9qTh1/9+X+1WaE8wCpw7JRzvl7Xlh6jIOjgIKP9bJHmmVKwknut5CqhTfEQiNoJ1hv
         fLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cB0U/qTfVrjxCk13SDAIYBFzvkQfg0+clBVJtK1GVQ=;
        b=qKt1hGWR/R7lLsGqQufDkHcM1mr+L2ANx+/iz7UzjIuONlPFdUlL4DqxN05xtE4Ycr
         Y6d+CXm3VzgcCuJLcCn9+kEgXRp74+JeG500Jts5Xx0+ttuejL7kH8ztJY3nbH1R+ml4
         jAoh/+LMbgWGQHyaypdtNyvNFjN5T9xs7iaST8noMeq1b62djs4uqItyEsIH9RD9J24V
         qn+QCM38058b7lu6b5Ky2yth4A3Q8rF/C/0AKeLAwzx/OtcRrHXR+TkO0MHfIYRm2N/f
         Cy64MyDTnCwFdr61S/6rd8JaHTtu8rk0I5BGO1H+N0PqPiD9abBDxAPAoUrS4r+pcGaM
         QaJA==
X-Gm-Message-State: AOAM5326jgpllLwtNjtsjs01+IVzokFedFMQoumkycXUh6flIxAsUYcf
        uUgwXyLcijYfcZ0KgGmzRF0JGozHwZY=
X-Google-Smtp-Source: ABdhPJyekVzvln7kXoeVQzAkLY24+tcynbgAQ2yyphguimJ9BZzjFLPBkvCJwNKUW8IVXgNuPz+ivQ==
X-Received: by 2002:a17:902:6a8b:b0:149:82bb:560a with SMTP id n11-20020a1709026a8b00b0014982bb560amr19852322plk.158.1643139762131;
        Tue, 25 Jan 2022 11:42:42 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:41 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE)
Subject: [PATCH stable 5.4 7/7] ARM: dts: gpio-ranges property is now required
Date:   Tue, 25 Jan 2022 11:42:22 -0800
Message-Id: <20220125194222.12783-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

commit c8013355ead68dce152cf426686f8a5f80d88b40 upstream

Since [1], added in 5.7, the absence of a gpio-ranges property has
prevented GPIOs from being restored to inputs when released.
Add those properties for BCM283x and BCM2711 devices.

[1] commit 2ab73c6d8323 ("gpio: Support GPIO controllers without
    pin-ranges")

Link: https://lore.kernel.org/r/20220104170247.956760-1-linus.walleij@linaro.org
Fixes: 2ab73c6d8323 ("gpio: Support GPIO controllers without pin-ranges")
Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20211206092237.4105895-3-phil@raspberrypi.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
[florian: Remove bcm2711.dtsi hunk which does not exist in 5.4]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm283x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 50c64146d492..af81f386793c 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -183,6 +183,7 @@
 
 			interrupt-controller;
 			#interrupt-cells = <2>;
+			gpio-ranges = <&gpio 0 0 54>;
 
 			/* Defines pin muxing groups according to
 			 * BCM2835-ARM-Peripherals.pdf page 102.
-- 
2.25.1

