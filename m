Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F333D284C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhGVP42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232783AbhGVP4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 071C360FDA;
        Thu, 22 Jul 2021 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971798;
        bh=wwKmLKODTZBHtA3fUmbP/gGArouTRDt2zQQGUwYEEQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHv+WR7j1ic2e0MBH9sM7JQjArMmvWcc3UUH7+cj6n57GPRBlYu4B9EiZoWaZ6QRk
         XBxs3xJOe/NGEFskqY8Ikua0wB4wEjAlUl5f3DxrmF/DxZTanpBhw2WB/mLkcokcUk
         NMiK231r/0nCHfKgVcMRzThTwbng5hVXj+cSXHj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/125] ARM: dts: rockchip: Fix thermal sensor cells o rk322x
Date:   Thu, 22 Jul 2021 18:29:54 +0200
Message-Id: <20210722155624.784332167@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 48e6e8d44a1a..5fdea760ffd4 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -524,7 +524,7 @@
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



