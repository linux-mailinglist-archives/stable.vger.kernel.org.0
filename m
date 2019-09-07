Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB3AC713
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 16:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391750AbfIGO6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 10:58:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33938 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391733AbfIGO6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 10:58:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id s18so9411027wrn.1;
        Sat, 07 Sep 2019 07:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1COcKaS2HXJAJL3v76zzn2hj7Bwkz387tvnsFY+Qqwo=;
        b=KniegP04d/AhcqE+5LUIynxWrj4CHnLgNRFGgR7j8m829cSrKRqZLjBci1iMhrN9+x
         cqyDDhNpm9roTgyItEoJBj9jYmhcfmOiEyJecJy+xX17N141k3tCye93e+hJxq2oXIDB
         2x2zNGykFoX/BoI0c03XYb1SW0e2rtEpH2DysWWXHRAgWNMQz7SLWGUisP3CVuaoBXJk
         hoNFQ2uHsjflydICv0dD6BWPs46wkgceQ9aSvnBXiTjZ/E1aAz0wzza4n/sDf/D3+icV
         6KW8/8E0Wg/nkvsmHWe0k2DE4bzBIRAbzjsS5SLleqiJXKabVZqL4pFk1s9IvWhS8sqE
         RrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1COcKaS2HXJAJL3v76zzn2hj7Bwkz387tvnsFY+Qqwo=;
        b=OLBrlOsQnwZNSqQDaAU/cWhRFV2JMhner3XB04U+kwOOjfy8DcUuBKz2oa1lmw/aNy
         4rUQnCxEUbIpBSoIsmZJMLPUzEm3rLVcb2ge44mTAPcVjkLrdAgAlIg24eZH84Nrkg/V
         Hxi3isyEvcWGwg+CCwiw8FxfXBjMyvnKQOh0p3wmqB4XEEG3zCDi/ZcWRQYQkHnZZUJB
         TuCg8K9SmvUHkBoAkf1/ytRU+KOG607XVb5d+DeKLdtjperRI3wtqjZNp1o0y2s5Pile
         0VUxUzQilrnmur4ktNnunmrW3wxHgHFNo+i07mdQzJwsWNEh6nslNVXvIN0ZIFPPUtDg
         oj4A==
X-Gm-Message-State: APjAAAUbIY5/SbZ8DctVuR2fKajdUU2jJVi+7qITQRpwpLLefN7AjTM0
        VT9BWPIJS4tP4exCmRPUNaKDdPlDZT64/Y2GXE8=
X-Google-Smtp-Source: APXvYqzSXDuicK9cIB3YHlgQmu0ZhC7GmzlZl5Qjwb/WQCt4v0+9tJb5jpYKC073HCxRSWvKDYp3DpEEhmnzeKDshIA=
X-Received: by 2002:adf:e286:: with SMTP id v6mr11989190wri.4.1567868296438;
 Sat, 07 Sep 2019 07:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190903162519.7136-1-sashal@kernel.org> <20190903162519.7136-44-sashal@kernel.org>
 <7957107d-634f-4771-327e-99fdd5e6474e@daenzer.net> <20190903170347.GA24357@kroah.com>
 <20190903200139.GJ5281@sasha-vm> <CAKMK7uFpBnkF4xABdkDMZ8TYhL4jg6ZuGyHGyVeBxc9rkyUtXQ@mail.gmail.com>
In-Reply-To: <CAKMK7uFpBnkF4xABdkDMZ8TYhL4jg6ZuGyHGyVeBxc9rkyUtXQ@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Sat, 7 Sep 2019 10:58:03 -0400
Message-ID: <CADnq5_Mfee4xmzMJ-Hmw251QCMfabWPKd8PX+o70D97qdCDJ8g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 044/167] drm/amdgpu: validate user pitch alignment
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Sasha Levin <sashal@kernel.org>, Dave Airlie <airlied@linux.ie>,
        Yu Zhao <yuzhao@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 3, 2019 at 4:16 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Tue, Sep 3, 2019 at 10:01 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Tue, Sep 03, 2019 at 07:03:47PM +0200, Greg KH wrote:
> > >On Tue, Sep 03, 2019 at 06:40:43PM +0200, Michel D=C3=A4nzer wrote:
> > >> On 2019-09-03 6:23 p.m., Sasha Levin wrote:
> > >> > From: Yu Zhao <yuzhao@google.com>
> > >> >
> > >> > [ Upstream commit 89f23b6efef554766177bf51aa754bce14c3e7da ]
> > >>
> > >> Hold your horses!
> > >>
> > >> This commit and c4a32b266da7bb702e60381ca0c35eaddbc89a6c had to be
> > >> reverted, as they caused regressions. See commits
> > >> 25ec429e86bb790e40387a550f0501d0ac55a47c &
> > >> 92b0730eaf2d549fdfb10ecc8b71f34b9f472c12 .
> > >>
> > >>
> > >> This isn't bolstering confidence in how these patches are selected..=
.
> > >
> > >The patch _itself_ said to be backported to the stable trees from 4.2
> > >and newer.  Why wouldn't we be confident in doing this?
> > >
> > >If the patch doesn't want to be backported, then do not add the cc:
> > >stable line to it...
> >
> > This patch was picked because it has a stable tag, which you presumably
> > saw as your Reviewed-by tag is in the patch. This is why it was
> > backported; it doesn't take AI to backport patches tagged for stable...
> >
> > The revert of this patch, however:
> >
> >  1. Didn't have a stable tag.
> >  2. Didn't have a "Fixes:" tag.
> >  3. Didn't have the usual "the reverts commit ..." string added by git
> >  when one does a revert.
> >
> > Which is why we still kick patches for review, even though they had a
> > stable tag, just so people could take a look and confirm we're not
> > missing anything - like we did here.
> >
> > I'm not sure what you expected me to do differently here.
>
> Yeah this looks like fail on the revert side, they need to reference
> the reverted commit somehow ...
>
> Alex, why got this dropped? Is this more fallout from the back&forth
> shuffling you're doing between your internal branches behind the
> firewall, and the public history?

The behind the firewall comments are not really helpful.  There aren't
any "behind the firewall" trees.  Everything is mirrored in public.
Yes it is annoying that we don't have a direct committer tree, but the
only shuffling is between public trees.  The problem is 90% of our
customers want packaged out of tree drivers rather than in tree
drivers because they are using an old distro or a custom distro or
something else so we have to do this dance.  I realize there are other
dances we could do to solve this problem, but they all have their own
set of costs and this is what we have now.  The patch shuffling
doesn't help, but regardless, the same thing could happen even with a
direct committer tree if someone missed the tag when committing.

Alex

>
> Also adding Dave Airlie.
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
