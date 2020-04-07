Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901A81A01E8
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDGABB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgDGABB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6F620768;
        Tue,  7 Apr 2020 00:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217660;
        bh=K2m3pcjtFaB1WdUGw6/97iAE58R7nthpPofK+CoeoqM=;
        h=From:To:Cc:Subject:Date:From;
        b=Kknbdf+TIFolbtAz2Wr8pqEth8WWfUisNdQawJitN2wcMDnKoxmdIlekd4wirxnqW
         +4XfyZhdZy3/v2IGLZpFpUqS6Jg8ZS3YUhkkUxoyuWc+b0xqDNjOsJMfCyYu8CjNRr
         9kxKlt7S4iJQ4GvGi85h6gFR1jqvWHOD4wJCa2HE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 01/35] ARM: dts: sun8i-a83t-tbs-a711: HM5065 doesn't like such a high voltage
Date:   Mon,  6 Apr 2020 20:00:23 -0400
Message-Id: <20200407000058.16423-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f781d330cff50..e8b3669e0e5d8 100644
--- a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
@@ -374,8 +374,8 @@
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

