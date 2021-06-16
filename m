Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3C3A938A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 09:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhFPHNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 03:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhFPHNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 03:13:49 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CEC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 00:11:43 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id h15so1554524ybm.13
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 00:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AP4Xum7KRX4wPSKrz0Wg+XKFNvBxfaDH7lB1CBw+SJk=;
        b=YYGBIph94C3ofniuo0VzUjN5np3nqzgIyHcFXnJeFMkWjuILuCR96MiGyoRS93goTi
         K80Ocak6tFFetSoSz1i8ZqBYXsOHCIRLxLvlYyEWkyHUYqRm0bY0W7moc+lQU8tabZTw
         XDKRNuvHbt5pwTBBiosnqgxW2h14a3vpfxzY+YYP0MUaZD8WN9LiCIB9zroQWHNnUDvC
         41dnS5DHscdPdq7pvjARlo6+Tl9VJ4eyDDXiObfGxQDeDvD/60YeWEtdbGB4z8TrFc0a
         Ii3N6i+ELDy8UMrE1+ALtsIM2jSclBqdqs5ohGWqxPc9utlM3vHXccp4tN4xm7sfX9Vl
         ePiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AP4Xum7KRX4wPSKrz0Wg+XKFNvBxfaDH7lB1CBw+SJk=;
        b=DHnfe9rZR/xqH5E+1A+LyNE+MJRt0c9RrSJcZTBx3OXBQL5TCizeatBQBYe5VC+8RI
         l9cWYNpdzb8IuQFHWTxCqJ9tcPEMSxiOlOVE7iQu597LrJ2GJfQIc91q3ezVeMEWAHdR
         cPzeUMEnJvY1RGwD6Zyco+80d4WpQF8bjVKMlDohqaQ5EZ8+qANjjmO2PSLVn6NA+MwW
         h6Sx2ajpbg9HjfHkmGAxt1FR2JKJ2TgWixrfNstTGIF+sfAKsiiAszktiENjEmSLP1TU
         JG16lSbdgM7HbSw8hs93wjwTXNex/b+46Pn3J+xP3WKaLAyJRUd4wRurgCIdNRDa5fRz
         Wj3Q==
X-Gm-Message-State: AOAM533nSRwBmGFG39yVHOzmd+NSpyoMoNfk8fyEuCasBVMmOj1L1Xy1
        j/AkAW6bJW2PedSQ+0eHC1MC7TaFdxA3+CJqwELEEQ==
X-Google-Smtp-Source: ABdhPJwknwCr/WIso7ZMB+C2FfwyW4cSSgg59RdfifV6WsksV9aCtsdiDnAvwB54xpkq3rKDe2z8KXTauDIhDwclUdE=
X-Received: by 2002:a25:7ec4:: with SMTP id z187mr4497650ybc.136.1623827502513;
 Wed, 16 Jun 2021 00:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <f546c93e-0e36-03a1-fb08-67f46c83d2e7@huawei.com> <YMmfke61mTcPV4vB@kroah.com>
In-Reply-To: <YMmfke61mTcPV4vB@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 16 Jun 2021 00:11:31 -0700
Message-ID: <CAJuCfpG8p7AasufvqehNOLdoXw5ZQFuQhi6mhqPvA3GbPn1puQ@mail.gmail.com>
Subject: Re: Questions about backports of fixes for "CoW after fork() issue"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Liu Shixin <liushixin2@huawei.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        "Jann Horn," <jannh@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 11:52 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 16, 2021 at 02:47:15PM +0800, Liu Shixin wrote:
> > Hi, Suren,
> >
> > I read the previous discussion about fixing CVE-2020-29374 in stable 4.14 and 4.19 in
> > <https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/>
> >
> > https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/
> >
> > And the results of the discussion is that you backports of 17839856fd58 for 4.14 and
> >
> > 4.19 kernels.
> >
> > But the bug about dax and strace in the discussion has not been solved, right? I don't
> >
> > find a conclusion on this issue, am I missing something? Does this problem still exist in
> >
> > the stable 4.14 and 4.19 kernel?

That is my understanding after discussions with Andrea but I did not
verify that myself. As Greg pointed out, the best way would be to try
it out.
Thanks,
Suren.

>
> As the code is all there for you, can you just test them and see for
> yourself?
>
> thanks,
>
> greg k-h
