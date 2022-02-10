Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF34B03CA
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 04:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiBJDMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 22:12:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiBJDMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 22:12:05 -0500
X-Greylist: delayed 514 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 19:12:06 PST
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA47D1EADC
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 19:12:06 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220210030329epoutp03fd458509d2934009573c814a76d60166~STaquaJvS3071030710epoutp03g
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 03:03:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220210030329epoutp03fd458509d2934009573c814a76d60166~STaquaJvS3071030710epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644462209;
        bh=DH/9O9Z3dgVORgHIkvNXQao8lX5dwnmxxo735+xdAJ4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ov5Qqkg/FTScjjVPa5pXpZDNBRBw8QzfwgdDsAisd0Q3TE++P2/TSkzelzA/v1hzO
         3up+TgtnXBcvtJG1U3L3eRZ92ohhEZ3WblylwkXy4R2G9TPP5u833lrMNSn/pXccaU
         afB3/RtrvPco4cSPF3IplQOv/lAkDP4I0SbMXkq8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220210030328epcas5p1d655714fe4992ce9e9d394d5e88b971d~STaqUO3t61634516345epcas5p1Y;
        Thu, 10 Feb 2022 03:03:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4JvM5859gFz4x9Q0; Thu, 10 Feb
        2022 03:03:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.AD.46822.16F74026; Thu, 10 Feb 2022 11:58:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220210030323epcas5p4b0ab5b5e019e1357b9315d8930545c70~STalgV8DD0184701847epcas5p4Z;
        Thu, 10 Feb 2022 03:03:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220210030323epsmtrp2980841b1eaf0891b7c74ada517572882~STalfX-h82167621676epsmtrp2R;
        Thu, 10 Feb 2022 03:03:23 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-86-62047f614ce1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.45.29871.B7084026; Thu, 10 Feb 2022 12:03:23 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220210030321epsmtip1ba39a81695498362e6b20216d337b822~STai85god1858118581epsmtip1R;
        Thu, 10 Feb 2022 03:03:20 +0000 (GMT)
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
In-Reply-To: <20220208171823.226211-2-krzysztof.kozlowski@canonical.com>
Subject: RE: [PATCH 01/10] ARM: dts: exynos: add missing HDMI supplies on
 SMDK5250
