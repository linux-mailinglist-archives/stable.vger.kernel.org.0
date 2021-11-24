Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECFA45C45A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351232AbhKXNrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349334AbhKXNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0021E61179;
        Wed, 24 Nov 2021 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758836;
        bh=dTPb2kXkqqZHHUU/5EsT1jSVWNxZwUWDpuzJjesggv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVWd1J+w5EuL+8U48IYt5Yiv+FAKF6Ki+RSQLg1TnJxJds1l3Dfm401dWf8wugrtT
         L22wccGg0vjPslutPXvUGpCR3jCh0dOtX16pbFJkgsAPVX0Ol2+WW4hrzkLfWu4MZE
         ydmtlkbAFMZdxWaok2Lcd6/QOIiyfuf8ACLE1WwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Thiery <heiko.thiery@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/279] arm64: dts: imx8mm-kontron: Fix reset delays for ethernet PHY
Date:   Wed, 24 Nov 2021 12:55:31 +0100
Message-Id: <20211124115720.248284776@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 315e7b884190a6c9c28e95ad3b724dde9e922b99 ]

According to the datasheet the VSC8531 PHY expects a reset pulse of 100 ns
and a delay of 15 ms after the reset has been deasserted. Set the matching
values in the devicetree.

Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index e99e7644ff392..49d7470812eef 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -123,8 +123,8 @@
 
 		ethphy: ethernet-phy@0 {
 			reg = <0>;
-			reset-assert-us = <100>;
-			reset-deassert-us = <100>;
+			reset-assert-us = <1>;
+			reset-deassert-us = <15000>;
 			reset-gpios = <&gpio4 27 GPIO_ACTIVE_LOW>;
 		};
 	};
-- 
2.33.0



