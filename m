Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED4646D444
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhLHNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 08:22:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhLHNWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 08:22:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 334E6B8169E
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 13:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D363C00446;
        Wed,  8 Dec 2021 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638969548;
        bh=UElgydWHY21Po+3PC+V4ijzgzcpDaVwhg7yHM8k8vXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=piGvyRYGNO9zmHTeB8cPfR980L1kiivWMugCix3OCny7cvsgM36N3h744jbVapZwb
         jhF/5+6PX11x0GW4DP6DLbWDNvDoDKZWKzzJmofAyeTalTCzh2+ug6KgU5jkm1zIC6
         8WpwAgbIpT2dCAN1UOkaUbC6lJEqB1yoloXtK0Bc=
Date:   Wed, 8 Dec 2021 14:19:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Patrik John <patrik.john@u-blox.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] serial: tegra: Change lower tolerance baud rate limit
 for tegra20 and tegra30
Message-ID: <YbCwyVoz4o5wMuXJ@kroah.com>
References: <sig.0974db5058.20211206171457.1639733-1-patrik.john@u-blox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sig.0974db5058.20211206171457.1639733-1-patrik.john@u-blox.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 06:14:57PM +0100, Patrik John wrote:
> commit b40de7469ef135161c80af0e8c462298cc5dac00 upstream.
> 
> The current implementation uses 0 as lower limit for the baud rate
> tolerance for tegra20 and tegra30 chips which causes isses on UART
> initialization as soon as baud rate clock is lower than required even
> when within the standard UART tolerance of +/- 4%.
> 
> This fix aligns the implementation with the initial commit description
> of +/- 4% tolerance for tegra chips other than tegra186 and tegra194.
> 
> Fixes: d781ec21bae6 ("serial: tegra: report clk rate errors")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Patrik John <patrik.john@u-blox.com>
> Link: https://lore.kernel.org/r/sig.19614244f8.20211123132737.88341-1-patrik.john@u-blox.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Backport for 5.4-stable 

Now queued up, thanks.

greg k-h
