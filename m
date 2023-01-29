Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907B268010E
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 20:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjA2TAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 14:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2TAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 14:00:21 -0500
X-Greylist: delayed 172 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Jan 2023 11:00:20 PST
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1BF18B05;
        Sun, 29 Jan 2023 11:00:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675018631; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=HR1S7lcbkVRGFxrxvbDExW//GLek5S1JwH267gecTUbHX+uU86A1Iujcd+ANveWwrA
    1EyF+TGynGYG+hBLQgv2utb80QC+psN2noOpdtTVnHgpSh/UPNH0sJzaiVrTucwqraAv
    xdXMXgQRdtgZV1Yh+MtTA3WE0/kv28j+4/YwFaraONZNYHDrPIPgxl9Op6OAbJ2EXjlv
    0MXx9DoPLu5BjplerSSq9lZSEWCaP8NLhLLbSNrTItpAAhveYWXipR1HI263k8nACRi6
    HJClzMFi3gKXD61CC1qALCxmZCSP8Kp5ccxWdv5d92LevP+KopLEk096hliMzTKSfFBi
    2tow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1675018631;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=hdb0RhMA/W7iN9ASZsM7cnZYyO0Ib+35iRVsKYcQ5ek=;
    b=n5+RlhKvMP1+jn3OjHvWKl0LrqNMsB9FEqRz9rSh+ns2E02O14z9zFp+leN6zqx49o
    uFr19EJMiN5JyyeKs/T6XCfMapiBQDGXCQN47n5VtDCX+euzL16zSAwps08nP2p+Rd0O
    MFGBDAKgoOfZKDPv8zYKquu5SSKctmN1H5WkZHAx+aMUBz76S+vZoIsE2II3gYlSVcGf
    V8//L3DHzHYllbTjuW2L10tfXgJQyo6E1U2oOn2HrhpWx/Ry53Ijvp0ikSAMwhQtHh76
    l4BB+TYmkNBtoSiSccWDqzO+CM2vzJdQeT5RYYHecqj/stCQjNeiSsHbR65rkrvuTlC5
    W3iw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1675018631;
    s=strato-dkim-0002; d=goldelico.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=hdb0RhMA/W7iN9ASZsM7cnZYyO0Ib+35iRVsKYcQ5ek=;
    b=E+aDT93U3y9S01cTyej6zxM3jIN3/VWByxf0osZiqiKxlSQ3N3NiFvUHrH05ZqOhie
    3EnnAEWN6l7xqpnd4H3liApdqETkGdDEHSCffo34YxMYuHkfwkhbfUHfOvTIGkH4Hj0x
    gFdlj2qr0TGzgOjLb7uuh+oDYDoZC5GOmcaK1QrAsOzEzRIALpRHVwOqHFEIsTrDtgD1
    Liq55aTjCKTlyUfpnCbeAJdE4ZUjrADk9oZeIfQb9Fct27EZLKozJcmUUl9H5O4Udh+0
    d7qbmWGBR3pogfZ9dBQdLMy8tIKN48KUp9PhJmo0QhwjD9rke0cpfO4NkScgiklmAwoJ
    Vxrg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1iTDUhfN4hi3qVZrW/J"
Received: from iMac.fritz.box
    by smtp.strato.de (RZmta 49.2.2 SBL|AUTH)
    with ESMTPSA id e4ab20z0TIvBI4C
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 29 Jan 2023 19:57:11 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0?= <zhouyanjie@wanyeetech.com>
Cc:     linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH v2] MIPS: DTS: CI20: fix otg power gpio
Date:   Sun, 29 Jan 2023 19:57:04 +0100
Message-Id: <8bcf9311284b4cab8be36922d6027813bfdf2bae.1675018624.git.hns@goldelico.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to schematics it is PF15 and not PF14 (MIC_SW_EN).
Seems as if it was hidden and not noticed during testing since
there is no sound DT node.

Fixes: 158c774d3c64 ("MIPS: Ingenic: Add missing nodes for Ingenic SoCs and boards.")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/mips/boot/dts/ingenic/ci20.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 9819abb2465dd..a276488c0f752 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -115,7 +115,7 @@ otg_power: fixedregulator@2 {
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 
-		gpio = <&gpf 14 GPIO_ACTIVE_LOW>;
+		gpio = <&gpf 15 GPIO_ACTIVE_LOW>;
 		enable-active-high;
 	};
 };
-- 
2.38.1

