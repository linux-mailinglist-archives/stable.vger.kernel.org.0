Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830E9309AB
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 09:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfEaHr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 03:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbfEaHr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 03:47:56 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16DA125C45;
        Fri, 31 May 2019 07:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559288875;
        bh=GWIosX87hTOI8Tkfm7AbxvgTQ89o5/vaaxIkcdU4J+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bBXWKSPmMfZ5XQ8DvB5lKq+8d/OZG8wH3JOaRMOzGD5tbNo4HPwkkEihZ46z1hur/
         uitjg3tLBXP6aFxUw2HEUS/2uMbaO6HWy7SY/aMa068N+MyGW0EzOfnuY/kMh65COk
         Q+jiYktwA07UVyFqwEmHgH6hZdLqL3IQkkIyiTQ4=
Date:   Fri, 31 May 2019 15:46:34 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Peng Fan <peng.fan@nxp.com>
Cc:     Stephen Boyd <sboyd@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Message-ID: <20190531074633.GF23453@dragon>
References: <20190522014832.29485-1-peng.fan@nxp.com>
 <20190523132235.GZ9261@dragon>
 <20190529233547.B7F6F2435D@mail.kernel.org>
 <AM0PR04MB4481A7FF28A9AB9A1584423888180@AM0PR04MB4481.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4481A7FF28A9AB9A1584423888180@AM0PR04MB4481.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 01:22:57AM +0000, Peng Fan wrote:
> Hi Stephen,
> 
> > Subject: Re: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
> > audio_pll2_out
> > 
> > Quoting Shawn Guo (2019-05-23 06:22:36)
> > > On Wed, May 22, 2019 at 01:34:46AM +0000, Peng Fan wrote:
> > > > There is no audio_pll2_clk registered, it should be audio_pll2_out.
> > > >
> > > > Cc: <stable@vger.kernel.org>
> > > > Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for imx8mm")
> > > > Signed-off-by: Peng Fan <peng.fan@nxp.com>
> > >
> > > Stephen,
> > >
> > > I leave this to you, since it's a fix.
> > >
> > 
> > Is it a critical fix? Or is it an annoyance that can wait in -next until the next
> > merge window?
> 
> I did not run into issue without this fix currently, so it should be fine to wait
> in -next until the next merge window.

I was trying to pick up the patch, but the base64 Content-Transfer-Encoding
make the applying difficult.  Please talk to NXP colleague Anson Huang
<Anson.Huang@nxp.com> to find out how to fix it.

https://patchwork.kernel.org/patch/10944169/#22656941

Shawn
