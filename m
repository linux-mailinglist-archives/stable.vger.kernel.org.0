Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22E3B791
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389910AbfFJOjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389601AbfFJOjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:39:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1445E20679;
        Mon, 10 Jun 2019 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560177560;
        bh=sDxKOMqNl6mcejMEg2pPUogSHoYRL4p1v1GrqXN51Ok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=exg2YVBfbp1cinQhKi3ma2vPMu1fCBEcHgv60Ky2/tVOpO6w0iqC+g2T6AQBusDxJ
         1f4BS+/24Z/Jcu8rI1mvMDSmzPFhfy38Mp8Gap2uPOJF98OiKUNBmMqwCIoPsxr/p/
         gPd3VYDEGhsno06YkBsilrW5vYtNsm8Nuqs58rz0=
Date:   Mon, 10 Jun 2019 16:39:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
Message-ID: <20190610143918.GA31086@kroah.com>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
 <20190610073119.GB20470@kroah.com>
 <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
 <20190610074840.GB24746@kroah.com>
 <20190610063340.051ee13b@lwn.net>
 <20190610140528.GA18627@kroah.com>
 <f53d2786-a857-d69c-2ead-6e4c19708d6c@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f53d2786-a857-d69c-2ead-6e4c19708d6c@mageia.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 05:27:39PM +0300, Thomas Backlund wrote:
> Den 10-06-2019 kl. 17:05, skrev Greg Kroah-Hartman:
> > On Mon, Jun 10, 2019 at 06:33:40AM -0600, Jonathan Corbet wrote:
> > > On Mon, 10 Jun 2019 09:48:40 +0200
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > Hm, 2.1 here:
> > > > 	Running Sphinx v2.1.0
> > > > perhaps Tumbleweed needs to update?  :)
> > > 
> > > Heh...trying 2.1 is still on my list of things to do ... :)
> > > 
> > > > Anyway, this should not be breaking, if Jon doesn't have any ideas, I'll
> > > > just drop these changes.
> > > 
> > > The fix for that is 551bd3368a7b (drm/i915: Maintain consistent
> > > documentation subsection ordering) which was also marked for stable.  Jiri,
> > > do you somehow not have that one?
> > 
> > It's part of this series, which is probably why it works for me.  Don't
> > know why it doesn't work for Jiri, unless he is cherry-picking things?
> > 
> 
> Actualliy it is not.
> 
> This patch Jiri responded to / points out to break stuff is part of 5.1.8,
> but the fix in in review queue for 5.1.9 :
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-5.1/drm-i915-maintain-consistent-documentation-subsection-ordering.patch?id=29167bff7a1c0d79dda104c44c262b0bc4cd6644

Ah, that makes more sense, and is why my build works for me :)

Jiri, wait a few days and this will get fixed...

thanks,

greg k-h
