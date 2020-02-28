Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58666173198
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 08:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgB1HNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 02:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgB1HNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 02:13:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1FF6246A0;
        Fri, 28 Feb 2020 07:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582874021;
        bh=VHXmD4OTdDkdv1F2TKoSjZSFerLMd9X6FArKd5vBcGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wAJvIxqZqpGdxdB/VYY5QDooW62VbfVSQZLoSos/NVn9PdLKih3f8xwU9USNV6p09
         V5cWClU3WEC5oSrV+01uIfjr9+DxNFTU/oYO+Cm4OZ4w1DD7bdP98I1B371J2bflnB
         Rkukd5n/5kAZDnIaKjkYd7sQuvygL9I/rTBtbFHU=
Date:   Fri, 28 Feb 2020 08:06:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: device link patches on 4.19.99 breaks functionality
Message-ID: <20200228070610.GA2895159@kroah.com>
References: <CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com>
 <20200227095107.GB579982@kroah.com>
 <CAGETcx-RCS84nWAU7BPZSaXei5VCV1X+S48eYoSjYhgmjaFq0A@mail.gmail.com>
 <CAGETcx8kFOHMmCd3gopUmQgFp+DfC45gVqVkNbb4TwWmvZOJkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8kFOHMmCd3gopUmQgFp+DfC45gVqVkNbb4TwWmvZOJkA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 02:17:38PM -0800, Saravana Kannan wrote:
> On Thu, Feb 27, 2020 at 1:26 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Thu, Feb 27, 2020 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Feb 21, 2020 at 01:21:00AM -0800, Saravana Kannan wrote:
> > > > 4.19.99 seems to have picked up quite a few device link patches.
> > > > However, one of them [1] broke the ability to add stateful and
> > > > stateless links between the same two devices. Looks like the breakage
> > > > was fixed in the mainline kernel in subsequent commits [2] and [3].
> > > >
> > > > Can we pull [2] and [3] into 4.19 please? And any other intermediate
> > > > device link patches up to [3].
> > > >
> > > > [1] - 6fdc440366f1a99f344b629ac92f350aefd77911
> > > > [2] - 515db266a9da
> > > > [3] - fb583c8eeeb1 (this fixed a bug in [2])
> > >
> > > "up to"?
> > >
> > > 515db266a9da does not apply to 4.19, so should I just drop [1] instead?
> > >
> > > Or, can you provided a backported set of patches so I know exactly what
> > > to apply?
> >
> > Let me take a stab at backporting [2] and [3] or whatever else might
> > be necessary. What git repo/branch did you want me to try that on?
> 
> I'm assuming this one:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y

Yes, that is the one, thanks.

greg k-h
