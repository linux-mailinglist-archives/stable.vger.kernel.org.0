Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA72D2365
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 06:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgLHF53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 00:57:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35681 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgLHF53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 00:57:29 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201208055645epoutp03c01eee5834cc1e85063d6600e852e349~OqCfA5QIl0707307073epoutp03O
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 05:56:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201208055645epoutp03c01eee5834cc1e85063d6600e852e349~OqCfA5QIl0707307073epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607407005;
        bh=rsTbIIaLQR8rxKChGFAebQUI8U0NU4zTklX8KiGdDKo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=dzjDz/Z6NO2Qpcwx7D39nkrlpnQkFqEceXRLQjhgKemGRtc1eUyLswoBrDfQLHLQq
         n42XHIxcXl4/iabXiEHQwOKCmQ3Q1pjloTfwpLrwSasjv2UbhoeH8GRkrVBOyvhOVX
         VkEKir11wo8PKnE3Iqrr3U3ynIH55T8Ibr/8FqpQ=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20201208055644epcas5p21f63a4791903718c81d0896467ac4742~OqCeTLPG51547615476epcas5p28;
        Tue,  8 Dec 2020 05:56:44 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.5D.50652.C951FCF5; Tue,  8 Dec 2020 14:56:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20201208055644epcas5p1df3f99bc365eb99992f9f3f2dac6f359~OqCdyUXUg0827208272epcas5p1H;
        Tue,  8 Dec 2020 05:56:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201208055644epsmtrp1c4638dbbb03509ae6b574f8054cae4a1~OqCdxNgRY3137731377epsmtrp1K;
        Tue,  8 Dec 2020 05:56:44 +0000 (GMT)
