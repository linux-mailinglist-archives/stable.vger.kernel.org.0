Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D066D711CA
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 08:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfGWGV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 02:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfGWGV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 02:21:59 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7493218D4;
        Tue, 23 Jul 2019 06:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563862918;
        bh=OgDxbod6Qfkmt/g27y5ShwVP5xlMwBRDW5wzrzqw47E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T7L0zh3SHOKJeX/pVipnV/beItuDd8FoZ6IqBZaDxQF9pYrXx86UelKWqvF+JGybi
         RCivj2XkZtGWJHljYYaUvFmjKxHMzwWzhqX71jjJMPOugZuYCG/Cyu8vZ+/NW8d/lT
         QraCPCEQLxrVeKZ5reNgoXkzalMi1pz5g+8DPUUo=
Date:   Tue, 23 Jul 2019 14:21:27 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Peng Fan <peng.fan@nxp.com>
Cc:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Anson Huang <anson.huang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "van.freenix@gmail.com" <van.freenix@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: imx: imx8mm: fix audio pll setting
Message-ID: <20190723062126.GC15632@dragon>
References: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 02:55:43AM +0000, Peng Fan wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> The AUDIO PLL max support 650M, so the original clk settings violate
> spec. This patch makes the output 786432000 -> 393216000,
> and 722534400 -> 361267200 to aligned with NXP vendor kernel without any
> impact on audio functionality and go within 650MHz PLL limit.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Applied, thanks.
