Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0A27302C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgIURDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbgIUQh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 428D6206B7;
        Mon, 21 Sep 2020 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706248;
        bh=cFOb6X2TH9jpa/vZrkwFVssHoq37dH+POa/lNLMPUHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5Fm4m7oVAfMUbGKtbr6tU+qAsZOizbv/1LglxYTxVTtPn5HX9pB4ZBYZDlEhdNq5
         KHsPxKm1ozpCl2mJOOGnjMioIqv6/LAjnRk51COaacGgQANGQu402okr1JKgYhDVMW
         iwAlDUl8NrUEhOGMnX551l9R6BG4NwoExJG5CqNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/94] ARM: dts: BCM5301X: Fixed QSPI compatible string
Date:   Mon, 21 Sep 2020 18:26:54 +0200
Message-Id: <20200921162035.884232548@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 501877e87a5b8..dffa8b9bd536d 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -426,7 +426,7 @@
 	};
 
 	spi@18029200 {
-		compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
+		compatible = "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi";
 		reg = <0x18029200 0x184>,
 		      <0x18029000 0x124>,
 		      <0x1811b408 0x004>,
-- 
2.25.1



