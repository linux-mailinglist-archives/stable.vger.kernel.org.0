Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E0341A3
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfFDITX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726732AbfFDITX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 04:19:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0503924963;
        Tue,  4 Jun 2019 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559636362;
        bh=xMO9UObsezuXeCIEXeQJ8UXmRjag2Ce/Q6TmtoEVfsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tCXvoP3BZRtixZ1awWVxknWGssK1+9t/HTawFEGhW/ip/Z6T7h7jQDcJpY1l4OxwM
         QHEmosjlqD7FTYxaW1ZvuiNK6OIh0LlGKBObRuarQquLahv/0Eff5QOij95N4hov4t
         YZdawQRmTUU2tT1s6/IDRescepvpgcHBUzG1J3VA=
Date:   Tue, 4 Jun 2019 10:19:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert "btrfs: Honour FITRIM range constraints during
 free space trim" from all stable trees
Message-ID: <20190604081920.GG6840@kroah.com>
References: <20190529112314.GY15290@suse.cz>
 <20190529113300.GB11952@kroah.com>
 <20190529115752.GZ15290@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529115752.GZ15290@suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 01:57:52PM +0200, David Sterba wrote:
> On Wed, May 29, 2019 at 04:33:00AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, May 29, 2019 at 01:23:14PM +0200, David Sterba wrote:
> > > Hi,
> > > 
> > > upon closer inspection we found a problem with the patch
> > > 
> > > "btrfs: Honour FITRIM range constraints during free space trim"
> > > 
> > > that has been merged to 5.1.4. This could happen with ranged FITRIM
> > > where the range is not 'honoured' as it was supposed to.
> > > 
> > > Please revert it and push in the next stable release so the buggy
> > > version is not in the wild for too long.
> > > 
> > > Affected trees:
> > > 
> > > 5.0.18
> > > 5.1.4
> > > 4.9.179
> > > 4.19.45
> > > 4.14.122
> > > 
> > > Master branch will have the revert too. Thanks.
> > 
> > What is the git commit id of the revert in Linus's tree?
> 
> The commit is not there yet, I'm going to send it with the next update
> in a few days for 5.2-rc2.
> 
> To shorthen the delay I hope it's possible to revert the patches without
> the corresponding master commit but if you insist on that I'll send the
> pull request today and will let you know the commit id.

Did this ever get reverted in Linus's tree?  I can't seem to find it...

thanks,

greg k-h
