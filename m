Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2204A7930
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 21:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiBBUHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 15:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiBBUHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 15:07:12 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E88C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 12:07:12 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id m6so2009115ybc.9
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 12:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcs/C0FVCi89M1M4Tvy0j4vQMVAalGYWhHkwfM8Bvqc=;
        b=I0ZXsSsqLNvaP6eq6CjSUyGH2c4SjM2d7XqaRnjaI04wGcpy7YdOAVz0F+skwnN8LL
         +2+YXedE1a6MhA3RjOlwsLCVOsZMLdWmHzrhEPij8SI7B20PSEZRBW0eM4ormfDxCpGa
         6hflw/ypCTbiD2474j/X699UHmu3knmcE6lasx6iTRzL8JOkb0CiwzCMsxF+XDxeA8Je
         xHalW+S1vDhJYyKau0fwp8vjbz8ZYEe0v/pCLpoMX/2KkUxDECCe5o0roXWoZGNKNrCO
         Y5KFxueKxebMUb9K1EWI/xH0/Mx7ltdQphF3CkYBRRp/StQBRSiDY3PgNsCxkQFKlmP2
         pUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcs/C0FVCi89M1M4Tvy0j4vQMVAalGYWhHkwfM8Bvqc=;
        b=5L3erXtNA7jzIIck0kew8+PEb4o1fMxyjShzP6JlsofLvCtDW+RRdKSerTMBd0rbuL
         tLChbFxkYyJIEuKfc81XuVjWvIcgeI99bUwBJA15u7u9ejqwExrKl3TJRUvW6IB0FRfv
         4EivV4bGaC9RE6dj07vTT9wIoNMQx+jLwm/Pq1XLMS3IaW8KJpS3D83CLLWkINV8v9+B
         nXQ+NSx6wZ9JB0X0zTlSAkV3SMySNqTg9lTw72/gOqeXYHEBz8cTW+10yPgF54/zqSjm
         j5wNOurORyVzyE2g4HX5Dl85sNcRCC68SHhyDP8RFiWnGNxGS4vyVYEm5wpqnMWyo25z
         6Mkw==
X-Gm-Message-State: AOAM531+OMWyVZyioeBrqW1mVSz78j3pn/3ou55BELbfqSkaUy802yPo
        dzNZ4RZxaCiECHKXottq3vvKOXZ9wnIctMzCG/s7DQ==
X-Google-Smtp-Source: ABdhPJzULmuuNz5nu6YwGVwdapZKVwE1k+y1sb2lPmefpuPeRMv0Eu+DgwLfB8HZGXo0iW3WUsSol8Vke7NXJ3SSK+w=
X-Received: by 2002:a25:b90f:: with SMTP id x15mr40741984ybj.423.1643832431526;
 Wed, 02 Feb 2022 12:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20220202195705.3598798-1-khilman@baylibre.com>
In-Reply-To: <20220202195705.3598798-1-khilman@baylibre.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 2 Feb 2022 12:06:35 -0800
Message-ID: <CAGETcx-ynfBcrUMVWq2abgasMp1dgh=e9oTQY+A4dmVgrrQ4Yg@mail.gmail.com>
Subject: Re: [PATCH] Revert "drivers: bus: simple-pm-bus: Add support for
 probing simple bus only devices"
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 2, 2022 at 11:57 AM Kevin Hilman <khilman@baylibre.com> wrote:
>
> This reverts commit d5f13bbb51046537b2c2b9868177fb8fe8a6a6e9.
>
> This change related to fw_devlink was backported to v5.10 but has
> severaly other dependencies that were not backported.  As discussed
> with the original author, the best approach for v5.10 is to revert.
>
> Link: https://lore.kernel.org/linux-omap/7hk0efmfzo.fsf@baylibre.com
> Cc: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>

Thanks for getting around to this Kevin. Sorry, I got caught up on
some urgent issues on my end.

Acked-by: Saravana Kannan <saravanak@google.com>

-Saravana

> ---
>  drivers/bus/simple-pm-bus.c | 39 +------------------------------------
>  1 file changed, 1 insertion(+), 38 deletions(-)
>
> diff --git a/drivers/bus/simple-pm-bus.c b/drivers/bus/simple-pm-bus.c
> index 244b8f3b38b4..c5eb46cbf388 100644
> --- a/drivers/bus/simple-pm-bus.c
> +++ b/drivers/bus/simple-pm-bus.c
> @@ -16,33 +16,7 @@
>
>  static int simple_pm_bus_probe(struct platform_device *pdev)
>  {
> -       const struct device *dev = &pdev->dev;
> -       struct device_node *np = dev->of_node;
> -       const struct of_device_id *match;
> -
> -       /*
> -        * Allow user to use driver_override to bind this driver to a
> -        * transparent bus device which has a different compatible string
> -        * that's not listed in simple_pm_bus_of_match. We don't want to do any
> -        * of the simple-pm-bus tasks for these devices, so return early.
> -        */
> -       if (pdev->driver_override)
> -               return 0;
> -
> -       match = of_match_device(dev->driver->of_match_table, dev);
> -       /*
> -        * These are transparent bus devices (not simple-pm-bus matches) that
> -        * have their child nodes populated automatically.  So, don't need to
> -        * do anything more. We only match with the device if this driver is
> -        * the most specific match because we don't want to incorrectly bind to
> -        * a device that has a more specific driver.
> -        */
> -       if (match && match->data) {
> -               if (of_property_match_string(np, "compatible", match->compatible) == 0)
> -                       return 0;
> -               else
> -                       return -ENODEV;
> -       }
> +       struct device_node *np = pdev->dev.of_node;
>
>         dev_dbg(&pdev->dev, "%s\n", __func__);
>
> @@ -56,25 +30,14 @@ static int simple_pm_bus_probe(struct platform_device *pdev)
>
>  static int simple_pm_bus_remove(struct platform_device *pdev)
>  {
> -       const void *data = of_device_get_match_data(&pdev->dev);
> -
> -       if (pdev->driver_override || data)
> -               return 0;
> -
>         dev_dbg(&pdev->dev, "%s\n", __func__);
>
>         pm_runtime_disable(&pdev->dev);
>         return 0;
>  }
>
> -#define ONLY_BUS       ((void *) 1) /* Match if the device is only a bus. */
> -
>  static const struct of_device_id simple_pm_bus_of_match[] = {
>         { .compatible = "simple-pm-bus", },
> -       { .compatible = "simple-bus",   .data = ONLY_BUS },
> -       { .compatible = "simple-mfd",   .data = ONLY_BUS },
> -       { .compatible = "isa",          .data = ONLY_BUS },
> -       { .compatible = "arm,amba-bus", .data = ONLY_BUS },
>         { /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, simple_pm_bus_of_match);
> --
> 2.34.0
>
