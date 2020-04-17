Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516CE1AD829
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgDQIFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 04:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729535AbgDQIFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 04:05:19 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66776C061A0C
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 01:05:19 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id f195so347845vka.4
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 01:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vw2Yz9QKvnH8qm78kPmIMpthfuS5ToTfV4/eBO9aXZs=;
        b=yakEra6h63cypV6sApwJRt8QTk1typgQ4CUWktDZ3OaZbJmY+czocu/ZicycqNwDkT
         JOIu15o2SyBxO3YPCHZvYc8bWH6INqt4ZqgoKAyIauLORiCPzFt5M5ACHWGXW2hYdyH/
         6cYdwDNvlR9nkz9COyri//bhLKT9lamCNgXtlh6zx8xDx3li9Gqv1iH6RwOQJCe8Tki4
         itvoWt2sG59DULq6Rl8gh+8HdsBK4UlEHfDhiv5K7OjcHUL9Uszq+t30cvWjVtTot6Mk
         5/RvXvnrgcgfUhZ17C1+iB3xaZA3KqYelNiDD7PBUZ7r8ywLOpqNIK4gN6j62jaFIj9L
         q3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vw2Yz9QKvnH8qm78kPmIMpthfuS5ToTfV4/eBO9aXZs=;
        b=c2hiUkLsiPZG33GWiKVblA9dy80nIZdLUtTQMyHADBgQQY4ABD3syBsdCnd+TYjyme
         cR+LQhfBP4jVE6txU9gQWmjehxTUTFlQnUEKC8+9/H7kn+RkkTkl3LoXTa3/w9iq46Hs
         JCZZQ3aDyKmDoGNPlTCwO3VrcATMYZ4Ov6s3tMm7xYTk9+NWoGSDmcMoKXl/HY24lnN2
         ESxU+jj4ZHvTT2jVUc2DGCgH8AHzXFhl6nbnB1+wOAMcfg0MBt3OF4cKSaVUHDPsHgGy
         ETRV/9ZTIZsCJjuNFWWAnUsUfMTn1P8B6JRpak/uanzFNz6F5fXES+ZE09yAiY+BgqWm
         hPhA==
X-Gm-Message-State: AGi0PuYzGUArFt2VL8SRblkro5XgtQ3QnkATcDZ8dEY6Ux7IJ1xOOUkl
        z+YCFWwmtg+KJtq8jZW7h4vELiEwBgHVwcFXHTI2cw==
X-Google-Smtp-Source: APiQypLoL1YUf3ZDQ50QAVVPjT9KC5UFb4LnKhTt6wcbcy1pMZpYbxuwtVXDiDhZcuVUwVfYGRbRIOQZDAqOlH9YkBI=
X-Received: by 2002:a1f:5003:: with SMTP id e3mr1455112vkb.59.1587110718373;
 Fri, 17 Apr 2020 01:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <1583886030-11339-1-git-send-email-skomatineni@nvidia.com>
 <CA+G9fYvreAv5HmZg0O4VvLvf_PYSvzD1rp08XONNQGExctgQ0Q@mail.gmail.com>
 <CAPDyKFpZEiqTdD6O-y6Sw7ifXF__MHAv0zKT=RFKs+Fmvr-K_Q@mail.gmail.com>
 <753ec108-858c-660e-af0a-f57922134609@nvidia.com> <512441d1-a9ba-912f-ed2e-46edad22278b@nvidia.com>
In-Reply-To: <512441d1-a9ba-912f-ed2e-46edad22278b@nvidia.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 17 Apr 2020 10:04:42 +0200
Message-ID: <CAPDyKFohGL-401DVb1NYf3YUwbokcDR5++8t5o+y+3yy5XbGyQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sdhci: tegra: Implement Tegra specific set_timeout callback
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
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

