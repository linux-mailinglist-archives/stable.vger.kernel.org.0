Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9722C3457D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 13:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfFDLeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 07:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfFDLeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 07:34:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13A424BF6;
        Tue,  4 Jun 2019 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559648054;
        bh=6o8kDRl9ZjidLYvEGKFXBpe5HVTMxK7R7OmhSzDbEfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jRpuSIGnEJZC9lWnEiG4ta5ZxesxUFiSo+VruQN3DH4JqNS734VjQeyRpFo8GQ5pS
         WKTa9W6vC7Kg0C15OXPqB6YgTK99dMr3qDWlmZJaDdSaYr4YgtnXLyMlhtc9idppTm
         +JooOxAcRNwJUjP7VHKKhkjIfUfXVZjZ42U7grTA=
Date:   Tue, 4 Jun 2019 13:34:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert "btrfs: Honour FITRIM range constraints during
 free space trim" from all stable trees
Message-ID: <20190604113411.GC18535@kroah.com>
References: <20190529112314.GY15290@suse.cz>
 <20190529113300.GB11952@kroah.com>
 <20190529115752.GZ15290@suse.cz>
 <20190604081920.GG6840@kroah.com>
 <20190604110355.GX15290@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604110355.GX15290@suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 01:03:55PM +0200, David Sterba wrote:
> On Tue, Jun 04, 2019 at 10:19:20AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 29, 2019 at 01:57:52PM +0200, David Sterba wrote:
> > > On Wed, May 29, 2019 at 04:33:00AM -0700, Greg Kroah-Hartman wrote:
> > > > On Wed, May 29, 2019 at 01:23:14PM +0200, David Sterba wrote:
> > > > > Hi,
> > > > > 
> > > > > upon closer inspection we found a problem with the patch
> > > > > 
> > > > > "btrfs: Honour FITRIM range constraints during free space trim"
> > > > > 
> > > > > that has been merged to 5.1.4. This could happen with ranged FITRIM
> > > > > where the range is not 'honoured' as it was supposed to.
> > > > > 
> > > > > Please revert it and push in the next stable release so the buggy
> > > > > version is not in the wild for too long.
> > > > > 
> > > > > Affected trees:
> > > > > 
> > > > > 5.0.18
> > > > > 5.1.4
> > > > > 4.9.179
> > > > > 4.19.45
> > > > > 4.14.122
> > > > > 
> > > > > Master branch will have the revert too. Thanks.
> > > > 
> > > > What is the git commit id of the revert in Linus's tree?
> > > 
> > > The commit is not there yet, I'm going to send it with the next update
> > > in a few days for 5.2-rc2.
> > > 
> > > To shorthen the delay I hope it's possible to revert the patches without
> > > the corresponding master commit but if you insist on that I'll send the
> > > pull request today and will let you know the commit id.
> > 
> > Did this ever get reverted in Linus's tree?  I can't seem to find it...
> 
> The patches 2 and 4 from this patchset
> 
> https://patchwork.kernel.org/project/linux-btrfs/list/?series=126297
> 
> will implement the equivalent change. Scheduled for merge to 5.2-rc4,
> the patches were not available last week.

You might want to mark those for stable, if this is a big deal :)

thanks,

greg k-h
