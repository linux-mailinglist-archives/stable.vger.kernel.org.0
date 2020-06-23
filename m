Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCD520515E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbgFWLyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732225AbgFWLyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 07:54:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A4520771;
        Tue, 23 Jun 2020 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592913261;
        bh=eyzS+tqORO1KfMB8WYmSySe1A0bDu0wMbvD3f7zRBuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIsB6wX1dU8CmLBPvK+DQHJ0dDVlzwBGRW3nfZc5Fp5nsvAlwKSJoJYWjI3RPPmrb
         s+CylihYfJHC6DnEpzgc6zfHW6boPa4wUGmbserfnNF45E19ANpgNH9FBSzUnBsK8f
         p6kRUHW9wrPv1RUpH4gEDuyJJXlxILq/+ENy6AeY=
Date:   Tue, 23 Jun 2020 13:54:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>,
        Rafael Antognolli <rafael.antognolli@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>
Subject: Re: [PATCH] drm/i915/tgl: Make Wa_14010229206 permanent
Message-ID: <20200623115415.GB1966723@kroah.com>
References: <20200618202701.729-1-rodrigo.vivi@intel.com>
 <20200619080900.GD8425@kroah.com>
 <20200619201404.GI334084@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619201404.GI334084@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 01:14:04PM -0700, Rodrigo Vivi wrote:
> On Fri, Jun 19, 2020 at 10:09:00AM +0200, Greg KH wrote:
> > On Thu, Jun 18, 2020 at 01:27:00PM -0700, Rodrigo Vivi wrote:
> > > From: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
> > > 
> > > commit 63d0f3ea8ebb67160eca281320d255c72b0cb51a upstream.
> > > 
> > > This workaround now applies to all steppings, not just A0.
> > > Wa_1409085225 is a temporary A0-only W/A however it is
> > > identical to Wa_14010229206 and hence the combined workaround
> > > is made permanent.
> > > Bspec: 52890
> > > 
> > > Signed-off-by: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
> > > Tested-by: Rafael Antognolli <rafael.antognolli@intel.com>
> > > Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
> > > [mattrope: added missing blank line]
> > > Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20200326234955.16155-1-swathi.dhanavanthri@intel.com
> > > Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/gt/intel_workarounds.c | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > What stable kernel(s) is this backport for?  You need to give us a hint
> > :)
> 
> It's for 5.7.y only. Sorry for not being clear

Thanks, now queued up.

greg k-h
