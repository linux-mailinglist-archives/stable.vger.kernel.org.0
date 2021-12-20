Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F4447ACE2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhLTOrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbhLTOp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9101CC0698C6;
        Mon, 20 Dec 2021 06:43:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51F2EB80EDF;
        Mon, 20 Dec 2021 14:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A6CC36AFA;
        Mon, 20 Dec 2021 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011409;
        bh=rqlWo1htnbUWLX2a3RAOqhcuexRxc/n/+a3E+fOYgRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkewQNRETRvJviEKpz8fcyyeQiTUv+8lKpFE+tlZyX90XxEtvqaL8yFR7iMBkZofz
         /pJBP5lGosiX8zE0ha+xqZLkmSGLE0jXBRIZDrpu2jfnkeuUwIH7+N44grnvvvLPqm
         rjz3jqGIx8QS4OcXfdkPN9MwGZMwtvMDPP099JsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/71] arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge
Date:   Mon, 20 Dec 2021 15:34:00 +0100
Message-Id: <20211220143026.078065169@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
index e87a04477440e..292ca70c512b5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
@@ -685,7 +685,6 @@ &sdmmc {
 &sdhci {
 	bus-width = <8>;
 	mmc-hs400-1_8v;
-	mmc-hs400-enhanced-strobe;
 	non-removable;
 	status = "okay";
 };
-- 
2.33.0



