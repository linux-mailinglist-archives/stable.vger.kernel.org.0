Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0218E47AD2F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbhLTOur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41038 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbhLTOsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A68611AB;
        Mon, 20 Dec 2021 14:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6D5C36AE8;
        Mon, 20 Dec 2021 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011722;
        bh=K8VUnCSNm6hDXKmou/9UqPAVfLnvtYdTiZN9wFfraMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnY7P/jcv1+Bq+BAcQXb7wtWIazIs+uqytTyB/+w32Vp6z276urtrtLXfPGtIcEk3
         3TzOwgq0myVfoRes+yhZt88I6L1fYlkPLS+TohqjTxl31EVH69/eL4oJbhxTsaLQem
         ZAmlQ/zPZyk5rYgcHRFUleO2d+H/QMyB8M28cqzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/99] arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge
Date:   Mon, 20 Dec 2021 15:33:51 +0100
Message-Id: <20211220143029.969962741@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Lapkin <email2tema@gmail.com>

[ Upstream commit 6dd0053683804427529ef3523f7872f473440a19 ]

Remove mmc-hs400-enhanced-strobe from the rk3399-khadas-edge dts to
improve compatibility with a wider range of eMMC chips.

Before (BJTD4R 29.1 GiB):

[    7.001493] mmc2: CQHCI version 5.10
[    7.027971] mmc2: SDHCI controller on fe330000.mmc [fe330000.mmc] using ADMA
.......
[    7.207086] mmc2: mmc_select_hs400es failed, error -110
[    7.207129] mmc2: error -110 whilst initialising MMC card
[    7.308893] mmc2: mmc_select_hs400es failed, error -110
[    7.308921] mmc2: error -110 whilst initialising MMC card
[    7.427524] mmc2: mmc_select_hs400es failed, error -110
[    7.427546] mmc2: error -110 whilst initialising MMC card
[    7.590993] mmc2: mmc_select_hs400es failed, error -110
[    7.591012] mmc2: error -110 whilst initialising MMC card

After:

[    6.960785] mmc2: CQHCI version 5.10
[    6.984672] mmc2: SDHCI controller on fe330000.mmc [fe330000.mmc] using ADMA
[    7.175021] mmc2: Command Queue Engine enabled
[    7.175053] mmc2: new HS400 MMC card at address 0001
[    7.175808] mmcblk2: mmc2:0001 BJTD4R 29.1 GiB
[    7.176033] mmcblk2boot0: mmc2:0001 BJTD4R 4.00 MiB
[    7.176245] mmcblk2boot1: mmc2:0001 BJTD4R 4.00 MiB
[    7.176495] mmcblk2rpmb: mmc2:0001 BJTD4R 4.00 MiB, chardev (242:0)

Fixes: c2aacceedc86 ("arm64: dts: rockchip: Add support for Khadas Edge/Edge-V/Captain boards")
Signed-off-by: Artem Lapkin <art@khadas.com>
Link: https://lore.kernel.org/r/20211115083321.2627461-1-art@khadas.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
index 635afdd99122f..2c644ac1f84b9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
@@ -699,7 +699,6 @@ &sdmmc {
 &sdhci {
 	bus-width = <8>;
 	mmc-hs400-1_8v;
-	mmc-hs400-enhanced-strobe;
 	non-removable;
 	status = "okay";
 };
-- 
2.33.0



