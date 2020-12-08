Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FA12D237A
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 07:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLHGPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 01:15:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24809 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgLHGPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 01:15:14 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201208061431epoutp01342e431224abd870f936080010e97ab6~OqR-kWgJU3163031630epoutp01l
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 06:14:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201208061431epoutp01342e431224abd870f936080010e97ab6~OqR-kWgJU3163031630epoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607408071;
        bh=RCI9kK2tJsruhg/x5Ng5MDmJmukKeeFlhWN0LjRmvvk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=CmcIsZop933nwm3GTUY3FUZnnBMzZvE6mCXSOh8mKbrrCgfvgIR5Lqmnsk9zrhn75
         zrH3X2XXEW/zF7g9FYRcjRJiAC4Ojm1BVH3NeI01icBlSHDRxyjqkPg/pkhKDILLJm
         LShekHuLd18e8FvOAQ83VSWTsJrB8Y/D/MGikbcw=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20201208061430epcas5p3896d33a10f201e81948e5a8971a15be4~OqR_8UogK3065330653epcas5p3T;
        Tue,  8 Dec 2020 06:14:30 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.9B.33964.6C91FCF5; Tue,  8 Dec 2020 15:14:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20201208061430epcas5p15cc5daed530a7f19846cca5743b2d738~OqR_P9W1E0329403294epcas5p10;
        Tue,  8 Dec 2020 06:14:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201208061430epsmtrp14b4084431e167c58693e8235d2812185~OqR_PGW1s0778207782epsmtrp11;
        Tue,  8 Dec 2020 06:14:30 +0000 (GMT)
