Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54813FE72B
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 03:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhIBBd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 21:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbhIBBd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 21:33:58 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79161C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 18:33:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id mf2so472459ejb.9
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 18:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6dET/6kkiERMePKTgGewFI/ZwcM7iIybz0T9uQS3Jx8=;
        b=XJuwEuJADFpgxhjC3oNosONM4NryseC/qW48arY18LR3FHuYEeTM5ntuBEn8ixTzno
         I9DmYkfs0r+6oZTQ9QLqeth4zUB4KbX4UC1TUrl8XDpkmVz7b74KUpaToYgZV+WDaNh2
         rCdGnXkU5e4fmTgfnL6erShG78CUC2eIG0HRJ/bpTzt8QYh3oCsYkIH7Iq9Y/MRZTtf8
         cZR5YLqv77QywpP5kuap/BObt7owMNCr7LwtuWgf6kEgwct6mTQFitpEYryX8QMaIQd9
         T1R4f2YBiJdP5ZyocDkzss7obkht7AkNrzpjSLqVKuhu7MRlKW9pNSHN+SB1SO4TL4Tr
         bt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6dET/6kkiERMePKTgGewFI/ZwcM7iIybz0T9uQS3Jx8=;
        b=d93z4yJnSn39AXbCxdYfznsgrdgZRpu0egD8JW0Sm2EmRtZk0MTvEOe1N7mtul1DWO
         F2yikRAVhw1+JiucAabxH1U30xWKNp7o0g41NMpOPy5hQfjZ6+VSPOUZ01iszJ4N7pJH
         kRe9DfSwRVlO3QfmJ+i1DA+nf8DexmrITw/vrfIEpPMzWFIv9/xaI+43LJB9kAtk9ycH
         etGFCHHuvKoiiMdUuj7GeYdDlfe+CX9POy1QzuMfh2NgWGFQRVPgKKlw+oViMvnN1v62
         x94fjxFWtlcTR36s2Iw+I7bB53zKQ7OtB/DTBm5M0zCZffXzQ3k5I/0AxssmEc3/jMss
         540g==
X-Gm-Message-State: AOAM532jgIsJXT0C9ofe8n7BjjouAX7KUUIaFGBK5Y+qE/Y+9a5m30AM
        ZBxSf9TMHeNwyOmf3pR5X8CGJgzGYDjoeSCnVq8=
X-Google-Smtp-Source: ABdhPJy68TXF3iHgvi9b2ezRwLPyIPbSeznrQhgidZ3CgCRfdVnBX7ckrpIi+k74yoNAD/PeYbLKTtE4GMqy3k7h2Js=
X-Received: by 2002:a17:906:31ca:: with SMTP id f10mr927595ejf.73.1630546379046;
 Wed, 01 Sep 2021 18:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUhebBrJ1fZG-i09PSKjC9Vat3Ym5VHoOrXGAO_tKQdpQ@mail.gmail.com>
 <YS8bvAc4XbaxSssu@kroah.com>
In-Reply-To: <YS8bvAc4XbaxSssu@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 2 Sep 2021 09:32:32 +0800
Message-ID: <CAD-N9QXikdSxPnTnEsU3KUYkjXsOpKR14JQ_-+B7OEzMOnjTSA@mail.gmail.com>
Subject: Re: Linux kernel 4.19 and below misses the patch - "fbmem: add margin
 check to fb_check_caps()"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 1, 2021 at 2:20 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 31, 2021 at 02:47:22PM +0800, Dongliang Mu wrote:
> > Hi stable maintainers,
> >
> > It seems that Linux kernel 4.19 and below miss the patch - "fbmem: add
> > margin check to fb_check_caps()" [1]. Linux kernel 5.4 and up is
> > already merged this patch[2].
> >
> > Are there any special issues about this patch? Why do maintainers miss
> > such a patch?
>
> Because it does not apply to those older kernels.  If you feel it should
> be included there, can you please provide a working backport of the
> patch so that we can apply it?

Sure, I will do that. Which mailing list or maintainers should I send to?

>
> thanks,
>
> greg k-h
