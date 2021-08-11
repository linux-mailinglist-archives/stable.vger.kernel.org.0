Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A000B3E9236
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 15:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhHKNHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 09:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhHKNHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 09:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B7F560D07;
        Wed, 11 Aug 2021 13:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628687216;
        bh=qcTlRMTdng/DbA+1wbB5n4EdMMJWgDMlUQ9bV3LywUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pD8ogjIbgcl+s78ScsxVFt6sFVlPZqalp8R+XFdW0kWFDBcfgY6S/ZlxkieoDVV4o
         wvIRSd8GxyOxlhtvDsi2/gvKNPYswwlw4kM6T9ejIkb7GXOr1qyHyc9V4wPxve6iK6
         xVagAwh3GRd537LMzD93Y9JfkD9SjNBHgD+O++2o=
Date:   Wed, 11 Aug 2021 15:06:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: Re: [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in
 eb_parse()
Message-ID: <YRPLbV+Dq2xTnv2e@kroah.com>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811122702.GA8045@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 02:27:02PM +0200, Pavel Machek wrote:
> On Wed 2021-08-11 09:46:12, Greg Kroah-Hartman wrote:
> > On Wed, Aug 11, 2021 at 09:28:43AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Jonathan Gray <jsg@jsg.id.au>
> > > > 
> > > > The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 in
> > > > 6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it should
> > > > have leading to 'batch' being used uninitialised.  The 5.13 backport and
> > > > the mainline commit did not remove the portion this patch adds back.
> > > 
> > > This patch has no upstream equivalent, right?
> > > 
> > > Which is okay -- it explains it in plain english, but it shows that
> > > scripts should not simply search for anything that looks like SHA and
> > > treat it as upsteam commit it.
> > 
> > Sounds like you have a broken script if you do it that way.
> 
> That is what you told me to do!
> 
> https://lore.kernel.org/stable/YQEvUay+1Rzp04SO@kroah.com/

Yes, which is fine for matching sha1 values.

> I would happily adapt my script, but there's no
> good/documented/working way to determine upstream commit given -stable
> commit.
> 
> If we could agree on
> 
> Commit: (SHA)
> 
> in the beggining of body, that would be great.
> 
> Upstream: (SHA)
> 
> in sign-off area would be even better.

What exactly are you trying to do when you find a sha1?  For some reason
my scripts work just fine with a semi-free-form way that we currently
have been doing this for the past 17+ years.  What are you attempting to
do that requires such a fixed format?

thanks,

greg k-h