X-AuditID: b6c32a4b-ea1ff700000184ac-f6-5fcf19c69b74
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.D3.08745.5C91FCF5; Tue,  8 Dec 2020 15:14:29 +0900 (KST)
Received: from pankajdubey02 (unknown [107.122.12.6]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201208061427epsmtip1738da04f5a89b9598e7c7482f3692454~OqR71-aKz2198521985epsmtip1n;
        Tue,  8 Dec 2020 06:14:27 +0000 (GMT)
From:   "Pankaj Dubey" <pankaj.dubey@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc:     "'Sylwester Nawrocki'" <snawrocki@kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>, <stable@vger.kernel.org>
In-Reply-To: <20201207190517.262051-3-krzk@kernel.org>
Subject: RE: [PATCH v2 2/4] soc: samsung: exynos-asv: handle reading
 revision register error
Date:   Tue, 8 Dec 2020 11:44:26 +0530
Message-ID: <000801d6cd29$635534d0$29ff9e70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI3Sc44zrAFnNObXiIFTUqq/KcsYAFGGxnGAlj5SuepDsZbAA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7bCmhu4xyfPxBs9+a1k8mLeNzeLvpGPs
        FhtnrGe1uP7lOavF+fMb2C02Pb7GanF51xw2ixnn9zFZrD1yl92i/elLZosFGx8xOnB7/P41
        idFj06pONo/NS+o9+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+P6hNesBev5K3rn97E3MH7l
        6WLk4JAQMJHo7zfoYuTiEBLYzShxvvEwG4TziVHi44EmdgjnM6PEo+17gBxOsI7jJx6xQCR2
        MUrsXLwcynnFKHGgYwMLSBWbgL7EuR/zWEESIgLzGCU2HfoENotZYBuTxOwpx8FmcQqYSfzq
        +MgIYgsLxEls7PvPBGKzCKhIzHtwmQ3E5hWwlHh+6SeULShxcuYTsA3MAvIS29/OYYa4SUHi
        59NlrCC2iICTxPGrZ9khasQlXh49ArZYQmAth8SnyV2MEA0uEjNfbmKDsIUlXh3fAvWclMTL
        /jYoO1/ix+JJzBDNLYwSk4/PZYVI2EscuDKHBRR+zAKaEut36UMs45Po/f2ECRKsvBIdbUIQ
        1WoS35+fgbpTRuJh81ImCNtDomfTPMYJjIqzkLw2C8lrs5C8MAth2QJGllWMkqkFxbnpqcWm
        BcZ5qeV6xYm5xaV56XrJ+bmbGMEpS8t7B+OjBx/0DjEycTAeYpTgYFYS4VWTOhsvxJuSWFmV
        WpQfX1Sak1p8iFGag0VJnFfpx5k4IYH0xJLU7NTUgtQimCwTB6dUA5POLcGsyz/kV17Zfz6o
        4b207J3kFcpxT7de+nwiq+3cHCnLYyfMIw1e/rD9mvSTSfxxoHbDMrkqL2VzlZ7cwEz7+eY5
        s25Iyn5lX+3wTFJ8w4rZe/qdXws/0VE4xJ/muEnNTFV+m0bMmir7j+KbpO6GbjTWUFhoc/xj
        t3Lfx0Smv3XG/ZYpL1tNuP/E35QKaL74Mc+WKbJ4amfdt1BZhly+l89C1y0/EfMs+7SNyLrz
        LIc15BkOnXcomSJWs3raAs4TdmErQi8cM+Zi7f6wRjxoXeCzVvuWJfd8Pb9/0N6n92v23Pf3
        F1d++yfQ4drcf9YkPfDBgZNen+aWSWZMcP3722JmhlFRa1Px42fR95VYijMSDbWYi4oTAQOs
        AC7IAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSnO5RyfPxBtP6zC0ezNvGZvF30jF2
        i40z1rNaXP/ynNXi/PkN7BabHl9jtbi8aw6bxYzz+5gs1h65y27R/vQls8WCjY8YHbg9fv+a
        xOixaVUnm8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlXF9wmvWgvX8Fb3z+9gbGL/y
        dDFyckgImEgcP/GIpYuRi0NIYAejxOppu9ghEjISk1evYIWwhSVW/nsOFhcSeMEosX+6EIjN
        JqAvce7HPLAaEYEFjBLbf4aD2MwCu5gkZk/3gxi6kVHiQ+NasCJOATOJXx0fGUFsYYEYiYV9
        35lAbBYBFYl5Dy6zgdi8ApYSzy/9hLIFJU7OfAJ0HQfQUD2Jto2MEPPlJba/ncMMcZuCxM+n
        y6BucJI4fvUsO0SNuMTLo0fYJzAKz0IyaRbCpFlIJs1C0rGAkWUVo2RqQXFuem6xYYFRXmq5
        XnFibnFpXrpecn7uJkZwxGlp7WDcs+qD3iFGJg7GQ4wSHMxKIrxqUmfjhXhTEiurUovy44tK
        c1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamCaxRtoN23TRSl+9Zn24dvszjoq
        xRs9nuBhoVegvuTA7ozqSc/LtQUjNrOuWs19MWTWlOagyD88V1sKMrdknV0XNn1q96QPdzMC
        QqJkZvPlKzfP4rKbYdl4bbvIjeonNVx/mp3Nsx41s0VL8cccO8S15vCSzrQrh6bfMFs1x2st
        u2/+sylR3O1SJeWyxfxK/r94J4ezVk/uvafWJ2x+8mfciedSFX+uxtQHTNkiy3G3pcDzhtLu
        5rak/T1JT9ezFfIG7U4I4w1k4nnRc2hzd890tz7HEwtmfbjUbmbNtj2TV7guY8mVSxmdUc1R
        rvZ7s1epMVxXmpx1XyY6l/94ZbzHjnmhFxPEF5v9WbV/thJLcUaioRZzUXEiALkjbaMnAwAA
X-CMS-MailID: 20201208061430epcas5p15cc5daed530a7f19846cca5743b2d738
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20201207190540epcas5p34b9ceff8ee297536443a5fc65a7c49bc
References: <20201207190517.262051-1-krzk@kernel.org>
        <CGME20201207190540epcas5p34b9ceff8ee297536443a5fc65a7c49bc@epcas5p3.samsung.com>
        <20201207190517.262051-3-krzk@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski <krzk@kernel.org>
> Sent: Tuesday, December 8, 2020 12:35 AM
> To: Krzysztof Kozlowski <krzk@kernel.org>; linux-arm-
> kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Sylwester Nawrocki <snawrocki@kernel.org>; Marek Szyprowski
> <m.szyprowski@samsung.com>; Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com>; Arnd Bergmann <arnd@arndb.de>; Chanwoo
> Choi <cw00.choi@samsung.com>; Alim Akhtar <alim.akhtar@samsung.com>;
> Pankaj Dubey <pankaj.dubey@samsung.com>; stable@vger.kernel.org
> Subject: [PATCH v2 2/4] soc: samsung: exynos-asv: handle reading revision
> register error
> 
> If regmap_read() fails, the product_id local variable will contain random
value
> from the stack.  Do not try to parse such value and fail the ASV driver
probe.
> 
> Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage
> driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/soc/samsung/exynos-asv.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/samsung/exynos-asv.c
> b/drivers/soc/samsung/exynos-asv.c
> index f653e3533f0f..5daeadc36382 100644
> --- a/drivers/soc/samsung/exynos-asv.c
> +++ b/drivers/soc/samsung/exynos-asv.c
> @@ -129,7 +129,13 @@ static int exynos_asv_probe(struct platform_device
> *pdev)
>  		return PTR_ERR(asv->chipid_regmap);
>  	}
> 
> -	regmap_read(asv->chipid_regmap, EXYNOS_CHIPID_REG_PRO_ID,
> &product_id);
> +	ret = regmap_read(asv->chipid_regmap,
> EXYNOS_CHIPID_REG_PRO_ID,
> +			  &product_id);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Cannot read revision from
> ChipID: %d\n",
> +			ret);
> +		return -ENODEV;
> +	}
> 
>  	switch (product_id & EXYNOS_MASK) {
>  	case 0xE5422000:
> --
> 2.25.1

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

