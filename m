Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541DF1454FD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAVNR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:17:57 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5407120678;
        Wed, 22 Jan 2020 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699077;
        bh=bHGZ3spmvh+DMpZ4zXokT9aDLQr1jM1mZT27m+NnFcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rk0ywgotO3zCQJG4Qrib+/UFOEfX8rja6vYHZ7Stf+kgvdR3e1Jaw5Syn3KIH9P0B
         pbn1dVgKF/pKkjJ0+Kx/2xjr7szo4I06rlyzOapALPpUJBFfNSSneaDL/JsDos+qPX
         TvJQMFalm6PkEn9phh2Jvl9Q3ySsgh2FLi1rjJM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 006/222] ARM: dts: imx6q-dhcom: fix rtc compatible
Date:   Wed, 22 Jan 2020 10:26:32 +0100
Message-Id: <20200122092833.811172521@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit 7d7778b1396bc9e2a3875009af522beb4ea9355a upstream.

The only correct and documented compatible string for the rv3029 is
microcrystal,rv3029. Fix it up.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -206,7 +206,7 @@
 	};
 
 	rtc@56 {
-		compatible = "rv3029c2";
+		compatible = "microcrystal,rv3029";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_rtc_hw300>;
 		reg = <0x56>;


