Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972440AB19
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 11:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhINJsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 05:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhINJsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 05:48:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C944DC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 02:46:54 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id o20so16881279ejd.7
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 02:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JvRU2iFGpeccVMjKtT6+w9RLMGZt7GKZuC+LrVKqfH0=;
        b=t8nrtFt41e1x2hjfB+hxvI9+eBukzuV7NTc1HQbRTbL8KvWZ5US9ohxp3jIdQRMzNW
         QSD8url1KQQ5Z2uU0ehu1MHjs6ZfwnarWTyqYP7EbHt2mk8rrtjWShCs+oMH8x45WJ/O
         pH3DPccXXOXcZwODq2zBYgNCdMzjEJSy5jz6aQfSSAmYdIUzyBDONox3oE+/X0+IWlos
         sublqwOAVJfDSzNYeKVB+nmpxBHCMNyvjvbecTYiXrYAQKzPCeF5LKaBh2kcM5eHkANY
         f98J/vbQ5rhivwPzfELxDtdQbXKcyOOzbfmV30itqZjdwTy7GiJSprk49r5Xf5IqiYI5
         +GSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JvRU2iFGpeccVMjKtT6+w9RLMGZt7GKZuC+LrVKqfH0=;
        b=ijP7VK/08v6oy2k3vppAEdxX5444lBzIgS+AUk3N63skakqi5eonDJEdEF7rPlcJOK
         MBPHr0VYzisiHUeNp34BXHk36AkRztFQStAb/cxIbWgqO0f47Yr4O5YATzFtxVZCFRNA
         hn9s5hRy5NAQmDsnWystmJjo9MTamoQtzjyudC/EasIb23UmVAqbimOV1+qpmvvb578C
         bfOyqt1ae8xRNqvDyHJbG7eQ9MEtWpY+PQ5glItIQAaJH/KgufGdrD8mQ9Kq7Zj+Mgc1
         7ba4mSzlxeBPcTNmdI7EtMnBEOHAbMyJVBP1vicpHqWV6DxqZnaXJsTLQuSkflaFyiLX
         cAxg==
X-Gm-Message-State: AOAM5335aebVNc6Hkz34k9gvms+zm81ymPnHgalUxU7fO9E8RHL57aja
        WDCPHvTB1AJTRkMwP2ynyrkOexgwuHeM9yYkhxJNag==
X-Google-Smtp-Source: ABdhPJyqFuqqSFYnM8fLvzksw99NPbhAmI/hXod0tUt0kQbaWey9PC26NFmCh8Tjfe8zmbWTDgQepoYhos6KThLNtOQ=
X-Received: by 2002:a17:906:417:: with SMTP id d23mr18175227eja.383.1631612813299;
 Tue, 14 Sep 2021 02:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com> <20210730143431.GB1517404@mutt>
 <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com>
In-Reply-To: <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 14 Sep 2021 11:46:42 +0200
Message-ID: <CADYN=9LE2JnE+vmv_UaeyJj_RpHcp+zZUv711VuQekLSiQ2bJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     sudeep.holla@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        liviu.dudau@arm.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        lkft-triage@lists.linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Jul 2021 at 16:44, Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2021-07-30 15:34, Anders Roxell wrote:
> > On 2021-07-30 13:17, Robin Murphy wrote:
> >> On 2021-07-30 12:35, Anders Roxell wrote:
> >>> From: Robin Murphy <robin.murphy@arm.com>
> >>>
> >>>> Now that PCI inbound window restrictions are handled generically between
> >>>> the of_pci resource parsing and the IOMMU layer, and described in the
> >>>> Juno DT, we can finally enable the PCIe SMMU without the risk of DMA
> >>>> mappings inadvertently allocating unusable addresses.
> >>>>
> >>>> Similarly, the relevant support for IOMMU mappings for peripheral
> >>>> transfers has been hooked up in the pl330 driver for ages, so we can
> >>>> happily enable the DMA SMMU without that breaking anything either.
> >>>>
> >>>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> >>>
> >>> When we build a kernel with 64k page size and run the ltp syscalls we
> >>> sporadically see a kernel crash while doing a mkfs on a connected SATA
> >>> drive.  This is happening every third test run on any juno-r2 device in
> >>> the lab with the same kernel image (stable-rc 5.13.y, mainline and next)
> >>> with gcc-11.
> >>
> >> Hmm, I guess 64K pages might make a difference in that we'll chew through
> >> IOVA space a lot faster with small mappings...
> >>
> >> I'll have to try to reproduce this locally, since the interesting thing
> >> would be knowing what DMA address it was trying to use that went wrong, but
> >> IOMMU tracepoints and/or dma-debug are going to generate an crazy amount of
> >> data to sift through and try to correlate - having done it before it's not
> >> something I'd readily ask someone else to do for me :)
> >>
> >> On a hunch, though, does it make any difference if you remove the first
> >> entry from the PCIe "dma-ranges" (the 0x2c1c0000 one)?
> >
> > I did this change, and run the job 7 times and could not reproduce the
> > issue.
>
> Thanks! And hold that thought; if it works then I suspect it probably is
> the best fix, but I'll double-check and write it up properly next week.

I just want to send a friendly reminder to this issue, since I haven't
seen a patch for this.
We still see the issue on v5.13.y and above.

Or have I missed anything?

Cheers,
Anders

>
> Cheers,
> Robin.
>
> > diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > index 8e7a66943b01..d3148730e951 100644
> > --- a/arch/arm64/boot/dts/arm/juno-base.dtsi
> > +++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > @@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
> >                           <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
> >                           <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
> >                  /* Standard AXI Translation entries as programmed by EDK2 */
> > -               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
> > -                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > +               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> >                               <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
> >                  #interrupt-cells = <1>;
> >                  interrupt-map-mask = <0 0 0 7>;
> >
> >
> > Cheers,
> > Anders
> >
