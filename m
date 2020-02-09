Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3FE156BC7
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgBIRWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbgBIRWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 12:22:21 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87C9520714;
        Sun,  9 Feb 2020 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581268940;
        bh=+0z1BXpbza53PIbAdcDgLM5HkkM9uwoMDmVOanBP/Zg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1unqZycGIhd18d7rJMvc45yMwpx7kOcNsa5IdA0TBLkflp+jDxrKfa2+hbn4tPx3V
         O9avO/PusQJl4YJqc1bFR63lzIaI3od4nPq5gQSXEoOY52Ww0i6vx51GiHLtK4rYil
         xd2AnVgUWtPvCnqvasTNeXNgSXQaFEGbeofxNxq4=
Date:   Sun, 9 Feb 2020 18:02:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jiri Slaby <jslaby@suse.cz>, josef@toxicpanda.com,
        dsterba@suse.com, martin@lichtvoll.de, wqu@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: do not zero f_bavail if we have
 available space" failed to apply to 5.5-stable tree
Message-ID: <20200209170213.GA3075@kroah.com>
References: <158124801131151@kroah.com>
 <45d4c547-7e27-3c59-e2f7-19f4e7b3548c@suse.cz>
 <20200209132640.GA2059551@kroah.com>
 <20200209155950.GD3584@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209155950.GD3584@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 10:59:50AM -0500, Sasha Levin wrote:
> On Sun, Feb 09, 2020 at 02:26:40PM +0100, Greg KH wrote:
> > On Sun, Feb 09, 2020 at 02:04:21PM +0100, Jiri Slaby wrote:
> > > On 09. 02. 20, 12:33, gregkh@linuxfoundation.org wrote:
> > > >
> > > > The patch below does not apply to the 5.5-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > ------------------ original commit in Linus's tree ------------------
> > > >
> > > > From d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 Mon Sep 17 00:00:00 2001
> > > > From: Josef Bacik <josef@toxicpanda.com>
> > > > Date: Fri, 31 Jan 2020 09:31:05 -0500
> > > > Subject: [PATCH] btrfs: do not zero f_bavail if we have available space
> > > 
> > > 5.5.2 was already released with this patch:
> > > commit 165387a9c90152f35976d82feca6eff5f0d5ac02
> > > Author: Josef Bacik <josef@toxicpanda.com>
> > > Date:   Fri Jan 31 09:31:05 2020 -0500
> > > 
> > >     btrfs: do not zero f_bavail if we have available space
> > > 
> > >     commit d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 upstream.
> > > 
> > > It cannot be applied twice :).
> > 
> > Oops, Sasha beat me too it, sorry for the noise :)
> 
> I've grabbed it for the fixes: tag, sorry :)

Not a problem, much rather see patches try to get applied more than
once, than not at all :)
