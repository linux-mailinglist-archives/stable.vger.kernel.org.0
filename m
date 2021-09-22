Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3348A41402E
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 05:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhIVDva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 23:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDva (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 23:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B433761107;
        Wed, 22 Sep 2021 03:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632282600;
        bh=4GJ+qLOLrbVB0AvyIsckephICS/Qyvey/QFysrN6f60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q35nr9tRYWBUFjhZXMqAWA2g1QtGtMvC5mc25BVrjN0/IB/QgEOZ7eRazNh4I36pL
         bI2JsyAEgn3QR6+aL59WVvb+BQt1D5ikfbM8RfJRowBgnimHjMmqbHEKIu10wVy+Ks
         5jHerxT2N1W8lyKSJPvs0GcDoi7HGm3+E+7cTCwZvX++zL7ZeBNcm4uQZKgyCUAZxt
         X7t0PgfQLjwC1drQ7m1rVqMq7pwRg8oO3F2/2UxROXVu5jc+IA7AxqudIjH/l723kx
         URBkytWvIH6TfXfHJpDvQ9Qu6gPH4RZlSvCdwLR9rvxKvjsYNQ5wHuFEsRf96aJemD
         Wxr9EPV5O1cBA==
Date:   Wed, 22 Sep 2021 11:49:47 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        m.felsch@pengutronix.de, tharvey@gateworks.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ARM: imx6q: drop of_platform_default_populate()
 from init_machine"
Message-ID: <20210922034946.GL10217@dragon>
References: <20210920234311.682163-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920234311.682163-1-festevam@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 08:43:11PM -0300, Fabio Estevam wrote:
> This reverts commit cc8870bf4c3ab0af385538460500a9d342ed945f.
>  
> Since commit cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate()
> from init_machine") the following errors are seen on boot:
> 
> [    0.123372] imx6q_suspend_init: failed to find ocram device!
> [    0.123537] imx6_pm_common_init: No DDR LPM support with suspend -19! 
> 
> , which break suspend/resume on imx6q/dl.
> 
> Revert the offeding commit to avoid the regression.
> 
> Thanks to Tim Harvey for bisecting this problem.
> 
> Cc: stable@vger.kernel.org
> Fixes: cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate() from  init_machine")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied, thanks!
