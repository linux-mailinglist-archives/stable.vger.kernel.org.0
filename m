Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9998EE5A7
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 18:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKDRQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 12:16:10 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37300 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfKDRQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 12:16:10 -0500
Received: by mail-io1-f67.google.com with SMTP id 1so19354420iou.4
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 09:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0fib82W+BkrhzwWy6AZrzSWTczIlx/uSuolJeAsrHk=;
        b=df2Yw2xaw1YF1xgf5HzdylLEGmLHPjYYyxcXdQ7C/WKLENjPrrkB1nFnpeNFWuJa+u
         hNC0HtdjZYOxKPgcJwJZczMrMhs+d0yETh0mGhEYFKVVSKjf1m0UFoHnrQ5xaRSdLpP1
         5tJ5PONqOAUjklCPeVWBmNNve3U21SimXsGgfqofC6aveNuY8MZ4CJte07qHXbvhw5IF
         Cixg8tNunNYl7wB6jtnjv2i38UM0VsuT/GYZ7WjWn6lCpJaV5ZECVFgeJLZ2wP8++JKZ
         Dps2ztIvJGShxhYaMONUA7KANJhEryUCrvT6UFiq47lV6Qs4pvlbtceE7VWl1BDtghDY
         jCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0fib82W+BkrhzwWy6AZrzSWTczIlx/uSuolJeAsrHk=;
        b=Hv0N1hARwtQ3QGrjxu7B9M5LyfPqIQAfgdaKj0u2LeVUhHO0ExJzY/CG8Bw1aKLDcO
         qXp6KaQnI8XeyqXaQgvH9g2m3toC+AotLxLU4lUR7kFF0gzphTfR/E/q35VCSIl5PeQM
         kvGgqEdfIzLr9gC41mwIAMZnu80ADF6pwz8KEldiXJVTD5/SvDDEBmHjmDHQ137/xH9N
         CCFe23lXiBY6qIWh5zaxI3ISoIeS2zKqAvJ7zgwRg/8hPJq/HU+VFoHoYF2Jc9iyQaTS
         TZVpWg6qCOmoUvq2p1QA45XowBn9AeCi4ervNoePIJt8DF0Y3RVe/DCyFEAu2NzqTYr/
         fTLQ==
X-Gm-Message-State: APjAAAXBbHme5ntkxHGiN1CqdTWuAZltzZ1yUPZuPuN4UHZsn0yY2GKW
        LGPztzO90k/2ajF34MYDoH4PFDHKDkxzXFqK6YA=
X-Google-Smtp-Source: APXvYqyCYR6/esEUEalepW0YBmm3JprI4N6JTQU0rk+wZMkNHplc/vx0ruW8GyZE4kNVXXJ3j00b4ML+JADLIquio9Q=
X-Received: by 2002:a5e:9e07:: with SMTP id i7mr931089ioq.42.1572887769912;
 Mon, 04 Nov 2019 09:16:09 -0800 (PST)
MIME-Version: 1.0
References: <15728601263783@kroah.com> <20191104140713.GE4787@sasha-vm>
 <CAOCk7Nr+-=oFMQp+sHzUbYEE0AP0W+uwTRsezMJiJtt9Fhmifw@mail.gmail.com> <20191104171234.GF4787@sasha-vm>
In-Reply-To: <20191104171234.GF4787@sasha-vm>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Mon, 4 Nov 2019 10:15:59 -0700
Message-ID: <CAOCk7NoX4Svh=GobGsV9DmZ7AV6Mzy_t57=iSpEx64ySfY4Csw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] dmaengine: qcom: bam_dma: Fix resource
 leak" failed to apply to 4.14-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, vkoul@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 4, 2019 at 10:12 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Nov 04, 2019 at 07:39:58AM -0700, Jeffrey Hugo wrote:
> >On Mon, Nov 4, 2019 at 7:07 AM Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> On Mon, Nov 04, 2019 at 10:35:26AM +0100, gregkh@linuxfoundation.org wrote:
> >> >
> >> >The patch below does not apply to the 4.14-stable tree.
> >> >If someone wants it applied there, or to any other stable or longterm
> >> >tree, then please email the backport, including the original git commit
> >> >id to <stable@vger.kernel.org>.
> >> >
> >> >thanks,
> >> >
> >> >greg k-h
> >> >
> >> >------------------ original commit in Linus's tree ------------------
> >> >
> >> >From 7667819385457b4aeb5fac94f67f52ab52cc10d5 Mon Sep 17 00:00:00 2001
> >> >From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> >> >Date: Thu, 17 Oct 2019 08:26:06 -0700
> >> >Subject: [PATCH] dmaengine: qcom: bam_dma: Fix resource leak
> >> >
> >> >bam_dma_terminate_all() will leak resources if any of the transactions are
> >> >committed to the hardware (present in the desc fifo), and not complete.
> >> >Since bam_dma_terminate_all() does not cause the hardware to be updated,
> >> >the hardware will still operate on any previously committed transactions.
> >> >This can cause memory corruption if the memory for the transaction has been
> >> >reassigned, and will cause a sync issue between the BAM and its client(s).
> >> >
> >> >Fix this by properly updating the hardware in bam_dma_terminate_all().
> >> >
> >> >Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
> >> >Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> >> >Cc: stable@vger.kernel.org
> >> >Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gmail.com
> >> >Signed-off-by: Vinod Koul <vkoul@kernel.org>
> >>
> >> Is the "Fixes:" tag correct here? Is it an issue without 6b4faeac05bc
> >> ("dmaengine: qcom-bam: Process multiple pending descriptors")?
> >
> >Yes.  The issue will occur, even if you submit only one descriptor.
> >The uart_dm driver which exposed this issue (msm_serial), only uses
> >one descriptor at a time, despite the hardware and some versions of
> >the bam driver allowing more than that.
> >
> >A trivial way to trigger this would be to queue a descriptor to
> >receive data from some peripheral that is attached to the BAM dma
> >engine, but the peripheral never sends that data - ie if you had a NIC
> >and you wanted to prequeue a receive buffer to accept an incoming
> >packet.  If you then invoke terminate_all(), perhaps you need to
> >renegotiate the link speed of the NIC, you'll hit the same issue -
> >with or without "Process multiple pending descriptors".
>
> In this case I'll happily take a backport of this patch :)

I'll see what I can do in the next few days.
