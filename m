Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABB6194124
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgCZOUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:20:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57416 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgCZOUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 10:20:51 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200326142049euoutp0103743e8b1881b301f80b77dee0edd26a~-4IN9wM831340513405euoutp01g
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 14:20:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200326142049euoutp0103743e8b1881b301f80b77dee0edd26a~-4IN9wM831340513405euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585232449;
        bh=hN+ecJpsrRK3zq7EWx6C58RKWjYp+sw4rItIRnqYql0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=RSjjvNrS7KQ0rjpAOlLm4UftVa+ue/hKs8GSiA9AqFLcoX52heS8QS98h6Id1YA6S
         ExfceU9a2nhi+8dQLlLY08QaagkjpCDRE5/AFXdOST5pYWhbnzhWuT58xB/rH7aLVK
         IMb88zQql8wTEi46wxFvOs2hzE7RuwllsSaCeAk4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200326142048eucas1p259edb440d4f80ef2d312b8eed1e5c216~-4INmW0GC2148121481eucas1p2x;
        Thu, 26 Mar 2020 14:20:48 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 77.CB.60679.04ABC7E5; Thu, 26
        Mar 2020 14:20:48 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200326142048eucas1p29aee56575f8b530fc2d83860f6185d6b~-4INRoN6T1889018890eucas1p26;
        Thu, 26 Mar 2020 14:20:48 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200326142048eusmtrp17a0ff825e37f4d6d09b6ce41e1db0cfe~-4INQ-KlH2054620546eusmtrp1V;
        Thu, 26 Mar 2020 14:20:48 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-cc-5e7cba40b760
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D9.0D.07950.04ABC7E5; Thu, 26
        Mar 2020 14:20:48 +0000 (GMT)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200326142048eusmtip27bef788e9fa098047b75c944c9e1b1f8~-4IM_IRwd0712907129eusmtip2y;
        Thu, 26 Mar 2020 14:20:48 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Simon Shields <simon@lineageos.org>, stable@vger.kernel.org
Subject: [PATCH] ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3
 CM36651 sensor's bus
