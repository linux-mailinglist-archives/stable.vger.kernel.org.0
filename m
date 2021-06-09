Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89983A1D5E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFITAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 15:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhFITAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 15:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3912061364;
        Wed,  9 Jun 2021 18:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623265104;
        bh=9WWjQNcohC0iQcBIHkL9GJ7pmFxz94zjkzzm8GKCc90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZrTEQH4Sz+y6YKzrrE1yf/sqmFVVu7R0ZH1m1bTTKxmJTWDW4lAnbuIEO2uM2wP2
         aqcQYNOiqNQnXFo6qQbHL6h0SgxeJUH5IFmqW6ppHPL+mv5gBjy/hy/UHQvBTeQSEk
         aE3AI8zC8v2TqS18wF7+UVlHco0ecWHcEiw/JuBA=
Date:   Wed, 9 Jun 2021 20:58:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     linux-clk@vger.kernel.org, sboyd@kernel.org,
        mturquette@baylibre.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] clk: agilex/stratix10: fix bypass representation
Message-ID: <YMEPToY4/q7UMsOO@kroah.com>
References: <20210609185008.36056-1-dinguyen@kernel.org>
 <20210609185008.36056-2-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609185008.36056-2-dinguyen@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 01:50:06PM -0500, Dinh Nguyen wrote:
> Each of these clocks(s2f_usr0/1, sdmmc_clk, gpio_db, emac_ptp,
> emac0/1/2) have a bypass setting that can use the boot_clk. The
> previous representation was not correct.
> 
> Fix the representation.
> 
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
>  drivers/clk/socfpga/clk-agilex.c | 57 ++++++++++++++++++++++++++------
>  drivers/clk/socfpga/clk-s10.c    | 55 ++++++++++++++++++++++++------
>  2 files changed, 91 insertions(+), 21 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
