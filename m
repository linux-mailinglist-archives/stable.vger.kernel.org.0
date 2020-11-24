Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177CF2C303C
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 19:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgKXSyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 13:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgKXSyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 13:54:02 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD69C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 10:54:02 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id y18so5630068qki.11
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 10:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sInI2hmCut2s4l2b0zvw3OBz+yXshC3npGBTp1dEvTU=;
        b=LByZn5NeP6g4VEwU7ORyy+IFtICBHx0nCSjTvidsqRHDkbcQk3CpzgjqtXmAuzayMJ
         PsUZlhC0kYw/OFCT3RQY3yzj3D8WbuLgsF28XK0eCVuzfCjlN3OoNqHsc56h4/swBA4d
         Hsx0zem6aa3N3ej8upm6aev5c+qcZ5kZGFISCfyFE0mH23JVTTv0DUS37UY//E5u/tLp
         N90yniYHg5mRr3VNI0SjpeUPpFhMdoDEme/BjQt8mDsbXgbnxa41k5halfRwSmzWnxJp
         N5fN5K7Ic8dkuCyW8h9+h5KwJtzgZH/4jB4J2/PUsEumpQP1tf+H7XHlwdNe7WhyEsU0
         tAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sInI2hmCut2s4l2b0zvw3OBz+yXshC3npGBTp1dEvTU=;
        b=AAZ0lMS6mf/4LilDEzayWcIdITb+oaNoP7cSMC/92AGA35Q6rCns5PfJ6ob1OmRfpq
         lecgeyUf+AogGd6x8ZJNpKPM6mQmlPL86a5psAzzwl0m7cAyIKDShRnIPOVBZ4k75krm
         UvcW5lmuwk4x4e31QKaP5JfLs5QeWVuL8JIh3YJbM9M5R8r87hDUCZUCEUYOGy7UrKxD
         PjnhdqWVdoWH4g53KnoS6wdSj4vk9ax9uo+VvYQenBgkEL3Aj+H5T7KxnJa/mS79N4+k
         rfEOweS+c/y4gruPyjYSvdW0oZaneQhaBbikPH/K0NyghgfhX9oEkJHVk14Ly8S7J+yp
         PaZw==
X-Gm-Message-State: AOAM533ck6ZpR55d0InduXg14isdeWNnm66v8+Yo5j2pHQxxlJ4wWy67
        BdBrclm4TpnP0Df9+pEs8C+QAFx6tLgWoFNMdjQ=
X-Google-Smtp-Source: ABdhPJxblPInPMhNKh7p1ndmBSH6cv9mke+FTt6WwlLtdX4uWTr2ZX6qz8chl+OUcL9JUWXxUey27+wGB5qS8AavPqU=
X-Received: by 2002:a25:9344:: with SMTP id g4mr7211037ybo.342.1606244041951;
 Tue, 24 Nov 2020 10:54:01 -0800 (PST)
MIME-Version: 1.0
References: <160612300715987@kroah.com> <20201124134123.ie5jvzygygayajo5@debian>
 <X71Lv314xaqrtn9B@kroah.com>
In-Reply-To: <X71Lv314xaqrtn9B@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 24 Nov 2020 18:53:25 +0000
Message-ID: <CADVatmMFEYRSKcq4mkZqs0feVPSWX9miG49ffbCR0utLtFSgfA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lukas Wunner <lukas@wunner.de>, Mark Brown <broonie@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, kdasu.kdev@gmail.com,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Nov 24, 2020 at 6:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 24, 2020 at 01:41:23PM +0000, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> > >
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >
> > Here is the backport for all the stable tree from v4.9.y to v5.4.y.
>
> THis didn't apply to 4.9.y, are you sure you tried that?
>
> Anyway, queued up for all other branches, thanks!

I was modifying one of my script which pulls in the stablerc and
stable-queue and I have completely messed up today  :(
Please drop this from v4.14.y. It will fail to build there. I had been
working on the version for v4.14.y and v4.9.y, but I will keep it
aside for today.
Really sorry for the confusion.


-- 
Regards
Sudip
