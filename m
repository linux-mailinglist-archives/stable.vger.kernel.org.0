Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9DA4B0425
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 05:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiBJEDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 23:03:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiBJEDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 23:03:49 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E628824585
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 20:03:47 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220210040342epoutp010ed79618b9034ab0c85a7cd8e610ae5f~SUPP_gfGG0239802398epoutp01E
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 04:03:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220210040342epoutp010ed79618b9034ab0c85a7cd8e610ae5f~SUPP_gfGG0239802398epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644465822;
        bh=s98+9VPav5RQZNoXRdsXGL9ubyNPY1JXXOB4R8f7M0Y=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=sM0jOl/UcXHS5CA5wIFZlQOqJ04l4K5gMPteGtG5vYHP7wC6ajUB5o4f2PYO5iApB
         qd+d/eqSY9kiWP8jXJnyAmw5wqjh9pVaMC9CtkAXRCAy/JK8z68BcO3Nn7szRUGGaQ
         kjNJ95ZO9CG1YiqGK/mSSMl3yeuuLjbqVdRYqKVk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220210040341epcas5p1226981efca4e61735205421bc2def079~SUPPIcF6r0129601296epcas5p1n;
        Thu, 10 Feb 2022 04:03:41 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4JvNQc44s3z4x9Q0; Thu, 10 Feb
        2022 04:03:36 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.1E.06423.19E84026; Thu, 10 Feb 2022 13:03:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220210040328epcas5p233a2f8ef33593694404334f11c6dde34~SUPDAJ3FA0864808648epcas5p2b;
        Thu, 10 Feb 2022 04:03:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220210040328epsmtrp26876f1897f533d89d65955b8851ed1ca~SUPDAOSDw2508625086epsmtrp2B;
        Thu, 10 Feb 2022 04:03:28 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-fc-62048e9151df
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.EA.08738.09E84026; Thu, 10 Feb 2022 13:03:28 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220210040326epsmtip15aa9d8c1f673af62fe86ddc57a0bf836~SUPAfxDt_2289122891epsmtip1s;
        Thu, 10 Feb 2022 04:03:26 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        "'Seung-Woo Kim'" <sw0312.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Daniel Vetter'" <daniel@ffwll.ch>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Vinod Koul'" <vkoul@kernel.org>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-phy@lists.infradead.org>
Cc:     "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Sylwester Nawrocki'" <snawrocki@kernel.org>,
        <stable@vger.kernel.org>
In-Reply-To: <20220208171823.226211-3-krzysztof.kozlowski@canonical.com>
Subject: RE: [PATCH 02/10] ARM: dts: exynos: add missing HDMI supplies on
 SMDK5420
