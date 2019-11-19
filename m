Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE91101515
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbfKSFke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:40:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbfKSFkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:40:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C809E21783;
        Tue, 19 Nov 2019 05:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142033;
        bh=8zJoHrLNn5sbwSXWJeAMxdvWZEyDAJiM8C5G+GLVnno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpQNLkaw8aMFfUB78Q++gVc7/eseWCCJ24xICa3uY3cCjHwVRV+qntA1zNAi4MScc
         zDoDGy6a2LLsYCRqwevFhwoPeEtLLs3N6HokDifn/S7KLlUL7YAhcN9W4bf1ByhAU5
         2ZRSmJSs7piUT0STTFRhMfY0YsfEf7shNcXUfrjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 366/422] ARM: dts: imx51-zii-rdu1: Fix the rtc compatible string
Date:   Tue, 19 Nov 2019 06:19:23 +0100
Message-Id: <20191119051422.731764698@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 1c5f335f61ffb838fc3cc1cec9464067663eb8c8 ]

According to Documentation/devicetree/bindings/rtc/rtc-ds1307.txt the
original compatible "maxim,ds1341" is not a valid entry.

Switch to the documented "dallas,ds1341" compatible.

Reported-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx51-zii-rdu1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx51-zii-rdu1.dts b/arch/arm/boot/dts/imx51-zii-rdu1.dts
index 6e80254c4562a..3fb66ddfe93a5 100644
--- a/arch/arm/boot/dts/imx51-zii-rdu1.dts
+++ b/arch/arm/boot/dts/imx51-zii-rdu1.dts
@@ -514,7 +514,7 @@
 	};
 
 	ds1341: rtc@68 {
-		compatible = "maxim,ds1341";
+		compatible = "dallas,ds1341";
 		reg = <0x68>;
 	};
 
-- 
2.20.1



