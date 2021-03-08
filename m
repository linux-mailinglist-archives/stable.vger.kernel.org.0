Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0813330A38
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 10:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCHJXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 04:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCHJXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 04:23:03 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8985FC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 01:23:03 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id h98so10590281wrh.11
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 01:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f64vzvUYp/6BIz2bYRDqXZcELW1TUj1vEHLZdr8FG/k=;
        b=0UV6grLle2JlyxB+vpGpxgFbYU0LPkv6t4Em4wd9KxppTar9HyPhGVFyjdh0X/1CeC
         yVM1j5hmq3BpE+J7hhF9nJz/vtBD4DUSU++ltZqVF2GzKyJbob5VZCtFotSy2KV0Im32
         0rEJWixBIRAg3tiDipdgt2UZCpbh4aJev6rXAUmhGSJyVts2MZ4zLAMuqfHad2YmDnO+
         GNhjgE9bbkpqYWqzcPqoV1Jq2/g2/AnEinoAVFDr6z/ouRtY2ze+WT331xVkyAOld3G4
         rOEHi2bw871/hMMwei2C84aalcY/MLwqpKtdrJcJ3tbmJgOFxfEFpgEkpYeyZfcU3jhp
         iOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f64vzvUYp/6BIz2bYRDqXZcELW1TUj1vEHLZdr8FG/k=;
        b=dypOdsa1s3fyngHQ9M2HNyy17/KzB6mJ8gzz8ruolfATAjWUSI3yB3CpA7Lyll0yR0
         jp3QSuxxQavIHEvKhWYniIEO2xmk7MfrXtxhYsl/DH5PF+ZCfvULLRCdVw1iyVEmjQB8
         hBCwOPUUUucBsu5ZBTjzcrCzOME+dr+h+jp1Ufi61le9PCmALWVOkDj+WfnCYxo28aBz
         WJXsQ7tfwV0A2/JK8x3gdQhka5AnlWPdXe3GJeC6YB13Rs+fQchqUpLyZV1TormCmQf7
         +mZDHx8j7wlMxBL3WWWeaXuO89Ofp80ZB+Oylw27n0waypqDb7d6wXDDzXdmcxzPmoR+
         GksA==
X-Gm-Message-State: AOAM531qjXYex4ar84drYLi+RmjJX4LhjAYTCmuY0HmFNYL5PrV2flYG
        N3hCbE9tCnch3pHkUybAnB0fJPE9W9C0L+MJ
X-Google-Smtp-Source: ABdhPJxO61PIGnoxcBeQJyEnYhOvEWnAdYMi1tSgdINEd2Cfr9brs/PTheL2dopelRb2FfdPi77nCw==
X-Received: by 2002:a5d:5047:: with SMTP id h7mr22548425wrt.111.1615195381875;
        Mon, 08 Mar 2021 01:23:01 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:90c:e290:5985:2622:fd0e:9316])
        by smtp.gmail.com with ESMTPSA id 9sm15888113wmf.13.2021.03.08.01.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 01:23:01 -0800 (PST)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     stable@vger.kernel.org
Cc:     linux-amlogic@lists.infradead.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Brunet?= <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH stable 5.10] Revert "arm64: dts: amlogic: add missing ethernet reset ID"
Date:   Mon,  8 Mar 2021 10:22:41 +0100
Message-Id: <20210308092241.17058-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It has been reported on IRC and in KernelCI boot tests, this change breaks
internal PHY support on the Amlogic G12A/SM1 Based boards.

We suspect the added signal to reset more than the Ethernet MAC but also
the MDIO/(RG)MII mux used to redirect the MAC signals to the internal PHY.

This reverts commit f3362f0c18174a1f334a419ab7d567a36bd1b3f3 while we find
and acceptable solution to cleanly reset the Ethernet MAC.

commit 19f6fe976a61f9afc289b062b7ef67f99b72e7b9 upstream.

Cc: stable@vger.kernel.org # 5.10.x
Reported-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Jérôme Brunet <jbrunet@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20210126080951.2383740-1-narmstrong@baylibre.com
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi        | 2 --
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 --
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi         | 3 ---
 3 files changed, 7 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 724ee179b316..fae48efae83e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -227,8 +227,6 @@ ethmac: ethernet@ff3f0000 {
 				      "timing-adjustment";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
-			resets = <&reset RESET_ETHERNET>;
-			reset-names = "stmmaceth";
 			status = "disabled";
 		};
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index a6127002573b..959b299344e5 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -224,8 +224,6 @@ ethmac: ethernet@ff3f0000 {
 				      "timing-adjustment";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
-			resets = <&reset RESET_ETHERNET>;
-			reset-names = "stmmaceth";
 			status = "disabled";
 
 			mdio0: mdio {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 726b91d3a905..0edd137151f8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -13,7 +13,6 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/power/meson-gxbb-power.h>
-#include <dt-bindings/reset/amlogic,meson-gxbb-reset.h>
 #include <dt-bindings/thermal/thermal.h>
 
 / {
@@ -576,8 +575,6 @@ ethmac: ethernet@c9410000 {
 			interrupt-names = "macirq";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
-			resets = <&reset RESET_ETHERNET>;
-			reset-names = "stmmaceth";
 			power-domains = <&pwrc PWRC_GXBB_ETHERNET_MEM_ID>;
 			status = "disabled";
 		};
-- 
2.25.1

