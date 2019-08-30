Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8484A3104
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 09:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfH3Ha0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 03:30:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45148 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfH3Ha0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Aug 2019 03:30:26 -0400
Received: from 162-237-133-238.lightspeed.rcsntx.sbcglobal.net ([162.237.133.238] helo=elm)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <tyhicks@canonical.com>)
        id 1i3bMV-0000hq-Ga; Fri, 30 Aug 2019 07:30:23 +0000
Date:   Fri, 30 Aug 2019 02:30:19 -0500
From:   Tyler Hicks <tyhicks@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Todd Kjos <tkjos@android.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 4.19 11/29] binder: take read mode of mmap_sem in
 binder_alloc_free_page()
Message-ID: <20190830073019.GA16891@elm>
References: <20190829105009.2265-1-sashal@kernel.org>
 <20190829105009.2265-11-sashal@kernel.org>
 <20190829151320.GC27650@elm>
 <20190830062910.GC15257@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830062910.GC15257@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-08-30 08:29:10, Greg Kroah-Hartman wrote:
> On Thu, Aug 29, 2019 at 10:13:20AM -0500, Tyler Hicks wrote:
> > Hello, Sasha!
> > 
> > On 2019-08-29 06:49:51, Sasha Levin wrote:
> > > From: Tyler Hicks <tyhicks@canonical.com>
> > > 
> > > [ Upstream commit 60d4885710836595192c42d3e04b27551d30ec91 ]
> > > 
> > > Restore the behavior of locking mmap_sem for reading in
> > > binder_alloc_free_page(), as was first done in commit 3013bf62b67a
> > > ("binder: reduce mmap_sem write-side lock"). That change was
> > > inadvertently reverted by commit 5cec2d2e5839 ("binder: fix race between
> > > munmap() and direct reclaim").
> > > 
> > > In addition, change the name of the label for the error path to
> > > accurately reflect that we're taking the lock for reading.
> > > 
> > > Backporting note: This fix is only needed when *both* of the commits
> > > mentioned above are applied. That's an unlikely situation since they
> > > both landed during the development of v5.1 but only one of them is
> > > targeted for stable.
> > 
> > This patch isn't meant to be applied to 4.19 since commit 3013bf62b67a
> > ("binder: reduce mmap_sem write-side lock") was never brought back to
> > 4.19.
> > 
> > Tyler
> > 
> > > 
> > > Fixes: 5cec2d2e5839 ("binder: fix race between munmap() and direct reclaim")
> 
> But this commit is in 4.19.49

That's correct but commit 3013bf62b67a isn't present in 4.19.y. See the
"Backporting note" above.

Tyler

> 
> thanks,
> 
> greg k-h
