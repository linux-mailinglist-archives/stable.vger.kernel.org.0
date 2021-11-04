Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563B1445004
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 09:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhKDITX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 04:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKDITW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 04:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8117C6109F;
        Thu,  4 Nov 2021 08:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636013805;
        bh=semzeFo/Mmvp2p44IcuS0JK5PH5nwU5r+P335QjRX2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0TeqcGCoYlXUmzbBuqmyLisVKh3cSG7Nk3FItGWhmEm1E1wwFRpFYvN3MGpTrYGOm
         F2TTzgo3zeleGuwouWFqZchmlKmRKF4qu11lKTnl7QcJMuL1G5BR10YhzxyDJ/ZV+l
         FQDmMXLeYCTCxAKEQHIl8jysbl0YbuKZkZUfeg+A=
Date:   Thu, 4 Nov 2021 09:16:42 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Souza, Jose" <jose.souza@intel.com>
Cc:     "Zhao, Yakui" <yakui.zhao@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Nikula, Jani" <jani.nikula@intel.com>,
        "Roper, Matthew D" <matthew.d.roper@intel.com>
Subject: Re: [PATCH] drm/i915: Remove memory frequency calculation
Message-ID: <YYOW6nhzILkqAnzp@kroah.com>
References: <1635599150237240@kroah.com>
 <20211101183230.89060-1-jose.souza@intel.com>
 <YYJaklqD9XAj16Lw@kroah.com>
 <fb21fbc6b8b03ffa3df2f629112132664cccda4c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb21fbc6b8b03ffa3df2f629112132664cccda4c.camel@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 12:30:18AM +0000, Souza, Jose wrote:
> On Wed, 2021-11-03 at 10:46 +0100, Greg KH wrote:
> > On Mon, Nov 01, 2021 at 11:32:30AM -0700, José Roberto de Souza wrote:
> > > This memory frequency calculated is only used to check if it is zero,
> > > what is not useful as it will never actually be zero.
> > > 
> > > Also the calculation is wrong, we should be checking other bit to
> > > select the appropriate frequency multiplier while this code is stuck
> > > with a fixed multiplier.
> > > 
> > > So here dropping it as whole.
> > > 
> > > v2:
> > > - Also remove memory frequency calculation for gen9 LP platforms
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.14-stable
> > > Cc: Yakui Zhao <yakui.zhao@intel.com>
> > > Cc: Matt Roper <matthew.d.roper@intel.com>
> > > Fixes: 5d0c938ec9cc ("drm/i915/gen11+: Only load DRAM information from pcode")
> > > Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
> > > Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20211013010046.91858-1-jose.souza@intel.com
> > > (cherry picked from commit 83f52364b15265aec47d07e02b0fbf4093ab8554)
> > 
> > There is no such commit in Linus's tree.
> > 
> > What commit is this that is being backported?
> 
> It is on Linus's tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=83f52364b15265aec47d07e02b0fbf4093ab8554

Ah, no, this is REALLY commit 59be177a909a ("drm/i915: Remove memory
frequency calculation"), which came in 5.15.

{sigh}

Someday the i915 developers will fix up how they reference git sha ids
and not do things that "look into the future" which causes so many
confusions over the years.

ugh.

greg k-h
