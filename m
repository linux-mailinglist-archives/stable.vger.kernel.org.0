Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81364484F05
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 09:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiAEILC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 03:11:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45864 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiAEILC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 03:11:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63F45B818F7;
        Wed,  5 Jan 2022 08:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5B7C36AE3;
        Wed,  5 Jan 2022 08:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641370260;
        bh=EKWivhL6+8Ou2By4uZJ4ChfZj1G9F6VLoou0uj2Bmk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JK2yiMWoahe6Cpo2TJ/XBJaSLW6WaJzckj3+accqeN5uIH+f3JWRdbpSyht9Mx71J
         66DhvlYT+M2dW/R8R+lT8hpcbyI0ZbAiFgjVFif4chIooXksynE14nK45cTDnRJntr
         8JX8Ulv8NyEgO81LnLUbQycwlzcLfSlMxVcdmqIM=
Date:   Wed, 5 Jan 2022 09:10:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Chao Yu <chao@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>
Subject: Re: [PATCH 5.10 60/76] f2fs: fix to do sanity check on last xattr
 entry in __f2fs_setxattr()
Message-ID: <YdVSkF3zLxFHu2u1@kroah.com>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.779679392@linuxfoundation.org>
 <YdNmdhsKS5ZWHOlB@eldamar.lan>
 <12184f7c-3662-7fdc-d44f-23ef29102ddd@kernel.org>
 <YdQZzAQg4vIQNXc4@eldamar.lan>
 <YdQf5CZUYMJlamzp@kroah.com>
 <YdS341+t5Us9gol1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdS341+t5Us9gol1@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 01:10:59PM -0800, Jaegeuk Kim wrote:
> On 01/04, Greg Kroah-Hartman wrote:
> > On Tue, Jan 04, 2022 at 10:56:28AM +0100, Salvatore Bonaccorso wrote:
> > > Hi,
> > > 
> > > On Tue, Jan 04, 2022 at 05:29:30PM +0800, Chao Yu wrote:
> > > > On 2022/1/4 5:11, Salvatore Bonaccorso wrote:
> > > > > Hi,
> > > > > 
> > > > > On Mon, Dec 27, 2021 at 04:31:15PM +0100, Greg Kroah-Hartman wrote:
> > > > > > From: Chao Yu <chao@kernel.org>
> > > > > > 
> > > > > > commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.
> > > > 
> > > > I've no idea.
> > > > 
> > > > I didn't add this line from v1 to v3:
> > > > 
> > > > https://lore.kernel.org/lkml/20211211154059.7173-1-chao@kernel.org/T/
> > > > https://lore.kernel.org/all/20211212071923.2398-1-chao@kernel.org/T/
> > > > https://lore.kernel.org/all/20211212091630.6325-1-chao@kernel.org/T/
> > > > 
> > > > Am I missing anything?
> > > 
> > > The line is added when a commit from "upstream" is added to the stable
> > > series to identify the upstream commit it is taken from for
> > > cherry-pick (or backport).
> > > 
> > > Strange so, that the fix is not in mainline actually yet.
> > 
> > I thought it was about to be sent to Linus.  Why has the f2fs maintainer
> > not sent a merge request to him to get this merged properly yet?
> 
> It's very surprising that -stable can cherry-pick non-upstreamed patches based
> on the stable maintainer's self assumption. Please wait for being upstreamed.

I normally do wait, but when a commit has a public CVE registered for
it, and it shows up in -next, I assume that it will be sent to Linus any
moment now.  Because of that, I made the call to take the patch then.

Odd that you wish to delay this, sorry I took it early.

greg k-h
