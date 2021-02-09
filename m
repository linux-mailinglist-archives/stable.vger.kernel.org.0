Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E693149DF
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhBIH7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBIH7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 02:59:41 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C88C06178A
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 23:58:59 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id r23so19243162ljh.1
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 23:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nvYr3UpVMJcspPgs92smoTgnsMh1VCW0bV8LvsobYYo=;
        b=PTS5aka1KohStwAU5+Gps+c4zkQiCj85UR26Vgmo6gQKkG7t2J+5d5hgJVySdMORoz
         944kjrRhLJYYDdkz9qf1vh/ztXdbs6a7RbFney1Maz9dUcn8Wsv981p8M+eT11QQxzdj
         xGodZQUfcAYqHiEhbdves1hZhIHJ6o+61VnMpEAu8UE+0FlyJfpNprfhneMUT0G2WkN6
         aoAV3/vQ/TFYrlafjpxXJBv1fxQjc4/5eyMVEt+xPenafiYunsPP6XBSGR2dXn278X9f
         5F/5I7eXgm5aM9StnDv9XSi3XaZyr/iKf88ekI4lGK47Z/SJuksWMs8WQVjLVc5F+WsF
         9SOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nvYr3UpVMJcspPgs92smoTgnsMh1VCW0bV8LvsobYYo=;
        b=baLzZs5rbLI54eM4agSmO1tMO7Je5L9XL9vSc+WRqoL2krax96tMdlhaPV/TbuNf3J
         8JxJgiE6P4W7WvFFNICoFWsznlGF0tHLwjSvK1EwmxHGBbBScZcmnJ7pD9v+qFYINrT2
         dC4tLhk57jmJ5GNkceON7hQjq4vzHiz+truN83WluWw/wDeZ1OL22B9PROT9sKEeVjf4
         q4fQqNXxjnQmkmeoO7S4T59fMVW0UuZZmbr0uRaXlGSCxg/9nyIucqnJF7hwBV/7EoyH
         UAYded5rhdY9Shws/Wi0y5eCOj/39YwK9mhThmEOoPbhcV1nwodN4APqATwjZpV6Oq++
         kaaA==
X-Gm-Message-State: AOAM530uMQVdwQcamua/EikGlsK6VqXf5uYO1BQmME/zZI0zIHMojN8D
        PIK/OttJWDWP/q/evNuPlhWpZFqwCUuG12YPXDL6xA==
X-Google-Smtp-Source: ABdhPJzyVOha9XmT9JUA0stVdq2FCGisCJUOITHdBXVCZOVheWKMIXAoOBJtz/eVi2kKilykxeYohCBUma3w/lrrYn8=
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr13363798ljj.343.1612857538176;
 Mon, 08 Feb 2021 23:58:58 -0800 (PST)
MIME-Version: 1.0
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
 <YCIym62vHfbG+dWf@kroah.com>
In-Reply-To: <YCIym62vHfbG+dWf@kroah.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 9 Feb 2021 13:28:47 +0530
Message-ID: <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com>
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        obayashi.yoshimasa@socionext.com
Cc:     hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Greg for your response.

On Tue, 9 Feb 2021 at 12:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Feb 09, 2021 at 11:39:25AM +0530, Sumit Garg wrote:
> > Hi Christoph, Greg,
> >
> > Currently we are observing an incorrect address translation
> > corresponding to DMA direct mapping methods on 5.4 stable kernel while
> > sharing dmabuf from one device to another where both devices have
> > their own coherent DMA memory pools.
>
> What devices have this problem?

The problem is seen with V4L2 device drivers which are currently under
development for UniPhier PXs3 Reference Board from Socionext [1].
Following is brief description of the test framework:

The issue is observed while trying to construct a Gstreamer pipeline
leveraging hardware video converter engine (VPE device) and hardware
video encode/decode engine (CODEC device) where we use dmabuf
framework for Zero-Copy.

Example GStreamer pipeline is:
gst-launch-1.0 -v -e videotestsrc \
> ! video/x-raw, width=480, height=270, format=NV15 \
> ! v4l2convert device=/dev/vpe0 capture-io-mode=dmabuf-import \
> ! video/x-raw, width=480, height=270, format=NV12 \
> ! v4l2h265enc device=/dev/codec0 output-io-mode=dmabuf \
> ! video/x-h265, format=byte-stream, width=480, height=270 \
> ! filesink location=out.hevc

Using GStreamer's V4L2 plugin,
- v4l2convert controls VPE driver,
- v4l2h265enc controls CODEC driver.

In the above pipeline, VPE driver imports CODEC driver's DMABUF for Zero-Copy.

[1] arch/arm64/boot/dts/socionext/uniphier-pxs3-ref.dts

> And why can't then just use 5.10 to
> solve this issue as that problem has always been present for them,
> right?

As the drivers are currently under development and Socionext has
chosen 5.4 stable kernel for their development. So I will let
Obayashi-san answer this if it's possible for them to migrate to 5.10
instead?

BTW, this problem belongs to the common code, so others may experience
this issue as well.

>
> > I am able to root cause this issue which is caused by incorrect virt
> > to phys translation for addresses belonging to vmalloc space using
> > virt_to_page(). But while looking at the mainline kernel, this patch
> > [1] changes address translation from virt->to->phys to dma->to->phys
> > which fixes the issue observed on 5.4 stable kernel as well (minimal
> > fix [2]).
> >
> > So I would like to seek your suggestion for backport to stable kernels
> > (5.4 or earlier) as to whether we should backport the complete
> > mainline commit [1] or we should just apply the minimal fix [2]?
>
> Whenever you try to create a "minimal" fix, 90% of the time it is wrong
> and does not work and I end up having to deal with the mess.

I agree with your concerns for having to apply a non-mainline commit
onto a stable kernel.

>  What
> prevents you from doing the real thing here?  Are the patches to big?
>

IMHO, yes the mainline patch is big enough to touch multiple
architectures. But if that's the only way preferred then I can
backport the mainline patch instead.

> And again, why not just use 5.10 for this hardware?  What hardware is
> it?
>

Please see my response above.

-Sumit

> thanks,
>
> greg k-h
