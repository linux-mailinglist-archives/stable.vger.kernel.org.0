Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B772126A710
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgIOO35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41427 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgIOO2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C73722581;
        Tue, 15 Sep 2020 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179649;
        bh=HAZp23Ou+P+rrFXKqLLv5gjdmUUhLgUk2swQ65tFFrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xs0G/6S+/VxBU4fGG0J9rq1gdvUTLvAm98lXqLzrFGAoGjz+DlZdn1FmKTKEqelfI
         JCtkl3Us35oOje5I9az0ehUnuWffQ9rD7eBd/jjeI5HkiPY7OMkmE+a+RCjYk2EZM6
         7D2EWFrebLUkGPEgdo20fzGiz36CNDQ+8HM5zljw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/132] ARM: dts: NSP: Fixed QSPI compatible string
Date:   Tue, 15 Sep 2020 16:12:15 +0200
Message-Id: <20200915140645.787378066@linuxfoundation.org>
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

[ Upstream commit d1ecc40a954fd0f5e3789b91fa80f15e82284e39 ]

The string was incorrectly defined before from least to most
specific, swap the compatible strings accordingly.

Fixes: 329f98c1974e ("ARM: dts: NSP: Add QSPI nodes to NSPI and bcm958625k DTSes")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 418e6b97cb2ec..8615d89fa4690 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -282,7 +282,7 @@
 		};
 
 		qspi: spi@27200 {
-			compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
+			compatible = "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi";
 			reg = <0x027200 0x184>,
 			      <0x027000 0x124>,
 			      <0x11c408 0x004>,
-- 
2.25.1



