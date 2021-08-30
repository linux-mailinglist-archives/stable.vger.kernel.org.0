Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB513FB0F7
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 07:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhH3F4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 01:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232470AbhH3F4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 01:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13BB060F35;
        Mon, 30 Aug 2021 05:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630302960;
        bh=6pnp1ccDs13DmyLnxJsnYOYsXSnmp+yCLwoyII6xkX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Th37oRzRxxWbcdvYM8h5aGgmUEsUh4EZS64w4BJzFtm03gX4DHr35oPzazLk+dbJW
         VqF2x0kjxCs+taB+YAbw7shG+by3YSmVOMhi8M7dn6WVpxh/LcIAvvsnvk9Aam+yga
         W2Nsx13McYZBGqemDZ0yRgR0OItBXQtxOjF30wjU=
Date:   Mon, 30 Aug 2021 07:55:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH stable-5.4.y] btrfs: fix race between marking inode needs
 to be logged and log syncing
Message-ID: <YSxy5yPpWMKClYCK@kroah.com>
References: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
 <YSsvSQR0qHhLeI6C@kroah.com>
 <3b67845a-9d24-95d8-9dcf-845df319c0a6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b67845a-9d24-95d8-9dcf-845df319c0a6@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 05:28:57AM +0800, Anand Jain wrote:
> On 29/08/2021 14:55, Greg KH wrote:
> > On Sat, Aug 28, 2021 at 06:37:28AM +0800, Anand Jain wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > > 
> > > commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.
> > 
> > 5.10 also needs this, can you provide a working backport for that as
> > well so that no one would get a regression if they moved to a newer
> > kernel release?  Then we could take this patch.
> 
> Ok, will do. Why are we keen on stable-5.10.y only, while there are
> other stable releases in between?

There are no other stable releases in between that are currently
supported.  Please see the front page of www.kernel.org for the active
list.

thanks,

greg k-h
