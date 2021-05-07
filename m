Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC50376357
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhEGKQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 06:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEGKQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 06:16:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA44C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 03:15:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id i14so6830981pgk.5
        for <stable@vger.kernel.org>; Fri, 07 May 2021 03:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CGNFptHLwlXmusZubY8G2EScKi7idPZtoLLDwWFQUTU=;
        b=GCfTHP3prbXvGrhNn96OkOFAcvCpkKiV47iA48pU7oT0afno7vtI5TKpzkScl9zDvG
         3nRLGMqY6ZrjI//BnhBWpejiqiue6DQFsQn+P3exMWm9JPoOQD9uop58F1jISUcdULa4
         k87VxfAh2mf8pX7saZXe/JkemXmjEMFzfLGeAA5ikvuGa2BkixAjcZ3JgGcu9lW7IkiY
         voh5WgtvpCii51A4gImR+BP8KwKLgqO8MMEurBfja//EVEV1NAJO0TCvQy1BIwX7ntkq
         txg/GI9WUhOHWSa5ddwtEFEgBoWhoUxmTdZKU97sUhuLLvq2XhfMUbas/+AhcVHTRmAa
         bOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CGNFptHLwlXmusZubY8G2EScKi7idPZtoLLDwWFQUTU=;
        b=ldbtIcooGMG/3YEZLRLJpGBDMrs9fEC4bp+C2z/yE/rFHXxq7x2A6H4bHCy7kU18X5
         Gq2nNugdTI3WqSc4BTeDdl3bZXedYMroa4WslRyCrFl0MCdg3rxXU9o0lPx5x4EBMx/v
         /yCHn9z2q5Da4mwgHslEQ5s3MAd4Rn4mX1qihNjSM/TfSBI2azPjGsqISNlK1F53pnLO
         uFLsdgFN2impzG0SU2aTQ08aB6zU0ixCV8j8dNounHpsNQFWFwuZErOFA8xEHiPNFTlF
         CMenYu1BFsDF4LAFBAAAzSk8ogvhE+PtyZ8uvOA0rxMW9fQCV0EpW7KkMKf5W4q1HdvJ
         WD/w==
X-Gm-Message-State: AOAM532+vsJ6jUzRQQ8gqfHn9fd45ENACyfeVogVaEF9q11kd8JlEEy0
        ErOKfNZY0ACPicH4ZQdOQsw+kn5bsWBy
X-Google-Smtp-Source: ABdhPJy/6XfquFMb9hz/doSqI5Ggb8gZtgoDRczm3Tf77oMaW/6kENMZZh3K6jijpcbjsHYTMh2ffg==
X-Received: by 2002:a63:5322:: with SMTP id h34mr9343864pgb.182.1620382511417;
        Fri, 07 May 2021 03:15:11 -0700 (PDT)
Received: from work ([103.77.37.184])
        by smtp.gmail.com with ESMTPSA id a18sm4424176pgg.51.2021.05.07.03.15.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 May 2021 03:15:10 -0700 (PDT)
Date:   Fri, 7 May 2021 15:45:08 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: MHI v5.13 commits for stable backporting
Message-ID: <20210507101508.GB5646@work>
References: <20210507080736.GA5646@work>
 <YJT3rOgd9WVvdRZl@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJT3rOgd9WVvdRZl@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 10:17:48AM +0200, Greg KH wrote:
> On Fri, May 07, 2021 at 01:37:36PM +0530, Manivannan Sadhasivam wrote:
> > Hi Greg,
> > 
> > As suggested by you in MHI v5.13 PR [1], please find the below commits that
> > got merged for v5.13 and should be backported to stable kernels:
> > 
> > 683e77cadc83 ("bus: mhi: core: Fix shadow declarations")
> > 5630c1009bd9 ("bus: mhi: pci_generic: Constify mhi_controller_config struct definitions")
> > ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use")
> > 47705c084659 ("bus: mhi: core: Clear configuration from channel context during reset")
> > 70f7025c854c ("bus: mhi: core: remove redundant initialization of variables state and ee")
> > 68731852f6e5 ("bus: mhi: core: Return EAGAIN if MHI ring is full")
> > 4547a749be99 ("bus: mhi: core: Fix MHI runtime_pm behavior")
> > 6403298c58d4 ("bus: mhi: core: Fix check for syserr at power_up")
> > 8de5ad994143 ("bus: mhi: core: Add missing checks for MMIO register entries")
> > 0ecc1c70dcd3 ("bus: mhi: core: Fix invalid error returning in mhi_queue")
> > 0fccbf0a3b69 ("bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue")
> > 
> > I'll make sure to tag stable list for future potential patches.
> 
> That's a lot, are you sure they are all needed?  Constify?
>

Filtered the patches now...

> What order should these be applied in and how far back should the
> patches be backported?
> 

Below is the order and stable kernel revisions:

6403298c58d4 ("bus: mhi: core: Fix check for syserr at power_up") #5.10
47705c084659 ("bus: mhi: core: Clear configuration from channel context during reset") #5.10
ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use") #5.10
8de5ad994143 ("bus: mhi: core: Add missing checks for MMIO register entries") #5.11
0fccbf0a3b69 ("bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue") #5.11
4547a749be99 ("bus: mhi: core: Fix MHI runtime_pm behavior") #5.12
0ecc1c70dcd3 ("bus: mhi: core: Fix invalid error returning in mhi_queue") #5.12

TBH I misunderstood that Sasha's bot will pick the patches based on Fixes tag
and the commit message, etc... and will apply them to respective stable kernels
based on trial and error. Probably I expected too much or I'm lazy :)

Thanks,
Mani

> thanks,
> 
> greg k-h
