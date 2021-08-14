Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C955A3EC0FC
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 08:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhHNGsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 02:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhHNGr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Aug 2021 02:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C2160EAF;
        Sat, 14 Aug 2021 06:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628923651;
        bh=pbU3Fmrno5HMnI4EhNQYmptFhrmwUnDuwzGpb9kreq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=af7CDPnwwFt9sPCoWJweLq20kXrPXikJAbr31Zj2++jrmWV+ihaD3YN1lWuw3aNfv
         P/0WH9FrEnHG2XsuiqPzf/H0Kcrr2I9tUt+BcbGNqmOKfhLI2OQVdd/B2bJhIpAFlg
         SSYcHdaCbc8wSM7tsuE0XiCzS1h+pqRMQ7SxGUJA=
Date:   Sat, 14 Aug 2021 08:47:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <YRdnANmNvp+Hkcg5@kroah.com>
References: <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
 <20210813102429.GA28610@duo.ucw.cz>
 <YRZRU4JIh5LQjDfE@kroah.com>
 <20210813111953.GB21912@1wt.eu>
 <YRaT3u4Qes8UY3x6@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRaT3u4Qes8UY3x6@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 11:46:38AM -0400, Theodore Ts'o wrote:
> On Fri, Aug 13, 2021 at 01:19:53PM +0200, Willy Tarreau wrote:
> > 
> > Plus this adds some cognitive load on those writing these patches, which
> > increases the global effort. It's already difficult enough to figure the
> > appropriate Cc list when writing a fix, let's not add more burden in this
> > chain.
> > 
> > ...
> > 
> > I'm also defending this on other projects. I find it important that
> > efforts are reasonably shared. If tolerating 1% failures saves 20%
> > effort on authors and adds 2% work on recipients, that's a net global
> > win. You never completely eliminate mistakes anyway, regardless of the
> > cost.
> 
> The only way I can see to square the circle would be if there was some
> kind of script that added enough value that people naturally use it
> because it saves *them* time, and it automatically inserts the right
> commit metadata in some kind of standardized way.
> 
> I've been starting to use b4, and that's a great example of a workflow
> that saves me time, and standardizes things as a very nice side
> effect.  So perhaps the question is there some kind of automation that
> saves 10-20% effort for authors *and* improves the quality of the
> patch metadata for those that choose to use the script?

A script/tool does generate the metadata in the "correct" way, as that
is what Sasha and I use.  It is the issue for when people do it on their
own for various reasons and do not just point us at an upstream commit
that can cause issues.  In those cases, people wouldn't be using any
script anyway, so there's nothing really to do here.

thanks,

greg k-h
