Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DAF12092
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfEBQws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfEBQws (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 12:52:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3BB2133F;
        Thu,  2 May 2019 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556815967;
        bh=wBfk1M/BwLkHjDbKma+JilJCMr3ehhSnhmx7DeDn5TA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GdxfdLLg+d6NiGCiDd6q580aEkdZ8+c02xPgLo4s28oc9ODog5IThLqqxatJc+tSy
         NMHsYjNpMPhMEXCtVIqjCXA15983Nd2zZjnEdFtJX3EnD9LGGNLwvVFcwRpkpIPN36
         dSUT/6V6dGld2WbYTmH9qdJIalE9f1LzkjDU2sRs=
Date:   Thu, 2 May 2019 18:52:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andre Noll <maan@tuebingen.mpg.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502165244.GB14995@kroah.com>
References: <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
 <20190502132027.GF11584@sasha-vm>
 <20190502141025.GB13141@kroah.com>
 <20190502152736.GW2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502152736.GW2780@tuebingen.mpg.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 05:27:36PM +0200, Andre Noll wrote:
> On Thu, May 02, 16:10, Greg Kroah-Hartman wrote
> > Ok, then how about we hold off on this patch for 4.9.y then.  "no one"
> > should be using 4.9.y in a "server system" anymore, unless you happen to
> > have an enterprise kernel based on it.  So we should be fine as the
> > users of the older kernels don't run xfs.
> 
> Well, we do run xfs on top of bcache on vanilla 4.9 kernels on a few
> dozen production servers here. Mainly because we ran into all sorts
> of issues with newer kernels (not necessary related to xfs). 4.9,
> OTOH, appears to be rock solid for our workload.

Great, but what is wrong with 4.14.y or better yet, 4.19.y?  Do those
also work for your workload?  If not, we should fix that, and soon :)

I would _STRONGLY_ recommend moving of of 4.9 on any non-SoC-based
system at this point in time, there should not be any reason to stick
with it, unless you are paying a company to provide support for it.

thanks,

greg k-h
