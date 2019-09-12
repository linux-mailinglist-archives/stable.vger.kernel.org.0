Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4BCB0992
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 09:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfILHgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 03:36:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56691 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728296AbfILHgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 03:36:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190912073609euoutp011bab12d391fa544bf0d3e7e625d16e9b~DoK9GeOas0063000630euoutp01P
        for <stable@vger.kernel.org>; Thu, 12 Sep 2019 07:36:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190912073609euoutp011bab12d391fa544bf0d3e7e625d16e9b~DoK9GeOas0063000630euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1568273769;
        bh=xr1ve3qxfxo+cmsy8W7XSfa0V/j5rgDfSkv6SiKMv18=;
        h=From:To:Cc:Subject:Date:References:From;
        b=N2hw0AvxuT4xOLpft7RLK3UG7UCuqFCh/5m4rhsLd0usAKuUP7fmebtqYG3/WYJYS
         XkSuZgX6M+MF8gR7WqQPPaWWGIXYr5E8hTRFV9mmK4Ws4oiF0dlJWIsZ7hRDscxkJz
         0SX1rEMa0REpS8Gd+MukpTYUr904P3hcjY+gFrNo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190912073609eucas1p2a2358048db5e416f956a7382e64a4b0c~DoK8cL2Mw3255232552eucas1p2h;
        Thu, 12 Sep 2019 07:36:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 67.25.04469.865F97D5; Thu, 12
        Sep 2019 08:36:08 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3~DoK7qWCL01439614396eucas1p19;
        Thu, 12 Sep 2019 07:36:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190912073608eusmtrp273c289cdbb8efbb23b26911a82e1d42c~DoK7buTrE0606806068eusmtrp2Z;
        Thu, 12 Sep 2019 07:36:08 +0000 (GMT)
X-AuditID: cbfec7f2-569ff70000001175-15-5d79f568c538
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 65.31.04166.865F97D5; Thu, 12
        Sep 2019 08:36:08 +0100 (BST)
Received: from AMDC2765.DIGITAL.local (unknown [106.120.51.73]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190912073607eusmtip1a8062ea741ba3490b4306770698d4d9a~DoK7EK7c80236902369eusmtip1F;
        Thu, 12 Sep 2019 07:36:07 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] arm64: dts: exynos: Revert
 "Remove unneeded address space mapping for soc node"
Date:   Thu, 12 Sep 2019 09:36:02 +0200
Message-Id: <20190912073602.22829-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWy7djP87oZXytjDQ4fN7J4MG8bm8XGGetZ
        Lc6f38BuMeP8PiaLtUfuslss2PiI0YHNY9OqTjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vg
        ymhe95ixYJpEReuJGywNjPeFuxg5OSQETCTefNvH1sXIxSEksIJR4viT+awQzhdGif5zncwQ
        zmdGiaMrG4EyHGAtJ2abQ8SXM0ocaW9nguu4P+EXC8hcNgFDia63XWwgtoiAqsTntgXsIEXM
        AucZJd72T2EGSQgLJEm8eHCRFcRmASr6t34fWDOvgK3EtteXWCAOlJdYveEA2BkSAgfYJBpu
        PWGGSLhIXD/RwgphC0u8Or6FHcKWkfi/cz4TREMzo8TDc2vZIZweRonLTTMYIaqsJQ4fvwj2
        ELOApsT6XfoQYUeJpxtOsED8ySdx460gSJgZyJy0bTozRJhXoqNNCKJaTWLW8XVwaw9euAR1
        mofE5VtzwWwhgViJDWeb2CYwys1C2LWAkXEVo3hqaXFuemqxYV5quV5xYm5xaV66XnJ+7iZG
        YMSf/nf80w7Gr5eSDjEKcDAq8fAK3K2IFWJNLCuuzD3EKMHBrCTC6/OmMlaINyWxsiq1KD++
        qDQntfgQozQHi5I4bzXDg2ghgfTEktTs1NSC1CKYLBMHp1QD4xJLhpXTvzzteSNjuObSk/Mb
        4rcc5E0MuvnqilmzSa2PyZx5JVt29LRP9vuVvPFJ8HPP2MIVM197/HiZIvzUxfGdueSEv02S
        5n3Jpv3r5r4N14wXaj379oy6+BSdcyW3imxfWcpIP9QRK9414XLWt2dq/g1PH9ZdcVDRnjGH
        83rzVUXuzMTj25VYijMSDbWYi4oTAbCJAo/0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xu7oZXytjDW72slk8mLeNzWLjjPWs
        FufPb2C3mHF+H5PF2iN32S0WbHzE6MDmsWlVJ5tH35ZVjB6fN8kFMEfp2RTll5akKmTkF5fY
        KkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZTSve8xYME2iovXEDZYGxvvC
        XYwcHBICJhInZpt3MXJxCAksZZQ4dPkbexcjJ1BcRuLktAZWCFtY4s+1LjaIok+MEr8Xz2EG
        SbAJGEp0vQVJcHKICKhKfG5bANbMLHCZUeLJZWMQW1ggQeL8nrlMIDYLUM2/9ftYQGxeAVuJ
        ba8vsUAskJdYveEA8wRGngWMDKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECg2zbsZ+bdzBe
        2hh8iFGAg1GJh1fgbkWsEGtiWXFl7iFGCQ5mJRFenzeVsUK8KYmVValF+fFFpTmpxYcYTYGW
        T2SWEk3OB0ZAXkm8oamhuYWlobmxubGZhZI4b4fAwRghgfTEktTs1NSC1CKYPiYOTqkGRq5n
        wUwLp3JM2xL5QsZGO0poakuPWruAYTBXa9Vt7evf03faPWa8vDHPMu3UjdPLc75NPRZ+lffH
        438CVyx99+fX7JrzeaHfnSXpTs6XRH16GkvC/4ue2dIsuDCCreXnOsZdCm9TojULlXc/shf9
        sjr53uSyOpHaC+57lk+5auJVdvxv0PfCciWW4oxEQy3mouJEAPgx/cBIAgAA
