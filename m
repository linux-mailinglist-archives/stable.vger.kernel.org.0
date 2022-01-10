Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481EE48A2A3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345359AbiAJWVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 17:21:01 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11510 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345353AbiAJWUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 17:20:55 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220110222051euoutp0214280976dec38ea2570f5223e1f6bee9~JCNVj5YDu1328513285euoutp02b
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 22:20:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220110222051euoutp0214280976dec38ea2570f5223e1f6bee9~JCNVj5YDu1328513285euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1641853251;
        bh=/IRh7Q8Tobr/1gd0FTSr7IuMEb+csGS0lGb/PbjOwe8=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=FDI+ljXck00lvkPLVZKo1oeKi1KYO7btzb0vdSNMiN7m/2OtHtCgLsVBe3cvbXJLK
         yjQEZC3WywbaXoSYoP85wHZHH9ChG8VJERwvlnnsLT9QMugdutoccUKeWfCZz96Vak
         vKNziRQ3YvRbCqgHiD4VOBUMpZtqz0lVnmc8ZTfw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220110222050eucas1p2ae3ed9c889e9469b7eecc7bb69da2569~JCNU1atOF0164601646eucas1p23;
        Mon, 10 Jan 2022 22:20:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D6.76.10260.341BCD16; Mon, 10
        Jan 2022 22:20:51 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220110222050eucas1p198aa252ee3102ef40a0199f99f12cdf7~JCNUSc5dD0726807268eucas1p1R;
        Mon, 10 Jan 2022 22:20:50 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220110222050eusmtrp2c113ebac37e34a36c0a1793ba753d0fd~JCNURrawg0478304783eusmtrp2E;
        Mon, 10 Jan 2022 22:20:50 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-12-61dcb1439266
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D4.C5.09522.241BCD16; Mon, 10
        Jan 2022 22:20:50 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220110222049eusmtip29bd2d87820a124c739316508037ce937~JCNTtxxAr1752417524eusmtip26;
        Mon, 10 Jan 2022 22:20:49 +0000 (GMT)
