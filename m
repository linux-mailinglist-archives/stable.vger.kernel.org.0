Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46780B0EC2
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 14:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfILMTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 08:19:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24802 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbfILMTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 08:19:18 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190912121916epoutp01e5d7dd7f2a3562cc60780f3e2ee627d6~DsCIygYts1832118321epoutp01a
        for <stable@vger.kernel.org>; Thu, 12 Sep 2019 12:19:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190912121916epoutp01e5d7dd7f2a3562cc60780f3e2ee627d6~DsCIygYts1832118321epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1568290756;
        bh=PzTe36grY6sw2UW4Pv0TfJk8OfKRzsyqw53J3AvyFYU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=SZEeMrCRTj2BN3Cf+c42A2uJ2PM28HSXDVi+kGfQnobNuHCBwM6l/3w5pqZKc8Nfn
         /YzSY/aqTgOyNxu54DBT2NtM8rRU86dfjupGFmD4SLqtZbL5mLXyT1vDK8yBx74kuZ
         EPa2Of03oW/2oRuRpLxumRFTE84P1CAeodHzGz10=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20190912121915epcas5p4ddbcbd2d9ef766d6b3d1e81012c4f1de~DsCH9P9aV0804308043epcas5p4y;
        Thu, 12 Sep 2019 12:19:15 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AF.98.04150.3C73A7D5; Thu, 12 Sep 2019 21:19:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20190912121914epcas5p3f4952e5a791470dccf8e15442a65f8e0~DsCHYNsp81220412204epcas5p3f;
        Thu, 12 Sep 2019 12:19:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190912121914epsmtrp2cf02f8836306f78d5db94b499c2707e8~DsCHXbUXb1986919869epsmtrp22;
        Thu, 12 Sep 2019 12:19:14 +0000 (GMT)
