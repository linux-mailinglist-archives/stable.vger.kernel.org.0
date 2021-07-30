Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA93DBB78
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 17:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbhG3PAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbhG3O64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 10:58:56 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B98C061385
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 07:57:40 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id f26so1136315ybj.5
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 07:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=37x8w0UYvLcVBgIUnWgo+PPV937yKLBY+SfU728blww=;
        b=Nh0DDzzSH9/W/vuSHcrfHS4tX6BVYIipubEgEk6nqQGRauR3Kjdmr4p6MwQRvyTzPa
         HZj8nWmjGVX/XgGv7lj5Wj0jzIQV+5G4nrJ6Cd/hFGGXEFJG9LaVCFnm/2ryaoNbm+fj
         BnX2OV8kicXKEWMO0asIm0Ao4WRkzZUXg0fwuoH6rlcsG7qZVgw7NuqF1YusYFYmbada
         zUvsgOnbni19kXc/c5UYuj1jJPlhp55fFRpZAK+pRtAJeJr6z4sp41VNBaKIgeCthe1h
         PXC0oGSMn8nywPNirdR99UIUfcNhydA3QjpWqui0nDN0f25yJPARQRoSwpxr+bZN5x6t
         63uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=37x8w0UYvLcVBgIUnWgo+PPV937yKLBY+SfU728blww=;
        b=oX3Ms5oHp69qUlENbDQA4GCSzry2oaU6r/Db5J4HjxbRrFYzA+YW15/nMFz9Wv4HIy
         zDLF2II1waiDfdIQyrsbMIskuvKBMyM9z3KMEZyQy2b6kx6enRJ6KsjNdMA5mkHfIOhR
         73OpVtIzCHBN2eBjTZwbI/4sUkVHcZK5ph4YCAb0OTHb3Hfs4UtneoDRWsf0WoAvV4zb
         I87jK0oCCKs4fQhJjq/G2L4bUzDxv65r1S2l8WaPt3Z4QAloXH2Je3sWE1LgXGt05ICk
         RsirowzYgfq8DiZSOC2dq5tt0enFmpDj+L0a3z8o4lSYYQKw9AgbROfZkc90n5dGBvHb
         pDpw==
X-Gm-Message-State: AOAM530tSkBsTehkZXP7CScyLYwCiL0IskCogXQhFmrWDqI+j0f1erFb
        iMQquNYHZMkk9/FR6zbHwiMErUvH3J51/diCZKnFhw==
X-Google-Smtp-Source: ABdhPJyWpTSfdHbBre+1lzAhAENFLLbKmABxKRKEbNWOSKpkoHZ+FO80HY+Ia/CDITLyxL0ubS/GvhoCNX1/Vxxnv2o=
X-Received: by 2002:a25:10d4:: with SMTP id 203mr3610734ybq.454.1627657060077;
 Fri, 30 Jul 2021 07:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com> <20210730143431.GB1517404@mutt>
 <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com>
In-Reply-To: <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 30 Jul 2021 16:57:28 +0200
Message-ID: <CADYN=9KV6u5ZTRWwpyNQt-FtnT3Fn0P6chQwodxOSg67_Qs7yg@mail.gmail.com>
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

Thank you Robin.

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
