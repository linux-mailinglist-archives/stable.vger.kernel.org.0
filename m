Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F277F354784
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbhDEUTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbhDEUTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:19:45 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE8FC06178C
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:19:33 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 82so3138054yby.7
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNHHnGDUPv1W2tiXmyfqQp1aOeyCQQoH/Xe+VtubBAs=;
        b=oSLTOu0u41YhlObLoq5obB4ekFQ3Z3fcQb0Ot7gmmQZHayIGAuJvBtuC7aFngzqOQW
         5spxlVGGNmWNP3wfJtzbTS87zoDGbT2tsr4sfBGtT/vnxKFZ0hwLUVNBKqDhucMZiiDh
         pxekwzSD6pP9C/5s7ZPGhp784NHolaZpX+esyumnSMjYOoRcCjeR+s/6FR1Nr6giaJKa
         sb//uK/pYISZhU8leyfwj6QrnHN/RVAaZMeu8Mx5MoComp2FFypkym3stu/txLtm/JR9
         Op0f5GihUL94iWUxm1XRsiVz+XZF0Bez8eRX3rn9r7r6iE2s/LfwfcosZOTHJqIG3aWc
         zgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNHHnGDUPv1W2tiXmyfqQp1aOeyCQQoH/Xe+VtubBAs=;
        b=un5ZUFBffOliCUPCejq3E4GAazsHTSjQzEdDBp/AP2mm8RfRaA881v3GjMLVcrVNn8
         +49YNN8y91R8ZjwtnR5JXj6tt/MfXFuLSvEfZm0uF/AZdTJtsCaGilv/UD1QyQQmPkGI
         NTD7F1TDO8hUJsweomQVnUQ6QVTMelc8PICHxjwXGcYP8y+QkD0IYB69lC3KKovbTgRr
         hWPROtkFTyb9YtV6FXxaMisC0sCKo2rLk1z4RDqYIl9ViBDpcVMb8pzdlY7Lvnv/o6Qz
         9Tf7S8moKsnasLVoCUCFK/1iaQ6lZqM7URfZQkiWPA7zyd3Fe6I83+nnuvWznN6V6dGX
         zJeA==
X-Gm-Message-State: AOAM530nUoN//D/WLs2C4LnCFNjCCesCF1gwyRMRoamNlRt0VsiLY2DY
        6k64J39TMl7cC+XyWFkFbKs1IfTUTLT+f2cUwMfmXQ==
X-Google-Smtp-Source: ABdhPJw/6g7Wi6AMuJUE0lijYmJfVHDAMCULfy+zD9/bWyL7Cmgklq7B2AJrK3HthQieUtp+G6LUaBY+uieDcih0wuU=
X-Received: by 2002:a25:58d5:: with SMTP id m204mr37228676ybb.32.1617653972190;
 Mon, 05 Apr 2021 13:19:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com> <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
In-Reply-To: <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 5 Apr 2021 13:18:56 -0700
Message-ID: <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 5, 2021 at 1:10 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> Hi Saravana,
>
> On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> > <ilya.lipnitskiy@gmail.com> wrote:
> > >
> > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > not configured by #gpio-cells and can't be parsed along with other
> > > "*-gpios" properties.
> > >
> > > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > > here.
> >
> > The only example of this that I see is "snps,nr-gpios".
> arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
> parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
> drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
> "nr-gpios" without any vendor prefix.

Ah ok. I just grepped the DT files. I'm not sure what Rob's position
is on supporting DT files not in upstream. Thanks for the
clarification.

> I personally don't think causing regressions is good for any reason,

I agree, but this is not a functional regression. Just a warning
that's spit out. I don't have a strong opinion on the stack dump vs
not, but I think we should at least reject future additions like this
and limit the exceptions to exactly what's allowed today. nr-gpios
(without any vendor prefix) is especially annoying to me.

Looks like even the DT spec has an exception only for vendor,nr and not just nr.
https://github.com/devicetree-org/dt-schema/blob/master/schemas/gpio/gpio-consumer.yaml#L20

-Saravana

> so I think we need to fix this in stable releases. The patch can be
> reverted when nr-gpios is no longer special. The logic here should
> also be aligned with scripts/dtc/checks.c, I actually submitted a
> patch to warn about "nr-gpios" only and not "nr-gpio" in dtc as well:
> https://www.spinics.net/lists/devicetree-compiler/msg03619.html
>
> Ilya
