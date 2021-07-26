Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229C83D5E32
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhGZPGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235138AbhGZPFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85AE16056C;
        Mon, 26 Jul 2021 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314373;
        bh=1zrjGaD0tA5qmJtS3rK4BplhZ9V3lD5UNcoKqJj83Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoOFJ3GTZGH6JTI49G9WTlaByFU87e9fBtwBueJSxiCcsztJVXBD7FLGuMWXo1OXH
         id6+hFle0b5uDL6xQ92F4wX2Fg14J0gHbui5kNfpMSM/oOETXntqVN+oTBvThgP7rG
         Xq1ZFf5Zdkmw2SYlTOqzMG4OtyJY0jQpysbeffLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/82] arm64: dts: rockchip: Fix power-controller node names for rk3328
Date:   Mon, 26 Jul 2021 17:38:06 +0200
Message-Id: <20210726153828.357481543@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elaine Zhang <zhangqing@rock-chips.com>

[ Upstream commit 6e6a282b49c6db408d27231e3c709fbdf25e3c1b ]

Use more generic names (as recommended in the device tree specification
or the binding documentation)

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-7-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 6c3684885fac..a3fb072f20ba 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -289,13 +289,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			pd_hevc@RK3328_PD_HEVC {
+			power-domain@RK3328_PD_HEVC {
 				reg = <RK3328_PD_HEVC>;
 			};
-			pd_video@RK3328_PD_VIDEO {
+			power-domain@RK3328_PD_VIDEO {
 				reg = <RK3328_PD_VIDEO>;
 			};
-			pd_vpu@RK3328_PD_VPU {
+			power-domain@RK3328_PD_VPU {
 				reg = <RK3328_PD_VPU>;
 			};
 		};
-- 
2.30.2



