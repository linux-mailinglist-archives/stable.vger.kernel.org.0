Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B303320A76
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 14:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBUNNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 08:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhBUNNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 08:13:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 605CC64E86;
        Sun, 21 Feb 2021 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613913140;
        bh=a0WWesbz05Zd3lBL1TH6rn3A+rI9d6p5T4MzKslzFzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pEYF4MH8m4hyiEOSA/nwMWCtRW4GU3tbrc/b793cOiDp+4UQ3cHL5kEnh8M4/hVoP
         Ttp9I/vXPiBX1GRk3UxEa6mRbzYYhKHAIlgknth1zpp8j93fQFNCRLN/yEr5kUhpaK
         d/OpdVHa4oILamUfq02sirN7q85c3fzXHMRi31p4=
Date:   Sun, 21 Feb 2021 14:12:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Trent Piepho <tpiepho@gmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always
 fallback to alt 1 for WBS") to back to v5.10.y
Message-ID: <YDJcMQnGWTIFG7k5@kroah.com>
References: <YDJWEh5qNUQbXcv2@eldamar.lan>
 <YDJXvYLSUQ3P0iMz@kroah.com>
 <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 05:03:34AM -0800, Trent Piepho wrote:
> On Sun, Feb 21, 2021 at 4:53 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sun, Feb 21, 2021 at 01:46:10PM +0100, Salvatore Bonaccorso wrote:
> > > Hi
> > >
> > > 517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
> > > was applied to mainline fixing (restoring) behaviour to pre 5.7. As
> > > the commit message describes in effect, WBS was broken for all USB-BT
> > > adapters that do not support alt 6.
> > >
> > > Can you consider it to apply it to back to 5.10.y?
> >
> > I do not see any such git commit id in Linus's tree, are you sure you
> > picked the right one?
> 
> Full hash is 517b693351a2d04f3af1fc0e506ac7e1346094de.
> 
> Looks like it should work as I intended on current 5.10.y, but I
> didn't test that kernel.

Ah, this thing isn't even in 5.11, it just now showed up in Linus's
tree.

Give it time to hit at least a released version (i.e. 5.12-rc1) before
we pull it into a stable release.  Unless the bluetooth maintainers say
it is ok to do so earlier than that.

thanks,

greg k-h
