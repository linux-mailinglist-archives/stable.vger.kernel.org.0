Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E234355DE6
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhDFV2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 17:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhDFV2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 17:28:46 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD79C06175F
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 14:28:38 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 11so9251582ybe.8
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 14:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=93yVXSM6Z8yACC6T5NYCS2RKgdWKzz8qPTNXWqHtpis=;
        b=YJeomDOZXDxp8j+Kg88CuTUoLUzWCMtguBHYlxo/4yvoAWRe0nvIbWZ1f45dSXHasa
         CE6J1dl0gomfw+UqxQiSCq5pepoLVHX+BneNbu9XLH4XKht9XsNvvbCYHSMA4bhOnQwp
         My+Rx4A0LBFGxUKMj50Dv06q30I3w5BMHBzGOQS/p7mZkt6Mh0yM7zIGwCnf3c9if9gd
         Ud5gKCokCSpAhHKYtyEoeqgcbU0yon7dHi6YlcPaGNiE5jhckFUfb81SitDOEIFQQhqa
         cumXaER0gopeJ5RWMvuxnaORpm7WXMP3bNfiMTChlgj8YhnHKjox+WhKW+n/q3E9uSge
         DsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=93yVXSM6Z8yACC6T5NYCS2RKgdWKzz8qPTNXWqHtpis=;
        b=jJuFFvDMNrbb/x1XInu1oHw7/rWDpV7YOsfPUGW43t+3dmL+LH8mLQSQB1nMNPNdKp
         0pq5uuGHUDjcersB9DvGfjY2eYuSEjrnVREPcjv469jYpvLJU0oLLN6VqXccPouZMeW8
         PH0BL6Yx2VT23SKTlM+EgFpXlBhIFlTaCgoAdwavT2YXCKoqFT90/acSIyViyiBZPEJV
         v6yUMY6pJFDTVXnyYyCjgHgf5qolPehNqDuOrTTxNa27AR/H+jSqs/EuliV1DDY+jaor
         k0fW84IFyWkRojo6at4g796cxT+Tt4qoSkm6kXCsHNj1wTu+vK3IyCgpwQqau/zuYZtI
         z+Qw==
X-Gm-Message-State: AOAM532SSgr7n8UIHthsZRTP0MC8JlC2AKue4Kto/mKe+oAYyGZPF3pV
        XU0mDB1D3TuiGOpk1JcsrH8k/FoIYjHjQcYZdg1Dlg==
X-Google-Smtp-Source: ABdhPJy/Y1EYV6sRSPCA3hja/J8mkWH6rU2d/pFcqsQTWTQ8uCNTn5P19KuoemUzWYpTV+0lXYV/ETi4IJr2yJPlBc4=
X-Received: by 2002:a25:c985:: with SMTP id z127mr187370ybf.20.1617744516682;
 Tue, 06 Apr 2021 14:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
 <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
 <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
 <20210406174050.GA1963300@robh.at.kernel.org> <CALCv0x2D6Y78XK7aeyyivcXqXZreHZd3kJc49tvtHx9eX+YH2w@mail.gmail.com>
In-Reply-To: <CALCv0x2D6Y78XK7aeyyivcXqXZreHZd3kJc49tvtHx9eX+YH2w@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 6 Apr 2021 14:28:00 -0700
Message-ID: <CAGETcx8aWReU=bv7FEujQGmJy91CORNQo6nY8x0+T3fOiN3YFQ@mail.gmail.com>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 6, 2021 at 12:28 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> On Tue, Apr 6, 2021 at 10:40 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Mon, Apr 05, 2021 at 01:18:56PM -0700, Saravana Kannan wrote:
> > > On Mon, Apr 5, 2021 at 1:10 PM Ilya Lipnitskiy
> > > <ilya.lipnitskiy@gmail.com> wrote:
> > > >
> > > > Hi Saravana,
> > > >
> > > > On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > >
> > > > > On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> > > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > > >
> > > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > > "*-gpios" properties.
> > > > > >
> > > > > > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > > > > > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > > > > > here.
> > > > >
> > > > > The only example of this that I see is "snps,nr-gpios".
> > > > arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
> > > > parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
> > > > drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
> > > > "nr-gpios" without any vendor prefix.
> > >
> > > Ah ok. I just grepped the DT files. I'm not sure what Rob's position
> > > is on supporting DT files not in upstream. Thanks for the
> > > clarification.
> >
> > If it's something we had documented, then we have to support it
> Do I read this correctly as a sort-of Ack of my proposed [PATCH v2] in
> this thread, since it aligns the code with the published DT schema?

He's talking about the DT binding documentation in the kernel.

I interpret Rob's reply as, you can do all of this:
1. Just fix up all drivers that use "*nr-gpios" that don't have
binding documentation in the kernel. Change them to use ngpios.
2. Try to switch away old defunct ARM server DTs from nr-gpios to
ngpios (both drivers and DT) and see if people notice.
3. Change the fw_devlink parsing code to have exceptions only for
cases that are using nr-gpios after (1) and (2).

-Saravana