On Thu, 16 Apr 2020 at 21:39, Sowjanya Komatineni
<skomatineni@nvidia.com> wrote:
>
>
> On 4/16/20 9:29 AM, Sowjanya Komatineni wrote:
> >
> > On 4/16/20 3:59 AM, Ulf Hansson wrote:
> >> External email: Use caution opening links or attachments
> >>
> >>
> >> On Wed, 15 Apr 2020 at 19:55, Naresh Kamboju
> >> <naresh.kamboju@linaro.org> wrote:
> >>> On Fri, 13 Mar 2020 at 06:41, Sowjanya Komatineni
> >>> <skomatineni@nvidia.com> wrote:
> >>>> Tegra host supports HW busy detection and timeouts based on the
> >>>> count programmed in SDHCI_TIMEOUT_CONTROL register and max busy
> >>>> timeout it supports is 11s in finite busy wait mode.
> >>>>
> >>>> Some operations like SLEEP_AWAKE, ERASE and flush cache through
> >>>> SWITCH commands take longer than 11s and Tegra host supports
> >>>> infinite HW busy wait mode where HW waits forever till the card
> >>>> is busy without HW timeout.
> >>>>
> >>>> This patch implements Tegra specific set_timeout sdhci_ops to allow
> >>>> switching between finite and infinite HW busy detection wait modes
> >>>> based on the device command expected operation time.
> >>>>
> >>>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> >>>> ---
> >>>>   drivers/mmc/host/sdhci-tegra.c | 31 +++++++++++++++++++++++++++++++
> >>>>   1 file changed, 31 insertions(+)
> >>>>
> >>>> diff --git a/drivers/mmc/host/sdhci-tegra.c
> >>>> b/drivers/mmc/host/sdhci-tegra.c
> >>>> index a25c3a4..fa8f6a4 100644
> >>>> --- a/drivers/mmc/host/sdhci-tegra.c
> >>>> +++ b/drivers/mmc/host/sdhci-tegra.c
> >>>> @@ -45,6 +45,7 @@
> >>>>   #define SDHCI_TEGRA_CAP_OVERRIDES_DQS_TRIM_SHIFT       8
> >>>>
> >>>>   #define SDHCI_TEGRA_VENDOR_MISC_CTRL 0x120
> >>>> +#define SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT BIT(0)
> >>>>   #define SDHCI_MISC_CTRL_ENABLE_SDR104                  0x8
> >>>>   #define SDHCI_MISC_CTRL_ENABLE_SDR50 0x10
> >>>>   #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300 0x20
> >>>> @@ -1227,6 +1228,34 @@ static u32 sdhci_tegra_cqhci_irq(struct
> >>>> sdhci_host *host, u32 intmask)
> >>>>          return 0;
> >>>>   }
> >>>>
> >>>> +static void tegra_sdhci_set_timeout(struct sdhci_host *host,
> >>>> +                                   struct mmc_command *cmd)
> >>>> +{
> >>>> +       u32 val;
> >>>> +
> >>>> +       /*
> >>>> +        * HW busy detection timeout is based on programmed data
> >>>> timeout
> >>>> +        * counter and maximum supported timeout is 11s which may
> >>>> not be
> >>>> +        * enough for long operations like cache flush, sleep
> >>>> awake, erase.
> >>>> +        *
> >>>> +        * ERASE_TIMEOUT_LIMIT bit of VENDOR_MISC_CTRL register allows
> >>>> +        * host controller to wait for busy state until the card is
> >>>> busy
> >>>> +        * without HW timeout.
> >>>> +        *
> >>>> +        * So, use infinite busy wait mode for operations that may
> >>>> take
> >>>> +        * more than maximum HW busy timeout of 11s otherwise use
> >>>> finite
> >>>> +        * busy wait mode.
> >>>> +        */
> >>>> +       val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> >>>> +       if (cmd && cmd->busy_timeout >= 11 * HZ)
> >>>> +               val |= SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> >>>> +       else
> >>>> +               val &= ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> >>>> +       sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> >>>> +
> >>>> +       __sdhci_set_timeout(host, cmd);
> >>> kernel build on arm and arm64 architecture failed on stable-rc 4.19
> >>> (arm), 5.4 (arm64) and 5.5 (arm64)
> >>>
> >>> drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
> >>> drivers/mmc/host/sdhci-tegra.c:1256:2: error: implicit declaration of
> >>> function '__sdhci_set_timeout'; did you mean
> >>> 'tegra_sdhci_set_timeout'? [-Werror=implicit-function-declaration]
> >>>    __sdhci_set_timeout(host, cmd);
> >>>    ^~~~~~~~~~~~~~~~~~~
> >>>    tegra_sdhci_set_timeout
> >>>
> >>> Full build log,
> >>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/83/consoleText
> >>>
> >>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=juno,label=docker-lkft/158/consoleText
> >>>
> >>> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/511/consoleText
> >>>
> >>>
> >>> - Naresh
> >> Thanks for reporting! What a mess.
> >>
> >> It turns out that the commit that was queued for stable that is
> >> causing the above errors, also requires another commit.
> >>
> >> The commit that was queued:
> >> 5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout
> >> callback")
> >>
> >> The additional commit needed (which was added in v5.6-rc1):
> >> 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")
> >>
> >> However, the above commit needs a manual backport (quite trivial, but
> >> still) for the relevant stable kernels, to allow it to solve the build
> >> problems.
> >>
> >> Greg, Sasha - I suggest you to drop the offending commit from the
> >> stable kernels, for now. I think it's better to let Sowjanya deal with
> >> the backports, then send them in small series instead.
> >>
> >> Kind regards
> >> Uffe
> >
> > Hi Ufee,
> >
> > Will back-porting below commit cause any issues to other vendors?
> >
> > 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")
> >
> sdhci-tegra driver in 4.19 is using same sdhci_ops for Tegra114 and
> Tegra210 and separate sdhci_ops for T210 started from 4.20.
>
> 5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout callback")
>
> So above commit can't be applied to 4.19. So probably a separate patch
> need to be created to apply for 4.19 and back port above commit along
> with its dependency commit (7d76ed77cfbd ("mmc: sdhci: Refactor
> sdhci_set_timeout()") for 5.4 and 5.4.

Alright, seems reasonable. Just keep me/Adrian on cc when/if you post
the patches so we can ack them.

Kind regards
Uffe
