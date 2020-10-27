Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CAC29BEB5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814502AbgJ0Q4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794303AbgJ0PLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 808C821D24;
        Tue, 27 Oct 2020 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811465;
        bh=kFM+WIo7lDsxmB2iJDyzMHfljOEKa+lhPZ2S+U6ZxQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A36VeEStMBzuMSVUr03PHjN6gK2JCzaGz4WiWScLjNg4EoqHU70ouxp0Q0/V2h7Gd
         y5TB1PxBNeFlWqU1nbTsiqqLHWhNmsIQKCZWPrdLcYKkIcTtPdDGrRxbQigSREHeUr
         zmwomb1NcpyLo2ObQ5UwUoNggXIoYsv9em+85uDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 502/633] arm64: dts: mt8173: elm: Fix nor_flash node property
Date:   Tue, 27 Oct 2020 14:54:05 +0100
Message-Id: <20201027135546.276251149@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 1276be23fd53e1c4e752966d0eab42aa54a343da ]

bus-width and non-removable is not used by the driver.
max-frequency should be spi-max-frequency for flash node.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Reported-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20200727074124.3779237-1-hsinyi@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
index a5a12b2599a4a..01522dd10603e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi
@@ -431,12 +431,11 @@ &nor_flash {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&nor_gpio1_pins>;
-	bus-width = <8>;
-	max-frequency = <50000000>;
-	non-removable;
+
 	flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
+		spi-max-frequency = <50000000>;
 	};
 };
 
-- 
2.25.1



