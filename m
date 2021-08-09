Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345683E439E
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhHIKJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbhHIKJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 06:09:23 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A7C0613D3;
        Mon,  9 Aug 2021 03:09:01 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id r17-20020a0568302371b0290504f3f418fbso3092045oth.12;
        Mon, 09 Aug 2021 03:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qoHRXfLSkf+2u1HB47ZXYyLT4NgEVZM0x+hX2iAEM0A=;
        b=V3dDLieTWYZK7LcO6IcE0dgZhbK3gmN5Dn1hrPuqmFwnYyqHT9HPXAtiAO+8x5LD2a
         rhZFan2ys8KPoz3pcG6PhhHxRtlejRkeG0R0x2uecegwLq2xmVX9l0KZjed6bDsAZUxd
         0/DQhTbNtPpx8727V8VsXa3kHezj/UkSMnGV2Raf2eckllnX43mB1ik0Nq9tv4qv/NBy
         VP6xuaTr21q3i58BtB9Q73+tQBzWtAXfVKae5XLTxj2IIRewzJhnZsn2U4f3UDjZfu2p
         x4rL4gmsFTWwAoaa3U7yN6eTINbme175X4Bh9iA+HsToZ4fiJksj0W/djk/5Cwt2Bmsg
         Qufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoHRXfLSkf+2u1HB47ZXYyLT4NgEVZM0x+hX2iAEM0A=;
        b=Mic+QDP2FxDYA5DzUr8vNYeekIeYCGqiWzJhbO4HU8cwN+405btU4nYi+lniOT/fFj
         Z/6u5mALhSdZDz+iqLGCwTOv27YFSxWE3tuVGkRwAIM5BGdodMf29V+PAV8BKuPCfPFN
         VBd17r/mJBM2MYe/u5VM2UCXsKNaBX2sFxmza+Lvr3bLZUi9/c70IESIOX/J6cwndi4S
         NUKQgGW3VCUqK7gzJ09NhIBLUVmT/A54Xo+7BzEE+/c87QeMLvoCc3LxnGr9Jj0y6fwQ
         3ZarXhRy8AxIam3lknzQgSn0GT5UejtWC7PHxFjmDejgSLVCjFJAcSfJ5hgTUNShKJ+n
         C6+Q==
X-Gm-Message-State: AOAM533/rwf9QTT+GivqitDWoOGLGCz/5WapT/DhV4kNmD4vhhfiNFVe
        rMaKgvcc0m4VJESLje85ngtNyhTgaTYAB2Nni3d/98nTnlfdkA==
X-Google-Smtp-Source: ABdhPJzSl9HGih+1oYlUMtTUINQffGyH3LHGqFRlSVEPYWjJF8/bhu9t47I5IwHuvLo6LextsjMFOBY/uHLsjyXWJ88=
X-Received: by 2002:a05:6830:1459:: with SMTP id w25mr769993otp.370.1628503740799;
 Mon, 09 Aug 2021 03:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
 <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org> <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
 <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org>
In-Reply-To: <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org>
From:   Mikael Pettersson <mikpelinux@gmail.com>
Date:   Mon, 9 Aug 2021 12:08:49 +0200
Message-ID: <CAM43=SPsQv-fS1cOF9NA+kKEQcFw9BjyNeDZtqkBiHVvgGwQfg@mail.gmail.com>
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on m68k/aranym
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k@lists.linux-m68k.org, stable@vger.kernel.org,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 9, 2021 at 3:59 AM Finn Thain <fthain@linux-m68k.org> wrote:
>
> On Sun, 8 Aug 2021, Mikael Pettersson wrote:
>
> > On Sun, Aug 8, 2021 at 1:20 AM Finn Thain <fthain@linux-m68k.org> wrote:
> > >
> > > On Sat, 7 Aug 2021, Mikael Pettersson wrote:
> > >
> > > > I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> > > > 5.10.47 to 5.10.56, and the new kernel failed to boot:
> > > >
> > > > ARAnyM 1.1.0
> > > > Using config file: 'aranym1.headless.config'
> > > > Could not open joystick 0
> > > > ARAnyM RTC Timer: /dev/rtc: Permission denied
> > > > ARAnyM LILO: Error loading ramdisk 'root.bin'
> > > > Blitter tried to read byte from register ff8a00 at 0077ee
> > > >
> > > > At this point it kept running, but produced no output to the console,
> > > > and would never get to the point of starting user-space. Attaching gdb
> > > > to aranym showed nothing interesting, i.e. it seemed to be executing
> > > > normally.
> > > >
> > > > A git bisect identified the following commit between 5.10.52 and
> > > > 5.10.53 as the culprit:
> > > > # first bad commit: [9e1cf2d1ed37c934c9935f2c0b2f8b15d9355654]
> > > > mm/userfaultfd: fix uffd-wp special cases for fork()
> > > >
> > >
> > > That commit appeared in mainline between v5.13 and v5.14-rc1. Is mainline
> > > also affected? e.g. v5.14-rc4.
> >
> > 5.14-rc4 boots fine. I suspect the commit has some dependency that
> > hasn't been backported to 5.10 stable.
> >
>
> On mainline, 9e1cf2d1ed3 is known as commit 8f34f1eac382 ("mm/userfaultfd:
> fix uffd-wp special cases for fork()").
>
> There are differences between the two commits that may be relevant. I
> don't know.
>
> If you checkout 8f34f1eac382 and if that works, it would indicate either
> missing dependencies in -stable, or those differences are important.
>
> OTOH, if 8f34f1eac382 fails in the same way as linux-5.10.y, it would
> indicate that -stable is missing a fix that's present in v5.14-rc4.

8f34f1eac382 boots fine.