Message-ID: <a0b84be2-55b5-64e7-d39a-c3cd3f46d443@samsung.com>
Date:   Mon, 10 Jan 2022 23:20:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [RFT][PATCH 1/3] ARM: dts: exynos: fix UART3 pins configuration
 in Exynos5250
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sylwester Nawrocki <snawrocki@kernel.org>, stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20211230195325.328220-1-krzysztof.kozlowski@canonical.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7djP87rOG+8kGmxuZbO4vF/bYv6Rc6wW
        N361sVpsfPuDyWLT42usFpd3zWGzmHF+H5PF8z4g0f70JbPFgo2PGB24PGY19LJ5bFrVyeZx
        59oeNo/NS+o9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK2PXys0sBUe5Kt5PXs3SwHiHo4uR
        k0NCwETi8JwNLF2MXBxCAisYJRZMbGeEcL4wShyb0sMMUiUk8JlRYulDcZiOu1++QXUsByrq
        38YK4XxklDiwrYsRpIpXwE7i/vLLYN0sAqoSh/e8Z4eIC0qcnPmEBcQWFUiSePjgF5gtLBAj
        0f6ymwnEZhYQl7j1ZD4TyFARgcNMEr/e3mSESLhKrNnUDTaUTcBQouttFxuIzSngIfH89h2o
        ZnmJ7W/nMIM0Swh84ZD4/b2ZFeJuF4mJR18yQtjCEq+Ob2GHsGUk/u+E2CYh0Mwo8fDcWnYI
        p4dR4nLTDKgOa4k7534BreMAWqEpsX6XPkTYUaLt4EWwsIQAn8SNt4IQR/BJTNo2nRkizCvR
        0SYEUa0mMev4Ori1By9cYp7AqDQLKVxmIfl/FpJ3ZiHsXcDIsopRPLW0ODc9tdg4L7Vcrzgx
        t7g0L10vOT93EyMwVZ3+d/zrDsYVrz7qHWJk4mA8xCjBwawkwrv3wq1EId6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUyTNpYF7c6awMriWn5mUfWzIzoh
        R4OaDx5+8My9fO8JhbZ9x/i8Vr3mvaCy4929xFM2bxVYxMS/MdhslI94mPj7n1m040FRjaP9
        8/bJHbZOFoqfm1XcF/Tlzf/wf9Lte/lm386okpiz9NOu3uPhR00qBKMkitvF8yLWPfJg3L22
        bG5ltGbgxWqucLtml32Hl7Xun8zVkah/ebbNM4et7fsjYmeUPWF3VUhKFO07xZu80iJH9X3H
        4S3ul6Kt9+YyszPlW2b1Tmjv/NolEPYgUNM01qfWawfvodL/Ab/S61uD95zbPH3r+cWmqsus
        rb5kHrPbuKyoeZddRPjnCoV3hfKfrl8zzQ/gM/y6af+Fj0osxRmJhlrMRcWJAIPb/S7EAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t/xe7pOG+8kGjy6LWdxeb+2xfwj51gt
        bvxqY7XY+PYHk8Wmx9dYLS7vmsNmMeP8PiaL531Aov3pS2aLBRsfMTpwecxq6GXz2LSqk83j
        zrU9bB6bl9R79G1ZxejxeZNcAFuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWR
        qZK+nU1Kak5mWWqRvl2CXsaulZtZCo5yVbyfvJqlgfEORxcjJ4eEgInE3S/fWLoYuTiEBJYy
        SjT8+skIkZCRODmtgRXCFpb4c62LDaLoPaPEp9Z7YAleATuJ+8svM4PYLAKqEof3vGeHiAtK
        nJz5BGgqB4eoQJLEhy1+IGFhgRiJ9pfdTCA2s4C4xK0n85lAZooIHGWSuHj8NzNEwlVizaZu
        Zohlsxkl3u/cDnYRm4ChRNdbkCs4OTgFPCSe374DNclMomtrFyOELS+x/e0c5gmMQrOQ3DEL
        ycJZSFpmIWlZwMiyilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzA2tx37uXkH47xXH/UOMTJx
        MB5ilOBgVhLh3XvhVqIQb0piZVVqUX58UWlOavEhRlNgYExklhJNzgcmh7ySeEMzA1NDEzNL
        A1NLM2MlcV7Pgo5EIYH0xJLU7NTUgtQimD4mDk6pBibJj5w2qySXeFxIkFJa+a7Sg0tuT56n
        tE17fd9PRbaHU0IfnDAwOjzPRLLTb12Zvb/7incs73feMuWbn/JFPcSgz9Swlmfuk11brz6u
        eVUs+f6Is8Q625DLMpYGmzfHFT5xaz59XOdwRcOd50knhZX8E0R+H3macOCktRe30L9gls/a
        q2K1/OeWtcjomEb7LdSM+rrLO028Mu7e3lDOlMmnHiw7Vvw6s2l5xrJjRsV8hy9Ux8pIWc6O
        ORVS/15ob9MHyXXbvDWmCKQo+E6cs+ekEo+NkYGFxctvi/dZGMW1Xcp77/tg298O/pzNJ2qO
        8Zrl71+y1seX5dH2f6LmJ25FhAodXJHObbZ8r+QTHiWW4oxEQy3mouJEAATwGXFWAwAA
X-CMS-MailID: 20220110222050eucas1p198aa252ee3102ef40a0199f99f12cdf7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211230195340eucas1p1ebbcf10a6b4fb15fca9b7757af5e1702
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211230195340eucas1p1ebbcf10a6b4fb15fca9b7757af5e1702
References: <CGME20211230195340eucas1p1ebbcf10a6b4fb15fca9b7757af5e1702@eucas1p1.samsung.com>
        <20211230195325.328220-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.12.2021 20:53, Krzysztof Kozlowski wrote:
> The gpa1-4 pin was put twice in UART3 pin configuration of Exynos5250,
> instead of proper pin gpa1-5.
>
> Fixes: f8bfe2b050f3 ("ARM: dts: add pin state information in client nodes for Exynos5 platforms")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Well, the uart3_data node is not referenced anywhere, so this change is 
not really relevant to any board, but for the completeness, feel free to 
add:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


> ---
>   arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> index d31a68672bfa..d7d756614edd 100644
> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> @@ -260,7 +260,7 @@ i2c3_hs_bus: i2c3-hs-bus {
>   	};
>   
>   	uart3_data: uart3-data {
> -		samsung,pins = "gpa1-4", "gpa1-4";
> +		samsung,pins = "gpa1-4", "gpa1-5";
>   		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
>   		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
>   		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

