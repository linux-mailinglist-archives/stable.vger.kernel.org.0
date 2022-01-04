Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1307A4849B5
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 22:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiADVLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 16:11:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59788 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiADVLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 16:11:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E425A6144A;
        Tue,  4 Jan 2022 21:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6FBC36AEB;
        Tue,  4 Jan 2022 21:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641330661;
        bh=WVtVkmJS1DFn3oS5EZCk6Y6ibXX0ZfMgpBLPcLcYdHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L1fYSTLnaHXcWVdJT5OjiISe1ilLRI41uTwljWqyyFkx8jQPcRwyFcyhhMziWIb/P
         igSI7rQ0fjKfc0pe+ZsFXHJv3kN5OIJncK44IEQd7kuFxKahOhi7qXQB/SLmj/WoRd
         5I16AhKLPDwlPymr38B2HW84JllgrBMPKV8b3PdlIFMry+muBlJSOrXqN1BBl4FXon
         /zZSl9ihiNl8PgSUPNihUl1DGhOSLx1SyDXBMMb1ckgBIAMfu6IJbIe5UVBcUMOD1P
         ZzRpNlMKMFpLZcXbTHBMrinCwsxwhzFQ+01gz8FKLC7S0GeSveR1g7TITxGdfu+cmG
         nieDccmvP/B2A==
Date:   Tue, 4 Jan 2022 13:10:59 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Chao Yu <chao@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>
Subject: Re: [PATCH 5.10 60/76] f2fs: fix to do sanity check on last xattr
 entry in __f2fs_setxattr()
Message-ID: <YdS341+t5Us9gol1@google.com>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.779679392@linuxfoundation.org>
 <YdNmdhsKS5ZWHOlB@eldamar.lan>
 <12184f7c-3662-7fdc-d44f-23ef29102ddd@kernel.org>
 <YdQZzAQg4vIQNXc4@eldamar.lan>
 <YdQf5CZUYMJlamzp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdQf5CZUYMJlamzp@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/04, Greg Kroah-Hartman wrote:
> On Tue, Jan 04, 2022 at 10:56:28AM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Tue, Jan 04, 2022 at 05:29:30PM +0800, Chao Yu wrote:
> > > On 2022/1/4 5:11, Salvatore Bonaccorso wrote:
> > > > Hi,
> > > > 
> > > > On Mon, Dec 27, 2021 at 04:31:15PM +0100, Greg Kroah-Hartman wrote:
> > > > > From: Chao Yu <chao@kernel.org>
> > > > > 
> > > > > commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.
> > > 
> > > I've no idea.
> > > 
> > > I didn't add this line from v1 to v3:
> > > 
> > > https://lore.kernel.org/lkml/20211211154059.7173-1-chao@kernel.org/T/
> > > https://lore.kernel.org/all/20211212071923.2398-1-chao@kernel.org/T/
> > > https://lore.kernel.org/all/20211212091630.6325-1-chao@kernel.org/T/
> > > 
> > > Am I missing anything?
> > 
> > The line is added when a commit from "upstream" is added to the stable
> > series to identify the upstream commit it is taken from for
> > cherry-pick (or backport).
> > 
> > Strange so, that the fix is not in mainline actually yet.
> 
> I thought it was about to be sent to Linus.  Why has the f2fs maintainer
> not sent a merge request to him to get this merged properly yet?

It's very surprising that -stable can cherry-pick non-upstreamed patches based
on the stable maintainer's self assumption. Please wait for being upstreamed.

The patch is on track via -next.
https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/commit/?h=dev&id=5598b24efaf4892741c798b425d543e4bed357a1


> 
> thanks,
> 
> greg k-h