Date:   Thu, 10 Feb 2022 08:33:18 +0530
Message-ID: <000001d81e2a$c37c90d0$4a75b270$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKO+pA4e/0lxhjrdKzLnJfOvLS5zwM3Y7bXAnFVvMKq8RoccA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxTVxzN7Xt9bc2qzwLhDjYHbyMGMz6KwC5TcAIhb+ucTJaNGRL2pG+l
        o7RNXxFmnIAIm2CFKonaMCTATOicH0BAcDSOFTtgc5IVYwzMQoFZAXVDUMIca3m48d+553fO
        Pb/f/RBjsj+IILFaa2QNWkZDEevwjh/DN0cwxfi+aPPcZmS60S9Ayx1mDJ213xAi5/xDAp24
        W4Oje78P4ejm5DECXZ59KkC/HJ4RoVb3LSH6rbuOQDXWBRyd/tUmQN/ZR0WovMcuQl9OejDU
        cHkcoNMnPQTqGvkJe8uPtpSYCLpnoQGnW61HCbpzwSWk71Y5BHRbczF9vN0KaMftTgE917op
        XbI3b3suyyhZQwirzdEp1VpVIqXIyE7JjouPlkfIE9AbVIiWyWcTqdR30yPS1BrvVFTIfkZT
        4KXSGY6jopK2G3QFRjYkV8cZEylWr9ToY/WRHJPPFWhVkVrW+KY8Ojomziv8JC93+kgTrh/d
        UDQzMI2VgBFpJZCIIRkLH1Y8wivBOrGMvArgz4MzgF/8BaDtwrCIXywAWNV3T/Dccuvb5tVC
        D4BPOuxCX0FGegAsvSr3YYKMgFeaKgifyJ+sEkLX9SbCV8DIQ3DE04D5sISkYZd52msWi/3I
        D2BPi8pH42QYHBywAh8tJRPgiak0Hy0lN8L+MxM4v8srsHO2DuP7CYGLk+dWWvAnk2H/WNlq
        UiD09NlX+oRktQRODSwRvCEVDrUt4jz2g/cd7SIeB8G5Bz2ELxeSefBY91aePgi/qb++Kt8B
        rznrcJ8EI8Phxe4oPmo9NC1NCHinFH5VIePVYbDswfCqMxiaq6qEPKahdfkaXgNCLWsGs6wZ
        zLJmAMv/YQ0At4IXWT2Xr2K5OH2Mli3877ZzdPmtYOXFb3nnChhzPYrsBQIx6AVQjFH+0oFi
        bJ9MqmQ+P8AadNmGAg3L9YI472GbsaCAHJ33y2iN2fLYhOjY+Pj42ISt8XIqUDqousTISBVj
        ZPNYVs8anvsEYklQieCLFzxjdyp2KBptBUNlw+q3Z7edJ5+VHD4763CaNzz+OuZmGDcjcX+2
        t6W2zXRcnJKRZLE5azQ/BFucH2eeedxeHZOZVFQ4yAbcydpZPuJGrvmu8qyY0W15benGLv1U
        1Ljj09q59zeaZUdKbMr7aZ1P9LUUnjGzO1SR0lgkaspW6Kcn+r/fHeCW/v3Pe+Ol9Ecdyvn6
        4cqipD7uVPihMdaQnvyau2sPdm6/bPZA5p7k0IlLVveEcFSEKxQZF1uOPnOtzwqCu56edDER
        jaT6z+o+Efyw7BRnK6xH2M5K08thic1LjtfVYQepikDnptI+46vndy3m2G9PBaReIJaDX6Jw
        LpeRb8EMHPMvUOFwhnoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWy7bCSnG51A0uSwbdj8ha9504yWfzfNpHZ
        Yv6Rc6wWV76+Z7OYdH8Ci8WLexdZLC487WGz2Pj2B5PF2aY37BabHl9jtbi8aw6bxYRV31gs
        Zpzfx2Sx9shddovWvUfYLdqfvmS2WLDxEaPFjMkv2Sx23jnB7CDsMauhl81j77cFLB6bVnWy
        eWz/9oDV4373cSaPzUvqPfq2rGL0OH5jO5PH501yAZxRXDYpqTmZZalF+nYJXBmvWxazFNzl
        r3hz6jVzA+Md3i5GTg4JAROJa6uXsIPYQgK7GSWWdbhDxKUlrm+cwA5hC0us/PccyOYCqnnO
        KHH+7VawBJuArsSOxW1sIAkRgZmsEgu2T2MBSTALNDBK7PijDtFxlVHi8/pFrCAJTgEPiZ0T
        XwPZHBzCAkESE/aZgIRZBFQlTp9axQgS5hWwlJj0zA0kzCsgKHFy5hMWkDCzgJ5E20ZGiOny
        EtvfzmGGuE1B4ufTZWDDRQScJE4+bGaDqBGXeHn0CPsERuFZSCbNQpg0C8mkWUg6FjCyrGKU
        TC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI5zLc0djNtXfdA7xMjEwXiIUYKDWUmE91Q9
        c5IQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTKs5p2Qf
        i67jqQ+a1L5X/6Kt/A8T9+xb21Ssr5Z9mONTya2ktIl7pcje+0EsbnesiwrmzuNwaPDayKpZ
        HhIblp3wyOO63fTdf/h3H78mctmjpu+a5B6Lrq87vum/W8y+aIae2CRFKYm7L0OElbZxfL86
        nalzJqvlyxTPsKTM3xs2Jj99WxPPzfyBf5Jg4YaVW4TlF70VCuJdnCYf76S18byf2ediG36t
        +DufeYRnP48OEu1LfWVrfzv9xqv/2tbykhvqNLNucBy0ef3Qv1VE6ODFJ1+/HDUKdJo4Q3v1
        H1fRs6v+rFf02nnwoo4mt+5TieR+W8XZ/WEJ7jnxXryKMVHvp83RXDT33dHpzq0rlFiKMxIN
        tZiLihMBcwE9RGIDAAA=
X-CMS-MailID: 20220210030323epcas5p4b0ab5b5e019e1357b9315d8930545c70
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220208171919epcas5p16d7ac6985aff7887acc40ab759bcc155
References: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com>
        <CGME20220208171919epcas5p16d7ac6985aff7887acc40ab759bcc155@epcas5p1.samsung.com>
        <20220208171823.226211-2-krzysztof.kozlowski@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
>Subject: [PATCH 01/10] ARM: dts: exynos: add missing HDMI supplies on
>SMDK5250
>
>Add required VDD supplies to HDMI block on SMDK5250.  Without them, the
>HDMI driver won't probe.  Because of lack of schematics, use same supplies
as
>on Arndale 5250 board (voltage matches).
>
>Cc: <stable@vger.kernel.org> # v3.15+
>Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>---
> arch/arm/boot/dts/exynos5250-smdk5250.dts | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>index 65d2474f83eb..21fbbf3d8684 100644
>--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
>+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
>@@ -118,6 +118,9 @@ &hdmi {
> 	status = "okay";
> 	ddc = <&i2c_2>;
> 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
>+	vdd-supply = <&ldo8_reg>;
>+	vdd_osc-supply = <&ldo10_reg>;
>+	vdd_pll-supply = <&ldo8_reg>;
> };

Cross checked with SMDK schematic, looks correct.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>
> &i2c_0 {
>--
>2.32.0


