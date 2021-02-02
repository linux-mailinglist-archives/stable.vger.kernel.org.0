Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0F230CC6F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhBBT41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233069AbhBBNuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B38EA64FB0;
        Tue,  2 Feb 2021 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273381;
        bh=BXefi+xJfD6C11RkR6fJ0e575vaDfNCykpnYB3p2SfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asBIgWVjCX3Rf7+RkrswV22VLqvk4IXGpVv24IWVbnH5tPiTU/T0jl8fci50swbwa
         YEDCjTbaxY3bNPufoUrC/jZjgiHDw/Leydt2gT9n6j4yGluvGoN3+CM9pJ1jbyHBZs
         QGhFgFopECl6X6Kz56YaLIObZ7Rv6XopgW9UoeU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/142] arm64: dts: imx8mp: Correct the gpio ranges of gpio3
Date:   Tue,  2 Feb 2021 14:37:29 +0100
Message-Id: <20210202133001.257836008@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit b764eb65e1c932f0500b30fcc06417cd9bc3e583 ]

On i.MX8MP, The GPIO3's secondary gpio-ranges's 'gpio controller offset'
cell value should be 26, so correct it.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Fixes: 6d9b8d20431f ("arm64: dts: freescale: Add i.MX8MP dtsi support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 6038f66aefc10..03ef0e5f909e4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -259,7 +259,7 @@
 				#gpio-cells = <2>;
 				interrupt-controller;
 				#interrupt-cells = <2>;
-				gpio-ranges = <&iomuxc 0 56 26>, <&iomuxc 0 144 4>;
+				gpio-ranges = <&iomuxc 0 56 26>, <&iomuxc 26 144 4>;
 			};
 
 			gpio4: gpio@30230000 {
-- 
2.27.0



