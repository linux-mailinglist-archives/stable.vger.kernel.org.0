Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E530D3213E8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBVKOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhBVKNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 05:13:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6465564E20;
        Mon, 22 Feb 2021 10:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613988769;
        bh=dOHfb5NEYVKxcVlS4l7VwHiD4sE09IMlyqahVy9e7oA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpY3hoPP/9NAPxfpWbs05gZdzEu2eqqTCTBMxWU/HoKhcJirpFcPBcTTgqxNo+Z/t
         FlM248bbVhVShqXABvXC/FJg1bufhxoSygzGNdjOXwfnUiTe72XLD5EoA40gcjhj5e
         Ckq7PCMRaGPzQRVivA5dNazZy494zawfYMu/Q6ms=
Date:   Mon, 22 Feb 2021 11:12:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Trent Piepho <tpiepho@gmail.com>, stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always
 fallback to alt 1 for WBS") to back to v5.10.y
Message-ID: <YDODn+OEk/ZT/TOI@kroah.com>
References: <YDJWEh5qNUQbXcv2@eldamar.lan>
 <YDJXvYLSUQ3P0iMz@kroah.com>
 <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
 <YDJcMQnGWTIFG7k5@kroah.com>
 <YDJddZykdgO5kShh@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDJddZykdgO5kShh@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 02:17:41PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Sun, Feb 21, 2021 at 02:12:17PM +0100, Greg Kroah-Hartman wrote:
> > On Sun, Feb 21, 2021 at 05:03:34AM -0800, Trent Piepho wrote:
> > > On Sun, Feb 21, 2021 at 4:53 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > On Sun, Feb 21, 2021 at 01:46:10PM +0100, Salvatore Bonaccorso wrote:
> > > > > Hi
> > > > >
> > > > > 517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
> > > > > was applied to mainline fixing (restoring) behaviour to pre 5.7. As
> > > > > the commit message describes in effect, WBS was broken for all USB-BT
> > > > > adapters that do not support alt 6.
> > > > >
> > > > > Can you consider it to apply it to back to 5.10.y?
> > > >
> > > > I do not see any such git commit id in Linus's tree, are you sure you
> > > > picked the right one?
> > > 
> > > Full hash is 517b693351a2d04f3af1fc0e506ac7e1346094de.
> > > 
> > > Looks like it should work as I intended on current 5.10.y, but I
> > > didn't test that kernel.
> > 
> > Ah, this thing isn't even in 5.11, it just now showed up in Linus's
> > tree.
> > 
> > Give it time to hit at least a released version (i.e. 5.12-rc1) before
> > we pull it into a stable release.  Unless the bluetooth maintainers say
> > it is ok to do so earlier than that.
> 
> Sure. We got a request in Debian to include the commit for an upcoming
> 5.10.y based update and just want to make sure we do not diverge here
> from upstream.  But it's obviously good to wait then unless bluetooth
> maintainers give the ack earlier.

This seems sane, I'll queue it up now, thanks.

greg k-h