Date:   Thu, 10 Feb 2022 09:33:24 +0530
Message-ID: <003301d81e33$28712a20$79537e60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKO+pA4e/0lxhjrdKzLnJfOvLS5zwJNwtwxAgVrE2eq+9du0A==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJsWRmVeSWpSXmKPExsWy7bCmuu7EPpYkg8sfVS16z51ksvi/bSKz
        xfwj51gtrnx9z2Yx6f4EFosX9y6yWFx42sNmsfHtDyaLs01v2C02Pb7GanF51xw2iwmrvrFY
        zDi/j8li7ZG77Bate4+wW7Q/fclssWDjI0aLGZNfslnsvHOC2UHYY1ZDL5vH3m8LWDw2repk
        89j+7QGrx/3u40wem5fUe/RtWcXocfzGdiaPz5vkAjijsm0yUhNTUosUUvOS81My89JtlbyD
        453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgL5SUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnTDh9ia3gD3/F388H2RsYv/F2MXJy
        SAiYSHQdb2IDsYUEdjNKbJzL38XIBWR/YpRo/rmeBcL5zCixc9ECoCoOsI7+U+4QDbsYJSbN
        K4aoecko0bdrCTNIgk1AV2LH4jY2kISIQDerxINji8FWMAvUSdx5uQCsiFPAQ+L03y6wuLBA
        iMT9ywuYQGwWAVWJ1h8fwGxeAUuJ55uXQtmCEidnPmGBmCMvsf3tHGaIFxQkfj5dxgpiiwg4
        Sew+OZ8VokZc4uXRI+wgR0gITOaU2PhpMztEg4vEitZpjBC2sMSr41ug4lISn9/thfoyW6Jn
        lzFEuEZi6bxjLBC2vcSBK3NYQEqYBTQl1u/Sh1jFJ9H7+wkTRCevREebEES1qkTzu6tQndIS
        E7u7WSFsD4kdW98zT2BUnIXksVlIHpuF5IFZCMsWMLKsYpRMLSjOTU8tNi0wzEsth8d2cn7u
        JkZwitfy3MF498EHvUOMTByMhxglOJiVRHhP1TMnCfGmJFZWpRblxxeV5qQWH2I0BYb2RGYp
        0eR8YJbJK4k3NLE0MDEzMzOxNDYzVBLnPZ2+IVFIID2xJDU7NbUgtQimj4mDU6qBKaLItIyD
        dY2ocdC0txtmLZ7oXiZ7XfuJ8aXX3hv6tT/+/hq3r+TB4cLLu548OHv5uUzeqqj+nFnXtGo4
        l508VbPxvvTatX6lp78t8bwWtMbpepT3vBV/l/IH7v3iZyS1OPfOHuE983Mypt74dHj/j0tv
        L53+bqXcqvBo7vuK5tXb72exL0yb+vcz7x2Zq16JKhUmc134Tn83SgxQauKb1d3VFukUd+rw
        78iImmAN96MupUHnVnk4zd9zssW8SiElr08rZXbQl9UP7JKjJ906uTDmBkN0PlOJ9k9nL57/
        uftj3G4KHdVJ33Do6fMLa6SyX/y8z/oyeFnV2t4QVT7VI/v8GtwWGGxuK9HYyHC6sFOJpTgj
        0VCLuag4EQDAO3ZkegQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWy7bCSnO6EPpYkg1v3LCx6z51ksvi/bSKz
        xfwj51gtrnx9z2Yx6f4EFosX9y6yWFx42sNmsfHtDyaLs01v2C02Pb7GanF51xw2iwmrvrFY
        zDi/j8li7ZG77Bate4+wW7Q/fclssWDjI0aLGZNfslnsvHOC2UHYY1ZDL5vH3m8LWDw2repk
        89j+7QGrx/3u40wem5fUe/RtWcXocfzGdiaPz5vkAjijuGxSUnMyy1KL9O0SuDImnL7EVvCH
        v+Lv54PsDYzfeLsYOTgkBEwk+k+5dzFycQgJ7GCUuHOnjaWLkRMoLi1xfeMEdghbWGLlv+fs
        EEXPGSW6781gBEmwCehK7FjcxgaSEBGYySqxYPs0sG5mgQZGiR1/1CE6rjJKHNi/BmwUp4CH
        xOm/XWwgtrBAkMSPkx1gk1gEVCVaf3xgArF5BSwlnm9eCmULSpyc+YQF5FRmAT2Jto2MEPPl
        Jba/ncMMcZ2CxM+ny1hBbBEBJ4ndJ+ezQtSIS7w8eoR9AqPwLCSTZiFMmoVk0iwkHQsYWVYx
        SqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgTHupbWDsY9qz7oHWJk4mA8xCjBwawkwnuq
        njlJiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBibbFaKe
        fmFXD0ZzfmizmPdKPaaAb4LrYuNSt+I/C6Ov8+QvK1sZdeOD0eP/VkEMcbUZXLcXTHmRVuSd
        pJW2OjMp9JHWH+8fe6pK5tR+4/pfyiG+0bpE2WvK1KeeGeW/epv0suYGTz8eZX1sL3ecdv4E
        9ikzMw2POhcqXlp196C/IZfVkdP7LabMj1nk9mhq+NQuvvZvu1kuVX7qnMS85v7Lghqb54cO
        Pf9qMevcqX1f912LvP+andPxs1f59WeqSeVT3pxIvTKXU9ImPWDXgQuHt+6/pvxns9Y2d7fd
        /RIFwmeffe+XWLjwxPyIxvvTnV+teKumbjz52uvbC8sdune5Hd1y+Iouq7B3PP82p+hmJZbi
        jERDLeai4kQA3gf9IGQDAAA=
X-CMS-MailID: 20220210040328epcas5p233a2f8ef33593694404334f11c6dde34
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220208171919epcas5p34f600badf08124d3c86c91fcb4065d11
References: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com>
        <CGME20220208171919epcas5p34f600badf08124d3c86c91fcb4065d11@epcas5p3.samsung.com>
        <20220208171823.226211-3-krzysztof.kozlowski@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>-----Original Message-----
>From: Krzysztof Kozlowski [mailto:krzysztof.kozlowski@canonical.com]
>Sent: Tuesday, February 8, 2022 10:48 PM
>To: Inki Dae <inki.dae@samsung.com>; Joonyoung Shim
><jy0922.shim@samsung.com>; Seung-Woo Kim
><sw0312.kim@samsung.com>; Kyungmin Park
><kyungmin.park@samsung.com>; David Airlie <airlied@linux.ie>; Daniel
>Vetter <daniel@ffwll.ch>; Rob Herring <robh+dt@kernel.org>; Krzysztof
>Kozlowski <krzysztof.kozlowski@canonical.com>; Alim Akhtar
><alim.akhtar@samsung.com>; Kishon Vijay Abraham I <kishon@ti.com>;
>Vinod Koul <vkoul@kernel.org>; dri-devel@lists.freedesktop.org;
>devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>phy@lists.infradead.org
>Cc: Marek Szyprowski <m.szyprowski@samsung.com>; Sylwester Nawrocki
><snawrocki@kernel.org>; stable@vger.kernel.org
>Subject: [PATCH 02/10] ARM: dts: exynos: add missing HDMI supplies on
>SMDK5420
>
>Add required VDD supplies to HDMI block on SMDK5420.  Without them, the
>HDMI driver won't probe.  Because of lack of schematics, use same supplies
as
>on Arndale Octa and Odroid XU3 boards (voltage matches).
>
>Cc: <stable@vger.kernel.org> # v3.15+
>Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>---
> arch/arm/boot/dts/exynos5420-smdk5420.dts | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts
>b/arch/arm/boot/dts/exynos5420-smdk5420.dts
>index 2978b5775a6d..4d7b6d9008a7 100644
>--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
>+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
>@@ -124,6 +124,9 @@ &hdmi {
> 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&hdmi_hpd_irq>;
>+	vdd-supply = <&ldo6_reg>;
>+	vdd_osc-supply = <&ldo7_reg>;
>+	vdd_pll-supply = <&ldo6_reg>;
> };


Same supply found on smdk5420 as well.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>
> &hsi2c_4 {
>--
>2.32.0


