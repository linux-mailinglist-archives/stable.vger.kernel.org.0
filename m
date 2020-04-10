Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EB81A451C
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 12:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgDJKUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 06:20:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:46772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDJKUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 06:20:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 59D04ABAD;
        Fri, 10 Apr 2020 10:20:38 +0000 (UTC)
Date:   Fri, 10 Apr 2020 11:20:59 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] stable CephFS backports
Message-ID: <20200410102059.GA18283@suse.com>
References: <20200408105844.21840-1-lhenriques@suse.com>
 <20200410091410.GF1691838@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200410091410.GF1691838@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 11:14:10AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 08, 2020 at 11:58:38AM +0100, Luis Henriques wrote:
> > Hi!
> > 
> > Please pick the backports for the following upstream commits:
> > 
> >   4fbc0c711b24 "ceph: remove the extra slashes in the server path"
> >   b27a939e8376 "ceph: canonicalize server path in place"
> > 
> > They fix an ancient bug that can be reproduced in kernels as old as 4.9 (I
> > couldn't reproduced it with 4.4).
> 
> All now queued up, including for 5.5.y, thanks.

Awesome, thanks.  And sorry, I forgot to mention in the cover-letter that
5.5 was a clean cherry-pick.

Cheers,
--
Luís