Date:   Thu, 26 Mar 2020 15:20:37 +0100
Message-Id: <20200326142037.20418-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsWy7djP87oOu2riDL6v0LPYOGM9q8X58xvY
        LWac38dksfbIXXaLLWdus1ks2PiI0YHNY9OqTjaPlvWb2Dz6tqxi9Pi8SS6AJYrLJiU1J7Ms
        tUjfLoEr49zmiawFN7krTr55wNLA+I6zi5GTQ0LARGLHqi6mLkYuDiGBFYwSt169YYZwvjBK
        7Pk2ixHC+cwocaPtGDNMy8V5t6FaljNKfF5ynBWuZUXnfhaQKjYBQ4mut11sILaIgKrE57YF
        7CA2s8BZRokPFyRBbGGBGIlbh6aD1bMA1Xw4f4QRxOYVsJX4smwXC8Q2eYnVGw6A3SQhcIRN
        YuaMx4wQCReJ3d3noWxhiVfHt7BD2DISpyf3sEA0NDNKPDy3lh3C6WGUuNw0A6rDWuLOuV9A
        53EAnaQpsX6XPkTYUeJL12sWkLCEAJ/EjbeCEEfzSUzaNp0ZIswr0dEmBFGtJjHr+Dq4tQcv
        XIIq8ZBYtiUBJCwkECvxfMsllgmMcrMQVi1gZFzFKJ5aWpybnlpslJdarlecmFtcmpeul5yf
        u4kRGPmn/x3/soNx15+kQ4wCHIxKPLwaLTVxQqyJZcWVuYcYJTiYlUR4n0YChXhTEiurUovy
        44tKc1KLDzFKc7AoifMaL3oZKySQnliSmp2aWpBaBJNl4uCUamAsN1M4dzCqO3BKQoz52X2z
        lP1Zdj+efFfuheWD+H+sQte3Xjy+f3Ka//V16WdWXrQ/3b6qZM2rT3an615JBK7e8bdR3e7l
        3sJTj+Yq83FfX7XOomXPM7kZRn8VPr5wDfjt8rYrPG27wRd+0+sGjRqrOafenGZSK/80YKUM
        X4tLkfG3z3+W796vq8RSnJFoqMVcVJwIAN1fkbD4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xe7oOu2riDBZul7bYOGM9q8X58xvY
        LWac38dksfbIXXaLLWdus1ks2PiI0YHNY9OqTjaPlvWb2Dz6tqxi9Pi8SS6AJUrPpii/tCRV
        ISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv49zmiawFN7krTr55
        wNLA+I6zi5GTQ0LAROLivNtMXYxcHEICSxklnn67zQqRkJE4Oa0ByhaW+HOtiw2i6BOjxMG9
        X1hAEmwChhJdb0ESnBwiAqoSn9sWsIMUMQtcZJT407sdrFtYIEriYNt5sCIWoKIP548wgti8
        ArYSX5btYoHYIC+xesMB5gmMPAsYGVYxiqSWFuem5xYb6RUn5haX5qXrJefnbmIEhty2Yz+3
        7GDsehd8iFGAg1GJh1ejpSZOiDWxrLgy9xCjBAezkgjv00igEG9KYmVValF+fFFpTmrxIUZT
        oOUTmaVEk/OB8ZBXEm9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoHx
        wp8Lu+vXRaat1ja8eXDx3YVNrboFVkmPJvkw1zB4a+zb8WvzgwLZYpWFjW8MPb5Z7n+s2+hn
        Fuk1I3JmbP5Pvh/WjX0Wzyr/7HFLtA5UeaQ/lUEtvzb7C6OvofXFGyfWnRRkPO8cMe+MvN0f
        hcpkgyduR7rcpMTsOB/NFDXZ4ba4lzUmTlmJpTgj0VCLuag4EQAuOa+zTwIAAA==
X-CMS-MailID: 20200326142048eucas1p29aee56575f8b530fc2d83860f6185d6b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200326142048eucas1p29aee56575f8b530fc2d83860f6185d6b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200326142048eucas1p29aee56575f8b530fc2d83860f6185d6b
References: <CGME20200326142048eucas1p29aee56575f8b530fc2d83860f6185d6b@eucas1p2.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GPIO lines for the CM36651 sensor I2C bus use the normal not the inverted
polarity. This bug has been there since adding the CM36651 sensor by
commit 85cb4e0bd2294, but went unnoticed because the "i2c-gpio" driver
ignored the GPIO polarity specified in the device-tree.

The recent conversion of "i2c-gpio" driver to the new, descriptor based
GPIO API, automatically made it the DT-specified polarity aware, what
broke the CM36651 sensor operation.

Fixes: c769eaf7a85d ("ARM: dts: exynos: Split Trats2 DTS in preparation for Midas boards")
Fixes: c10d3290cbde ("ARM: dts: Use GPIO constants for flags cells in exynos4412 boards")
Fixes: 85cb4e0bd229 ("ARM: dts: add cm36651 light/proximity sensor node for exynos4412-trats2")
CC: stable@vger.kernel.org # 4.16+
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi b/arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi
index 44f97546dd0a..f910aa924bfb 100644
--- a/arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi
+++ b/arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi
@@ -68,7 +68,7 @@
 
 	i2c_cm36651: i2c-gpio-2 {
 		compatible = "i2c-gpio";
-		gpios = <&gpf0 0 GPIO_ACTIVE_LOW>, <&gpf0 1 GPIO_ACTIVE_LOW>;
+		gpios = <&gpf0 0 GPIO_ACTIVE_HIGH>, <&gpf0 1 GPIO_ACTIVE_HIGH>;
 		i2c-gpio,delay-us = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.17.1

