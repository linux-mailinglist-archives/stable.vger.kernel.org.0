Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCF354768
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhDEULF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhDEULF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:11:05 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8833DC061756;
        Mon,  5 Apr 2021 13:10:58 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c15so2315872ilj.1;
        Mon, 05 Apr 2021 13:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yipPMaEHRBCVVLHFCEOHBoiBt4r0IqzPMd/p47fHFz8=;
        b=kXRuxDPCx2X1t6vPGgEQFce+rxUsWibPfNujCMhY4lrrhQE2hFCAksFpimzWUkV8gf
         b5i+XTx2jDeLrvQ0DCzyjwr1rq93K7ht8MaA+IkzzaNkQinH6zsNLhFSWHH0bvz1eCCV
         MMbzEK6fqiM5u1B6dydC80VAvqHepjKH2CxZFG4rTrwGrCIQCXVq27AQSO1he18AJNDz
         B1BskbqyayR3s2CezqEx3UDeBs9EXauCjDhD777+34ZcM52FpMWaN/OAhdW0kwr3czLy
         CPw+TTKpzmxwWHj5WyYP79ynDgHYuit9zBHjvQihnehwTSCLoqbDEpWMhJs/FKYz+hZ9
         WW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yipPMaEHRBCVVLHFCEOHBoiBt4r0IqzPMd/p47fHFz8=;
        b=kSWIbuNiiXU4a5y00kxdVjAdpubCUvuol1KPFjZCkiObVHrFjRvyQYyuZ8jq1OIB3f
         NjJINhOwN8womnGIAeuRrmI7RPb+0Lb0snJXRQQGrSWbFrK2uuVIBdRY2GeCyw0Soj+v
         KtneofNKkoNgCjRfwkMD/K/d1Cjrpf0qE/gJwUq7po+6ToTvHMxqJivxHNORgPejhZQT
         W2bRP/W5tZavelLqzdFGDX+ZVQ/9EZWjNF7n4t5uZsnF6MPMTyRk1/HW+8OG/VcrpyUI
         9E0cMNFZOqBvZYbQNQALs5a9QyzMGXzXW+fvqVKiDKgzh1u+RePNRgTbqYJSxRMfU2M1
         TG3w==
X-Gm-Message-State: AOAM533bCTcdC5wFwGp8jbczcLON670hTpgLjwLc7zWu1515gUHfEcOj
        UWwLHDtQpVAkZHF4z4EeXwvo6ry/IiQv7DjurD9QQ6URH55xW+wz
X-Google-Smtp-Source: ABdhPJyUgVzb6RWclGt3JbqMEbsLVzUDNX+nBpGEUf004VfGHr05DyUKIhgb12qjPc2VShHEvczv9qGyLhf1wuQqowM=
X-Received: by 2002:a05:6e02:104b:: with SMTP id p11mr20272403ilj.77.1617653457957;
 Mon, 05 Apr 2021 13:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com> <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
In-Reply-To: <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Mon, 5 Apr 2021 13:10:47 -0700
Message-ID: <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
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

Hi Saravana,

On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> <ilya.lipnitskiy@gmail.com> wrote:
> >
> > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > not configured by #gpio-cells and can't be parsed along with other
> > "*-gpios" properties.
> >
> > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > here.
>
> The only example of this that I see is "snps,nr-gpios".
arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
"nr-gpios" without any vendor prefix.

I personally don't think causing regressions is good for any reason,
so I think we need to fix this in stable releases. The patch can be
reverted when nr-gpios is no longer special. The logic here should
also be aligned with scripts/dtc/checks.c, I actually submitted a
patch to warn about "nr-gpios" only and not "nr-gpio" in dtc as well:
https://www.spinics.net/lists/devicetree-compiler/msg03619.html

Ilya
