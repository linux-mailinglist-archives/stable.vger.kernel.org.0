Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45F8515EE3
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiD3PzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 11:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiD3PzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 11:55:07 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B640D49F92;
        Sat, 30 Apr 2022 08:51:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x52so7673192pfu.11;
        Sat, 30 Apr 2022 08:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LpVI+wHvPmtuQd7BRofKYFwZVUXSQ/H1fRvs7yRvcu8=;
        b=T6VqIbSNwWtxsP2iTpZwkecEU9TxdUfWQg102Z4oprwO++xzkOjrF8S5CPwAuuhFoC
         ywfnEV5HXFU4Jc8W9tYVmW2iwwVXsBrKi3L1mqIbYVwvcuUUbJC1pw1Qm3PjfKNzeZww
         BUxQJ2CE8sDkMWDXwJObdoFLa+eJcytzQ+SzBSBIY8JIRBXwe1XK2uZrSeU2qtHCrp/I
         eaRXHoIJgT7sfWnvtqZuOR3X0cTaFHUsEjQKGre2U3QrFS4U7+dRijXWzNHvkXdcbvVU
         QvOznGEDYDPiXi6Ws7AZzzXUVpEWkPz7Azsqis0cbE4M9zuv6j6rajjAoPGpQeOAjQNq
         r+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LpVI+wHvPmtuQd7BRofKYFwZVUXSQ/H1fRvs7yRvcu8=;
        b=1Ls8LwW9EIKttUQ4QaOBrX/+BFUtiGsVpVsw9Q0EAQSGmAK4ggzqTKl3+ZzESptAPB
         aH7Qckh4E+AEJ/uXC7b/UjWdhlUsXwHEbOzp6TAGFX6fFT/uIUjk3HGSRoYTP5nm2wge
         v3Cg4crrSU+BNJ1OQJhqMLthTGnBtnzysAHAaRzNfZLsMnUfQXqiyG+58/S/qovbQJMk
         X4AKEDjK78mbY9efi1Q60vo69PNcf9tut0g2J9z+okiOEw+uUPp40w+v6s9z55clbhM2
         u0yboOj+6NpRoNIf4aCOdGqZGkS7xOWcSwxFhu5yALJqncPbRbxY2WI88A+Qk0cr42fC
         //IQ==
X-Gm-Message-State: AOAM532tKN6GQtKLLqfrmueCNUVn/m/gwKhzZ8HMyn2gejB/T5XNnR5D
        y1IRYREByOqhcxvTN8yUZr5LA9Xpx40ASg==
X-Google-Smtp-Source: ABdhPJxZR+6dKYd/WUpP6bN1rIoOdXa/nL+GYJHP2ncA9uKKuYd0a53b5ViyBDHJJx9n2czHRuyEow==
X-Received: by 2002:a65:6657:0:b0:381:1b99:3f04 with SMTP id z23-20020a656657000000b003811b993f04mr3479256pgv.512.1651333905220;
        Sat, 30 Apr 2022 08:51:45 -0700 (PDT)
Received: from guoguo-omen.lan ([2001:250:3000:7000:c0f1:53a1:ea79:5d2f])
        by smtp.gmail.com with ESMTPSA id j16-20020aa783d0000000b0050dc76281b8sm1755734pfn.146.2022.04.30.08.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 08:51:44 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] arm64: dts: mt7622: add irq to spi-nor controller
Date:   Sat, 30 Apr 2022 23:51:11 +0800
Message-Id: <20220430155112.227902-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Save some CPU from unnecessary polling and make SPI flash reading
a tiny bit faster.

Cc: <stable@vger.kernel.org> # v5.7+
Fixes: 23beb1adb5f6 ("arm64: dts: mt7622: add flash related device nodes")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
The nor controller driver in kernem when this dt is added doesn't
support IRQ so there isn't one defined in dt back then. However,
device-tree is supposed to describe the hardware, so I think this
can count as a fix.
My main purpose for the fixes tag is just for the linux-stable
backport though. spi-mtk-nor supports interrupt since v5.7.

 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 8c2563a3919a..e263a81a011b 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -570,6 +570,7 @@ nor_flash: spi@11014000 {
 		compatible = "mediatek,mt7622-nor",
 			     "mediatek,mt8173-nor";
 		reg = <0 0x11014000 0 0xe0>;
+		interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&pericfg CLK_PERI_FLASH_PD>,
 			 <&topckgen CLK_TOP_FLASH_SEL>;
 		clock-names = "spi", "sf";
-- 
2.35.1

