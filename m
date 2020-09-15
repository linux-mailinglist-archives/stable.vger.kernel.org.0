Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A3326B484
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgIOXZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbgIOOh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:37:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE69423C43;
        Tue, 15 Sep 2020 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180045;
        bh=9G+pKFcUkd4vMcWyqtBMtHP8LkapiOyGxC6Urnu4q0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzH69OaB+i6PmkyN71m/oJixHmpv2FjE8mskwhuH44UCYPk8fzmCcQQKz9dph2isN
         SqnVilMG9Xg2KRc/Rd7pdpkToWQqBaw/JSfNW8JHaK5sDKfh1ICUwFvG+aEamY9cQP
         gsdgpMoGjnpT9h5DpYY2f3zJyhm/0cpXRpxvL2SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 057/177] ARM: dts: BCM5301X: Fixed QSPI compatible string
Date:   Tue, 15 Sep 2020 16:12:08 +0200
Message-Id: <20200915140656.368708091@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b793dab8d811e103665d6bddaaea1c25db3776eb ]

The string was incorrectly defined before from least to most
specific, swap the compatible strings accordingly.

Fixes: 1c8f40650723 ("ARM: dts: BCM5301X: convert to iProc QSPI")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 2d9b4dd058307..0016720ce5300 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -488,7 +488,7 @@
 	};
 
 	spi@18029200 {
-		compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
+		compatible = "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi";
 		reg = <0x18029200 0x184>,
 		      <0x18029000 0x124>,
 		      <0x1811b408 0x004>,
-- 
2.25.1



