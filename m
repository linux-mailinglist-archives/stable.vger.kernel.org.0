Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE45C5634AA
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiGANuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 09:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGANuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 09:50:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3654127B0F;
        Fri,  1 Jul 2022 06:50:05 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id fd6so3052474edb.5;
        Fri, 01 Jul 2022 06:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=S238Db/f5zI03A6YGNudmxgF/CExzHE07DknqK4x2mc=;
        b=IVQrkRTajyHNPWyatD25GMEUfTOxHvMUU548LOOr4xfC1aQlrm2IZ2UxgWjqfNEDHz
         2fUkUf3xw+3nkHj7Q4VRxYVopJqtMQtVizt8wT9vSk6VRiE70PVI3rZYhkWeeSNQDCAr
         FXkLG1e97blUWgNNh+ikXajFRmvNMWQrAv31pn+ncFYW4qrmBoNOLAbibxyBPErq+ktr
         cwFSMfqwNnBec2vZnZxUGqrwG6khmOH7W33j1R76wdkQQn+vvFMq3NTBS9jRw89SvNPD
         lPJ6Xs5Dmk4/cxcULFqD6HTjpCuK1ww9v0kpFLJ9VaI8BkMUfhCA6Dw5GUJHGwGJhy7n
         I8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=S238Db/f5zI03A6YGNudmxgF/CExzHE07DknqK4x2mc=;
        b=7Coe7bI4se/eY76+eE4jkqRVEInvs8KlPqeO+z/5mu3u7M4OiX/S5C0DeXdhSdliDF
         YKZ7boVqqtuwCqaaEhu54XLjN9hVtJDHMJVTUg9FIvFa26lFO2pGr2PuZzkIE3v+Xwqb
         R7NxmdzXn/u7ukejvIx8J9fIXkFsftiQr7RcgtUY3jSLPFV3gqxl3TNyu9VDL8elmaxb
         IKq4mb0cw7ZoHtPX5GsBMvKS+UikKmrsulREndUJQvUgmPqfMB26OuXGFXPuMeenvJ+H
         FCyFiwqrzZYI3QcCN6Nh1NTNSHBaUF+e/7PNmWl7czQ/cfQb+3NcpiKBPxrEi5sG0G4R
         X67w==
X-Gm-Message-State: AJIora9HusVBWIZO9OZO4uXrON4bPUblslm2R6Ue4S8V9DC710PWBnuP
        eeBut4ti+Ya2evBNirRHbtsWrrSY3x+z8P8BFmY=
X-Google-Smtp-Source: AGRyM1skCD0fwcFKlUMkw9csHBGhfe0Sg8KpdhXXvn2uBEcW+iftoqoTJkcysNP/k/AO0r0LuqAPnDcqkGS78J5nwPk=
X-Received: by 2002:a05:6402:500b:b0:431:78d0:bf9d with SMTP id
 p11-20020a056402500b00b0043178d0bf9dmr18948899eda.184.1656683403633; Fri, 01
 Jul 2022 06:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220701133126.26496-1-ansuelsmth@gmail.com>
In-Reply-To: <20220701133126.26496-1-ansuelsmth@gmail.com>
Reply-To: cwchoi00@gmail.com
From:   Chanwoo Choi <cwchoi00@gmail.com>
Date:   Fri, 1 Jul 2022 22:49:22 +0900
Message-ID: <CAGTfZH1FZLihHVUcFYGif0o3RnwLMsy_3_=4vqKYed10pqAP3A@mail.gmail.com>
Subject: Re: [PATCH v2] PM / devfreq: exynos-bus: Fix NULL pointer dereference
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Rafael,

The pull request[1] has an  issue for exynos-bus.c devfreq driver
and then fixed it by this patch.

If possible, could you please apply this patch to linux-pm.git
directly for 5.19-rc5?

[1] "[GIT,PULL] devfreq fixes for 5.19-rc5"
- https://patchwork.kernel.org/project/linux-pm/patch/03056170-6501-3f4d-0331-37866d12330e@gmail.com/

Best Regards,
Chanwoo Choi

On Fri, Jul 1, 2022 at 10:45 PM Christian Marangi <ansuelsmth@gmail.com> wrote:
>
> Fix exynos-bus NULL pointer dereference by correctly using the local
> generated freq_table to output the debug values instead of using the
> profile freq_table that is not used in the driver.
>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Fixes: b5d281f6c16d ("PM / devfreq: Rework freq_table to be local to devfreq struct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/exynos-bus.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/devfreq/exynos-bus.c b/drivers/devfreq/exynos-bus.c
> index b5615e667e31..79725bbb4bb0 100644
> --- a/drivers/devfreq/exynos-bus.c
> +++ b/drivers/devfreq/exynos-bus.c
> @@ -447,9 +447,9 @@ static int exynos_bus_probe(struct platform_device *pdev)
>                 }
>         }
>
> -       max_state = bus->devfreq->profile->max_state;
> -       min_freq = (bus->devfreq->profile->freq_table[0] / 1000);
> -       max_freq = (bus->devfreq->profile->freq_table[max_state - 1] / 1000);
> +       max_state = bus->devfreq->max_state;
> +       min_freq = (bus->devfreq->freq_table[0] / 1000);
> +       max_freq = (bus->devfreq->freq_table[max_state - 1] / 1000);
>         pr_info("exynos-bus: new bus device registered: %s (%6ld KHz ~ %6ld KHz)\n",
>                         dev_name(dev), min_freq, max_freq);
>
> --
> 2.36.1
>
