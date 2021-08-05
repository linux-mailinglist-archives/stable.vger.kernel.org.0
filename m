Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FFF3E1A63
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhHERaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 13:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhHERaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 13:30:07 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E775CC061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 10:29:52 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id o20so8317742oiw.12
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 10:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=//g4i7dPmM5LMqLCjDXvcXRGd95uXE2vgn4qzLwU0SY=;
        b=PNO1jlvypvti+ViP9dl5Diewq2aHSsq40M5p0Wqa+L9WT+44MTQSg1X1U6nqPKtrLo
         079s+m7XLwWWSMFhtqT1UzXcfEuxXhvdEFz2UP/2pZyIXwWP1ip2DK6RToSOzK/QFqhv
         JN+I2kapp0zDV54QCVs0q3XJkFY4L6nBQFoqzIC4xzNvy2mN8Hx1yM49GYLUcwWTQc4C
         4owJPLl7VPJ0V94PRv50dCGkKAtAJkG0uz1zVkLYU4gEMFfre/4e3Ev4Vo4a+SI9hsbG
         MqtIqstPyq4m0Lfs/SLvy60Ts2nDq6oa3o+B3QSWXJgJyyEr/lhA4oAGmgtsOkFq784v
         K4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=//g4i7dPmM5LMqLCjDXvcXRGd95uXE2vgn4qzLwU0SY=;
        b=Lo+OerTguFojtDGxl2wkXfSDmL05WlGgNq1z5Lr/hbfVxCUh8KJEKkzkiF76vDLMsp
         vk+gwUNORZGzYWQROj3Ao+lCdQkRPXC3qEh39cYXzlns77FabXnpABQ0JRfpuG/NlTI8
         SUjSdCHjwW3bNFpjxDH11XVm77x0FCvCxbSHdbqsw+oTbyXlvId5JbgytXHam3ypozCm
         jdToGtHXx4FLIIe1yWYYNGs2mTn0d5aLTIpVnNl/Op8R2qifcuxeHcR2sxDm0h0ftEvG
         ZA5XdrsSdV6nWmY0pPIOwQegM1Ci/4pQf+tJAPO/gOAZfDkbP8sXzOpHy8Ja1H2c3ihT
         IpNw==
X-Gm-Message-State: AOAM532r3rl8ckv/PaE6fuLoscAw4PkKzJdQOnetFdUlNboLs1Khq5UB
        qc5M9+3sg0wcXdgopmLGFqs=
X-Google-Smtp-Source: ABdhPJxcW4dwR86PUIrvhW4r/RPUDG5pOXDxqMkHXvbE6yN5FiwYoSlyFDmiCBcH4y7+k8UDEIxZ1w==
X-Received: by 2002:aca:32c5:: with SMTP id y188mr10900993oiy.127.1628184592287;
        Thu, 05 Aug 2021 10:29:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n9sm1033267otn.54.2021.08.05.10.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:29:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 Aug 2021 10:29:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Willy Tarreau <w@1wt.eu>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <20210805172949.GA3691426@roeck-us.net>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <20210805164254.GG17808@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805164254.GG17808@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 06:42:54PM +0200, Willy Tarreau wrote:
> Hi Guenter,
> 
> On Thu, Aug 05, 2021 at 09:11:02AM -0700, Guenter Roeck wrote:
> > Hi folks,
> > 
> > we have (at least) two severe regressions in stable releases right now.
> > 
> > [SHAs are from linux-5.10.y]
> > 
> > 2435dcfd16ac spi: mediatek: fix fifo rx mode
> > 	Breaks SPI access on all Mediatek devices for small transactions
> > 	(including all Mediatek based Chromebooks since they use small SPI
> > 	 transactions for EC communication)
> > 
> > 60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
> > 	Breaks Bluetooth on various devices (Mediatek and possibly others)
> > 	Discussion: https://lkml.org/lkml/2021/7/28/569
> > 
> > Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.
> > 
> > I understand that upstream is just as broken until fixes are applied there.
> > Still, it shows that our test coverage is far from where it needs to be,
> > and/or that we may be too aggressive with backporting patches to stable
> > releases.
> > 
> > If you have an idea how to improve the situation, please let me know.
> 
> The first one is really interesting. The author did all the job right
> by documenting what commit this patch fixed, this commit was indeed
> present in the stable branches, and given that the change is probably
> only understood by the driver's maintainer, it's very likely that he
> did that in good faith after some testing on real hardware. So there's
> little chance that any extra form of automated testing will catch this
> if it worked at least in one place.
> 
> It looks like a typical "works for me" regression. The best thing that
> could possibly be done to limit such occurrences would be to wait "long
> enough" before backporting them, in hope to catch breakage reports before
> the backport, but here there were already 3 weeks between the patch was
> submitted and it was backported.

No. The patch is wrong. It just _looks_ correct at first glance. It claims
to fix something that wasn't broken. FIFO rx mode was working just fine,
handled in the receive interrupt as one would expect. The patch copies
data from the rx fifo before the transfer is even started. I do not
think it was tested on real hardware, or at least fifo receive transfer
was not tested.

The patch _does_ fix a problem on the transmit side, but the patch subject
doesn't mention that.

Guenter
