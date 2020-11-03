Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6301D2A52A6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgKCUvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgKCUvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DADD82053B;
        Tue,  3 Nov 2020 20:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436708;
        bh=ZEG/PITrBrNEmPAiZ7Xuy2CVBKPYhPVhfGll2w7GYr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSHqNe1EjlA46QDoQmNMxuo02sRMkXhYbNAwWQF02k9lGx+27Fr/jkwPBEW+tJDDt
         h6hooG2UhqPOUEWaLl/UwufuY0tVOkxQAldHj/I2KjfJjT6lHLqiMSIFwTBiVrAfc8
         bNJn9uyZ9SPy95GX6C9DJeE5FLAI55fjpGQfrM0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.9 368/391] ARM: dts: s5pv210: fix pinctrl property of "vibrator-en" regulator in Aries
Date:   Tue,  3 Nov 2020 21:36:59 +0100
Message-Id: <20201103203411.979640211@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 2c6658c607a3af2ed7bd41dc57a3dd31537d023e upstream.

Fix typo in pinctrl property of "vibrator-en" fixed regulator in Aries
family of boards.  The error caused lack of pin configuration for the
GPIO used in vibrator.

Fixes: 04568cb58a43 ("ARM: dts: s5pv210: Disable pull for vibrator enable GPIO on Aries boards")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200907161141.31034-5-krzk@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/s5pv210-aries.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -66,7 +66,7 @@
 		gpio = <&gpj1 1 GPIO_ACTIVE_HIGH>;
 
 		pinctrl-names = "default";
-		pinctr-0 = <&vibrator_ena>;
+		pinctrl-0 = <&vibrator_ena>;
 	};
 
 	touchkey_vdd: regulator-fixed-1 {


