Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345E13DBAAB
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbhG3Oek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbhG3Oek (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 10:34:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BC4C061765
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 07:34:35 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id r26so18357795lfp.5
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 07:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xSgqIVTtq5UONijeW+mzTphiez5rc1w48HNnCIiwK84=;
        b=CIyiRXRGYHuk3LmHN8018NyKnwACKK2uN9BmxalIleHZbaCPFsCOS+oUNFprtCg7zt
         RIUgF1GRBP2cLt3ebJuYHaiVfdrVp8Lt4e1d5B70En0EKGvklb1KWCSg24tgBv+GipsI
         sTQkJ/zjPwuINbfBo/Xt+eCVFWQ/A2UA7iz+8uaMXrzCGyDH78zwjQOIyRgS87O3bF4k
         VXMJ9dazIl1Jlz9W+9T4UA7OmukOb/FZ1gDlAqUWZUPTWCtDHZ4KpDnBxu2uk210HxQH
         LxXgbCVedqpGd4LyNcPGie9cebzvWMQWpVxc5dMEw5f5YTmxd/rYu5b15Yr4iITAtdUK
         MtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xSgqIVTtq5UONijeW+mzTphiez5rc1w48HNnCIiwK84=;
        b=AnOJrkj9vN91+qGpxmSolf9UDZ/v9FkswxwyLAtQPBUy2KNja/cy3p8euKpRLNReBu
         uzsNou+BtLWqC40ImLxxeCYnimNa5tZG5jMpZLAY0gWsTDZgZ1W89346CpuLCoMa+SgD
         UX57xlz9D6BELLs2pbp0HzOvBFdpZpUxvy3kLG75KFb6FXLf1+vatP4FHc2SCuapwM54
         uoKBnRosXbQUUUkOFS2aFA7oic/UrgLR1PqNcRtG+6NndQKTTW7wlnrIvJq/HtLTldSl
         sPg3KrbDm8fyT4aq0kEkoS0yyTYTGAKUYxUkXwbp833hW213G96YuJgSlKtX7AmzaGfI
         GKiQ==
X-Gm-Message-State: AOAM532rYxn1v02ziDHoEqxrJHxEJRNwxEzzO2XumWALD8ETrwlsengi
        jsLv7aJ12ugL9qOP/0DKDDRRUg==
X-Google-Smtp-Source: ABdhPJwlX395sRsAy1IIc1TyNBLG9nnDiLvGWmkSVsix4XNfHBArxDCsXYQAR2sV5kpMymcVSb6mfg==
X-Received: by 2002:a05:6512:128e:: with SMTP id u14mr2054793lfs.483.1627655673490;
        Fri, 30 Jul 2021 07:34:33 -0700 (PDT)
Received: from mutt (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id v4sm165462lfd.172.2021.07.30.07.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 07:34:33 -0700 (PDT)
Date:   Fri, 30 Jul 2021 16:34:31 +0200
From:   Anders Roxell <anders.roxell@linaro.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     sudeep.holla@arm.com, lorenzo.pieralisi@arm.com,
        liviu.dudau@arm.com, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org, arnd@arndb.de,
        lkft-triage@lists.linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
Message-ID: <20210730143431.GB1517404@mutt>
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-30 13:17, Robin Murphy wrote:
> On 2021-07-30 12:35, Anders Roxell wrote:
> > From: Robin Murphy <robin.murphy@arm.com>
> > 
> > > Now that PCI inbound window restrictions are handled generically between
> > > the of_pci resource parsing and the IOMMU layer, and described in the
> > > Juno DT, we can finally enable the PCIe SMMU without the risk of DMA
> > > mappings inadvertently allocating unusable addresses.
> > > 
> > > Similarly, the relevant support for IOMMU mappings for peripheral
> > > transfers has been hooked up in the pl330 driver for ages, so we can
> > > happily enable the DMA SMMU without that breaking anything either.
> > > 
> > > Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> > 
> > When we build a kernel with 64k page size and run the ltp syscalls we
> > sporadically see a kernel crash while doing a mkfs on a connected SATA
> > drive.  This is happening every third test run on any juno-r2 device in
> > the lab with the same kernel image (stable-rc 5.13.y, mainline and next)
> > with gcc-11.
> 
> Hmm, I guess 64K pages might make a difference in that we'll chew through
> IOVA space a lot faster with small mappings...
> 
> I'll have to try to reproduce this locally, since the interesting thing
> would be knowing what DMA address it was trying to use that went wrong, but
> IOMMU tracepoints and/or dma-debug are going to generate an crazy amount of
> data to sift through and try to correlate - having done it before it's not
> something I'd readily ask someone else to do for me :)
> 
> On a hunch, though, does it make any difference if you remove the first
> entry from the PCIe "dma-ranges" (the 0x2c1c0000 one)?

I did this change, and run the job 7 times and could not reproduce the
issue.

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 8e7a66943b01..d3148730e951 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
                         <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
                         <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
                /* Standard AXI Translation entries as programmed by EDK2 */
-               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
-                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
+               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
                             <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
                #interrupt-cells = <1>;
                interrupt-map-mask = <0 0 0 7>;


Cheers,
Anders
