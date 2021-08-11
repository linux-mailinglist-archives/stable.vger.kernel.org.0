Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8873E8D36
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 11:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhHKJZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 05:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbhHKJZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 05:25:23 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7AEC061765;
        Wed, 11 Aug 2021 02:24:59 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id s13so3610573oie.10;
        Wed, 11 Aug 2021 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KpUGh0zg9Fpa+S0TUkpvupAbNPR/xy3fQ3etaoZJ5lg=;
        b=sMd/okKyGAWpSM9VToNJ5wG3HHyL+w1XYSM7ab9XX+uaEyTkRdQ89EONbdEBSHKG4T
         MYrNdTGrttS2TqgkOvb2gWHTvsciNcMv71mBIWqVEhF8kTpb3piO7qsJOpoFnrwE71sf
         xQCQkhelG2ZEaK28PHwsTMCvol689cEDt2XV5BywppQM0PMAEt0Gfq3L5B0kX2c53BHk
         aBKOqYsjaEr8jrOFunuoLdtl3xgBShsAGnbylO5SWUES0hD346dqF6qhznGZQb8JyDEI
         u3zwuHvaTAXm0/9o3uy0JG2RXdbiEEeKxPwbuHPRhy20tFETenO7Qru4T+GwAIs0KwGN
         l4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpUGh0zg9Fpa+S0TUkpvupAbNPR/xy3fQ3etaoZJ5lg=;
        b=hhWLULHgHdh4AB9eOe2s5idxGTMkT75Plv5ELptF22+993y4iBGNiRIQXH9y1xko9E
         QpxukakFzrgZySegioY3XXWM6H6EFnZFub6PRCx+Nyy7qVx0pJiZVcWKMKurrkO8wM2Q
         FJiFpur60AOKAn3d0o7CxEc5hML03Q/neEr8ioEXXX3KEUWfvt44OSauGtNl0kuaO0z+
         pc/gWPxk2vnWPD+7ECcLnvE/n2fARyiOfu78vY1HM237UXMFrIYOujQUf7gJ6uJZycuI
         hBcMAHg0UlQSldZbXOBH851d9or5XypzORfG6fyhkzTadEVb4nhLPJeWOYzqYyxuXfes
         Epzw==
X-Gm-Message-State: AOAM532+5PxKh11ZqWuKB7DZ7KGMxkPuxxNnUNAFUW6Re8LS1url/bXM
        bIhQHIadajOq7Www+8DmngofNdm5P4iXIWtn95o=
X-Google-Smtp-Source: ABdhPJwrgB/rwz9fAiKby0fgb7UbnJ+HtqNmIaVdt+Hl3JXb+Jk3DP801dbFMSvWnOo2bIsw08H26FgwB/ybmOjlj34=
X-Received: by 2002:aca:f203:: with SMTP id q3mr4037582oih.143.1628673899119;
 Wed, 11 Aug 2021 02:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
 <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org> <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
 <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org> <CAM43=SO03vCzo4LiwSFJyNbWdVXu_wu1gdm5wzi2ArsWShCqqA@mail.gmail.com>
 <CAMuHMdUADRtNrVsJZFdymOoGe8LNEg=x2PtzRVJhh0rcyLpHoQ@mail.gmail.com> <YRKiXiL4jk6DefMD@kernel.org>
In-Reply-To: <YRKiXiL4jk6DefMD@kernel.org>
From:   Mikael Pettersson <mikpelinux@gmail.com>
Date:   Wed, 11 Aug 2021 11:24:47 +0200
Message-ID: <CAM43=SOG60ETBZRk1VsDmhzfoC_eC8F0KxRDQZgXdhoZUyLEjw@mail.gmail.com>
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on m68k/aranym
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        stable <stable@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 5:59 PM Mike Rapoport <rppt@kernel.org> wrote:
>
> On Mon, Aug 09, 2021 at 03:40:04PM +0200, Geert Uytterhoeven wrote:
> > CC Mike
> >
> > On Mon, Aug 9, 2021 at 3:32 PM Mikael Pettersson <mikpelinux@gmail.com> wrote:
> > > On Mon, Aug 9, 2021 at 3:59 AM Finn Thain <fthain@linux-m68k.org> wrote:
> > > > On Sun, 8 Aug 2021, Mikael Pettersson wrote:
> > > > > On Sun, Aug 8, 2021 at 1:20 AM Finn Thain <fthain@linux-m68k.org> wrote:
> > > > > > On Sat, 7 Aug 2021, Mikael Pettersson wrote:
> > > > > > > I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> > > > > > > 5.10.47 to 5.10.56, and the new kernel failed to boot:
> > > > > > >
> > > > > > > ARAnyM 1.1.0
> > > > > > > Using config file: 'aranym1.headless.config'
> > > > > > > Could not open joystick 0
> > > > > > > ARAnyM RTC Timer: /dev/rtc: Permission denied
> > > > > > > ARAnyM LILO: Error loading ramdisk 'root.bin'
> > > > > > > Blitter tried to read byte from register ff8a00 at 0077ee
> > > > > > >
> > > > > > > At this point it kept running, but produced no output to the console,
> > > > > > > and would never get to the point of starting user-space. Attaching gdb
> > > > > > > to aranym showed nothing interesting, i.e. it seemed to be executing
> > > > > > > normally.
> > >
> > > My initial bisect was wrong. I tried reverting 8f34f1eac382 from
> > > 5.10.57 but that made no difference, so I re-ran the git bisect with
> > > all known good points pre-marked. This landed on:
> > > # first bad commit: [ce6ee46e0f39ed97e23ebf7b5a565e0266a8a1a3]
> > > mm/page_alloc: fix memory map initialization for descending nodes
> > >
> > > Reverting _that_ from 5.10.57 does unbreak that kernel.
>
> Indeed there is a problem with that commit in 5.10. The memmap
> initialization relies on availability of zone_to_nid() to link struct page
> to a node. But in 5.10 zone_to_nid() is only defined for NUMA, but not for
> DISCONTIGMEM.
>
> Mikael, can you please try the patch below:
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 9d0c454d23cd..63b550403317 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -445,7 +445,7 @@ struct zone {
>          */
>         long lowmem_reserve[MAX_NR_ZONES];
>
> -#ifdef CONFIG_NUMA
> +#ifdef CONFIG_NEED_MULTIPLE_NODES
>         int node;
>  #endif
>         struct pglist_data      *zone_pgdat;
> @@ -896,7 +896,7 @@ static inline bool populated_zone(struct zone *zone)
>         return zone->present_pages;
>  }
>
> -#ifdef CONFIG_NUMA
> +#ifdef CONFIG_NEED_MULTIPLE_NODES
>  static inline int zone_to_nid(struct zone *zone)
>  {
>         return zone->node;
>
> --
> Sincerely yours,
> Mike.

Applying this on top of 5.10.57 fixes the problem, thanks.

Tested-by: Mikael Pettersson <mikpelinux@gmail.com>
