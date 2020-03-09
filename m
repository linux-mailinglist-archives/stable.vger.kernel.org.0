Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37BB17DB41
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 09:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCIIkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 04:40:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34263 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgCIIkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 04:40:35 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200309084033euoutp016c4b89fc04ba83dfd438b659acc4b44e~6lhRylwsA1936419364euoutp01u
        for <stable@vger.kernel.org>; Mon,  9 Mar 2020 08:40:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200309084033euoutp016c4b89fc04ba83dfd438b659acc4b44e~6lhRylwsA1936419364euoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583743233;
        bh=NGg3GV4wcJ669e6wjVEE564nwN09ctwPFgrI9ZV8yyE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CxWtsmQPu9ntXhxQS25QJ2cugGopEu9SsHUlX0JDGvqj9p8TsN4mGusIOkYCMCc50
         11597v15hnuLrF7FwJ8wEOFkJiKFdSMdSnKBemoEq0XZ1G62BcfF1QtU/4lioNk5S3
         g9mdpPhIaCheo7Io6UYZ2Gvoz8S5WMejlUpg4Klk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200309084033eucas1p1940610d27375f391fb1db13a02e8a1ba~6lhRnPdsR1711217112eucas1p1Z;
        Mon,  9 Mar 2020 08:40:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id A5.D1.60698.101066E5; Mon,  9
        Mar 2020 08:40:33 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200309084032eucas1p24c1602c831e38195b9f939c3f343607c~6lhRFBkmH2702927029eucas1p2B;
        Mon,  9 Mar 2020 08:40:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200309084032eusmtrp1f84aa979348266420d702d9fef809c73~6lhRDu_gL2157121571eusmtrp1E;
        Mon,  9 Mar 2020 08:40:32 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-b5-5e6601014b38
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 41.F9.08375.001066E5; Mon,  9
        Mar 2020 08:40:32 +0000 (GMT)
