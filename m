Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD83BD78
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 22:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389332AbfFJU3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 16:29:00 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:37484 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389331AbfFJU3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 16:29:00 -0400
Received: by mail-yb1-f176.google.com with SMTP id l66so4282361ybf.4
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 13:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWMnTaCtA0ApaontFRaHKkuBSu74zZvVh5DwIXCwLAI=;
        b=CKb9JhtOX28ioMMoPWYKAvc1FjzHaUEpFr33k9h3/h5+WaS9bjsNdGqDaAUs3huMES
         eYdYzTVjzM8nqKZNjjPOhC+1fIQc+frapR8hezM8ULVm+jLK16t6elu8J1U0kGorfUyN
         bYFM28hM3BirIBjfIDuyLIIZuxSlZGlqNDvMwVakIuJRuoT4LDPFZVq/zpRlEY7j98yW
         6NyxldX0z8p9Q1Ow2FEIAtFB5vMyB4GRjzCgo41s8LU9yjgVkmwsRq+Dj+/AX7rqhhnK
         G4KQW0B+QEC8RAxMPpAK4jo/hNPA2vXbh2XnWKKCYltZKgEyXLSLQzYC3LN1GVCa08mc
         n6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWMnTaCtA0ApaontFRaHKkuBSu74zZvVh5DwIXCwLAI=;
        b=Khpj/Y+TBMqBuZ8db3WxUnJh7MR6Y1jf1vTvZvKjVa8EAVQYqFtYASu/vvnc9atvcU
         BJXjD8FRDY0fx5NOsisxUfLl9lhot0F07DpFdnevKl/AdN53K4Lf0k33Cpb7dXK42Bjk
         V9nMWku3AVzXycq3UyHAcoGePzOFVztnpmd07SJeV1fB3L0bKhwXPXnTHhF/UpnG7d36
         nUnQIFpn1AdU+GHsC6Cwvzl0GpkStElL8dsGIk+LgvkbrYDJD0Hm0WW6Dxxc/2vEFIQo
         c1DOwHwwdUQ8Sa72+OoP4ZLWcGoUMekcITNwBQlj5t9lyzQRYmYysiO71BtweEnr7nEI
         F6nA==
X-Gm-Message-State: APjAAAXkQMamWFwv38YvAToqhvlepBIJcO/AkpKc3a3Poz/26F8zz075
        6DUbiUA63VirY3fXnLyHJ8tRdIXexc6nl6hM7nU=
X-Google-Smtp-Source: APXvYqw8tF+776j/5GAZ8SB4z5P3p8em4gBHudxzEtE1s255BTNvZ3GhoWL/M+Lwaxy+M+mL/Au92a9eeViqsTeEZxs=
X-Received: by 2002:a05:6902:4c3:: with SMTP id v3mr34371035ybs.144.1560198539412;
 Mon, 10 Jun 2019 13:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <1558603746191117@kroah.com> <CAOQ4uxip8H45S-UmWhNowv9sQUTYzcDMVCZxw=6AvFN-4c1Uvw@mail.gmail.com>
 <20190523195741.GA4436@kroah.com>
In-Reply-To: <20190523195741.GA4436@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 10 Jun 2019 23:28:46 +0300
Message-ID: <CAOQ4uxjKKJduAkomNHxo=T1i4-FVUJ_JABkXfpjz2qt=DAHTZA@mail.gmail.com>
Subject: Re: Patch "ovl: fix missing upper fs freeze protection on copy up for
 ioctl" has been added to the 4.19-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > This patch is fine for stable, but I have a process question.
> > All these patches from overlayfs 5.2-rc1 are also v4.9 stable candidates:
> >
> > 1. acf3062a7e1c - ovl: relax WARN_ON() for overlapping layers use case
> > 2. 98487de318a6 - ovl: check the capability before cred overridden
> > 3. d989903058a8 - ovl: do not generate duplicate fsnotify events for "fake" path
> > 4. 9e46b840c705 - ovl: support stacked SEEK_HOLE/SEEK_DATA
> >
> > #2 wasn't properly marked for stable, but the other are marked with
> > Fixes: and Reported-by:
> >
> > Are those marks not sufficient to get selected for stable trees these days?
>
> Not by default, no.  Sometimes they might get picked up if we get bored,
> or the auto-bot notices them.
>
> > I must admit that #1 in borderline stable. Not sure if eliminating an unjust
> > WARN_ON qualified, but syzbot did report a bug..
>
> syzbot things are good to fix in stable kernels, so that syzbot can
> continue to find real things in stable kernels.  So yes, that is fine to
> backport.
>
> > Just asking in order to improve the process, but in any case,
> > please pick those patches for v4.9+ (unless anyone objects?)
> > They all already have LTP/xfstests/syzkaller tests that cover them.
>
> I'll queue them up for the next round after this, thanks.
>

Hi Greg,

I forgot to follow up on those patches.
Now I look at linux-4.19.y, I only see patch #1 (ovl: relax WARN_ON()..)
and not the 3 other patches I listed as stable candidates.
Was there any issue with those patches?

Thanks,
Amir.
