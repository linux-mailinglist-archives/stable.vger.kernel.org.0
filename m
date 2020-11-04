Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF44A2A63B6
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgKDL50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgKDL5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 06:57:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2641220759;
        Wed,  4 Nov 2020 11:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604491039;
        bh=goCd/FsixsuhFDQdIYZUh9ms1ET37ZuEkEzXEWKQDgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gBW/wRXVSiC3ZN6j4jEa4wzxZdeawe1Jr5n7hg1AfVtBWXSQ4PgdUePxIxKaFFmqd
         BYrL61Hsw718XoSK/cieL5MBCZzyqXcuaca9+r161xvqJwKKntBjZzedVzuSvsLGY8
         K6Oc10fjc7M1RmAwTVBIbPB5loOBd47cQ4e5yzF8=
Date:   Wed, 4 Nov 2020 12:58:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Gorski, Mateusz" <mateusz.gorski@linux.intel.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, cezary.rojewski@intel.com,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Message-ID: <20201104115810.GA1694250@kroah.com>
References: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
 <20201103153541.GC3267686@kroah.com>
 <d6006431-420f-55c7-0f78-977507e11fcf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6006431-420f-55c7-0f78-977507e11fcf@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 12:46:36PM +0100, Gorski, Mateusz wrote:
> 
> > > [ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]
> > > 
> > > Add alternative topology binary file name based on used machine driver
> > > and fallback to use this name after failed attempt to load topology file
> > > with name based on NHLT.
> > > This change addresses multiple issues with current mechanism, for
> > > example - there are devices without NHLT table, and that currently
> > > results in tplg_name being empty.
> > > 
> > > Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
> > > Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
> > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Link: https://lore.kernel.org/r/20200427132727.24942-2-mateusz.gorski@linux.intel.com
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > ---
> > > 
> > > This functionality is merged on upstream kernel and widely used. Merging
> > > it to LTS kernel would improve the user experience and resolve some of the
> > > problems regarding topology naming that the users are facing.
> > What problems are people facing, and what kernel(s) are you asking for
> > this to be ported to, and why can't people just use 5.8 or newer if they
> > have this new hardware?
> > 
> > thanks,
> > 
> > greg k-h
> 
> I forgot to add - I wanted this change to be merged to stable 5.4 kernel.
> Please let me know if I should resend this patch with this information
> included.
> 
> As for the user issues - topology binary file name is currently created
> according to information from NHLT. The problem is, that some laptops (for
> example Dell XPS 13) do not have NHLT at all. This results in topology
> binary name being empty (" ").
> This patch adds alternative name based on loaded machine driver.
> 
> It applies not only to new hardware, please note that the mentioned Dell XPS
> 13 is based on Kabylake. This issue existed on upstream from the beginning
> of Skylake driver and was only recently addressed.

When was that laptop released and is this the only change that is needed
in order for the 5.4.y kernel to work properly on it?

thanks,

greg k-h
