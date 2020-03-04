Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F76179275
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgCDOh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 09:37:58 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44143 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgCDOh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 09:37:58 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200304143756euoutp02fff958f1ebde2d7192cf358ae8debe1c~5IK41M_lU2524525245euoutp026
        for <stable@vger.kernel.org>; Wed,  4 Mar 2020 14:37:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200304143756euoutp02fff958f1ebde2d7192cf358ae8debe1c~5IK41M_lU2524525245euoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583332676;
        bh=99b9/nqKXyV4JwNnoUH49XBGlIXWBdmlcza0HtOWdQg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ZSbYbOsJ8j/n6Exv6eZ2MOyfRT0H1KWGATgOSk/cjuhzJES2laik/OZ5EKSPYXodD
         vE+5l5Jz+T5neUL/fVpXlzthQWoNcS4MBdBLCDDd83BrbiQhFlP0wrecrO6sJFsOjF
         Z5iIpksp4Jk9qG9fPsUAUVMg0FK9IfsEyblcfEiw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200304143756eucas1p1dc39ee2b972cd168590e723976959900~5IK4mwQkj3115131151eucas1p1Y;
        Wed,  4 Mar 2020 14:37:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 57.C9.60679.44DBF5E5; Wed,  4
        Mar 2020 14:37:56 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6~5IK4V9MeV3243032430eucas1p1u;
        Wed,  4 Mar 2020 14:37:56 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200304143756eusmtrp10d13cac3efe57838f04e6eab767dae1f~5IK4VW-Wg1965119651eusmtrp1S;
        Wed,  4 Mar 2020 14:37:56 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-68-5e5fbd447a04
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 8A.16.08375.34DBF5E5; Wed,  4
        Mar 2020 14:37:56 +0000 (GMT)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200304143755eusmtip245b66475e741a3f2cf49bf10e06d1a82~5IK4BU9Pt2804428044eusmtip26;
        Wed,  4 Mar 2020 14:37:55 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: exynos: Fix polarity of the LCD SPI bus on
 UniversalC210 board
Date:   Wed,  4 Mar 2020 15:37:26 +0100
Message-Id: <20200304143726.15826-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWy7djP87oue+PjDM78FrbYOGM9q8X58xvY
        LWac38dksfbIXXaLBRsfMTqwemxa1cnm0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBkXWxrZ
        ChZwVfye2cXSwLiVo4uRk0NCwESis2UXWxcjF4eQwApGiY9XW9hAEkICXxglHt3ygLA/M0qs
        +OkL07D12EN2iIbljBLHp71igXCAGu6c2s4EUsUmYCjR9bYLbJKIgKrE57YFYB3MICs69y4H
        KxIWiJb42LOBFcRmASr6d/EbWJxXwFbi8fUGRoh18hKrNxxgBmmWENjCJnF97h82iISLxN0p
        S1kgbGGJV8e3sEPYMhKnJ/ewQDQ0M0o8PLeWHcLpYZS43DQDaqy1xJ1zv4AmcQDdpCmxfpc+
        RNhR4svtZmaQsIQAn8SNt4IgYWYgc9K26VBhXomONiGIajWJWcfXwa09eOESM4TtIXFt0Ut2
        SNDFSize0806gVFuFsKuBYyMqxjFU0uLc9NTi43yUsv1ihNzi0vz0vWS83M3MQKj/PS/4192
        MO76k3SIUYCDUYmH98XU+Dgh1sSy4srcQ4wSHMxKIrzCpkAh3pTEyqrUovz4otKc1OJDjNIc
        LErivMaLXsYKCaQnlqRmp6YWpBbBZJk4OKUaGDmqcsQzum6HXg3rvhjYekfxcevkblEze9XU
        eastn9t8SM1bmfCK5aTfyvSZvavfWsnOy9xnHc2Yvfpz/imroymiHN1KZsbyKQ8vxhZcUTbP
        iE3x67eX/LLyTsZb3XA121k9BYEcns/XLTu8ecbagmdrdvWUL1zbdcfAhTPWx0Lw/mtb3ocW
        SizFGYmGWsxFxYkAIm4Dhe4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/xe7oue+PjDP4HWGycsZ7V4vz5DewW
        M87vY7JYe+Quu8WCjY8YHVg9Nq3qZPPo27KK0ePzJrkA5ig9m6L80pJUhYz84hJbpWhDCyM9
        Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jIstjWwFC7gqfs/sYmlg3MrRxcjJISFg
        IrH12EP2LkYuDiGBpYwSH5pfskMkZCROTmtghbCFJf5c62KDKPrEKHHp4kKwBJuAoUTXW5AE
        J4eIgKrE57YFYM3MAqsYJb7dcQexhQUiJa5dW8kCYrMA1fy7+I0JxOYVsJV4fL2BEWKBvMTq
        DQeYJzDyLGBkWMUoklpanJueW2yoV5yYW1yal66XnJ+7iREYWtuO/dy8g/HSxuBDjAIcjEo8
        vC+mxscJsSaWFVfmHmKU4GBWEuEVNgUK8aYkVlalFuXHF5XmpBYfYjQFWj6RWUo0OR8Y9nkl
        8YamhuYWlobmxubGZhZK4rwdAgdjhATSE0tSs1NTC1KLYPqYODilGhjbXBw/lR9m7Z+40lv1
        AoOmb9IZlZ/sb4RfLt3zL86b9/19nsJdJ9nPWakYJekdF126erbyt8kNj180TQm++dlOmcGv
        csaSeXPnVl528j96LkD+71bp0EPxr+4dZRPf9upbkbvex8bpTyU0zXdmsJy7n6lbOCFHWCV3
        GVtHyuSaK5+ulCT4X+lQYinOSDTUYi4qTgQAWeHcSkMCAAA=
X-CMS-MailID: 20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6
References: <CGME20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6@eucas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recent changes in the SPI core and the SPI-GPIO driver revealed that the
GPIO lines for the LD9040 LCD controller on the UniversalC210 board are
defined incorrectly. Fix the polarity for those lines to match the old
behavior and hardware requirements to fix LCD panel operation with
recent kernels.

CC: stable@vger.kernel.org # 5.0+
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4210-universal_c210.dts | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4210-universal_c210.dts b/arch/arm/boot/dts/exynos4210-universal_c210.dts
index a1bdf7830a87..9dda6bdb9253 100644
--- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
@@ -115,7 +115,7 @@
 		gpio-sck = <&gpy3 1 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpy3 3 GPIO_ACTIVE_HIGH>;
 		num-chipselects = <1>;
-		cs-gpios = <&gpy4 3 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpy4 3 GPIO_ACTIVE_LOW>;
 
 		lcd@0 {
 			compatible = "samsung,ld9040";
@@ -124,8 +124,6 @@
 			vci-supply = <&ldo17_reg>;
 			reset-gpios = <&gpy4 5 GPIO_ACTIVE_HIGH>;
 			spi-max-frequency = <1200000>;
-			spi-cpol;
-			spi-cpha;
 			power-on-delay = <10>;
 			reset-delay = <10>;
 			panel-width-mm = <90>;
-- 
2.17.1

