Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D741A2458
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgDHOuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:50:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:42430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgDHOuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 10:50:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BDA2AAA7C;
        Wed,  8 Apr 2020 14:50:09 +0000 (UTC)
Date:   Wed, 8 Apr 2020 15:50:30 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] stable CephFS backports
Message-ID: <20200408145030.GA13974@suse.com>
References: <20200408105844.21840-1-lhenriques@suse.com>
 <20200408134550.GA32263@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200408134550.GA32263@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 02:45:51PM +0100, Luis Henriques wrote:
> On Wed, Apr 08, 2020 at 11:58:38AM +0100, Luis Henriques wrote:
> > Hi!
> > 
> > Please pick the backports for the following upstream commits:
> 
> I'm not sure how that happen, but it looks like I've messed up the 2nd
> backport.  Please hold on picking these backports for now, I'll need to
> figure out how I did that.  I'll send a new version soon.

Ok, I panicked -- backports seem to be fine.  Social isolation isn't new
to me but not seeing other human beings for this long starts making some
(reversible?) damage in my brain :-)

Cheers,
--
Luís

> > 
> >   4fbc0c711b24 "ceph: remove the extra slashes in the server path"
> >   b27a939e8376 "ceph: canonicalize server path in place"
> > 
> > They fix an ancient bug that can be reproduced in kernels as old as 4.9 (I
> > couldn't reproduced it with 4.4).
> > 
> > Cheers,
> > --
> > Luis Henriques
> > 
> > Ilya Dryomov (1):
> >   ceph: canonicalize server path in place
> > 
> > Xiubo Li (1):
> >   ceph: remove the extra slashes in the server path
