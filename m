Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B4297186
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 16:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465244AbgJWOpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 10:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S375361AbgJWOpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 10:45:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D523C21527;
        Fri, 23 Oct 2020 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603464302;
        bh=tx/xCFuKw3P8gE6W5DzkANsOLBvQvsfJBKejB3vAZK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WTgQVnfERgKS4gB9JwdGQvFTfbrsgMw2ZR/uxfEch1+8frioryhNRZgkGAdsC5i/m
         cHh5nTqImFlZT3Mm/uFb5SgeKti6zn9EeZ1OWLgPugFoxp7uMRL/beR2cOSFw3F8c7
         4qb1HRq0D7nfVHuN3Mbl4ElU7P+G2nWJnmfocPBI=
Date:   Fri, 23 Oct 2020 16:45:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: does 548b8b5168c9 qualify for stable?
Message-ID: <20201023144537.GA2524936@kroah.com>
References: <4f1324d2-6b0f-dcb6-ff58-a6a05a15d407@rasmusvillemoes.dk>
 <20201023142231.GA2518006@kroah.com>
 <d4e98ed1-bd02-fb7a-d520-8ccdd91e9c48@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4e98ed1-bd02-fb7a-d520-8ccdd91e9c48@rasmusvillemoes.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 23, 2020 at 04:37:25PM +0200, Rasmus Villemoes wrote:
> On 23/10/2020 16.22, Greg KH wrote:
> > On Fri, Oct 23, 2020 at 03:40:26PM +0200, Rasmus Villemoes wrote:
> >> Hi,
> >>
> >> Please consider whether
> >>
> >> commit 548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8
> >> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >> Date:   Thu Sep 17 08:56:11 2020 +0200
> >>
> >>     scripts/setlocalversion: make git describe output more reliable
> >>
> >> qualifies for -stable. 
> > 
> > Looks like it qualifies, how far back do you want it to go?
> > 
> 
> Cool, thanks. I think we have a project using 4.9.y, certainly we have
> projects based on 4.19 and 5.4 - so might as well make it all of the
> ones listed on kernel.org currently.
> 
> > And yes, backported patches always make it much easier to apply :)
> 
> OK. How do you prefer to get those? Individual patch emails with [PATCH
> X.Y-stable] in subject?

That works.

> Or should I put them in a git repo you can cherry-pick them from?

git repos don't work, email does :)

> Should I include the "Commit 548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8
> upstream" line?

Yes please.

> How about notes on how it differs from the upstream commit (e.g. when
> just the context uses `` instead of $() or similar)?

That is also nice to have, if possible, whatever you feel like doing
here.

thanks,

greg k-h