Received: from [106.120.51.74] (unknown [106.120.51.74]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200309084032eusmtip20aa3b7f1792aaeef80aa9f24847f1668~6lhQutZ4Y0673306733eusmtip2P;
        Mon,  9 Mar 2020 08:40:32 +0000 (GMT)
Subject: Re: [PATCH] ARM: dts: exynos: Fix polarity of the LCD SPI bus on
 UniversalC210 board
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
From:   Andrzej Hajda <a.hajda@samsung.com>
Message-ID: <39ad90c3-0ad1-ad7f-5002-52eb2440dd38@samsung.com>
Date:   Mon, 9 Mar 2020 09:40:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304143726.15826-1-m.szyprowski@samsung.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsWy7djP87qMjGlxBn3POS02zljPanH+/AZ2
        ixnn9zFZrD1yl91iwcZHjA6sHptWdbJ59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8ai9ifM
        Bde5K56ua2JtYNzK2cXIySEhYCLx/NwMVhBbSGAFo8TN9UxdjFxA9hdGieam9+wQzmdGifvX
        2tlhOm6sbWOGSCxnlNh86iyU85ZR4vXuU2wgVcIC8RJvF20G6xARCJG4//QF2A5mgUqJ6dum
        soDYbAKaEn833wSr5xWwk5jYuJ0JxGYRUJH4cugkM4gtKhAhMW37P0aIGkGJkzOfgPVyAtW/
        eXeNHWKmvETz1tnMELa4xK0n88F+kBCYzC4xa+8+FoizXSR+321jgrCFJV4d3wL1jozE6ck9
        UDX1EvdXtDBDNHcwSmzdsJMZImEtcefcL6BLOYA2aEqs36UPEXaU+HK7mRkkLCHAJ3HjrSDE
        DXwSk7ZNhwrzSnS0CUFUK0rcP7sVaqC4xNILX9kmMCrNQvLZLCTfzELyzSyEvQsYWVYxiqeW
        FuempxYb56WW6xUn5haX5qXrJefnbmIEppbT/45/3cG470/SIUYBDkYlHt4H8qlxQqyJZcWV
        uYcYJTiYlUR4G7WS44R4UxIrq1KL8uOLSnNSiw8xSnOwKInzGi96GSskkJ5YkpqdmlqQWgST
        ZeLglGpgnNX9JP7kgneb3qo8v/os8fuTVvvE7t+foy2n/zmQwavjevqZ1aqmvg+h104VVvAk
        LxFZqXIutH+BYTjDc7cnU/JOGMqJFgedif/duXffFzdDWRZBgw3bZ7lcCDyh0dQnnbNvT+n2
        qB/O7/b4LTjqGnTrsHuRgqf9GQnDdjbZFYv4XgWf15cVU2Ipzkg01GIuKk4EAE3nSJIpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t/xe7oMjGlxBmeva1lsnLGe1eL8+Q3s
        FjPO72OyWHvkLrvFgo2PGB1YPTat6mTz6NuyitHj8ya5AOYoPZui/NKSVIWM/OISW6VoQwsj
        PUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYxF7U+YC65zVzxd18TawLiVs4uRk0NC
        wETixto25i5GLg4hgaWMEgsPLGGDSIhL7J7/lhnCFpb4c62LDaLoNaPEq1drmUASwgLxEm8X
        bWbvYuTgEBEIkVj4Xg8kzCxQKbF+ykQmiPqJjBI9U5vAhrIJaEr83XwTzOYVsJOY2LgdbA6L
        gIrEl0MnwZaJCkRIPJ7YzghRIyhxcuYTFhCbE6j+zbtr7BAL1CX+zLvEDGHLSzRvnQ1li0vc
        ejKfaQKj0Cwk7bOQtMxC0jILScsCRpZVjCKppcW56bnFhnrFibnFpXnpesn5uZsYgdG07djP
        zTsYL20MPsQowMGoxMP7QD41Tog1say4MvcQowQHs5IIb6NWcpwQb0piZVVqUX58UWlOavEh
        RlOg5yYyS4km5wMjPa8k3tDU0NzC0tDc2NzYzEJJnLdD4GCMkEB6YklqdmpqQWoRTB8TB6dU
        A+NE1hcrfl5OUJj4coXCy37dppMxtlqvz3Gxd25+ekPnygLL1+ZPMnw19zzcbODyh60jzevE
        +Ui9pNeMXtcr5vJoWSaqeX6XKV7Zmrckpim59EaahFH+vRlszZsilvWr/bVdVXCsXrI1a4Il
        e0zLosBDrwymRH498WdydqNx8sOkhzrtSyM/symxFGckGmoxFxUnAgC4fvEUvAIAAA==
X-CMS-MailID: 20200309084032eucas1p24c1602c831e38195b9f939c3f343607c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6
References: <CGME20200304143756eucas1p1557bba245d3b9878cd2adc970e6d58f6@eucas1p1.samsung.com>
        <20200304143726.15826-1-m.szyprowski@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.03.2020 15:37, Marek Szyprowski wrote:
> Recent changes in the SPI core and the SPI-GPIO driver revealed that the
> GPIO lines for the LD9040 LCD controller on the UniversalC210 board are
> defined incorrectly. Fix the polarity for those lines to match the old
> behavior and hardware requirements to fix LCD panel operation with
> recent kernels.
>
> CC: stable@vger.kernel.org # 5.0+
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>


 --
Regards
Andrzej

> ---
>  arch/arm/boot/dts/exynos4210-universal_c210.dts | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos4210-universal_c210.dts b/arch/arm/boot/dts/exynos4210-universal_c210.dts
> index a1bdf7830a87..9dda6bdb9253 100644
> --- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
> +++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
> @@ -115,7 +115,7 @@
>  		gpio-sck = <&gpy3 1 GPIO_ACTIVE_HIGH>;
>  		gpio-mosi = <&gpy3 3 GPIO_ACTIVE_HIGH>;
>  		num-chipselects = <1>;
> -		cs-gpios = <&gpy4 3 GPIO_ACTIVE_HIGH>;
> +		cs-gpios = <&gpy4 3 GPIO_ACTIVE_LOW>;
>  
>  		lcd@0 {
>  			compatible = "samsung,ld9040";
> @@ -124,8 +124,6 @@
>  			vci-supply = <&ldo17_reg>;
>  			reset-gpios = <&gpy4 5 GPIO_ACTIVE_HIGH>;
>  			spi-max-frequency = <1200000>;
> -			spi-cpol;
> -			spi-cpha;
>  			power-on-delay = <10>;
>  			reset-delay = <10>;
>  			panel-width-mm = <90>;


