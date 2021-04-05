Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34EA3547E1
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhDEUzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhDEUzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:55:48 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D3AC061756;
        Mon,  5 Apr 2021 13:55:42 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id x17so13279686iog.2;
        Mon, 05 Apr 2021 13:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pl2zZp1doMtSTurK4t2K/SYdeF+JJEMQaZ0JlLiuBg=;
        b=D8Rf66/lLIh1WUBvCEqNjZ3WXVXn1eGogGxvnOAnYlXhqjunF39UxzMoM0WC6+V+tT
         tp/8cXUjWc+7kaq9qDGA7cEB1hab9WmsOMPbFeU7sG4yx4U5GyIceTg2DHZV/yORK0wX
         6adZUF/tq4oqNy09B9I1QF7G6YAVnBH3onilFkf0M4NqRuJkkoa37tzjRP+lKrS128HL
         QMSDAJuoozMjIEloApGLSm52QfwXoqm8Pdn0+4cHK66fpjX7B0lxmYl1rYPnCsCRnsWa
         YTRfcZy0DmSZROzDoLPJTxZ6Oc9022Dpgo4BcFJWpM5dtOthg/dvk3zp9dYUJrfJwgLu
         69zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pl2zZp1doMtSTurK4t2K/SYdeF+JJEMQaZ0JlLiuBg=;
        b=pLRtb5DE39ly2F/Ak/fhSe2e/in0x09vrpOx+XUzkTMsEHHQ7F5EA2Y5yi4qYZ28ca
         0UFTRqpw37Uz4tch23qF7T3YLh6fIk42yQIOhZGyh1dSTyyHYcZBCSW9nLpR34xFisoM
         luS+z6hlSp7IEhhb4ba3SBT19D2UKP3YYbCMbHfOS/v+J/jeTVDjOQdlQc1Uit8Ly3u9
         A/RPSMA8Giw3TsHZAjkntTxUlc9YY4nzWb4obQwGXZO2KONn4YZl0iAHN/arFMJxJlOD
         u7jYcaG5JZ9MW9BQgZepn/nPbE1yviVLgMC20hUV8lyt1mzaLPqIj1C6UyuNE6WV6ZHT
         5SVA==
X-Gm-Message-State: AOAM530nSLgByRJrqSrBukG4TMOX88ku9MJFb4Wntvg3X+37XXtd2ffO
        TXsuyfVdQM+VLjL5ZDyepDfmVgtJBCe0hfnGUiI=
X-Google-Smtp-Source: ABdhPJwnu0V3PtTwT2C7foXC/kfe25JyBEml2UQhZ1Oa0qeiPg/w0Snj0rQr01eCXlPS+fGI+4w/sfLu8CqCgXe8VCQ=
X-Received: by 2002:a5d:848a:: with SMTP id t10mr21442006iom.68.1617656141715;
 Mon, 05 Apr 2021 13:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
 <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com> <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
In-Reply-To: <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 5 Apr 2021 13:55:31 -0700
Message-ID: <CALCv0x0sSxdoLbqc9srSYWQQAZ56pgcWY1=3pDuCgeiNWO3Nmg@mail.gmail.com>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 5, 2021 at 1:19 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Mon, Apr 5, 2021 at 1:10 PM Ilya Lipnitskiy
> <ilya.lipnitskiy@gmail.com> wrote:
> >
> > Hi Saravana,
> >
> > On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> > > <ilya.lipnitskiy@gmail.com> wrote:
> > > >
> > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > not configured by #gpio-cells and can't be parsed along with other
> > > > "*-gpios" properties.
> > > >
> > > > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > > > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > > > here.
> > >
> > > The only example of this that I see is "snps,nr-gpios".
> > arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
> > parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
> > drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
> > "nr-gpios" without any vendor prefix.
>
> Ah ok. I just grepped the DT files. I'm not sure what Rob's position
> is on supporting DT files not in upstream. Thanks for the
> clarification.
For the offending drivers and docs that don't have any dts/dtsi files
in-tree, can we just "sed -i 's/nr-gpios/ngpios'" and call it good?

> Looks like even the DT spec has an exception only for vendor,nr and not just nr.
> https://github.com/devicetree-org/dt-schema/blob/master/schemas/gpio/gpio-consumer.yaml#L20
Thanks for linking the spec. I can re-spin the patch with ",nr-gpios"
as the special suffix to align with the spec.

Ilya
