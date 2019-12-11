Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97ED11B541
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfLKPwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:52:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731941AbfLKPUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF2A2465B;
        Wed, 11 Dec 2019 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077617;
        bh=ywdnx7cF1Laca/fA/1bBIR/STIwTiUzSxnVGm7rNlho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgZb7AmkZLPXksnyGb+wWjoBdIi2Rm3D9z8pbKnunV+Q2YOrlcH0iKmMwmkQvunLO
         RtY492AuFExrevbKNoY8X5botUeb0Hr/5pH+tJMiq9tgScwItY+hS5RsLfM7Wh89Nu
         GZeMMy4mcuollXowh1jOK4OyhX2SGGLVnmKLwqJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Otavio Salvador <otavio@ossystems.com.br>,
        Fabio Berton <fabio.berton@ossystems.com.br>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/243] ARM: dts: rockchip: Fix the PMU interrupt number for rv1108
Date:   Wed, 11 Dec 2019 16:04:27 +0100
Message-Id: <20191211150346.212107689@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Otavio Salvador <otavio@ossystems.com.br>

[ Upstream commit c955b7aec510145129ca7aaea6ecbf6d748f5ebf ]

According to the Rockchip vendor tree the PMU interrupt number is
76, so fix it accordingly.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Tested-by: Fabio Berton <fabio.berton@ossystems.com.br>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rv1108.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rv1108.dtsi b/arch/arm/boot/dts/rv1108.dtsi
index ed8f6ca52c5bc..4090ad2619ffb 100644
--- a/arch/arm/boot/dts/rv1108.dtsi
+++ b/arch/arm/boot/dts/rv1108.dtsi
@@ -66,7 +66,7 @@
 
 	arm-pmu {
 		compatible = "arm,cortex-a7-pmu";
-		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	timer {
-- 
2.20.1



