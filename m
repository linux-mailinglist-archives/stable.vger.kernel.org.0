Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB241ABEAA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 13:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505955AbgDPK7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 06:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505913AbgDPK7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 06:59:43 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52981C0258D4
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 03:59:43 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id g10so2642709uae.5
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 03:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p/NQn3x2dQrPgmua+MkXZ2CPgsicQ89yPGaFimgDCmY=;
        b=H1PRjyupkz+ecVblYlD5uZ6r4HV5zKCOh+pkNDaV9amQ+qoxu3nkqACQli5ciwIiPE
         RZYTRcRro5ZMqNbQf4/M1vESYaAobmD4nNuC0g72XoFTuHA9BzE6oyn5+UZPvtNAlJEW
         ie/Lt169KGZ57WHaUv2tfQZD62uiHLfBim1YFbVgseXfc9JvQkfriTgSS7/0211ybdZR
         vY785wUltPwG3+Y3GOoKYBsPOR6lhKm25CiMM1z+OitCgs5fCmLii0es72sWXK7AhmWu
         v4PzLn8cVZR22flguxUivk/kqmXVeFMLyegDsuJNhiW5y+CWuztKa+zfIYH2w41QuLYZ
         TDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p/NQn3x2dQrPgmua+MkXZ2CPgsicQ89yPGaFimgDCmY=;
        b=e2VCzKNkuzEZFxlMUYY474yKXtnDLvuP/5409fLMs7423dwQZm4MbsUERgMLj6b7+E
         uaaLXQva8cUQui1R+ZvZu35f09X03jmQlQr4gDSfvdBY3rdbSIROkWgC415W/+Q2dUch
         m0x+mypNGTIbla3lt7adDD41aCCkv5+ADBxgJf+3GE87kMSPLUVF6eltija4VA8z98rL
         RTm+WRIqS2kLU0QgV0RGPqrwsP3nWz6CLTUtHjDP70mlsjs1m44RCgPKGLBStEDDC7nd
         7oxMLaHro+WQ/Ax/0sxzjk1VKH+QY63dFMcZ760K8FqEKlkCRkx+ywm4JfumUhCerXB3
         Px9g==
X-Gm-Message-State: AGi0PuY6uqcdIMpEivEGnINeVygHbv/iJEZjs8m4psH0DROsoOMhaWpp
        k8zvvSI29iqBbY9+dNlDSRolxch2bAmqsuqfoOLptA==
X-Google-Smtp-Source: APiQypIheC8zF+5u1sxqSHfIaGuYjJzSfh8tnXKmJeq8phNdy3w/AXb9wUOkMUHaVScHJYnzRhCpI5N5eo01eUkNqKU=
X-Received: by 2002:ab0:2ea:: with SMTP id 97mr8516870uah.129.1587034782283;
 Thu, 16 Apr 2020 03:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <1583886030-11339-1-git-send-email-skomatineni@nvidia.com> <CA+G9fYvreAv5HmZg0O4VvLvf_PYSvzD1rp08XONNQGExctgQ0Q@mail.gmail.com>
In-Reply-To: <CA+G9fYvreAv5HmZg0O4VvLvf_PYSvzD1rp08XONNQGExctgQ0Q@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 16 Apr 2020 12:59:06 +0200
Message-ID: <CAPDyKFpZEiqTdD6O-y6Sw7ifXF__MHAv0zKT=RFKs+Fmvr-K_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sdhci: tegra: Implement Tegra specific set_timeout callback
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "(Exiting) Baolin Wang" <baolin.wang@linaro.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bradley Bolen <bradleybolen@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Aniruddha Tvs Rao <anrao@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Apr 2020 at 19:55, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Fri, 13 Mar 2020 at 06:41, Sowjanya Komatineni
> <skomatineni@nvidia.com> wrote:
> >
> > Tegra host supports HW busy detection and timeouts based on the
> > count programmed in SDHCI_TIMEOUT_CONTROL register and max busy
> > timeout it supports is 11s in finite busy wait mode.
> >
> > Some operations like SLEEP_AWAKE, ERASE and flush cache through
> > SWITCH commands take longer than 11s and Tegra host supports
> > infinite HW busy wait mode where HW waits forever till the card
> > is busy without HW timeout.
> >
> > This patch implements Tegra specific set_timeout sdhci_ops to allow
> > switching between finite and infinite HW busy detection wait modes
> > based on the device command expected operation time.
> >
> > Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> > ---
> >  drivers/mmc/host/sdhci-tegra.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> > index a25c3a4..fa8f6a4 100644
> > --- a/drivers/mmc/host/sdhci-tegra.c
> > +++ b/drivers/mmc/host/sdhci-tegra.c
> > @@ -45,6 +45,7 @@
> >  #define SDHCI_TEGRA_CAP_OVERRIDES_DQS_TRIM_SHIFT       8
> >
> >  #define SDHCI_TEGRA_VENDOR_MISC_CTRL                   0x120
> > +#define SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT            BIT(0)
> >  #define SDHCI_MISC_CTRL_ENABLE_SDR104                  0x8
>
> >  #define SDHCI_MISC_CTRL_ENABLE_SDR50                   0x10
> >  #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300          0x20
> > @@ -1227,6 +1228,34 @@ static u32 sdhci_tegra_cqhci_irq(struct sdhci_host *host, u32 intmask)
> >         return 0;
> >  }
> >
> > +static void tegra_sdhci_set_timeout(struct sdhci_host *host,
> > +                                   struct mmc_command *cmd)
> > +{
> > +       u32 val;
> > +
> > +       /*
> > +        * HW busy detection timeout is based on programmed data timeout
> > +        * counter and maximum supported timeout is 11s which may not be
> > +        * enough for long operations like cache flush, sleep awake, erase.
> > +        *
> > +        * ERASE_TIMEOUT_LIMIT bit of VENDOR_MISC_CTRL register allows
> > +        * host controller to wait for busy state until the card is busy
> > +        * without HW timeout.
> > +        *
> > +        * So, use infinite busy wait mode for operations that may take
> > +        * more than maximum HW busy timeout of 11s otherwise use finite
> > +        * busy wait mode.
> > +        */
> > +       val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> > +       if (cmd && cmd->busy_timeout >= 11 * HZ)
> > +               val |= SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> > +       else
> > +               val &= ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> > +       sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> > +
> > +       __sdhci_set_timeout(host, cmd);
>
> kernel build on arm and arm64 architecture failed on stable-rc 4.19
> (arm), 5.4 (arm64) and 5.5 (arm64)
>
> drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
> drivers/mmc/host/sdhci-tegra.c:1256:2: error: implicit declaration of
> function '__sdhci_set_timeout'; did you mean
> 'tegra_sdhci_set_timeout'? [-Werror=implicit-function-declaration]
>   __sdhci_set_timeout(host, cmd);
>   ^~~~~~~~~~~~~~~~~~~
>   tegra_sdhci_set_timeout
>
> Full build log,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/83/consoleText
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=juno,label=docker-lkft/158/consoleText
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/511/consoleText
>
> - Naresh

Thanks for reporting! What a mess.

It turns out that the commit that was queued for stable that is
causing the above errors, also requires another commit.

The commit that was queued:
5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout callback")

The additional commit needed (which was added in v5.6-rc1):
7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")

However, the above commit needs a manual backport (quite trivial, but
still) for the relevant stable kernels, to allow it to solve the build
problems.

Greg, Sasha - I suggest you to drop the offending commit from the
stable kernels, for now. I think it's better to let Sowjanya deal with
the backports, then send them in small series instead.

Kind regards
Uffe
