Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F25B26B52F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgIOXjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgIOOe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:34:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8368221D7E;
        Tue, 15 Sep 2020 14:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179323;
        bh=oq0yfkhZ5+QWjIzLaDbYzHopAYNvik52ZcjWmDWRAlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHjzDkCjf/ud2a2nXlKNNKe5cd4tkq5A9hSfPJbvJiXRaZpNPtRNibIIdaReNXmph
         d6njYFoxlTQ9YaVe6oo091uoPK1X5eFReiJF4Sezy89UHcz1dbFd3Nb6KZ06a/w1ke
         u+LmZSTUajwWIrb1d5tiMh9Rh5ZfpUbTGZiIAlT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/78] ARM: dts: BCM5301X: Fixed QSPI compatible string
Date:   Tue, 15 Sep 2020 16:12:40 +0200
Message-Id: <20200915140634.312588802@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
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
index a678fb7c9e3b2..c91716d5980c3 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -445,7 +445,7 @@
 	};
 
 	spi@18029200 {
-		compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
+		compatible = "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi";
 		reg = <0x18029200 0x184>,
 		      <0x18029000 0x124>,
 		      <0x1811b408 0x004>,
-- 
2.25.1



