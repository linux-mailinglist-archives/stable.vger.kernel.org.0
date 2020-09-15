Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335CC26A711
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgIOOaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgIOO2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9A722582;
        Tue, 15 Sep 2020 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179651;
        bh=9G+pKFcUkd4vMcWyqtBMtHP8LkapiOyGxC6Urnu4q0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHDzifoOfv5i+OBEiFSu9q4iZw0fBbMzQm+zY12qa8lJ5NAXaKLaaCQ1lW0a8zbvn
         See4yRs1Pq1fMb84gJUIDjidjzy3NeQV4y+orZbJkD+vxW1q/v0NzhTW8r/9SNeZBT
         kDtmxtaX7aAkipapTEv1oShojdGU2qblY/Ov8hmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/132] ARM: dts: BCM5301X: Fixed QSPI compatible string
Date:   Tue, 15 Sep 2020 16:12:16 +0200
Message-Id: <20200915140645.834792529@linuxfoundation.org>
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



