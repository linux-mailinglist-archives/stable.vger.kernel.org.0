Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3545D3A0C39
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhFIGPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:15:52 -0400
Received: from muru.com ([72.249.23.125]:39756 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFIGPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 02:15:51 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id EB3628061;
        Wed,  9 Jun 2021 06:14:04 +0000 (UTC)
Date:   Wed, 9 Jun 2021 09:13:53 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for linux-5.4.y PATCH 2/4] ARM: OMAP2+: Prepare timer
 code to backport dra7 timer wrap errata i940
Message-ID: <YMBcIbBPfr6W19j5@atomide.com>
References: <20210602104625.6079-1-tony@atomide.com>
 <20210602104625.6079-2-tony@atomide.com>
 <YL+lOumPYQ1fNoYw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL+lOumPYQ1fNoYw@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

* Greg KH <greg@kroah.com> [210608 17:13]:
> On Wed, Jun 02, 2021 at 01:46:23PM +0300, Tony Lindgren wrote:
> > Prepare linux-5.4.y to backport upstream timer wrap errata commit
> > 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> > 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels still use
> > mach-omap2/timer instead of drivers/clocksource as these kernels still
> > depend on legacy platform code for timers. Note that earlier stable
> > kernels need also additional patches and will be posted separately.
> 
> I do not understand this paragraph.
> 
> What upstream commit is this?  And "posted separately" shouldn't show up
> in a changelog text, right?

This would be a partial backport to add struct dmtimer_clockevent from
commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 to the platform timer
code used in the older kernels.

How about the following for the description:

Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
struct dmtimer_clockevent backported to the platform timer code
still used in linux-5.4.y stable kernel. Needed to backport upstream
commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels use
mach-omap2/timer instead of drivers/clocksource as these kernels still
depend on legacy platform code for booting.

> Can you fix this up to make this obvious what is happening here and make
> a patch series that I can take without editing changelog text?

Sure I'll repost the series, assuming the above is OK for description :)
Please let me know if you need further details added.

Hmm so what's the correct way to prevent automatically applying these
into the earlier stable kernels?

For earlier stable kernels, these changes depend on at least some
additional clock related changes.

Regards,

Tony
