Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5C8303CFC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404497AbhAZM2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404288AbhAZM2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 07:28:01 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E646C0611C2
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 04:27:20 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id t12so3883452ljc.6
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 04:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9v3KzGuGqK5MBcKhrYjClIynInTPzsS/HTqIFvp1/IQ=;
        b=AhNeC2fz88Ilx7fr9U//EqOYLJZuP4afzoY1D9Y/bD2x0QTfkyd4mKOivKJxKrQ0Yf
         6AvZnGWJ+8LIf9dqoKuCS6bVudx19xZbFELWI43p6MaiD6HlMHGZn9DB+SNCIrXee6Ab
         eqMtMi4JDWBe5lQUk4xFFtxSmYZP0Ucw+Ov1Fp43HytHn3j1Ibi/PCf4/YuHN3aGeLvK
         GUIFIvLGogG+pAvZxYHFZq704nBoKjv6IL+3GJnyh9QRAMF39P9lFY1Z9Cq9IZ6tDM+7
         pK9wJQJCbRKYmOj3QsDHtWvQsugGdzgQ0HViEv2CgJEv2tfA7uECayDfXOPMkVaLxfHo
         VpPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9v3KzGuGqK5MBcKhrYjClIynInTPzsS/HTqIFvp1/IQ=;
        b=AvyMG7m6nJb8DmBI7mtLP4JeqeQ/dZpbd225gVN+gGW6uOGgScoBJOjnxksEPGG4fB
         jQegCbkqVNblPZihdr1Bsod7MFa9xllMF3IqNq2LtK9hFMUiKSHaBv9ibsEGKY2ut/+w
         CtYbZ8KmF1/VXkdBg3XU1tmzOlKEx7+G09NkZC0wkCR/nnuBHZtS5HA+xI/QU8MJlRnR
         M8RNKL/l1CiT6gU+w04uvBkdy2v57/jl1AjRNTKXbbrBugIBLkTGeu3bbmjZ1wFYBy41
         qNtrrqalw251Pl3NAKHqsKibuxzy4SjK8teiRbACDKf/5RsJxjvLcMuFqWEaitCYi5m7
         5S7A==
X-Gm-Message-State: AOAM533kg1OjvscvqDWQz3afv/3fZPbutpDr8jedoppGkeLlvPDQEGWn
        EpSU4HyQy3Ke/pthXw/GSp9r07PeC9GB1/REtxo0ig==
X-Google-Smtp-Source: ABdhPJwQDPzt2pQJdG1h2shmSbkHRYF079XcqA/pvY3/oPEW206//2F908lHU7Mei6Id7APUc3gEXfQ+JgG0zDmUVa8=
X-Received: by 2002:a2e:854d:: with SMTP id u13mr2614130ljj.439.1611664038883;
 Tue, 26 Jan 2021 04:27:18 -0800 (PST)
MIME-Version: 1.0
References: <20210126095230.26580-1-ulf.hansson@linaro.org>
In-Reply-To: <20210126095230.26580-1-ulf.hansson@linaro.org>
From:   Nicolas Schichan <nschichan@freebox.fr>
Date:   Tue, 26 Jan 2021 13:27:08 +0100
Message-ID: <CAHNNwZCFrZvmiVD7A3Ys9rpxfb0AytJx1CFQDYkMWUkYTDuCsw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pltfm: Fix linking err for sdhci-brcmstb
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 10:52 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> The implementation of sdhci_pltfm_suspend() is only available when
> CONFIG_PM_SLEEP is set, which triggers a linking error:
>
> "undefined symbol: sdhci_pltfm_suspend" when building sdhci-brcmstb.c.
>
> Fix this by implementing the missing stubs when CONFIG_PM_SLEEP is unset.
>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Nicolas Schichan <nschichan@freebox.fr>
> Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/host/sdhci-pltfm.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
> index 6301b81cf573..9bd717ff784b 100644
> --- a/drivers/mmc/host/sdhci-pltfm.h
> +++ b/drivers/mmc/host/sdhci-pltfm.h
> @@ -111,8 +111,13 @@ static inline void *sdhci_pltfm_priv(struct sdhci_pltfm_host *host)
>         return host->private;
>  }
>
> +extern const struct dev_pm_ops sdhci_pltfm_pmops;
> +#ifdef CONFIG_PM_SLEEP
>  int sdhci_pltfm_suspend(struct device *dev);
>  int sdhci_pltfm_resume(struct device *dev);
> -extern const struct dev_pm_ops sdhci_pltfm_pmops;
> +#else
> +static inline int sdhci_pltfm_suspend(struct device *dev) { return 0; }
> +static inline int sdhci_pltfm_resume(struct device *dev) { return 0; }
> +#endif
>
>  #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
> --
> 2.25.1
>

Hello,

I have just given this patch a test and no issues here, so:

Tested-By: Nicolas Schichan <nschichan@freeebox.fr>

Regards,

--
Nicolas Schichan