X-AuditID: b6c32a4a-6c9ff7000000c5dc-a6-5fcf159c6e93
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.91.08745.C951FCF5; Tue,  8 Dec 2020 14:56:44 +0900 (KST)
Received: from pankajdubey02 (unknown [107.122.12.6]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201208055642epsmtip17c7980d6b1f36f1614c6a3d5c3934b52~OqCcKf0F41256012560epsmtip1r;
        Tue,  8 Dec 2020 05:56:42 +0000 (GMT)
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
In-Reply-To: <20201207190517.262051-2-krzk@kernel.org>
Subject: RE: [PATCH v2 1/4] soc: samsung: exynos-asv: don't defer early on
 not-supported SoCs
Date:   Tue, 8 Dec 2020 11:26:17 +0530
Message-ID: <000701d6cd26$e82ad1e0$b88075a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI3Sc44zrAFnNObXiIFTUqq/KcsYAIOJYs6AiA8chmpCkUPMA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7bCmpu4c0fPxBvcfGVk8mLeNzeLvpGPs
        FhtnrGe1uP7lOavF+fMb2C02Pb7GanF51xw2ixnn9zFZrD1yl92i/elLZosFGx8xOnB7/P41
        idFj06pONo/NS+o9+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+N00znWgh6hiim3frI3MLbz
        dzFyckgImEhcn7aXqYuRi0NIYDejxO/pz5ghnE+MEiv6j0NlPjNKLL/+nhmmZcm526wQiV2M
        Et9mz2aDcF4xSpz5/J8NpIpNQF/i3I95YFUiAvMYJTYd+sQO4jALbGOSmD3lODtIFaeAmcSx
        v78YQWxhgXiJpmVLWLoYOThYBFQk7jzKAgnzClhKfP3xnQnCFpQ4OfMJC4jNLCAvsf3tHKiT
        FCR+Pl3GCmKLCDhJXJi2ih2iRlzi5dEjYHslBLZwSEy/co4FosFFYve/CUwQtrDEq+Nb2CFs
        KYmX/W1Qdr7Ej8WTmCGaWxglJh+fywqRsJc4cGUO2KHMApoS63fpQyzjk+j9/YQJJCwhwCvR
        0SYEUa0m8f35Gag7ZSQeNi+FWushsW3ZSsYJjIqzkLw2C8lrs5C8MAth2QJGllWMkqkFxbnp
        qcWmBUZ5qeV6xYm5xaV56XrJ+bmbGMEpS8trB+PDBx/0DjEycTAeYpTgYFYS4VWTOhsvxJuS
        WFmVWpQfX1Sak1p8iFGag0VJnFfpx5k4IYH0xJLU7NTUgtQimCwTB6dUA1NfwersKAvbhDT/
        NWvL+9s/SvG7G5e9eua1JrKYZ99hL2tOg9ryp8/qmJ/yLDurfS0qyyuXxdnTK/DjqZTwaRFy
        G9pzl+Tu+Hzu2c7k66265zg7AydvLpc4c8StfoXPzRIbJ8fOXfMn7F9SlVQ00ySj3vT//3CL
        XeIzW3s+M4aduLOVp2bHl9SDP+Ysmshf1RGyp71EvjcuelvJ/WbXI9d2tcXuu3WF9ecO5SOn
        vVcdMLLvnr+EeYHZu5qpZg9/prLEcQb9uDDnShPr4R8exqeYy7Y2n1n8pkRvEU9vUtblLIGf
        5Uz8Yjv2T97T3bNTMCTtW5/HvaDXN9dGTe81vqDWff9SpfN10fsx8z63ySmxFGckGmoxFxUn
        AgAt87KmyAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSnO4c0fPxBucaBSwezNvGZvF30jF2
        i40z1rNaXP/ynNXi/PkN7BabHl9jtbi8aw6bxYzz+5gs1h65y27R/vQls8WCjY8YHbg9fv+a
        xOixaVUnm8fmJfUefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlXG66RxrQY9QxZRbP9kbGNv5
        uxg5OSQETCSWnLvNCmILCexglFi4qBgiLiMxefUKVghbWGLlv+fsXYxcQDUvGCWmz/3CApJg
        E9CXOPdjHliRiMACRontP8NBbGaBXUwSs6f7QTRsZJTYNf8lM0iCU8BM4tjfX4wgtrBArMTf
        aZuAbA4OFgEViTuPskDCvAKWEl9/fGeCsAUlTs58wgJSwiygJ9G2kRFivLzE9rdzmCFuU5D4
        +XQZ1AlOEhemrWKHqBGXeHn0CPsERuFZSCbNQpg0C8mkWUg6FjCyrGKUTC0ozk3PLTYsMMpL
        LdcrTswtLs1L10vOz93ECI43La0djHtWfdA7xMjEwXiIUYKDWUmEV03qbLwQb0piZVVqUX58
        UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTCfa6ueeLA713cop+Z3ZPvyi
        w4NCZoa131OWPEuU3jdVmslX5lnemRyeqKj4b4Ldt/f94sjbuUQzSJ4hJrCtcGmOUtamL8KK
        y/SeyK20/lqrWfng61HvwqY+9gmTbGMOpjAsFHO7cMK0cM6l65ezQjdFpzK4Vb+6Xfe4OXuD
        /434kDtC1i1ndjhVae+QMXHO/LiB79yOku8MGrt2l/mqRFxvMeMrXMnzQ3j+9rhtM3aeCn4U
        L3t9Q/E+1mXOOyZt+mfCFnK9hm3d1tP6p1U22HsyP52wcNbTG3nHJvypjn0epqC7UeuUU/GH
        +mPXd7U0J00Rsq2pzIpbMukR52wzF7dpEQzXn93fe05Bb+WLM0osxRmJhlrMRcWJAFw+iUQm
        AwAA
X-CMS-MailID: 20201208055644epcas5p1df3f99bc365eb99992f9f3f2dac6f359
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20201207190537epcas5p24ffb1c540a4491c9da4b74d37d2e706e
References: <20201207190517.262051-1-krzk@kernel.org>
        <CGME20201207190537epcas5p24ffb1c540a4491c9da4b74d37d2e706e@epcas5p2.samsung.com>
        <20201207190517.262051-2-krzk@kernel.org>
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
> Subject: [PATCH v2 1/4] soc: samsung: exynos-asv: don't defer early on
not-
> supported SoCs
> 
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Check if the SoC is really supported before gathering the needed
resources.
> This fixes endless deferred probe on some SoCs other than
> Exynos5422 (like Exynos5410).
> 
> Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage
> driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/soc/samsung/exynos-asv.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/soc/samsung/exynos-asv.c
> b/drivers/soc/samsung/exynos-asv.c
> index 8abf4dfaa5c5..f653e3533f0f 100644
> --- a/drivers/soc/samsung/exynos-asv.c
> +++ b/drivers/soc/samsung/exynos-asv.c
> @@ -119,11 +119,6 @@ static int exynos_asv_probe(struct platform_device
> *pdev)
>  	u32 product_id = 0;
>  	int ret, i;
> 
> -	cpu_dev = get_cpu_device(0);
> -	ret = dev_pm_opp_get_opp_count(cpu_dev);
> -	if (ret < 0)
> -		return -EPROBE_DEFER;
> -
>  	asv = devm_kzalloc(&pdev->dev, sizeof(*asv), GFP_KERNEL);
>  	if (!asv)
>  		return -ENOMEM;
> @@ -144,6 +139,11 @@ static int exynos_asv_probe(struct platform_device
> *pdev)
>  		return -ENODEV;
>  	}
> 
> +	cpu_dev = get_cpu_device(0);
> +	ret = dev_pm_opp_get_opp_count(cpu_dev);
> +	if (ret < 0)
> +		return -EPROBE_DEFER;
> +
>  	ret = of_property_read_u32(pdev->dev.of_node, "samsung,asv-
> bin",
>  				   &asv->of_bin);
>  	if (ret < 0)
> --
> 2.25.1

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

