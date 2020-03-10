Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B1918007C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCJOoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgCJOoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 10:44:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BAA208E4;
        Tue, 10 Mar 2020 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583851447;
        bh=Hg0k4vAVhXU8yxiLsnntnJZ7extf50qKVGxQb+E4DOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQVYNiMVDiGa92xt8Ehwkm4To8B8rZOPD+lOH0HG1ArjC7WxB4EiriNW+5atGSaej
         ejXXXuf4WKPucnOaT4BCRwK6LhUGQyxVM7/TGOV/U46PCtFJtDKRPsMbrop99FXPAb
         UhuQsa0Miw3hpnNsbqfiHSICEcnLayRj3tMXv9u4=
Date:   Tue, 10 Mar 2020 15:44:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos Tarcatu <dragos_tarcatu@mentor.com>
Cc:     broonie@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.14] ASoC: topology: Fix memleak in
 soc_tplg_manifest_load()
Message-ID: <20200310144404.GD3376131@kroah.com>
References: <158378610642216@kroah.com>
 <20200310140211.25468-1-dragos_tarcatu@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310140211.25468-1-dragos_tarcatu@mentor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 04:02:11PM +0200, Dragos Tarcatu wrote:
> commit 242c46c023610dbc0213fc8fb6b71eb836bc5d95 upstream.
> 
> In case of ABI version mismatch, _manifest needs to be freed as
> it is just a copy of the original topology manifest. However, if
> a driver manifest handler is defined, that would get executed and
> the cleanup is never reached. Fix that by getting the return status
> of manifest() instead of returning directly.
> 
> Fixes: 583958fa2e52 ("ASoC: topology: Make manifest backward compatible from ABI v4")
> Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
> Link: https://lore.kernel.org/r/20200207185325.22320-3-dragos_tarcatu@mentor.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  sound/soc/soc-topology.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Thanks for the backport, now queued up.

greg k-h
