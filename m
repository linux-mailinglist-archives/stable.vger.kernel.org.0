Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F03DFB75
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 08:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhHDGfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 02:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235303AbhHDGfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 02:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C6C60EEA;
        Wed,  4 Aug 2021 06:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628058904;
        bh=hlUdSfFtnTLV+mjlpJlXi76aK62FaMHnx7LVeCvrID0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sGfGUCb4lssK1VzB6QHzWrTyEx9teKpKM5LQwDurant7bavDq1KN8xaeSEbWXrK1t
         JRiyNBi9iD2EgTf3R8fJ0Q3dYJiAfr1aGwpsopEJQJbbTr3wv+IGh8xCPPyZIwH5IN
         MKl43R8ur5Hn3tVjItqNYI3rsDhhIRJEVayDom0k=
Date:   Wed, 4 Aug 2021 08:35:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@iki.fi>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
Message-ID: <YQo1FfCeDTOouv8G@kroah.com>
References: <20210802134339.023067817@linuxfoundation.org>
 <20210803192607.GA14540@duo.ucw.cz>
 <e591d78c-0196-a218-59dd-91d83aa65f90@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e591d78c-0196-a218-59dd-91d83aa65f90@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 09:25:34AM +0300, Thomas Backlund wrote:
> Den 03-08-2021 kl. 22:26, skrev Pavel Machek:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 5.10.56 release.
> > > There are 67 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Not sure what went wrong, but 50 or so patches disappeared from the queue:
> > 
> > 48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction
> > 474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnecessary inode logging during link and rename
> > 2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate errors on awaiting already signaled fences"
> > b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
> > 11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
> > 984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
> > sk into newly allocated nskb
> > 
> > Best regards,
> 
> Looks like a fallout of switching to use rc-* for current review queues and
> apparently keep queue-* for upcoming stuff
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/

exactly.  We are trying to see if this works to reduce the window of
people getting notified of being added to the queue and a -rc with the
patch in it for some changes.  It also allows us to work while -rcs are
out for review.

Let's see how this works for a bit, we have already had some growing
pains with it :)

greg k-h
