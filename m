Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854C03A1D5C
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFITAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 15:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhFITAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 15:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B947561364;
        Wed,  9 Jun 2021 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623265090;
        bh=5Oerxcxkbmnp9SKdd+X4WFEOBlR8i4Q0NSdmLzUwXSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vbuS46zf1uAcACc3q5IfWloooE8dYfn/TfKl+OcZre+whL+D3CQ5H0EpfPyeL9naY
         +i2wFA/12ZX6gzUAXvwryDLvOhEQoBrmP5ddPV2GxsPDIUWXhmh+ru32xmuS8kQmoH
         Crq7i4Xhoo/LWIR0D00DPDmHZCfwZePAtF+J7i3w=
Date:   Wed, 9 Jun 2021 20:58:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     linux-clk@vger.kernel.org, sboyd@kernel.org,
        mturquette@baylibre.com, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] clk: agilex/stratix10/n5x: fix how the bypass_reg is
 handled
Message-ID: <YMEPQOly+gPx2kmL@kroah.com>
References: <20210609185008.36056-1-dinguyen@kernel.org>
 <20210609185008.36056-4-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609185008.36056-4-dinguyen@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 01:50:08PM -0500, Dinh Nguyen wrote:
> If the bypass_reg is set, then we can return the bypass parent, however,
> if there is not a bypass_reg, we need to figure what the correct parent
> mux is.
> 
> The previous code never handled the parent mux if there was a
> bypass_reg.
> 
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
>  drivers/clk/socfpga/clk-periph-s10.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
