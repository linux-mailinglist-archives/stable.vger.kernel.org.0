Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CA02431A3
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 02:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMAIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 20:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgHMAIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 20:08:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25A320774;
        Thu, 13 Aug 2020 00:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597277282;
        bh=pKtuXYVz1xGuYZdygwhBuEOHiHPZxImUOidX/Ua9brY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OnLaSYk7Dud9284Ox7lqs0BxwKOrAbJwHr7co2UUgO6QFGtEJ7DiRCwpisX8HxR+E
         14wDqLIuQjtjqIqjN5ydOQ7OMdhIpKcxfUtrtKUAYaeizDwFkM4QphtGIYUu6PirO8
         sAwZDOwTm89LPtbYADrE72YvfOs94i8dbWNE2XWI=
Date:   Wed, 12 Aug 2020 20:08:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Erik Faye-Lund <kusmabite@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: Request to pick up couple NVIDIA Tegra ASoC patches into 5.7
 kernel
Message-ID: <20200813000800.GM2975990@sasha-vm>
References: <2db6e1ef-5cea-d479-8a7a-8f336313cb1d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2db6e1ef-5cea-d479-8a7a-8f336313cb1d@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 10:14:34PM +0300, Dmitry Osipenko wrote:
>Hello, stable-kernel maintainers!
>
>Could you please cherry-pick these commits into the v5.7.x kernel?
>
>commit 0de6db30ef79b391cedd749801a49c485d2daf4b
>Author: Sowjanya Komatineni <skomatineni@nvidia.com>
>Date:   Mon Jan 13 23:24:17 2020 -0800
>
>    ASoC: tegra: Use device managed resource APIs to get the clock
>
>commit 1e4e0bf136aa4b4aa59c1e6af19844bd6d807794
>Author: Sowjanya Komatineni <skomatineni@nvidia.com>
>Date:   Mon Jan 13 23:24:23 2020 -0800
>
>    ASoC: tegra: Add audio mclk parent configuration
>
>commit ff5d18cb04f4ecccbcf05b7f83ab6df2a0d95c16
>Author: Sowjanya Komatineni <skomatineni@nvidia.com>
>Date:   Mon Jan 13 23:24:24 2020 -0800
>
>    ASoC: tegra: Enable audio mclk during tegra_asoc_utils_init()
>
>It will fix a huge warnings splat during of kernel boot on NVIDIA Tegra
>SoCs. For some reason these patches haven't made into 5.7 when it was
>released and several people complained about the warnings. Thanks in
>advance!

They never made it in because they don't have a stable tag, a fixes tag,
or do they sound like they fix a problem :)

Do you have a reference to the issue at hand here?

Either way, 5.7 is alive for only about 1 or 2 weeks, is anyone still
stuck on 5.7?

-- 
Thanks,
Sasha