X-CMS-MailID: 20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3
References: <CGME20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3@eucas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space
mapping for soc node") changed the address and size cells in root node from
2 to 1, but /memory nodes for the affected boards were not updated. This
went unnoticed on Exynos5433-based TM2(e) boards, because they use u-boot,
which updates /memory node to the correct values. On the other hand, the
mentioned commit broke boot on Exynos7-based Espresso board, which
bootloader doesn't touch /memory node at all.

This patch reverts commit ef72171b3621, so Exynos5433 and Exynos7 SoCs
again matches other ARM64 platforms with 64bit mappings in root node.

Reported-by: Alim Akhtar <alim.akhtar@samsung.com>
Fixes: ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space mapping for soc node")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <stable@vger.kernel.org>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
---
A few more comments:

1. I've added 'tested-by' tag from Alim, as his original report pointed
that reverting the offending commit fixes the boot issue.

2. This patch applies down to v4.18.

3. For v5.3 release, two patches:
   - "arm64: dts: exynos: Move GPU under /soc node for  Exynos5433"
   - "arm64: dts: exynos: Move GPU under /soc node for Exynos7"
   has to be applied first to ensure that GPU node will have correct 'reg'
   property (nodes under /soc still use 32bit mappings). I'm not sure if
   this can be expressed somehow in stable porting tags.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 6 +++---
 arch/arm64/boot/dts/exynos/exynos7.dtsi    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index 239bf44d174b..f69530730219 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -18,8 +18,8 @@
 
 / {
 	compatible = "samsung,exynos5433";
-	#address-cells = <1>;
-	#size-cells = <1>;
+	#address-cells = <2>;
+	#size-cells = <2>;
 
 	interrupt-parent = <&gic>;
 
@@ -260,7 +260,7 @@
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges;
+		ranges = <0x0 0x0 0x0 0x18000000>;
 
 		chipid@10000000 {
 			compatible = "samsung,exynos4210-chipid";
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index f09800f355db..3a00ef0a17ff 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -12,8 +12,8 @@
 / {
 	compatible = "samsung,exynos7";
 	interrupt-parent = <&gic>;
-	#address-cells = <1>;
-	#size-cells = <1>;
+	#address-cells = <2>;
+	#size-cells = <2>;
 
 	aliases {
 		pinctrl0 = &pinctrl_alive;
@@ -87,7 +87,7 @@
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges;
+		ranges = <0 0 0 0x18000000>;
 
 		chipid@10000000 {
 			compatible = "samsung,exynos4210-chipid";
-- 
2.17.1

