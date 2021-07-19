Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF03CE5CB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348529AbhGSPxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350409AbhGSPvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1095B60FDC;
        Mon, 19 Jul 2021 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712168;
        bh=VsOISFCwQv1AE/8JHSouyfP6yzXVxKdCN4oZ5qKMw4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsFlyvmsV3Asy1Nlcojp4uSIEdrGuAuj9aDD4e7nELYgIovTbS/imy9pM1xxarUWq
         DXehQthkrVoPKLnKXJ2kEcv7Vop5omfwn7sVwH1DT7QAzWlBPcHknASYMM/EuSsgqb
         VMguuaYjSDig91ndMDn0yQy+X0uy2G46ZVVV0k9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 277/292] arm64: dts: rockchip: Re-add regulator-always-on for vcc_sdio for rk3399-roc-pc
Date:   Mon, 19 Jul 2021 16:55:39 +0200
Message-Id: <20210719144952.020134326@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit eb607cd4957fb0ef97beb2a8293478be6a54240a ]

Re-add the regulator-always-on property for vcc_sdio which supplies sdmmc,
since it gets disabled during reboot now and the bootrom expects it to be
enabled  when booting from SD card. This makes rebooting impossible in that
case and requires a hard reset to boot again.

Fixes: 04a0077fdb19 ("arm64: dts: rockchip: Remove always-on properties from regulator nodes on rk3399-roc-pc.")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20210619121306.7740-1-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
index e4345e5bdfb6..35b7ab3bf10c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -384,6 +384,7 @@
 
 			vcc_sdio: LDO_REG4 {
 				regulator-name = "vcc_sdio";
+				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3000000>;
-- 
2.30.2



