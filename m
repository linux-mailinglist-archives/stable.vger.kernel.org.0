Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165732A49F7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKCPeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgKCPeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 10:34:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03D3020735;
        Tue,  3 Nov 2020 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604417689;
        bh=XmePEw9JU0rAZFEeNQ5n/UYCqWNsboTn5hyfBC16x4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIX7/2dmsXSV9/1SZ2NGVDwZM90tDQjQ+FigSzWSKfN00vScP2rdeOoMO4/5+raZa
         vzLX04WsgV2vnZ+MESIwsPz76w86R9u6eIMZRNj7K5u572vhd7yQ8du46CLv0LiCxN
         CZZAc1SumiOdLZUtcst3noBy39gBF6z3lgEvZHVY=
Date:   Tue, 3 Nov 2020 16:35:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mateusz Gorski <mateusz.gorski@linux.intel.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, cezary.rojewski@intel.com,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Message-ID: <20201103153541.GC3267686@kroah.com>
References: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 03:10:47PM +0100, Mateusz Gorski wrote:
> [ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]
> 
> Add alternative topology binary file name based on used machine driver
> and fallback to use this name after failed attempt to load topology file
> with name based on NHLT.
> This change addresses multiple issues with current mechanism, for
> example - there are devices without NHLT table, and that currently
> results in tplg_name being empty.
> 
> Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
> Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Link: https://lore.kernel.org/r/20200427132727.24942-2-mateusz.gorski@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> 
> This functionality is merged on upstream kernel and widely used. Merging
> it to LTS kernel would improve the user experience and resolve some of the
> problems regarding topology naming that the users are facing.

What problems are people facing, and what kernel(s) are you asking for
this to be ported to, and why can't people just use 5.8 or newer if they
have this new hardware?

thanks,

greg k-h
