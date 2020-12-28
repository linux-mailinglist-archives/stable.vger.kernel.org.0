Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CE92E4173
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438820AbgL1OJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438816AbgL1OJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:09:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4F0206D8;
        Mon, 28 Dec 2020 14:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164530;
        bh=O4hdeWMADuGP0Im4Q+6tEPZ1DnqsPYgqjmZEIiWGOg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZafDQmOK6pL8McdQiDwwgLtgxSQKyGvivto6YKH/vUqFJ01DHG/Ych2QnRX715+n
         qOuno7pExFUJpcC5EDQz9PnfFk/I+yaSsfvQYEk6nufds7P5Nj72Mn5NcDnAkzvbkA
         EAe1SalKjsexeXrxSodyEtOEHFuhGP/fRPucv/Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/717] arm64: tegra: Fix DT binding for IO High Voltage entry
Date:   Mon, 28 Dec 2020 13:43:24 +0100
Message-Id: <20201228125030.854577287@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 6b26c1a034885923822f6c4d94f8644d32bc2481 ]

Fix the device-tree entry that represents I/O High Voltage property
by replacing 'nvidia,io-high-voltage' with 'nvidia,io-hv' as the former
entry is deprecated.

Fixes: dbb72e2c305b ("arm64: tegra: Add configuration for PCIe C5 sideband signals")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 93438d2b94696..6946fb210e484 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -378,7 +378,7 @@
 					nvidia,schmitt = <TEGRA_PIN_DISABLE>;
 					nvidia,lpdr = <TEGRA_PIN_ENABLE>;
 					nvidia,enable-input = <TEGRA_PIN_DISABLE>;
-					nvidia,io-high-voltage = <TEGRA_PIN_ENABLE>;
+					nvidia,io-hv = <TEGRA_PIN_ENABLE>;
 					nvidia,tristate = <TEGRA_PIN_DISABLE>;
 					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				};
@@ -390,7 +390,7 @@
 					nvidia,schmitt = <TEGRA_PIN_DISABLE>;
 					nvidia,lpdr = <TEGRA_PIN_ENABLE>;
 					nvidia,enable-input = <TEGRA_PIN_ENABLE>;
-					nvidia,io-high-voltage = <TEGRA_PIN_ENABLE>;
+					nvidia,io-hv = <TEGRA_PIN_ENABLE>;
 					nvidia,tristate = <TEGRA_PIN_DISABLE>;
 					nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				};
-- 
2.27.0



