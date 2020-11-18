Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F472B83A5
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgKRSLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 13:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgKRSLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 13:11:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C526420872;
        Wed, 18 Nov 2020 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605723108;
        bh=GDncWy8ESSBN1pabOMAXmhhQzWiSEvD97hTR7E9XGjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nq00NpBRbLX9enCO6BETJ3kdWGkPV5ZA76yaAEA6r2GJGR6kkw1J8WNvDfLuUklMV
         e5LCtZT1tPyeDRDdr3LTmGF/5FePW95OtFqa1PpIffj9Y1Q2qsWbo5/qIDRYZ8bJXd
         MfU7hDCronfc++DneFxps3WTYxHKfF+1ZX0GZKyE=
Date:   Wed, 18 Nov 2020 19:12:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hussam Al-Tayeb <ht990332@gmx.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        stable@vger.kernel.org
Subject: Re: Suggestion: Lengthen the review period for stable releases from
 48 hours to 7 days.
Message-ID: <X7VkEheJv7mUtXGo@kroah.com>
References: <17c526d0c5f8ed8584f7bee9afe1b73753d1c70b.camel@gmx.com>
 <20201117080141.GA6275@amd>
 <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
 <1605651898@msgid.manchmal.in-ulm.de>
 <20201118140953.GC629656@sasha-vm>
 <b50f0ee318cbedcd9bca95a1af00b520c4b3126b.camel@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b50f0ee318cbedcd9bca95a1af00b520c4b3126b.camel@gmx.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 08:02:16PM +0200, Hussam Al-Tayeb wrote:
> On Wed, 2020-11-18 at 09:09 -0500, Sasha Levin wrote:
> > On Tue, Nov 17, 2020 at 11:29:16PM +0100, Christoph Biedl wrote:
> > > On the other hand the pace of the stable patches became fairly
> > > high¹, so
> > > during a week of -rc review a *lot* of them will queue up and I
> > > predict
> > > we'll see requests for fast-laning some of them. Also, a release
> > > would
> > > immediately be followed by the next -rc review period, a procedure
> > > that
> > > gives me a bad feeling.
> >
> > Keep in mind that the stable tree derives itself from Linus's tree -
> > it's not a development tree on it's own and we don't control how many
> > fixes flow into Linus's tree (and as a result into the stable tree).
> >
> > This means that it doesn't matter how long the review window is open
> > for, you'll be getting the same time to review a single patch -
> > whether
> > we do 200 patches twice a week or 400 patches once a week. We can't
> > create time by moving review windows around.
> >
> 
> How long does it take for patches reaching Linux's tree to propagate
> down to the stable trees

It depends from a week, to a day, sometimes if it's important, an hour,
and sometimes months.

> and is there is mechanism for identifying
> followup patches?

Yes, happens all the time, don't you see this?  If we have missed any
fixes for fixes, please let us know, but our tools usually catch these
pretty well these days.

> In short, is there a guarantee that stable trees are as stable or
> better than mainline through the current SOP?

There's no guarantees in life, especially for free software :)

thanks,

greg k-h
