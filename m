Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD33A00BE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhFHSqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235746AbhFHSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 201C0613C8;
        Tue,  8 Jun 2021 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177407;
        bh=pTc7HixDW+/OLKjSTBMBvl79++CMzCaIwaxGDApCfzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTdj6UOY3BoUV7MyY+68hhJRrfOKd7+NGWHAWjOSmEJ2KN+EJNKUhMJojfUDx0Zp1
         FvmXC+HFMnk3rEZmb8Yf4zGl7dViRLladE3jN01idWraMVTKikNgo1qL6XG0VjADKk
         GrLzJzSI8tCwnKQ9zwBPVDHblKAO0yEgJDFBa6rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/78] ARM: dts: imx7d-pico: Fix the tuning-step property
Date:   Tue,  8 Jun 2021 20:27:02 +0200
Message-Id: <20210608175936.384321857@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 0e2fa4959c4f44815ce33e46e4054eeb0f346053 ]

According to Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml, the
correct name of the property is 'fsl,tuning-step'.

Fix it accordingly.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Fixes: f13f571ac8a1 ("ARM: dts: imx7d-pico: Extend peripherals support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-pico.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-pico.dtsi b/arch/arm/boot/dts/imx7d-pico.dtsi
index 6f50ebf31a0a..8a8df54ff563 100644
--- a/arch/arm/boot/dts/imx7d-pico.dtsi
+++ b/arch/arm/boot/dts/imx7d-pico.dtsi
@@ -307,7 +307,7 @@
 	pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
 	cd-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
 	bus-width = <4>;
-	tuning-step = <2>;
+	fsl,tuning-step = <2>;
 	vmmc-supply = <&reg_3p3v>;
 	wakeup-source;
 	no-1-8-v;
-- 
2.30.2



