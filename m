Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3503816B97B
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 07:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBYGMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 01:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgBYGMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 01:12:24 -0500
Received: from localhost (unknown [122.167.120.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 557BE2082F;
        Tue, 25 Feb 2020 06:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582611144;
        bh=fxLOFtVYfe/xZb9HlC6PvDLWrLnNe/I7p4/iU1LvhUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=igezpnXUhAdO5oTgHW459emyzcdKLBnR/P1Gw8dY0ve+VGQoVDDraV4MdWqHfMtUo
         irHddwFcD3/HwfcnJC3CLI42i2sQhWVZDSfb4Le8MzAg+4Y7KyjJHdT5Y4cbqeHPMg
         nyKpzGOjwpeRbizs0vyFNvNeGOUDVctNjc9bfEyc=
Date:   Tue, 25 Feb 2020 11:42:20 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: imx-sdma: Fix the event id check to include RX
 event for UART6
Message-ID: <20200225061220.GK2618@vkoul-mobl>
References: <20200224172236.22478-1-frieder.schrempf@kontron.de>
 <CAOMZO5CyYbAZRZrGLJNJXNJiekJXptUTu8tOfVw6y7-n-CXesg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CyYbAZRZrGLJNJXNJiekJXptUTu8tOfVw6y7-n-CXesg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24-02-20, 15:43, Fabio Estevam wrote:
> Hi Frieder,
> 
> On Mon, Feb 24, 2020 at 2:22 PM Schrempf Frieder
> <frieder.schrempf@kontron.de> wrote:
> >
> > From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >
> > On i.MX6 the DMA event for the RX channel of UART6 is '0'. To fix
> 
> I would suggest being a bit more specific than saying i.MX6.
> 
> I see UART6 is present on i.MX6UL/i.MX6SX, but not on i.MX6Q/i.MX6DL,
> so it would be better to specify it in the commit log.
> 
> imx6ul.dtsi does not have dma nodes under uart6, so I guess you fixed
> it for imx6sx.

and use right subsystem tag dmaengine. Git log of the file should tell
you the right one to use :)

> 
> > the broken DMA support for UART6, we change the check for event_id0
> > to include '0' as a valid id.
> >
> > Fixes: 1ec1e82f2510 ("dmaengine: Add Freescale i.MX SDMA support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Reviewed-by: Fabio Estevam <festevam@gmail.com>

-- 
~Vinod
