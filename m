Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3684C26A714
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgIOOaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgIOO2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70E522596;
        Tue, 15 Sep 2020 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179654;
        bh=9RmOxPyHm8BJ2j8MsbzGfwIE+u+YfknzpUp2PBwGcr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIcpDqtV7oi6O7ZKZE/qLHaRqly0J0Qf9xVUlqbs+3dBs0aHIF8zmFsoXQUw3zgmm
         UwwhQcoKEj8Y6UfMZHncWn9x3gio/6OPd7NVeWosmy1LySaFNpDTWm5TDo7mPqXGH/
         sRLpkdHy0ZcX38Y2CEFTWqURmACabLCKYiBldYvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/132] arm64: dts: ns2: Fixed QSPI compatible string
Date:   Tue, 15 Sep 2020 16:12:17 +0200
Message-Id: <20200915140645.879496020@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 686e0a0c8c61e0e3f55321d0181fece3efd92777 ]

The string was incorrectly defined before from least to most specific,
swap the compatible strings accordingly.

Fixes: ff73917d38a6 ("ARM64: dts: Add QSPI Device Tree node for NS2")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
index 15f7b0ed38369..39802066232e1 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
@@ -745,7 +745,7 @@
 		};
 
 		qspi: spi@66470200 {
-			compatible = "brcm,spi-bcm-qspi", "brcm,spi-ns2-qspi";
+			compatible = "brcm,spi-ns2-qspi", "brcm,spi-bcm-qspi";
 			reg = <0x66470200 0x184>,
 				<0x66470000 0x124>,
 				<0x67017408 0x004>,
-- 
2.25.1



