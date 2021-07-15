Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAF53CA115
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhGOPGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:06:31 -0400
Received: from mail-vk1-f174.google.com ([209.85.221.174]:35451 "EHLO
        mail-vk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhGOPGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 11:06:30 -0400
Received: by mail-vk1-f174.google.com with SMTP id d7so1369052vkf.2;
        Thu, 15 Jul 2021 08:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EAL3ij4XHjgPpAzfV3wX0aIEqeSH+vMpMbMC6ALQt4E=;
        b=BT6pfSR9BcHfAHBPvx40QPag8S8c5fBSS+7k2VZeKd4glxl6HyVgzjYQ1+JN5xmi9P
         OnZU41IYQT8fQsHhax2uuK6Mc7QJ0kQb/QfrZqaaxp/qSRJpNoD2S3Dnes8u26FhQ0bi
         cHdjCKzxVzGwg+nhxKE7i/aiPx2zS1rzdZRgHinMm3wOyBYO58JxtMXnBdFaDXue6ImO
         gNetsHAWUlgbyZ1h6sZWJR6G6Mxnbe20lb7DMhoiM9lmoA6J5KAWQlDWHCHZmz5whkf3
         R5kzIa22XnWFMBVHRBq/jQ0PwLoRt+IhfQ89So3o5ZaP4CmTNzl6FsK6SB17vVtKtYsf
         9+zw==
X-Gm-Message-State: AOAM5336LV/0Inx4fHWW9nLKfBRzaNfmUBZqDVL/T1YIzzTxcNeBI8DI
        BxS0RZus65N6ErCjvaBvG5LQfRIUgoH9nuw5JDE=
X-Google-Smtp-Source: ABdhPJwbqg3ncsIf8J4QDR0YkMtKrmi/eHuq+3V/c8gGsc897xRlIPN5LQKmvS/uo7TCrlmUYMIDLB0TgFoq5+M8MEA=
X-Received: by 2002:a1f:2746:: with SMTP id n67mr6163414vkn.5.1626361416269;
 Thu, 15 Jul 2021 08:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com> <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com> <YO7sNd+6Vlw+hw3y@sashalap> <YO8EQZF4+iQ13QU/@mit.edu>
 <YO8Gzl2zmg8+R8Uu@kroah.com> <YO8dN9U7J2bi1gkf@mit.edu> <YO8gFgQIRYvCODBT@kroah.com>
 <CAMuHMdUi+HsApqRwBDBFnfnAOs9EprDh5HCV4UncEL_cnXZasA@mail.gmail.com> <YPBKZnWfK08PWarN@mit.edu>
In-Reply-To: <YPBKZnWfK08PWarN@mit.edu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Jul 2021 17:03:25 +0200
Message-ID: <CAMuHMdW4UA_143NzSc=72toFUzV8man9xH6Qo9TGVHuskvBjhw@mail.gmail.com>
Subject: Re: 5.13.2-rc and others have many not for stable
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ted,

On Thu, Jul 15, 2021 at 4:47 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 15, 2021 at 11:01:04AM +0200, Geert Uytterhoeven wrote:
> > > Because cc: stable came first, and for some reason people think that it
> > > is all that is necessary to get patches committed to the stable tree,
> > > despite it never being documented or that way.  I have to correct
> > > someone about this about 2x a month on the stable@vger list.
> >
> > For a developer, it's much easier to not care about "Cc: stable"
> > at all, because as soon as you add a "Cc: stable" to a patch, or CC
> > stable, someone will compain ;-)  Much easier to just add a Fixes: tag,
> > and know it will be backported to trees that have the "buggy" commit.
>
> What sort of complaints have you gotten?  I add "cc: stable" for the
> ext4 tree, and I can't say I've gotten any complaints.

Usually a complaint about using the wrong process for subsystem X.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
