Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1644E3D299D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhGVQFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234465AbhGVQEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F216144E;
        Thu, 22 Jul 2021 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972321;
        bh=0TcEksb0S4SRI56JjLGAPblYLh9EjuKSotMt5Uz8RAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1ggY6gDUtb1ZqQ5kNw+M7v+d/w4Lj30WT/C4iP/y68HixhnKSBOrJvo2f8IDtm9t
         MZpD7u5HgghcPKq7AIJhlVs1ANWxsrJawauqiToYSSt1016SxrTUgnAbrx50nJwaS3
         mgYj9a5V5HoSVdykIkKpKUJsqH4s4cNrWtHbVJ18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Szymaszek <gszymaszek@short.pl>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/156] ARM: dts: stm32: fix the Odyssey SoM eMMC VQMMC supply
Date:   Thu, 22 Jul 2021 18:30:43 +0200
Message-Id: <20210722155630.595556046@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szymaszek <gszymaszek@short.pl>

[ Upstream commit f493162319788802b6a49634f7268e691b4c10ec ]

The Seeed SoM-STM32MP157C device tree had the eMMC’s (SDMMC2) VQMMC
supply set to v3v3 (buck4), the same as the VMMC supply. That was
incorrect, as on the SoM, the VQMMC supply is provided from vdd (buck3)
instead.

Signed-off-by: Grzegorz Szymaszek <gszymaszek@short.pl>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
index 6cf49a0a9e69..b5601d270c8f 100644
--- a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
@@ -269,7 +269,7 @@
 	st,neg-edge;
 	bus-width = <8>;
 	vmmc-supply = <&v3v3>;
-	vqmmc-supply = <&v3v3>;
+	vqmmc-supply = <&vdd>;
 	mmc-ddr-3_3v;
 	status = "okay";
 };
-- 
2.30.2



