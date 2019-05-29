Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3652DC46
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 13:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfE2L47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 07:56:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbfE2L47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 07:56:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A8D2AC4D;
        Wed, 29 May 2019 11:56:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EB104DA85E; Wed, 29 May 2019 13:57:52 +0200 (CEST)
Date:   Wed, 29 May 2019 13:57:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert "btrfs: Honour FITRIM range constraints during
 free space trim" from all stable trees
Message-ID: <20190529115752.GZ15290@suse.cz>
Reply-To: dsterba@suse.cz
References: <20190529112314.GY15290@suse.cz>
 <20190529113300.GB11952@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529113300.GB11952@kroah.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 04:33:00AM -0700, Greg Kroah-Hartman wrote:
> On Wed, May 29, 2019 at 01:23:14PM +0200, David Sterba wrote:
> > Hi,
> > 
> > upon closer inspection we found a problem with the patch
> > 
> > "btrfs: Honour FITRIM range constraints during free space trim"
> > 
> > that has been merged to 5.1.4. This could happen with ranged FITRIM
> > where the range is not 'honoured' as it was supposed to.
> > 
> > Please revert it and push in the next stable release so the buggy
> > version is not in the wild for too long.
> > 
> > Affected trees:
> > 
> > 5.0.18
> > 5.1.4
> > 4.9.179
> > 4.19.45
> > 4.14.122
> > 
> > Master branch will have the revert too. Thanks.
> 
> What is the git commit id of the revert in Linus's tree?

The commit is not there yet, I'm going to send it with the next update
in a few days for 5.2-rc2.

To shorthen the delay I hope it's possible to revert the patches without
the corresponding master commit but if you insist on that I'll send the
pull request today and will let you know the commit id.
