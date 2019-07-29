Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BA179723
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391065AbfG2T6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390992AbfG2T6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:58:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7534130832E1;
        Mon, 29 Jul 2019 19:58:18 +0000 (UTC)
Received: from parsley.fieldses.org (ovpn-117-226.phx2.redhat.com [10.3.117.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2E65D6A0;
        Mon, 29 Jul 2019 19:58:18 +0000 (UTC)
Received: by parsley.fieldses.org (Postfix, from userid 2815)
        id 7F14B1804A0; Mon, 29 Jul 2019 15:58:17 -0400 (EDT)
Date:   Mon, 29 Jul 2019 15:58:17 -0400
From:   "J. Bruce Fields" <bfields@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Qian Lu <luqia@amazon.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, ctracy@engr.scu.edu
Subject: Re: Request for inclusion on linux-4.14.y
Message-ID: <20190729195817.GB9606@parsley.fieldses.org>
References: <20190726213635.GB1900@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
 <20190728150425.GD8637@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728150425.GD8637@sasha-vm>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 29 Jul 2019 19:58:18 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 28, 2019 at 11:04:25AM -0400, Sasha Levin wrote:
> On Fri, Jul 26, 2019 at 02:36:35PM -0700, Qian Lu wrote:
> > Hello Greg,
> > 
> > Can you please consider including the following patches in the stable
> > linux-4.14.y branch?
> > 
> > An NFS server accepts only a limited number of concurrent v4.1+ mounts. Once
> > that limit is reached, on the affected client side, mount.nfs appears to hang to
> > keep reissuing CREATE_SESSION calls until one of them succeeds. This is to bump
> > the limit, also return smaller ca_maxrequests as the limit approaches instead of
> > waiting till we have to fail CREATE_SESSION completely.
> > 
> > 44d8660d3bb0("nfsd: increase DRC cache limit")
> > de766e570413("nfsd: give out fewer session slots as limit approaches")
> > c54f24e338ed("nfsd: fix performance-limiting session calculation")
> 
> I've queued these 3 for 4.14 and older.
> 
> Note that c54f24e338ed has a fix: 3b2d4dcf71c4a ("nfsd: Fix overflow
> causing non-working mounts on 1 TB machines") which was queued as well.

Thanks for catching that.  These sound like reasonable stable backports.

--b.
