Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3489E48696E
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 19:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbiAFSNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 13:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiAFSNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 13:13:42 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBADC061245;
        Thu,  6 Jan 2022 10:13:41 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id 19so4134684ioz.4;
        Thu, 06 Jan 2022 10:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEtJLoaA5iONOvnEVWtg5iP2Ussm1/FGTAkvl8oexE4=;
        b=DU+rXY8T5G10Gr4qPrA8xqxZOy3OkFDI5RIxobVhOj0lBBWQpL2HI/Mfjt1tvGc9LP
         U+1NePR+011SMkc/U3NJCZCscp/bkCkRRQQetZ78Y7Qycks2Si2+uDn7Nt3Bc00VsBUf
         svS/n/rJa1kvYx0KDyAilDYl8qSL+ZE44aVmB4T40m3+9BkkV2eazFqDKacPxQkH5RfQ
         l7Ug+5eMDF/84sr7U6+qabi2CqMr+twhuLitR7OlMHs4ogCzqZ8901VleubUayxML//J
         eGdd+NgMRCwQrHdZdGTVxIjlsEPoMZntjKncXXbG7tCRi8aBpYohgyEyw4uJ29trCxBS
         bqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEtJLoaA5iONOvnEVWtg5iP2Ussm1/FGTAkvl8oexE4=;
        b=NFa6mI0k7QqMpRFj4N9j453i7Cyrh0q8QjGgzblcfwmNzxc1PbcK1yPh2cmh64uAM2
         GbJ4Eop9Fwz5AtSeuXxJQ5foz+wT9IcSx+INDUnjRoAvejyTkO2y2y1qLfIbC7PdtiEb
         AH6pvO6eGAncfhO9BtUw9kFHI6Hg2KB4xuPmO3plrbz+LowPoz0j76LPlJz2YLXeVB/w
         6PN8uaCawuNJ38YRbqXKFFtQ+M1+W9cvpxyhTQo1K/kwIqPRrXgTAkDY6EhPHOYdjhC7
         Vc589c0KmxBh3eURXe8IZrwJjXDjHSVuBiSHEZWECElItvQ5euhC7qmiQP+37EC5pqPA
         /QiQ==
X-Gm-Message-State: AOAM532fR6/33BGnuhwBs0e/pAdX3hLiHtG55SpcBcfMlAM2qljFpsOo
        BYuEoXjELljMyKoWO/sGIOyN6RbEAgetsgPc2tP427hk
X-Google-Smtp-Source: ABdhPJyhr3snTkGgNEkVx77B7Srk7PUlnDiZW9SzjEH7pRqrqPmlLFCj8DeDA6goEYe4mUJvzOfpnE0tQxhwUNteq5A=
X-Received: by 2002:a05:6638:14c2:: with SMTP id l2mr28020601jak.276.1641492821017;
 Thu, 06 Jan 2022 10:13:41 -0800 (PST)
MIME-Version: 1.0
References: <20211230195325.328220-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211230195325.328220-1-krzysztof.kozlowski@canonical.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 6 Jan 2022 23:43:05 +0530
Message-ID: <CAGOxZ52GgtkJ6RStGXik7PmMNfaisrqRojmsvQZWUPaNR8Qp+g@mail.gmail.com>
Subject: Re: [RFT][PATCH 1/3] ARM: dts: exynos: fix UART3 pins configuration
 in Exynos5250
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Krzysztof

On Fri, Dec 31, 2021 at 4:02 PM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
>
> The gpa1-4 pin was put twice in UART3 pin configuration of Exynos5250,
> instead of proper pin gpa1-5.
>
> Fixes: f8bfe2b050f3 ("ARM: dts: add pin state information in client nodes for Exynos5 platforms")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
Thanks for fixing this.
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> index d31a68672bfa..d7d756614edd 100644
> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> @@ -260,7 +260,7 @@ i2c3_hs_bus: i2c3-hs-bus {
>         };
>
>         uart3_data: uart3-data {
> -               samsung,pins = "gpa1-4", "gpa1-4";
> +               samsung,pins = "gpa1-4", "gpa1-5";
>                 samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
>                 samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
>                 samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
> --
> 2.32.0
>


-- 
Regards,
Alim
