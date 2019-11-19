Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2725C1017B1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfKSFkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbfKSFkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:40:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34B622303;
        Tue, 19 Nov 2019 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142019;
        bh=MxlgPNIfRZUc8+XjXZZznbftC8zjMG5AwsiChYigWyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtEbcoj2ho5fHqpJXUnkBSMdaor3Xlfz38s9RYm9nIOv48YL6Uk0wYt6q/ikCviS5
         DU53C1jX3OvNgtRubmsmKZ0BndkzBCsjsaAmaCAAcK1kv/Y/6exD+pzP49ZpsFQ+3q
         tlr/1BHmGjdSR8M9Lc7E+TVlmv/toTIlFaqyG1fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 310/422] ARM: dts: clearfog: fix sdhci supply property name
Date:   Tue, 19 Nov 2019 06:18:27 +0100
Message-Id: <20191119051419.086019662@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit e807f0298144c06740022a2f900d86b7f115595e ]

The vmmc phandle, like all power supply property names, must have the
'-supply' suffix.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-clearfog.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-clearfog.dtsi b/arch/arm/boot/dts/armada-388-clearfog.dtsi
index 7c6ad2afb0947..1b0d0680c8b62 100644
--- a/arch/arm/boot/dts/armada-388-clearfog.dtsi
+++ b/arch/arm/boot/dts/armada-388-clearfog.dtsi
@@ -48,7 +48,7 @@
 					     &clearfog_sdhci_cd_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.20.1



