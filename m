Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888E23904A3
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 17:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhEYPKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 11:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEYPKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 11:10:49 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CEAC06138A
        for <stable@vger.kernel.org>; Tue, 25 May 2021 08:09:19 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id p20so38595332ljj.8
        for <stable@vger.kernel.org>; Tue, 25 May 2021 08:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VXhstycvJ/ZxY8r6rEvIPljRylC1sPEk0zKGubyDqnc=;
        b=BkHE3p4fPN34oOAaNSE02dOwEecfhj/NQtDloDqQc+xn+yc/uj4k7T1GAhnkoP7XK5
         PAirC+CqUOlNV4agBX4g9/Ge6HdzmhIku6IGO1lZlAQ4HoUyPFHWGpKqSpYR4oCZ17/x
         OL4NFaTV9ufHRrTmyXNPQy0SobLF2Ah9Y/tHmZgKuKoywMAr/qH4eq4OhSBPU+fW+iew
         lDytQ6AVAFVeL5MfFadlSqcfKptxdCKCSmg60GJGHFKBdWVJjN6us/ZAJ3izcjLvMERO
         yT9gaICJf2Nc/0SKF4R1mlJwpRq4RbvU1REAIzGEeLOMIo34QkHzOBHiHCvo0l+vpuOR
         E/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXhstycvJ/ZxY8r6rEvIPljRylC1sPEk0zKGubyDqnc=;
        b=A0B04g5CLr5Vtzef1B5h5aEOsEcqZYArsLx4DzjFMxvWN742pZc/MVZ9lKdmYDAD17
         AId4g6iqKBi0WaWk7wAtpfzMrlW34FRL1V69YJjza8xOFsP/doEHuUBPWOAHBgJmFNKA
         ayR9HMMIFvg/OM3ka5qrmog5A9Q20FVo8ZhfF8/XlAlUuQJgh8ub5Qw8sDd5+/faDHWz
         IPD28qufeYyRbymT15ndyoQ3jkYUS7FNuaTpiWPSIZEnffXw9ejwdryduOIsTGNhhLOW
         q4TZVG0m41K4wyWM55uX6rAPHnya/VUKZLaG3d/gacBo9+X8W9J4VlhGAUol9jGggoTA
         dYHw==
X-Gm-Message-State: AOAM532RX/S6lEz+zDT7W/KbSn3kAFg0GY80X9dotGKD9Msp33egd1Fu
        soEQ/TGXQrijh/3DYK0jgzJX4zNKTiZtMHzdK459/A==
X-Google-Smtp-Source: ABdhPJxLgO3lpcEhQzJRZHtjBBS37mdWQMb5YUpDCqSSE+VsKji9pL95xpoUjuJXjYq+UoY6D/AWgxbpMKAO5jVryg0=
X-Received: by 2002:a2e:90c7:: with SMTP id o7mr21231147ljg.368.1621955356716;
 Tue, 25 May 2021 08:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210512210316.1982416-1-luzmaximilian@gmail.com>
 <CACRpkdZpm4w6Ym2p9xTsYpkU7CR531aLUUxXj54tssoqd6c9=Q@mail.gmail.com> <YKYnYCaoUDwjS1gL@smile.fi.intel.com>
In-Reply-To: <YKYnYCaoUDwjS1gL@smile.fi.intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 25 May 2021 17:09:05 +0200
Message-ID: <CACRpkdYHxKbAwFTD=g_xWxq2wnRFC2V7NBrODVn-QDVUREfyhA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/amd: Add device HID for new AMD GPIO controller
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sachi King <nakato@nakato.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 11:09 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, May 20, 2021 at 01:50:50AM +0200, Linus Walleij wrote:
> > On Wed, May 12, 2021 at 11:03 PM Maximilian Luz <luzmaximilian@gmail.com> wrote:
> >
> > > Add device HID AMDI0031 to the AMD GPIO controller driver match table.
> > > This controller can be found on Microsoft Surface Laptop 4 devices and
> > > seems similar enough that we can just copy the existing AMDI0030 entry.
> > >
> > > Cc: <stable@vger.kernel.org> # 5.10+
> >
> > Why? It's hardly a regression?
>
> IIRC the stable policy allows to backport new IDs.

You're right.

> > > Tested-by: Sachi King <nakato@nakato.io>
> > > Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> >
> > I've applied the patch for next without the stable tag for now.
>
> It can be pulled to stable afterwards anyway :-)

Nah I'll tag it back on. But it goes upstream with the rest of
patches for v5.14 in the merge window because it is not
urgent.

Yours,
Linus Walleij
