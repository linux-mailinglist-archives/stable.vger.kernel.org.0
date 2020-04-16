Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CFB1ACA2B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410388AbgDPPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441538AbgDPNmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAEBA2076D;
        Thu, 16 Apr 2020 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044557;
        bh=5tu6jgjQORBsXTyfqgjJ3eMKXV2UrGsH132oHEvwEcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fovl8ECzJJmB98/VgMt4lrAiUYzEgGDAgGNwv4nx1UgKPSMVKcMLUjcPNCSZ1Bnh9
         DqSkm0KnsNg8+ZPMRW3ULgq7Ksc/MK6H3GgJ7YSl9OF7cB7nwojcwVQzXbWpWb8MVb
         TEMPbJM2EGIv2uEr6M1ZdaZ8CGtZl0dlmYJvbjPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/232] ARM: dts: sun8i-a83t-tbs-a711: HM5065 doesnt like such a high voltage
Date:   Thu, 16 Apr 2020 15:21:35 +0200
Message-Id: <20200416131316.814283255@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit a40550952c000667b20082d58077bc647da6c890 ]

Lowering the voltage solves the quick image degradation over time
(minutes), that was probably caused by overheating.

Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
index 397140454132f..6bf93e5ed6817 100644
--- a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
@@ -358,8 +358,8 @@
 };
 
 &reg_dldo3 {
-	regulator-min-microvolt = <2800000>;
-	regulator-max-microvolt = <2800000>;
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <1800000>;
 	regulator-name = "vdd-csi";
 };
 
-- 
2.20.1



