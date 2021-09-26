Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C11A4189B0
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 17:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhIZPGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 11:06:06 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:42944 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231944AbhIZPGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 11:06:03 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 18QF3Uol015040;
        Sun, 26 Sep 2021 17:03:30 +0200
Date:   Sun, 26 Sep 2021 17:03:29 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jari Ruusu <jariruusu@protonmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: glibc VETO for kernel version SUBLEVEL >= 255
Message-ID: <20210926150329.GA13506@1wt.eu>
References: <qscod31lyVG7t-CW63o_pnsara-v9Wf6qXz9eSfUZnxtHk2AkeJ73yvER1XYO_311Wxo2wC8L2JuTdLJm8vgvhVVaGa5fdumXx5iHWarqwA=@protonmail.com>
 <YVAhOlTsb0NK0BVi@kroah.com>
 <YVArDZSq9oaTFakz@eldamar.lan>
 <YVA9l9svFyDgLPJy@kroah.com>
 <xxvm9EznCQoQ_-YYhxhEknGTxHEnVW584ypJShT__L09eV-JOfFtr-K4M33xRa3VTL5tNgOGvJSUqWthW-El4IwTi6Vt4B_XZA-xMB6vOEY=@protonmail.com>
 <YVBYfQY94j7K39qc@kroah.com>
 <gjSfoj7RAJMOeVL1pzzsZl5SjMGR_BXqigZqgkJe4G_8PPfm3EhxRlrRi-I7-Z0guYL0DAFOWeSWmrt_R8RcgzNq6Bcnk7BlQ9g3_G9aT2w=@protonmail.com>
 <YVBb9ZoDGgV4cbXb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVBb9ZoDGgV4cbXb@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 26, 2021 at 01:39:33PM +0200, Greg Kroah-Hartman wrote:
> On Sun, Sep 26, 2021 at 11:31:20AM +0000, Jari Ruusu wrote:
> > On Sunday, September 26th, 2021 at 14:24, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > Why use an older kernel tree on this device? Rasbian seems to be on
> > > 4.19.y at the least right now, is there something in those older kernel
> > > trees that you need?
> > 
> > Due to circumstances, I need "smallest possible" kernel with all extra
> > stripped out. 4.9.y kernels are smaller than newer ones.
> 
> Smaller by how much, and what portion grew?  Are we building things into
> the kernel that previously was able to be compiled out?  Or is there
> something new added after 4.9 that adds a huge memory increase?
> 
> Figuring that out would be good as you only have 1 more year for 4.9.y
> to be alive, that's not going to last for forever...

FWIW a situation I faced a few times was trying to put a modern kernel
on a small NAND partition of an older device. Nowadays kernels are really
big. I don't have numbers here but for example I never managed to make a
5.10 fit into the 4 MB partition of an old armv5 device where its 3.4 had
plenty of room. And there isn't a single thing to disable, it looks more
like a systemic growth, probably due to all the stuff we now have to
improve large systems performance and harden everything.

Willy
