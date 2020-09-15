Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CE826B538
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgIOXj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgIOOet (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:34:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFEE921D7B;
        Tue, 15 Sep 2020 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179318;
        bh=W93tyXhRIXwKapefYmklEI12NA5WAyktXunWnPRnGPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J840ADUQFTbYlQBQb/b2vwpepcMdTRj0al5G4Nf04zRQdW3xsztN4KmJzCcV8/axF
         s0uBHGGlPc2uiAn3/D4zr884iTxxsawGDRwOHXHzwkDjBEKZkcWVa+9WTT43NWjh5k
         Gvuyxt1CvmxDYG0dM60sXXEInNOl802Du0y2Z4l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/78] ARM: dts: bcm: HR2: Fixed QSPI compatible string
Date:   Tue, 15 Sep 2020 16:12:38 +0200
Message-Id: <20200915140634.200661037@linuxfoundation.org>
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

[ Upstream commit d663186293a818af97c648624bee6c7a59e8218b ]

The string was incorrectly defined before from least to most specific,
swap the compatible strings accordingly.

Fixes: b9099ec754b5 ("ARM: dts: Add Broadcom Hurricane 2 DTS include file")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-hr2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-hr2.dtsi b/arch/arm/boot/dts/bcm-hr2.dtsi
index e35398cc60a06..dd71ab08136be 100644
--- a/arch/arm/boot/dts/bcm-hr2.dtsi
+++ b/arch/arm/boot/dts/bcm-hr2.dtsi
@@ -217,7 +217,7 @@
 		};
 
 		qspi: spi@27200 {
-			compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
+			compatible = "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi";
 			reg = <0x027200 0x184>,
 			      <0x027000 0x124>,
 			      <0x11c408 0x004>,
-- 
2.25.1



