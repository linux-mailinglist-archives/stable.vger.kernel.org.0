Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1101B78C4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDXPCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgDXPCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 11:02:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95FBB20706;
        Fri, 24 Apr 2020 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587740555;
        bh=Fj2S3F/OmiTweW9mhD8inBZXbZ8mycgLwEUngsWxwOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXQR2x3mUb5HlJzPpJZ2H0z+sXMeW+fNn7OXQCsoYZPgQmZjqtfolVBm5UYem+h8B
         26xdZEoF3HYVpRATY6aSoBqsOQDy6T7nNU58bqwlBKNU6kYe2mHYknqL27hpjzWjxB
         OR305xeHKt8phS6kf50f65ftxXM8GQzMFrACH5rc=
Date:   Fri, 24 Apr 2020 17:02:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: List of patches to apply to stable releases
Message-ID: <20200424150232.GC607082@kroah.com>
References: <20200422194306.GA103402@roeck-us.net>
 <20200424101118.GC381429@kroah.com>
 <20200424140218.GA136135@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424140218.GA136135@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 07:02:18AM -0700, Guenter Roeck wrote:
> On Fri, Apr 24, 2020 at 12:11:18PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 22, 2020 at 12:43:06PM -0700, Guenter Roeck wrote:
> > 
> [ ... ]
> > > 
> > > Upstream commit ce4e45842de3 ("crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static")
> > >   upstream: v4.20-rc1
> > >     Fixes: c709eebaf5c5 ("crypto: mxs-dcp - Fix SHA null hashes and output length")
> > >       in linux-4.4.y: 33378afbd12b
> > >       in linux-4.9.y: df1ef6f3c9ad
> > >       in linux-4.14.y: c0933fa586b4
> > >       in linux-4.19.y: 70ecd0459d03
> > >       upstream: v4.20-rc1
> > >     Affected branches:
> > >       linux-4.4.y
> > >       linux-4.9.y
> > >       linux-4.14.y
> > >       linux-4.19.y
> > 
> > That's really not a "bug", but I'll take it to keep your scripts happy.
> > 
> No need to do that - if it happens please let me know and feel free to
> drop. The script finds lots of irrelevant patches which are (often
> unnecessarily) marked as Fixes: (maybe we should have a rule stating that
> comment changes or documentation changes don't count as "fix"). I already
> drop a lot of them, and feedback like this helps me decide what to drop
> in the future.
> 
> In this case I kept the patch in the list not for the happiness of the
> script but for the happiness of static analyzers. While it doesn't fix
> a bug per se, it reduces the noise produced by those, which I think does
> help because less noise improves focus on real bugs.

Yes it does, good point, but I don't want to start backporting all
sparse warning fixes to stable kernels just yet :)
