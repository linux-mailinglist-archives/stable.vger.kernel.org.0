Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D48381F30
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEPOC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 10:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhEPOC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 10:02:28 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A175C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 07:01:11 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 6FD9C92009C; Sun, 16 May 2021 16:01:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 6D8F292009B;
        Sun, 16 May 2021 16:01:09 +0200 (CEST)
Date:   Sun, 16 May 2021 16:01:09 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.12] MIPS: Reinstate platform `__div64_32' handler
In-Reply-To: <YKDiQUcuqIDwRvyg@kroah.com>
Message-ID: <alpine.DEB.2.21.2105161558240.3032@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2105160318070.3032@angie.orcam.me.uk> <YKDiQUcuqIDwRvyg@kroah.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 16 May 2021, Greg KH wrote:

> > Reported-by: Huacai Chen <chenhuacai@kernel.org>
> > Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> > Fixes: c21004cd5b4c ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
> > Cc: stable@vger.kernel.org # v2.6.30+
> > ---
> > Hi,
> > 
> >  This is a backported version of commit c49f71f60754 with a fix for MIPSr6 
> > compilation, that is commit 25ab14cbe9d1 included and the commit message 
> > amended accordingly.  I have folded intermediate commit c1d337d45ec0 into 
> > this change as well, as trivially obvious and mechanically in the way 
> > between the two former changes, though strictly speaking an enhancement 
> > rather than a fix.  This way the state between master and stable branches 
> > is consistent.
> > 
> >  Rationale: the three changes could be applied separately as with master, 
> > however we'd have an unnecessary intermediate MIPSr6 build regression, 
> > which caused the drop of the original fix.
> > 
> >  This is for 5.12-stable and before.  Let me know if you'd prefer me to 
> > resolve this differently, or otherwise please apply.
> > 
> >  NB verified with a couple of representative defconfigs and booted on hw 
> > where available (with the test_div64 test module backported and enabled).
> 
> I would prefer to take the same exact commits that are in Linus's tree,
> that makes it easier to track over time and ensure that we have this
> correct.
> 
> So what commit ids should I apply in what order?

 Sure, this will be commits: c49f71f60754, c1d337d45ec0, 25ab14cbe9d1 in 
the order given.

  Maciej
