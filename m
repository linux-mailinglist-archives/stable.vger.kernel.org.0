Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C66BA1C4E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfH2OE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 10:04:57 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:31526 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfH2OE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 10:04:57 -0400
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x7TE4hMT005980;
        Thu, 29 Aug 2019 23:04:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x7TE4hMT005980
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1567087484;
        bh=V+lbFxqlT+wd+YZgxlyNRbBDlB7GpYlOVv7o2hTS5yQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vGtZwdNqugs7ZwQdGDWOMDjdUeOubga9J2nO4YdJJ91bdf3rSAcky03Ezi4jo3Fp0
         uN3tOrkq03IXkzNnX14lsNN1FGd8Jh2MCgc4GmWa/WHELUDbPOBV4WSTgt1UsI3hUe
         ZjsuSIa088Tmzezv9iAARNvhKXyAkzy2xEnbpT5V3miPAAggqxSsAVwiFiwjeQVQmo
         XNRkqd+TyqilT9A5gU2MctK8FVDKDXjbcOECNFbDWC9od5ivUzhc6xf8aYMCFKYQ9C
         UfxbdYB9TOT1v2Ip7USxXsciKX/YpPWfjHOquUHU8O22hwFtHUdb1ZnFX91a5xf/Yu
         Y7I5w3IXZwpow==
X-Nifty-SrcIP: [209.85.222.52]
Received: by mail-ua1-f52.google.com with SMTP id k7so1192145uao.6;
        Thu, 29 Aug 2019 07:04:43 -0700 (PDT)
X-Gm-Message-State: APjAAAWKY2xiJgszPCeGssTO2T/9OSDQ07n8AZBFgzHQ07UE3RsbNZvN
        mQpgC5pnG8+cSSC/XKYS+S7qsxZAbj+BjFtWum8=
X-Google-Smtp-Source: APXvYqyRDUJ3u5oUv/jHQhqE0k0YskLGM9awy7Nq6OtAJ1WmuhqZBF7BDBVIdGwEa3ued2ZdUIlx3DiF2CP1PVL3RXY=
X-Received: by 2002:ab0:4261:: with SMTP id i88mr4930502uai.95.1567087482413;
 Thu, 29 Aug 2019 07:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190829104928.27404-1-yamada.masahiro@socionext.com>
 <CAPDyKFooFQgBgK3N1Ob9rsT_7-5kqC9i7PeMxkkeAbnDP+Fwnw@mail.gmail.com>
 <CAK7LNASDfJQrMq4jjwDjrQF-4E9A_BZtgh+K-duTAo8zRVZA0g@mail.gmail.com> <CAPDyKFpnRbtVpYkpM7CDYfxvdBjqybB4SVWyuSrS1jpYduTbCw@mail.gmail.com>
In-Reply-To: <CAPDyKFpnRbtVpYkpM7CDYfxvdBjqybB4SVWyuSrS1jpYduTbCw@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 29 Aug 2019 23:04:03 +0900
X-Gmail-Original-Message-ID: <CAK7LNARC_Y968UtXE3v72Dw=69-6jutFTVy54K=iT5o52udXSg@mail.gmail.com>
Message-ID: <CAK7LNARC_Y968UtXE3v72Dw=69-6jutFTVy54K=iT5o52udXSg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mmc: sdhci-cadence: enable v4_mode to fix ADMA 64-bit addressing
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Piotr Sroka <piotrs@cadence.com>,
        "# 4.0+" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ulf,

On Thu, Aug 29, 2019 at 10:27 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Thu, 29 Aug 2019 at 14:05, Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Thu, Aug 29, 2019 at 8:48 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> > >
> > > On Thu, 29 Aug 2019 at 12:49, Masahiro Yamada
> > > <yamada.masahiro@socionext.com> wrote:
> > > >
> > > > The IP datasheet says this controller is compatible with SD Host
> > > > Specification Version v4.00.
> > > >
> > > > As it turned out, the ADMA of this IP does not work with 64-bit mode
> > > > when it is in the Version 3.00 compatible mode; it understands the
> > > > old 64-bit descriptor table (as defined in SDHCI v2), but the ADMA
> > > > System Address Register (SDHCI_ADMA_ADDRESS) cannot point to the
> > > > 64-bit address.
> > > >
> > > > I noticed this issue only after commit bd2e75633c80 ("dma-contiguous:
> > > > use fallback alloc_pages for single pages"). Prior to that commit,
> > > > dma_set_mask_and_coherent() returned the dma address that fits in
> > > > 32-bit range, at least for the default arm64 configuration
> > > > (arch/arm64/configs/defconfig). Now the host->adma_addr exceeds the
> > > > 32-bit limit, causing the real problem for the Socionext SoCs.
> > > > (As a side-note, I was also able to reproduce the issue for older
> > > > kernels by turning off CONFIG_DMA_CMA.)
> > > >
> > > > Call sdhci_enable_v4_mode() to fix this.
> > > >
> > > > I think it is better to back-port this, but only possible for v4.20+.
> > > >
> > > > When this driver was merged (v4.10), the v4 mode support did not exist.
> > > > It was added by commit b3f80b434f72 ("mmc: sdhci: Add sd host v4 mode")
> > > > i.e. v4.20.
> > > >
> > > > Cc: <stable@vger.kernel.org> # v4.20+
> > > > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > >
> > > Applied for fixes, by adding below tag, thanks!
> > >
> > > Fixes: b3f80b434f72 ("mmc: sdhci: Add sd host v4 mode")
> >
> > This is not a bug commit.
>
> Right, but it can't be applied before this commit, hence why I added
> it. Not sure that it matters, but I can remove the tag if you
> insists!?

I hesitate to add Fixes to the commit that
did nothing wrong.


I added "Cc: <stable@vger.kernel.org> # v4.20+"
so this is enough for the stable kernel maintainers.




-- 
Best Regards
Masahiro Yamada
