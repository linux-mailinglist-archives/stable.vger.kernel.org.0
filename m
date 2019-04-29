Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E584DC8D
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 09:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfD2HEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 03:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfD2HEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 03:04:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB9E2053B;
        Mon, 29 Apr 2019 07:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556521439;
        bh=qrDMuZuX1wxLmzGaTUP/jakCb0ach5fUyGbQ7MM+gc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g2SwCdonv4sBwoaRV9G5h5/VYEIdu1JH66qG29TL/dVWpc5On8fkEVWhVMDI8n9AJ
         u2rgivwzLW4an0/yc+6apvluiyNAzZ6zisXjLY+2FoloS7rvm39zSwZB1diBIqYDYM
         9xcUQ+oOKKTWjLTFRxyg4+bBbEaqXRmUyU2C4n1s=
Date:   Mon, 29 Apr 2019 09:03:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org,
        diana.craciun@nxp.com, msuchanek@suse.de, npiggin@gmail.com,
        christophe.leroy@c-s.fr
Subject: Re: [PATCH stable v4.4 00/52] powerpc spectre backports for 4.4
Message-ID: <20190429070357.GA3167@kroah.com>
References: <20190421142037.21881-1-mpe@ellerman.id.au>
 <20190421163421.GA8449@kroah.com>
 <87o94qac1z.fsf@concordia.ellerman.id.au>
 <87a7g99viy.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7g99viy.fsf@concordia.ellerman.id.au>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 04:26:45PM +1000, Michael Ellerman wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
> > Greg KH <gregkh@linuxfoundation.org> writes:
> >> On Mon, Apr 22, 2019 at 12:19:45AM +1000, Michael Ellerman wrote:
> >>> -----BEGIN PGP SIGNED MESSAGE-----
> >>> Hash: SHA1
> >>> 
> >>> Hi Greg/Sasha,
> >>> 
> >>> Please queue up these powerpc patches for 4.4 if you have no objections.
> >>
> >> why?  Do you, or someone else, really care about spectre issues in 4.4?
> >> Who is using ppc for 4.4 becides a specific enterprise distro (and they
> >> don't seem to be pulling in my stable updates anyway...)?
> >
> > Someone asked for it, but TBH I can't remember who it was. I can chase
> > it up if you like.
> 
> Yeah it was a request from one of the distros. They plan to take it once
> it lands in 4.4 stable.

Ok, thanks for confirming, I'll work on this this afternoon.

greg k-h
