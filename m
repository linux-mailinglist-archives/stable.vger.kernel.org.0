Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8532ECC92
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 10:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbhAGJTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 04:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGJTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 04:19:51 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81859C0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 01:19:10 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qw4so8642954ejb.12
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 01:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citymesh-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=eYTvBE3gKnGdp6qJqTd0PqscgsbdjG7rieP/UNhpStU=;
        b=R23q7L5+v0Q4pyFKhpZiwPqFaZmSxsQbXxM2L4b73x3cyXbsfFZ3UiAUDmq08by6VK
         5YrxBuyWcHJbiMkUNkoOiRPYRGR4bsduv6SIaetkb2RfilbEtvsIc4qnzB/lBAPjo5sj
         RuOkvdbhJZTUJK5p2/VrWNMprCAEjzVLHIzt1YbPUDyZwuO8TyfDvBHmJXf1aS6q5fYo
         x9Omv+K8fCWUECxwtz0QuZWcDIcRIr1q5l8PjCGsfZ4Ai16fbq7xPF4n1qcOdl1mQo+1
         9qSGF4/VmIpcTVzR48bIqKWLuS5GhIQ+Arm0WYTllpk1QROR5IDIxJq6r1hV5HCpbTYu
         RFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eYTvBE3gKnGdp6qJqTd0PqscgsbdjG7rieP/UNhpStU=;
        b=G7fMf/5hfxRWAMOKsvls8dCwRCCfOleQman9TI/K+qzOIJM0GqO3TyZJg2CoBElJic
         LoPfM8C9L3pm+kGgtmBAJCgE/sTa247UF7ze57fguX0sFCRKa1NWGbXbFSZLN3mqt73A
         p2QZNrZPJ0l9PBH0RWdm6ZtgYpzwa1jYvu6nFCHrU4NBqKDDh0UtQlNy+PqAeR/zCpuZ
         Wt4YdL99KS65Sq3ipQGrUpxMbL5ZkYJ2UPHzUJ5mp9/vimKU297XQbfQ0W6HMM2zDs7/
         Ev0DqKf/bsfTI+wDWg2EgSxVq/EJlHfKaETjtt+GUCG9eMxE/hOEKgE15h7L8+QD+DDr
         s+7g==
X-Gm-Message-State: AOAM530jg9J3tlEDXWCoAa2pRLKQ3EqmE1zlpEgd0CpffRsi+FTStGnA
        sp3+TZejHrZzu4vzz6jBBRq3ew==
X-Google-Smtp-Source: ABdhPJxpx19R4TA5hBZH/4t1moHicce1D4RWq6QCllr+la1c9AZ7vlCCx8emeiu7mSlC154klLbY5g==
X-Received: by 2002:a17:906:605:: with SMTP id s5mr5785013ejb.280.1610011149160;
        Thu, 07 Jan 2021 01:19:09 -0800 (PST)
Received: from localhost.localdomain ([31.31.140.89])
        by smtp.gmail.com with ESMTPSA id dk16sm2199978ejb.85.2021.01.07.01.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:19:08 -0800 (PST)
From:   Koen Vandeputte <koen.vandeputte@citymesh.com>
X-Google-Original-From: Koen Vandeputte <koen.vandeputte@ncentric.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming
Date:   Thu,  7 Jan 2021 10:19:06 +0100
Message-Id: <20210107091906.7843-1-koen.vandeputte@ncentric.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2 regulator descriptions carry identical naming.

This leads to following boot warning:
[    0.173138] debugfs: Directory 'vdd1p8' with parent 'regulator' already present!

Fix this by renaming the one used for audio.

Fixes: 5051bff33102 ("ARM: dts: imx: ventana: add LTC3676 PMIC support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: stable@vger.kernel.org # v4.11
---
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw52xx.dtsi b/arch/arm/boot/dts/imx6qdl-gw52xx.dtsi
index 736074f1c3ef..959d8ac2e393 100644
--- a/arch/arm/boot/dts/imx6qdl-gw52xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw52xx.dtsi
@@ -418,7 +418,7 @@
 
 			/* VDD_AUD_1P8: Audio codec */
 			reg_aud_1p8v: ldo3 {
-				regulator-name = "vdd1p8";
+				regulator-name = "vdd1p8a";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;
-- 
2.17.1

