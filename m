Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6A63CA0ED
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 16:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhGOOuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 10:50:18 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60522 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235310AbhGOOuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 10:50:18 -0400
Received: from callcc.thunk.org (96-65-121-81-static.hfc.comcastbusiness.net [96.65.121.81])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16FEl3hj017299
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 10:47:04 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C6F574202F5; Thu, 15 Jul 2021 10:47:02 -0400 (EDT)
Date:   Thu, 15 Jul 2021 10:47:02 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YPBKZnWfK08PWarN@mit.edu>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7sNd+6Vlw+hw3y@sashalap>
 <YO8EQZF4+iQ13QU/@mit.edu>
 <YO8Gzl2zmg8+R8Uu@kroah.com>
 <YO8dN9U7J2bi1gkf@mit.edu>
 <YO8gFgQIRYvCODBT@kroah.com>
 <CAMuHMdUi+HsApqRwBDBFnfnAOs9EprDh5HCV4UncEL_cnXZasA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUi+HsApqRwBDBFnfnAOs9EprDh5HCV4UncEL_cnXZasA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 11:01:04AM +0200, Geert Uytterhoeven wrote:
> > Because cc: stable came first, and for some reason people think that it
> > is all that is necessary to get patches committed to the stable tree,
> > despite it never being documented or that way.  I have to correct
> > someone about this about 2x a month on the stable@vger list.
> 
> For a developer, it's much easier to not care about "Cc: stable"
> at all, because as soon as you add a "Cc: stable" to a patch, or CC
> stable, someone will compain ;-)  Much easier to just add a Fixes: tag,
> and know it will be backported to trees that have the "buggy" commit.

What sort of complaints have you gotten?  I add "cc: stable" for the
ext4 tree, and I can't say I've gotten any complaints.

     	       	       	   	       - Ted
