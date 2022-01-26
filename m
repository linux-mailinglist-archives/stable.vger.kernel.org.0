Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB9F49CC75
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242216AbiAZOhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242212AbiAZOhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:37:37 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A524BC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 06:37:37 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id 2so43277075uax.10
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 06:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avwJHIRaqXRC/i9e13WL28KHJgoLxfbjcz1VFRenbkU=;
        b=x1tCF12wi5jFG0bKPzUmsb0PFBzFjATYSjByY8wZ6ICBfLGkKcJeu7Alymq4xVsiOB
         KYoWYI9sUXfrFv1PFXafFDDY6QRBM52gBFU0EzHv5MgSw5lQGLMcyH9FkuSdoyHRYdVy
         iiBFhF9DEeWgG6DG34sJ/0GgXKdgPDiQLEAZjZM/FVC/NHS52OcFgFaPz3db8LZmpHe9
         9vZOZmLbuHXH5hSRBDdTIRVk4tz+ni+A8v7wmx7sSTB2OIgrOKuNd/wszR0SsRKvfvDa
         xj6r6n80WxBSDq94NXKxre/SH6uS1qbfsFstkqrDNMJMSJjS6kT6Gp6MNokw0DpubAcH
         mPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avwJHIRaqXRC/i9e13WL28KHJgoLxfbjcz1VFRenbkU=;
        b=nhwUHn0FJgTnCA36r5JioqD/KsVyfEhEIkRB8joaJLED/QUp/M7r1mt0kyC6CoxaoR
         Add6Q0weNxi7Qil6K+XSs+kFTweMcNIgSbMhSPwJ8aYhC0RoVQutqjgDwjdHOSHGqAOF
         hz/Yz++dcRfp5SW1l+i2FMdgSLK9NJ5XKhMAnTnCjHYPXxkNazJ4pWj2Bl8LfvD5ilZQ
         MmhLYbE28o33CTe/ILN9J2pQ0Tyd+qt0Rs3pzZppQAYZHG/ryJns+rZk9TLXA4UzWBsB
         WVm5y7D0v9itxWjw5GZx1PuojMUtVrEdxQI9BeivV8cdAbVrD8NoJh4aWJq6RVl5rD0f
         9c6w==
X-Gm-Message-State: AOAM53238Ma59S2FcbLGvGaVFAljI8fZLOKNLoSwQjGNEGeGy5VzlX12
        iQzeVrjetauNysc/QVwdurMz8Id7j1wlLm7P+PBIYw==
X-Google-Smtp-Source: ABdhPJyKzdarUsh6PeiX6XzMcEB4kanF0P+vXrKo74f9owtvZ3IiqsyxF+4Y66p7BUoOK9lx/1jRYfeImqxCcw6dDfU=
X-Received: by 2002:ab0:781a:: with SMTP id x26mr9412148uaq.61.1643207856844;
 Wed, 26 Jan 2022 06:37:36 -0800 (PST)
MIME-Version: 1.0
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com> <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
 <YfAk90OPjlpjruV5@kroah.com> <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
 <YfEmZiwkdZlQ3DVb@eldamar.lan> <CAG=yYw==-5tugkdgaA3XeWAOi5ni7waAJ=+qsAecTN=kR8HSnw@mail.gmail.com>
In-Reply-To: <CAG=yYw==-5tugkdgaA3XeWAOi5ni7waAJ=+qsAecTN=kR8HSnw@mail.gmail.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Wed, 26 Jan 2022 20:07:00 +0530
Message-ID: <CAG=yYwknUUgL9+zi=rgNZ390ZJdt8Aqv8oYfVJ1X78hf6XwjjQ@mail.gmail.com>
Subject: Re: review for 5.16.3-rc2
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 6:06 PM Jeffrin Thalakkottoor
<jeffrin@rajagiritech.edu.in> wrote:
>
> > What version of pahole are you using? Are you using Debian
> > downstream's 1.22-2? If so please check if it's just the same issue as
> > reported in https://bugs.debian.org/1004311
> >
> > Regards,
> > Salvatore
> i was using 1.22-2.
> i think it is the  debian  issue as you pointed.anyway thanks
>

i downloaded pahole 1.23  from kernel.org and
the problem is fixed
i will test 5.16.3-rc2 and send another mail
-- 
software engineer
rajagiri school of engineering and technology