X-AuditID: b6c32a49-a5bff70000001036-e2-5d7a37c3daad
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.1F.03638.2C73A7D5; Thu, 12 Sep 2019 21:19:14 +0900 (KST)
Received: from [107.108.73.28] (unknown [107.108.73.28]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190912121913epsmtip19d14299ca1abc31d156511fab4232091~DsCGjiozQ2617226172epsmtip1j;
        Thu, 12 Sep 2019 12:19:13 +0000 (GMT)
Subject: Re: [PATCH] arm64: dts: exynos: Revert
 "Remove unneeded address space mapping for soc node"
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
From:   Alim Akhtar <alim.akhtar@samsung.com>
Message-ID: <28550827-0ada-6f7a-dfee-a9aa3f8fd976@samsung.com>
Date:   Thu, 12 Sep 2019 17:26:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912073602.22829-1-m.szyprowski@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsWy7bCmhu5h86pYg823+Sw2zljPanH+/AZ2
        ixnn9zFZrD1yl91iwcZHjA6sHptWdbJ59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bW+duY
        Cu5KVfT9O87UwDhDtIuRk0NCwETi0+GrbF2MXBxCArsZJRraGqCcT4wSL9c2MEI43xglOiat
        YYJpWbmlmR0isZdR4nXzDxYI5y2jxPnGE2wgVcICaRLz364E6xARCJG4//QFK4jNLFApMX3b
        VBYQm01AW+Lu9C1gNbwCdhJLPu5iB7FZBFQl3m98xgxiiwpESHx6cJgVokZQ4uTMJ2C9nED1
        Db9a2SBmikvcejKfCcKWl9j+dg4zyEESAkfYJHZ272aDONtF4s+UiywQtrDEq+Nb2CFsKYnP
        7/YC1XAA2dkSPbuMIcI1EkvnHYMqt5c4cGUOC0gJs4CmxPpd+hCr+CR6fz9hgujklehoE4Ko
        VpVofncVqlNaYmJ3NyuE7SFx+dZcZkhQTWSUmHBkFtMERoVZSD6bheSbWUi+mYWweQEjyypG
        ydSC4tz01GLTAsO81HK94sTc4tK8dL3k/NxNjOAEo+W5g3HWOZ9DjAIcjEo8vBY6VbFCrIll
        xZW5hxglOJiVRHh93lTGCvGmJFZWpRblxxeV5qQWH2KU5mBREuedxHo1RkggPbEkNTs1tSC1
        CCbLxMEp1cB4kCNmulOFd5Wyr0WbCaNo/EMp6bZDL19NbZjawrkhMMD3jEJHjpcN44bfHL8P
        RZXOv5Ckc1knaXHy500mlzdPjZuW+mRv4AwZEZ5t0hdchczMLNSPCBrJbtC5v3ndBDnGRdP5
        HX/4OHte6pOOMJnz+dnFxTNjH63RPLLHoL5oC3fs5omSh9qVWIozEg21mIuKEwHciVqKLAMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWy7bCSnO4h86pYg19tahYbZ6xntTh/fgO7
        xYzz+5gs1h65y26xYOMjRgdWj02rOtk8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Pr/G1M
        BXelKvr+HWdqYJwh2sXIySEhYCKxckszexcjF4eQwG5GiVnbprJCJKQlrm+cwA5hC0us/Pcc
        qug1o8TLndOZuxg5OIQF0iS2dOeBmCICIRIL3+uBlDMLVEqsnzKRCaJ8IqNE0+5jbCAJNgFt
        ibvTtzCB2LwCdhJLPu4Cm88ioCrxfuMzZhBbVCBC4vCOWYwQNYISJ2c+YQGxOYHqG361skEs
        MJOYt/khM4QtLnHryXwmCFteYvvbOcwTGIVmIWmfhaRlFpKWWUhaFjCyrGKUTC0ozk3PLTYs
        MMpLLdcrTswtLs1L10vOz93ECI4GLa0djCdOxB9iFOBgVOLhfaBZFSvEmlhWXJl7iFGCg1lJ
        hNfnTWWsEG9KYmVValF+fFFpTmrxIUZpDhYlcV75/GORQgLpiSWp2ampBalFMFkmDk6pBsb8
        3fzFf+s8ihSOPpv0d/+TmBTlA76+/nO8ozSuf0npWPzMtUGwR336K6cvXNvqin/IOwWeWv/z
        Y9XvvRF7nUy6pVKyM43OTJ3WnerxWFL3vR6rx76DrS0LF89+9HYl40fZ+fMdGiqDVI4dLX/J
        mvn7+ZqSSsOolKOrND8XsR8rfRj/uSD8xBYlluKMREMt5qLiRACDd5CIggIAAA==
X-CMS-MailID: 20190912121914epcas5p3f4952e5a791470dccf8e15442a65f8e0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3
References: <CGME20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3@eucas1p1.samsung.com>
        <20190912073602.22829-1-m.szyprowski@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marek,

On 9/12/19 1:06 PM, Marek Szyprowski wrote:
> Commit ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space
> mapping for soc node") changed the address and size cells in root node from
> 2 to 1, but /memory nodes for the affected boards were not updated. This
> went unnoticed on Exynos5433-based TM2(e) boards, because they use u-boot,
> which updates /memory node to the correct values. On the other hand, the
> mentioned commit broke boot on Exynos7-based Espresso board, which
> bootloader doesn't touch /memory node at all.
> 
> This patch reverts commit ef72171b3621, so Exynos5433 and Exynos7 SoCs
> again matches other ARM64 platforms with 64bit mappings in root node.
> 
> Reported-by: Alim Akhtar <alim.akhtar@samsung.com>
> Fixes: ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space mapping for soc node")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
> A few more comments:
> 
> 1. I've added 'tested-by' tag from Alim, as his original report pointed
> that reverting the offending commit fixes the boot issue.
> 
This is still valid,reverting the offending commit does work.
Thanks!

> 2. This patch applies down to v4.18.
> 
> 3. For v5.3 release, two patches:
>     - "arm64: dts: exynos: Move GPU under /soc node for  Exynos5433"
>     - "arm64: dts: exynos: Move GPU under /soc node for Exynos7"
>     has to be applied first to ensure that GPU node will have correct 'reg'
>     property (nodes under /soc still use 32bit mappings). I'm not sure if
>     this can be expressed somehow in stable porting tags.
> 
> Best regards
> Marek Szyprowski
> Samsung R&D Institute Poland
> ---
>   arch/arm64/boot/dts/exynos/exynos5433.dtsi | 6 +++---
>   arch/arm64/boot/dts/exynos/exynos7.dtsi    | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> index 239bf44d174b..f69530730219 100644
> --- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> @@ -18,8 +18,8 @@
>   
>   / {
>   	compatible = "samsung,exynos5433";
> -	#address-cells = <1>;
> -	#size-cells = <1>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
>   
>   	interrupt-parent = <&gic>;
>   
> @@ -260,7 +260,7 @@
>   		compatible = "simple-bus";
>   		#address-cells = <1>;
>   		#size-cells = <1>;
> -		ranges;
> +		ranges = <0x0 0x0 0x0 0x18000000>;
>   
>   		chipid@10000000 {
>   			compatible = "samsung,exynos4210-chipid";
> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> index f09800f355db..3a00ef0a17ff 100644
> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> @@ -12,8 +12,8 @@
>   / {
>   	compatible = "samsung,exynos7";
>   	interrupt-parent = <&gic>;
> -	#address-cells = <1>;
> -	#size-cells = <1>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
>   
>   	aliases {
>   		pinctrl0 = &pinctrl_alive;
> @@ -87,7 +87,7 @@
>   		compatible = "simple-bus";
>   		#address-cells = <1>;
>   		#size-cells = <1>;
> -		ranges;
> +		ranges = <0 0 0 0x18000000>;
>   
>   		chipid@10000000 {
>   			compatible = "samsung,exynos4210-chipid";
> 
