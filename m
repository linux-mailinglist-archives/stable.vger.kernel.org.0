Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679CE3E7EB7
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhHJRe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232905AbhHJRe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F81610A0;
        Tue, 10 Aug 2021 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616846;
        bh=Iu6W+aucb0aktf+z3AmbVFRr50+3uJ/lbQzb8BDpTVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFtdTs/5jL8GsJTJp61mGGD3gF0qOQlhbCJGhorEeYemCGmSsCxJd64Ljn7m21PUo
         qOYn7pkDm4xwaxRK/NxIFEelZh52f6BhQpsJIBgnjewZVTJyf+NFOSZoiNhpex9Xrq
         YGOwasLN5ArnUYm2a99bfiL2zTQlOl7c2IURNjuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/85] ARM: dts: colibri-imx6ull: limit SDIO clock to 25MHz
Date:   Tue, 10 Aug 2021 19:29:40 +0200
Message-Id: <20210810172948.452998426@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

[ Upstream commit 828db68f4ff1ab6982a36a56522b585160dc8c8e ]

NXP and AzureWave don't recommend using SDIO bus mode 3.3V@50MHz due
to noise affecting the wireless throughput. Colibri iMX6ULL uses only
3.3V signaling for Wi-Fi module AW-CM276NF.

Limit the SDIO Clock on Colibri iMX6ULL to 25MHz.

Fixes: c2e4987e0e02 ("ARM: dts: imx6ull: add Toradex Colibri iMX6ULL support")
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi b/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi
index 038d8c90f6df..621396884c31 100644
--- a/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi
+++ b/arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi
@@ -43,6 +43,7 @@
 	assigned-clock-rates = <0>, <198000000>;
 	cap-power-off-card;
 	keep-power-in-suspend;
+	max-frequency = <25000000>;
 	mmc-pwrseq = <&wifi_pwrseq>;
 	no-1-8-v;
 	non-removable;
-- 
2.30.2



