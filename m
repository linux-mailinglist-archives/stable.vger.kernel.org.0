Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1792717383B
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 14:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgB1NY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 08:24:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgB1NY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 08:24:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6552469D;
        Fri, 28 Feb 2020 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582896297;
        bh=ug9eHs2EpiK+YBjFQf4RcFDG3qY+jtqjLKWWo58n9r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r3TUEONCz3gkyWpHTIdd0sj9qIOem8qYcw1M2Iez10jnw3egXLaTv4VJLyoEGz7EA
         ToM9mi43y/+IG6vTVAzS3z8G5Dyim26HaMGazS14N6Gxs7SBEAiILyGkYMo5fi4qER
         S06lDLphyCAtcmizNuUm7WA3Iwv2p5sRYnxYngDU=
Date:   Fri, 28 Feb 2020 14:24:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miles Chen <miles.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 60/97] lib/stackdepot: Fix outdated comments
Message-ID: <20200228132455.GA3021902@kroah.com>
References: <20200227132214.553656188@linuxfoundation.org>
 <20200227132224.337663006@linuxfoundation.org>
 <20200228130532.GA2979@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228130532.GA2979@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 02:05:33PM +0100, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit ee050dc83bc326ad5ef8ee93bca344819371e7a5 ]
> > 
> > Replace "depot_save_stack" with "stack_depot_save" in code comments because
> > depot_save_stack() was replaced in commit c0cfc337264c ("lib/stackdepot:
> > Provide functions which operate on plain storage arrays") and removed in
> > commit 56d8f079c51a ("lib/stackdepot: Remove obsolete functions")
> 
> This is wrong.
> 
> > +++ b/lib/stackdepot.c
> > @@ -96,7 +96,7 @@ static bool init_stack_slab(void **prealloc)
> >  		stack_slabs[depot_index + 1] = *prealloc;
> >  		/*
> >  		 * This smp_store_release pairs with smp_load_acquire() from
> > -		 * |next_slab_inited| above and in depot_save_stack().
> > +		 * |next_slab_inited| above and in stack_depot_save().
> >  		 */
> >  		smp_store_release(&next_slab_inited, 1);
> >  	}
> 
> May have been outdated for mainline, but they are actually okay for
> 4.19.

Good catch, I'll go drop this from the stable queues (4.14, 4.9, and 4.19).

greg k-h
