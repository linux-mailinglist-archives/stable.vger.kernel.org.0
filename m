Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D51246B94
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgHQP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388136AbgHQP6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:58:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4AA2072E;
        Mon, 17 Aug 2020 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679911;
        bh=mdDePSu7eStr8QxZQkIFDAJN7NczDRXPX+oERb1uTbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNFx/ieFKbWNMcCl/NZdnj0eBCPzYsUaCo2lfZ+dj3hijw/UUWos9V9cWSeObj0+X
         p0o86FgCaa9W7VOhyz8Bm3P+hkcXwKRYqCUTd/wDuYVodT2tJZraAzdMNkCJDbiX1F
         Tf7WATxIdVgReCgkh4eX86zd1/DZFNvjdUC9L8WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.7 376/393] ARM: dts: exynos: Extend all Exynos5800 A15s OPPs with max voltage data
Date:   Mon, 17 Aug 2020 17:17:06 +0200
Message-Id: <20200817143837.847384622@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit d644853ff8fcbb7a4e3757f9d8ccc39d930b7e3c upstream.

On Exynos5422/5800 the regulator supply for the A15 cores ("vdd_arm") is
coupled with the regulator supply for the SoC internal circuits
("vdd_int"), thus all operating points that modify one of those supplies
have to specify a triplet of the min/target/max values to properly work
with regulator coupling.

Fixes: eaffc4de16c6 ("ARM: dts: exynos: Add missing CPU frequencies for Exynos5422/5800")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5800.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/exynos5800.dtsi
+++ b/arch/arm/boot/dts/exynos5800.dtsi
@@ -23,17 +23,17 @@
 &cluster_a15_opp_table {
 	opp-2000000000 {
 		opp-hz = /bits/ 64 <2000000000>;
-		opp-microvolt = <1312500>;
+		opp-microvolt = <1312500 1312500 1500000>;
 		clock-latency-ns = <140000>;
 	};
 	opp-1900000000 {
 		opp-hz = /bits/ 64 <1900000000>;
-		opp-microvolt = <1262500>;
+		opp-microvolt = <1262500 1262500 1500000>;
 		clock-latency-ns = <140000>;
 	};
 	opp-1800000000 {
 		opp-hz = /bits/ 64 <1800000000>;
-		opp-microvolt = <1237500>;
+		opp-microvolt = <1237500 1237500 1500000>;
 		clock-latency-ns = <140000>;
 	};
 	opp-1700000000 {


