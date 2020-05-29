Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F031E8684
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 20:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgE2SVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 14:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2SVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 14:21:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3753C03E969;
        Fri, 29 May 2020 11:21:35 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q11so4904573wrp.3;
        Fri, 29 May 2020 11:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLXiRl9cDcJQQ+j3BIvVxaRM9eyFQUW8oMYbC//hTWw=;
        b=PIRjTM/zhFET505J1F3i/uxUINJAWq4DGpG+4MDw7UUdtGHRdWRjEcwI+wUmHNLTxS
         TeJ57bVYgy7g7YWqz0QEqGLeOhy48OT+abnt80YRuB9NEh9hwLW4Oip4xnbft2jigjWg
         H6Wbz5Z51JFFnwgpf37EHIOLMY9PIe8oRQXLZWnun4JajK/2AHp/9QXMNlaPci+lBMD/
         xiQhKppYZS7t2k3+h1fgYhidRH8U2BcIDqRt4SnS6hmNv7HuuRgO4zGuf7ZayV+SsZNc
         d7VuIlwWe729P0Gz2OrcrxiyQYicBlctjgKpveJrIQ/OaxrAsbn3QE00QCTANTbHxCsE
         ixkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLXiRl9cDcJQQ+j3BIvVxaRM9eyFQUW8oMYbC//hTWw=;
        b=N/6+GYh7E2Fzc1Lf+PbQauhIxws6nXgV+IUPQHoG7ZOjOrj4gCXFJS//b6lh1b0NnY
         +WNB84oT9vGPkq5njkZ2tQuMBVuVW+M4jxtk5QU0c7e3XD1CLKMM7rqyNHSKYjkKtly8
         wEG8jgMS+Z9Sf8arEjp9LlPcQTw16d8B4bQay1SWRNB7dAK92TqxTJDVkgQPiUljOvva
         0ARLTUukiD+IaGOD1gKzXBtlb8UzTmc6iD/6fsTCDERc8nJm8cEdhCzSJbNFZ8wEY/yG
         xMlGfmbmNEqGkSCPFBlRMltRRPZSCG9TrzNpG6T2VyOyXRnFx1DfynLi1ngah1gVbk4O
         2ZRw==
X-Gm-Message-State: AOAM533OwSQRi7Q9ox6fEZLslLG2D4FtWpKDktEYQ9f1FzcCnn14lGIo
        gMOsAzkVEXPn3kmoSPxRnTfG4mkHb2GDa8iKx5zFhoDp
X-Google-Smtp-Source: ABdhPJzZfyp8e713uokhnlncAGKpGbSODS17oXrNKjcyEh7Rq/5hnnoiflVwEml34+J+6mfTf9ifb+Y1QFXG23w6V7k=
X-Received: by 2002:adf:9f0b:: with SMTP id l11mr5759898wrf.66.1590776494740;
 Fri, 29 May 2020 11:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com> <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
 <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com> <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
In-Reply-To: <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
From:   Frank Mori Hess <fmh6jj@gmail.com>
Date:   Fri, 29 May 2020 14:21:23 -0400
Message-ID: <CAJz5OpdMDumfdYC+aj0N20p4qVEkEkHhNY3uKest6RSpPtrDWQ@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Doug Anderson <dianders@chromium.org>
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 1:53 PM Doug Anderson <dianders@chromium.org> wrote:
> >
> > I don't get it.  A hypothetical machine could have literally anything
> > sharing the IRQ line, right?
>
> It's not a real physical line, though?  I don't think it's common to
> have a shared interrupt between different IP blocks in a given SoC.
> Even if it existed, all the drivers should disable their interrupts?

I don't know, it's a hypothetical machine so it can be whatever you
want.  The driver requests shared irqs, if it doesn't actually support
irq sharing, it shouldn't request them.

> > Anyways, my screaming interrupt occurs after a a new kernel has been
> > booted with kexec.  In this case, it doesn't matter if the old kernel
> > called disable_irq or not.  As soon as the new kernel re-enables the
> > interrupt line, the kernel immediately disables it again with a
> > backtrace due to the unhandled screaming interrupt.  That's why the
> > dwc2 hardware needs to have its interrupts turned off when the old
> > kernel is shutdown.
>
> Isn't that a bug with your new kernel?  I've seen plenty of bugs where
> drivers enable their interrupt before their interrupt handler is set
> to handle it.  You never know what state the bootloader (or previous
> kernel) might have left things in and if an interrupt was pending it
> shouldn't kill you.

It wouldn't hurt to add disabling of the dwc2 irq early in dwc2
initialization, but why leave the irq screaming after shutdown?  If
there is another device using the same irq, it will generate unhandled
interrupt backtraces and get its irq disabled when the new kernel
requests its irq, if the device's driver is loaded before the dwc2
driver (assuming the new kernel even has a dwc2 driver).  The dwc2
driver in its current state will generate unhandled interrupt
backtraces by itself until it registers the right handler.

-- 
Frank
