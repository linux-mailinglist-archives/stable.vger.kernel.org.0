Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507A4355C2B
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 21:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhDFT2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 15:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhDFT2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 15:28:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD4DC06174A;
        Tue,  6 Apr 2021 12:28:32 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c18so7540010iln.7;
        Tue, 06 Apr 2021 12:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+9IBnnDWwF5bA/uOPxMCh5R3le9aBNY4U0lwaK9R/w=;
        b=adwamlucztIc0MSna8H9oes/oLiAN/OySUHgtAuhHRvhxzetLmHo+Z+cpsbZhOWVAF
         +2Ez3O5x2unjOXI13majOCOiPDDxnoUhDE23FnNiWrswHIP6eguB05bX4vYKY2VceHHE
         Zm+RoO9NaFqEi6o/+4E/3kld2u8Pt6ik8o1DE2+T0XTYXBISrn+I9AXK0I+aT20FxVGZ
         BjOvdipncmX3hHTQj0OzNap6+BHa9Hqh4IBMyGT6wcmPismEK3DWjZ7PK0Z4BjSpQRBF
         U+NyMR1h8a3+mnsD97AF+Gj/xqpUJVAHS3YNAngIDvGnXltCtLloDRbB3kHUNgFMSUWi
         3bkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+9IBnnDWwF5bA/uOPxMCh5R3le9aBNY4U0lwaK9R/w=;
        b=eEd8oeWLPGUENSvKfkYfX72MiCL2XYdO/LQw7bdR0xhQAFDju6mjPXpJ/OIBWzqAAy
         Cbz55FXWN2fzSYFTXKWoMSrfEnCfOpT+Vo8Z0b2paTbtRR4qbSOhGhNO1UJ6P8TNw6S/
         MyHy86ygl6fHgC3XB4JLoGb82nPyo9UnvUbP1JmXr9UyjtHU8EoHsPAnNHU0T5xw8gU3
         lqrAWoFWhRolVchyjSFASc9gQYFYE93kUJpd0cop1mQODPzmaiXiRXMGV0g0np804iZF
         2O2IrwhOnsdlGoBOiNxTMG/4wgXYo9WzP8Sdh5UkCTMSCFG7t/AXtUKTZ3pjCLNlYXD9
         KEfw==
X-Gm-Message-State: AOAM530h0vC3xu/UxBAZqXPL84ckqo6cMK4tyEtHYPjAH1UtgqmR955H
        41IbMR8el9+aTocZuVj1IdN+sMuWCNYs0b31Y2Q=
X-Google-Smtp-Source: ABdhPJyqK17Dv9uOZS3bqIAfHhKcyL5NNUmYoe+6UcKRBsMoIbFQeSZA1n50HL6M3lTekmKnkesydMWPsOqyv/i/Qmk=
X-Received: by 2002:a05:6e02:ec9:: with SMTP id i9mr5379002ilk.0.1617737312092;
 Tue, 06 Apr 2021 12:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
 <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
 <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com> <20210406174050.GA1963300@robh.at.kernel.org>
In-Reply-To: <20210406174050.GA1963300@robh.at.kernel.org>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Tue, 6 Apr 2021 12:28:21 -0700
Message-ID: <CALCv0x2D6Y78XK7aeyyivcXqXZreHZd3kJc49tvtHx9eX+YH2w@mail.gmail.com>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
To:     Rob Herring <robh@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 6, 2021 at 10:40 AM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Apr 05, 2021 at 01:18:56PM -0700, Saravana Kannan wrote:
> > On Mon, Apr 5, 2021 at 1:10 PM Ilya Lipnitskiy
> > <ilya.lipnitskiy@gmail.com> wrote:
> > >
> > > Hi Saravana,
> > >
> > > On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
> > > >
> > > > On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > >
> > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > "*-gpios" properties.
> > > > >
> > > > > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > > > > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > > > > here.
> > > >
> > > > The only example of this that I see is "snps,nr-gpios".
> > > arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
> > > parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
> > > drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
> > > "nr-gpios" without any vendor prefix.
> >
> > Ah ok. I just grepped the DT files. I'm not sure what Rob's position
> > is on supporting DT files not in upstream. Thanks for the
> > clarification.
>
> If it's something we had documented, then we have to support it
Do I read this correctly as a sort-of Ack of my proposed [PATCH v2] in
this thread, since it aligns the code with the published DT schema?

Ilya
