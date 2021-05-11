Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144F737A627
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 13:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhEKL6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 07:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhEKL6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 07:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E97161007;
        Tue, 11 May 2021 11:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620734247;
        bh=6WMcv2xd6VsBSIHKu0Ob2YKNaIqY4ZBocnGR8jWPXfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Velce/SBQYGXz4Bg/7MEcnrC8mePdPHBrP4IMe4Tpsax5sLl6YyaI71oMDf3fz+kg
         ygCu/riXXrPEFlt8H0bnpxiOEjpI74RMzM6Ck7hSb8hnBv6BN8JxnfKRwl6iwbyawV
         3iFX9unUIIRRf70XxgGvOnAODX+8wsSURNF6FWuA=
Date:   Tue, 11 May 2021 13:57:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 108/299] platform/x86: intel_pmc_core: Dont use
 global pmcdev in quirks
Message-ID: <YJpxJPVLp803CaBt@kroah.com>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102008.507160403@linuxfoundation.org>
 <20210510121240.GD3547@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510121240.GD3547@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 02:12:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: David E. Box <david.e.box@linux.intel.com>
> > 
> > [ Upstream commit c9f86d6ca6b5e23d30d16ade4b9fff5b922a610a ]
> > 
> > The DMI callbacks, used for quirks, currently access the PMC by getting
> > the address a global pmc_dev struct. Instead, have the callbacks set a
> > global quirk specific variable. In probe, after calling dmi_check_system(),
> > pass pmc_dev to a function that will handle each quirk if its variable
> > condition is met. This allows removing the global pmc_dev later.
> 
> This does not fix a bug.. it is preparation for further cleanups that
> are not queued to 5.10 stable. So this should not be in 5.10 either.

I'll leave this for now, it will be helpful for later.

thanks,

greg k-h
