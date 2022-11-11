Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B973D625A99
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiKKMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 07:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiKKMkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 07:40:42 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C69F7B22E
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 04:40:41 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p12so4168896plq.4
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 04:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+pSb3nKIXHaiftR3v+Evz/+SDGPAA0OKtaaUaJuams=;
        b=Sjp+mfbMzTuBd24OSiZRNL5zBW3SR3VhtM052t7yx/J6peolwpXst7LHpoNhlP9dD8
         9mseGD3RSu7bRw7aHIcBd1wSnaU5o6nLd7pEv3S+kb9HP0IcUDkg2hUASCyg+4M+IOyE
         08L8NwAfmRui4CAQhMSxF+aTuV/l8wcqkMXVYZbjWVQYWPDnBNNNiJEr6Kxm8PeX1vgH
         FLI4W3mxjcPdLzWn3o6pv0if/c7n2L6SagBoUnKYUCGKsYHLGdAYMDvhe06ghDz5HLG8
         PfvCLm5t2xvoWdnWkk5Pt1zDQKOuBgzys4CtR9MMJ7PJFtqbRtt4/W5uBhyl6vpt7Kjf
         3lxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z+pSb3nKIXHaiftR3v+Evz/+SDGPAA0OKtaaUaJuams=;
        b=67TK4PSjbAIRJ2PCokQo4uJbyuBtV6OtG6PMSL6XbqT8t4hBnbrKuvskHjTWPADzUl
         DTCuCUifJJgXyGhiTitYy7LDb6ghSzrofFEYOyP5KyjCt40cuABYKw7I8kMTmAFpaCQR
         IikEa224mVzk3ut6ueZfYDixNGNN45k10LDa67dNyvFr67LOiDGNn9br13SgSqVYl22x
         hrHXJyVRrBRFW6lq3xSp5zaY0P8iDpjewk0ff+aquBJHSSRqNmBiffHS6HzOu7e3CNpj
         Lt3zrcXtxNm6T6rQqOqy7NaYhayYOQOldagFqxBr5/vqrX5adIj/lQv8x3M9CwScpVWF
         A+hA==
X-Gm-Message-State: ANoB5pk1Sbi9xSZLvBNgC1rvFon9Q3eY3X5Ar0R0mRm4XkQq8C0Y8pwD
        zWstSH0gI3E25GyQ3MQijl0EcHVhVYBvvCjrvQj3BCvBE9EkDw==
X-Google-Smtp-Source: AA0mqf4ti3oIKNWdDvRGk3CYFGxw+N1DPpSsx+LEvKJ59w+/d/YXkMZ5jOTCwUxB+wZd+6Fsj3xULFkVVj/qRccDZtQ=
X-Received: by 2002:a17:90a:f18f:b0:218:8f4:bad5 with SMTP id
 bv15-20020a17090af18f00b0021808f4bad5mr1786731pjb.55.1668170440958; Fri, 11
 Nov 2022 04:40:40 -0800 (PST)
MIME-Version: 1.0
References: <CGME20221110154141eucas1p1e69a91704c32c07307a9c73b95e0d9a3@eucas1p1.samsung.com>
 <20221110154131.2577-1-m.szyprowski@samsung.com>
In-Reply-To: <20221110154131.2577-1-m.szyprowski@samsung.com>
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Fri, 11 Nov 2022 13:40:29 +0100
Message-ID: <CAPLW+4mpZWJHg6qQi1SOAwB-KRrzQo1sOnY4ku5FV3zgVAqNYw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc3: exynos: Fix remove() function
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Nov 2022 at 16:41, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
> The core DWC3 device node was not properly removed by the custom
> dwc3_exynos_remove_child() function. Replace it with generic
> of_platform_depopulate() which does that job right.
>
> Fixes: adcf20dcd262 ("usb: dwc3: exynos: Use of_platform API to create dwc3 core pdev")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> Cc: stable@vger.kernel.org
> ---

Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>

>  drivers/usb/dwc3/dwc3-exynos.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
> index 0ecf20eeceee..4be6a873bd07 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -37,15 +37,6 @@ struct dwc3_exynos {
>         struct regulator        *vdd10;
>  };
>
> -static int dwc3_exynos_remove_child(struct device *dev, void *unused)
> -{
> -       struct platform_device *pdev = to_platform_device(dev);
> -
> -       platform_device_unregister(pdev);
> -
> -       return 0;
> -}
> -
>  static int dwc3_exynos_probe(struct platform_device *pdev)
>  {
>         struct dwc3_exynos      *exynos;
> @@ -142,7 +133,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
>         struct dwc3_exynos      *exynos = platform_get_drvdata(pdev);
>         int i;
>
> -       device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
> +       of_platform_depopulate(&pdev->dev);
>
>         for (i = exynos->num_clks - 1; i >= 0; i--)
>                 clk_disable_unprepare(exynos->clks[i]);
> --
> 2.17.1
>
