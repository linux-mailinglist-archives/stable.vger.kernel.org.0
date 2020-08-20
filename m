Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2919224B0DA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHTIPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgHTIPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:15:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C9B1207DE;
        Thu, 20 Aug 2020 08:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597911323;
        bh=tddAiBcBg636YsUky6xQnxC3WBTnjkIrM7gdFJfAUQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=10zAw+KyLlJbU0S3r/KJWy2PL+yM+t4glZ2QgmyYfdlogEd4NbDUBsbLnXFQR56Jr
         e2PIFfkXvrammwnmgiRoUtClVNl96hWnxw3oe3LyGyKuxzMsIxD5WHh54UM9n4h1h4
         P3A5ds6L1Y5s0hoqITiwVO67+1XDHV5ygnD11obI=
Date:   Thu, 20 Aug 2020 10:15:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Stable <stable@vger.kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Erik Faye-Lund <kusmabite@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: Request to pick up couple NVIDIA Tegra ASoC patches into 5.7
 kernel
Message-ID: <20200820081543.GG4049659@kroah.com>
References: <2db6e1ef-5cea-d479-8a7a-8f336313cb1d@gmail.com>
 <20200813000800.GM2975990@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813000800.GM2975990@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 08:08:00PM -0400, Sasha Levin wrote:
> On Wed, Aug 12, 2020 at 10:14:34PM +0300, Dmitry Osipenko wrote:
> > Hello, stable-kernel maintainers!
> > 
> > Could you please cherry-pick these commits into the v5.7.x kernel?
> > 
> > commit 0de6db30ef79b391cedd749801a49c485d2daf4b
> > Author: Sowjanya Komatineni <skomatineni@nvidia.com>
> > Date:   Mon Jan 13 23:24:17 2020 -0800
> > 
> >    ASoC: tegra: Use device managed resource APIs to get the clock
> > 
> > commit 1e4e0bf136aa4b4aa59c1e6af19844bd6d807794
> > Author: Sowjanya Komatineni <skomatineni@nvidia.com>
> > Date:   Mon Jan 13 23:24:23 2020 -0800
> > 
> >    ASoC: tegra: Add audio mclk parent configuration
> > 
> > commit ff5d18cb04f4ecccbcf05b7f83ab6df2a0d95c16
> > Author: Sowjanya Komatineni <skomatineni@nvidia.com>
> > Date:   Mon Jan 13 23:24:24 2020 -0800
> > 
> >    ASoC: tegra: Enable audio mclk during tegra_asoc_utils_init()
> > 
> > It will fix a huge warnings splat during of kernel boot on NVIDIA Tegra
> > SoCs. For some reason these patches haven't made into 5.7 when it was
> > released and several people complained about the warnings. Thanks in
> > advance!
> 
> They never made it in because they don't have a stable tag, a fixes tag,
> or do they sound like they fix a problem :)
> 
> Do you have a reference to the issue at hand here?
> 
> Either way, 5.7 is alive for only about 1 or 2 weeks, is anyone still
> stuck on 5.7?

What's a few more patches :)

I've queued them up now, but people really should be moving to 5.8.y
now...

thanks,

gre gk-h
