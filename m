Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A769B3B7F9E
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhF3JHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhF3JHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 05:07:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5075E61C4D;
        Wed, 30 Jun 2021 09:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625043917;
        bh=JpvRLiW6mt+Yal2I4CkLvJakelw/ne7ekB1oXgIhC+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJ7OdH+91IQvwpCcTSnz/daiGSkSdruA8/J8JPod75lTVRRYsSvbEsx24Vu4KQ5D+
         iUlwj614MjgQCOPHOXe0mHljMhWsAT4eSvXuz02g+TuRnYAsSdekNSBYF8WoGxcdLT
         bwnwvOLqDggkf2jhcUL0DulfaYJw5QBjDN6dHuLQ=
Date:   Wed, 30 Jun 2021 11:05:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Qiang Liu <cyruscyliu@gmail.com>
Cc:     Hugh Dickins <hughd@google.com>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        iLifetruth <yixiaonn@gmail.com>, Michal Hocko <mhocko@suse.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] nds32: fix up stack guard gap
Message-ID: <YNwzyyx+8N6lus+y@kroah.com>
References: <20210629104024.2293615-1-gregkh@linuxfoundation.org>
 <382e353f-7489-d8c8-5711-a2d99b0b7f0@google.com>
 <CAAKa2jn6LB14BYXJWoVoqgcqrjTYwJgLdDCa8mir=jOw6x5ZDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAKa2jn6LB14BYXJWoVoqgcqrjTYwJgLdDCa8mir=jOw6x5ZDA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 10:33:29AM +0800, Qiang Liu wrote:
> Hi,
> 
> On Wed, Jun 30, 2021 at 4:33 AM Hugh Dickins <hughd@google.com> wrote:
> >
> > On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:
> >
> > > Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
> > > up almost all architectures to deal with the stack guard gap, but forgit
> > > nds32.
> > >
> > > Resolve this by properly fixing up the nsd32's version of
> > > arch_get_unmapped_area()
> > >
> > > Reported-by: iLifetruth <yixiaonn@gmail.com>
> > > Cc: Nick Hu <nickhu@andestech.com>
> > > Cc: Greentime Hu <green.hu@gmail.com>
> > > Cc: Vincent Chen <deanbo422@gmail.com>
> > > Cc: Michal Hocko <mhocko@suse.com>
> > > Cc: Hugh Dickins <hughd@google.com>
> > > Cc: Qiang Liu <cyruscyliu@gmail.com>
> > > Cc: stable <stable@vger.kernel.org>
> > > Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > Acked-by: Hugh Dickins <hughd@google.com>
> >
> > but it's a bit unfair to say that commit forgot nds32:
> > nds32 came into the tree nearly a year later.
> Could we use "not forward ported to"?

Nah, it was just a mistake in the nds32 implementation when it was
submitted.

thanks,

greg k-h
