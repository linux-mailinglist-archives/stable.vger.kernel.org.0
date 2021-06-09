Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F743A0EEC
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbhFIIwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:52:13 -0400
Received: from muru.com ([72.249.23.125]:39892 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhFIIwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:52:13 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C759780F5;
        Wed,  9 Jun 2021 08:50:24 +0000 (UTC)
Date:   Wed, 9 Jun 2021 11:50:13 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for linux-5.4.y PATCH 2/4] ARM: OMAP2+: Prepare timer
 code to backport dra7 timer wrap errata i940
Message-ID: <YMCAxXPUkSR1yxK3@atomide.com>
References: <20210602104625.6079-1-tony@atomide.com>
 <20210602104625.6079-2-tony@atomide.com>
 <YL+lOumPYQ1fNoYw@kroah.com>
 <YMBcIbBPfr6W19j5@atomide.com>
 <YMBeI4aOMmWMRsu/@kroah.com>
 <YMBmpAY04FRKOLMT@atomide.com>
 <YMBuVJBzGjm+aVbV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMBuVJBzGjm+aVbV@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg KH <greg@kroah.com> [210609 07:31]:
> On Wed, Jun 09, 2021 at 09:58:44AM +0300, Tony Lindgren wrote:
> > * Greg KH <greg@kroah.com> [210609 06:22]:
> > > On Wed, Jun 09, 2021 at 09:13:53AM +0300, Tony Lindgren wrote:
> > > > How about the following for the description:
> > > > 
> > > > Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
> > > > struct dmtimer_clockevent backported to the platform timer code
> > > > still used in linux-5.4.y stable kernel. Needed to backport upstream
> > > > commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> > > > 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels use
> > > > mach-omap2/timer instead of drivers/clocksource as these kernels still
> > > > depend on legacy platform code for booting.
> > > 
> > > Why are you combining 2 commits into one here?
> > 
> > OK so still too confusing, how about let's just have:
> > 
> > Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
> > struct dmtimer_clockevent backported to the platform timer code
> > still used in linux-5.4.y stable kernel.
> 
> Why not just use the normal commit message with the "upstream commit..."
> message as the first line, and then in the s-o-b area add
> [backported to 5.4.y - tony]
> 
> That's the normal thing we do here for backporting.

OK sure works for me thanks. I will repost the series with
updated patch descriptions.

Regards,

Tony

