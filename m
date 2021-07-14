Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF53C8C06
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGNTk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhGNTk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBE24613D6;
        Wed, 14 Jul 2021 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291485;
        bh=fdX3OWonzQBkMm3CKVLceeQ5nc48BR8fbedd/LnPc0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLF8YV4IlUqJA5w89aE7ezPwwv+9k4ZlJTdbL9qI2hFKkEhBChK5xOOoX8LMfP5zT
         PUaKSWEzHwPhP5DIxNydqeTKCeyJX5hC+T9KJrsuS40U7XxiVBc2zFpwL50Z/cXQt4
         dUW/jVCzAWd4xq1spC9t3LF4Jljgs/2HTm/TU2e044NmQ4DuHnkG+eMkYdX3OpNk0P
         3EtdnSMiZ0BVomAzvZPbn+RaJeYcbYgAN513Ogv4zSi6vvFYIg4ci0ivPoEuDlvONf
         +NdLqp624xWe15he1x+VFSOSsxxf2P06gNdQk3eimwBAkwjQ7fhuSPa473HYQ9UbGe
         paoLq2tR3FS/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 003/108] ARM: dts: rockchip: Fix thermal sensor cells o rk322x
Date:   Wed, 14 Jul 2021 15:36:15 -0400
Message-Id: <20210714193800.52097-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit d5c24e20daf09587cbc221d40be1ba92673e8d94 ]

The number of cells to be used with a thermal sensor specifier
must be "1". Fix this.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20210506175514.168365-2-ezequiel@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk322x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk322x.dtsi b/arch/arm/boot/dts/rk322x.dtsi
index 208f21245095..9f02ba7a0cc2 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -517,7 +517,7 @@ tsadc: tsadc@11150000 {
 		pinctrl-0 = <&otp_pin>;
 		pinctrl-1 = <&otp_out>;
 		pinctrl-2 = <&otp_pin>;
-		#thermal-sensor-cells = <0>;
+		#thermal-sensor-cells = <1>;
 		rockchip,hw-tshut-temp = <95000>;
 		status = "disabled";
 	};
-- 
2.30.2

