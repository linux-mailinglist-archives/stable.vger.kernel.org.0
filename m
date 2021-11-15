Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD25451176
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243871AbhKOTIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243887AbhKOTEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E48A6338C;
        Mon, 15 Nov 2021 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000158;
        bh=SldKeyc1TkhVS6tDgUHlpFTRA7q6zvHN3ZzIJMhX5y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbXbUVAV/fxbqBj39SDDxkRuS/DaKyhcOe61eyeiR5KueuSvSheK/5Dya4jx5DjfT
         vsFegqJrPzywgKYGd0xNqn9HtEZTJHqQuQajzV2t7Ugj2m4n9cvjbBIj2P/7Us7xoF
         ahk+VZ+lghS3o4aFmo8uXFivwdE0w0T2LfLbMyIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 558/849] arm64: dts: rockchip: fix rk3568 mbi-alias
Date:   Mon, 15 Nov 2021 18:00:41 +0100
Message-Id: <20211115165439.136404885@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit b6c1a590148c63f822091912b4c09c79fbb13971 ]

The mbi-alias incorrectly points to 0xfd100000 when it should point to
0xfd410000.
This fixes MSIs on rk3568.

Fixes: a3adc0b9071d ("arm64: dts: rockchip: add core dtsi for RK3568 SoC")
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Link: https://lore.kernel.org/r/20210728180034.717953-2-pgwipeout@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index d225e6a45d5cb..fdfe283b7a30d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -201,7 +201,7 @@
 		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-controller;
 		#interrupt-cells = <3>;
-		mbi-alias = <0x0 0xfd100000>;
+		mbi-alias = <0x0 0xfd410000>;
 		mbi-ranges = <296 24>;
 		msi-controller;
 	};
-- 
2.33.0



