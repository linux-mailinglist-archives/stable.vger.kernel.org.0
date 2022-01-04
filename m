Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03107483FC6
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 11:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiADKWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 05:22:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiADKWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 05:22:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2144961311;
        Tue,  4 Jan 2022 10:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC842C36AEB;
        Tue,  4 Jan 2022 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641291751;
        bh=juGCHWXZ82rSP6vUi7Im0z1iI5+iYRDhfx46SdS0lfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vX2UDCJ/SIcOuW/65tB/Ea8zuWq+WN1BuB7rAVE1uq+OIUTkLSRaeSNxHBItzR6rl
         FIRvzTrnOXYtvymXOJoUqSF3ETtn+QmQeqzU6LBrIK50kLS6uUVeNGTzqR/j8AH6g4
         edShgHi0HYyD1oT7FWKsuElFthvRVqNS0tMZkEZY=
Date:   Tue, 4 Jan 2022 11:22:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Chao Yu <chao@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.10 60/76] f2fs: fix to do sanity check on last xattr
 entry in __f2fs_setxattr()
Message-ID: <YdQf5CZUYMJlamzp@kroah.com>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.779679392@linuxfoundation.org>
 <YdNmdhsKS5ZWHOlB@eldamar.lan>
 <12184f7c-3662-7fdc-d44f-23ef29102ddd@kernel.org>
 <YdQZzAQg4vIQNXc4@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdQZzAQg4vIQNXc4@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 10:56:28AM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Tue, Jan 04, 2022 at 05:29:30PM +0800, Chao Yu wrote:
> > On 2022/1/4 5:11, Salvatore Bonaccorso wrote:
> > > Hi,
> > > 
> > > On Mon, Dec 27, 2021 at 04:31:15PM +0100, Greg Kroah-Hartman wrote:
> > > > From: Chao Yu <chao@kernel.org>
> > > > 
> > > > commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.
> > 
> > I've no idea.
> > 
> > I didn't add this line from v1 to v3:
> > 
> > https://lore.kernel.org/lkml/20211211154059.7173-1-chao@kernel.org/T/
> > https://lore.kernel.org/all/20211212071923.2398-1-chao@kernel.org/T/
> > https://lore.kernel.org/all/20211212091630.6325-1-chao@kernel.org/T/
> > 
> > Am I missing anything?
> 
> The line is added when a commit from "upstream" is added to the stable
> series to identify the upstream commit it is taken from for
> cherry-pick (or backport).
> 
> Strange so, that the fix is not in mainline actually yet.

I thought it was about to be sent to Linus.  Why has the f2fs maintainer
not sent a merge request to him to get this merged properly yet?

thanks,

greg k-h
