Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC54B325E4C
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 08:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhBZHcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 02:32:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhBZHcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 02:32:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3766A64ED3;
        Fri, 26 Feb 2021 07:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614324702;
        bh=ND2aNeSDF+CdZU//MneX68fHcP77aarQea98G/sjog8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kyTVO/5zoV3mCcbKZbeXmldvDRSAWZfPiUe27bW63bx306jI3XR4sLsfLkzbdwxIX
         dShMl/9mAMELUcii6lq8l3MgeKRu5uZjzVAqUurR0Mz2a8GpaNMH6U2CvFQSaq4AoV
         hTeDK0LeCDH5mt+3MWxHjJtPd1gWo9nS+mh/+2sQ=
Date:   Fri, 26 Feb 2021 08:31:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Douglas Anderson <dianders@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, stefan.saecherl@fau.de,
        qy15sije@cip.cs.fau.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] kgdb: Fix to kill breakpoints on initmem after boot
Message-ID: <YDij234n3KAxWuXf@kroah.com>
References: <20210224081652.587785-1-sumit.garg@linaro.org>
 <20210225155607.634snzzq3w62kpkn@maple.lan>
 <CAFA6WYMYDNk2S=7crfYsrbP7XONTA-ytEypoqeo1GTpxf8NhAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYMYDNk2S=7crfYsrbP7XONTA-ytEypoqeo1GTpxf8NhAQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 12:32:07PM +0530, Sumit Garg wrote:
> + stable ML
> 
> On Thu, 25 Feb 2021 at 21:26, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
> >
> > On Wed, Feb 24, 2021 at 01:46:52PM +0530, Sumit Garg wrote:
> > > Currently breakpoints in kernel .init.text section are not handled
> > > correctly while allowing to remove them even after corresponding pages
> > > have been freed.
> > >
> > > Fix it via killing .init.text section breakpoints just prior to initmem
> > > pages being freed.
> > >
> > > Suggested-by: Doug Anderson <dianders@chromium.org>
> > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> >
> > I saw Andrew has picked this one up. That's ok for me:
> > Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
> >
> > I already enriched kgdbtest to cover this (and they pass) so I guess
> > this is also:
> > Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
> >
> 
> Thanks Daniel.
> 
> > BTW this is not Cc:ed to stable and I do wonder if it crosses the
> > threshold to be considered a fix rather than a feature. Normally I
> > consider adding safety rails for kgdb to be a new feature but, in this
> > case, the problem would easily ensnare an inexperienced developer who is
> > doing nothing more than debugging their own driver (assuming they
> > correctly marked their probe function as .init) so I think this weighs
> > in favour of being a fix.
> >
> 
> Makes sense, Cc:ed stable.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
