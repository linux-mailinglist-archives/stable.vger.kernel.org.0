Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C50611A4D0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 08:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfLKHHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 02:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfLKHHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 02:07:53 -0500
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23CA520836;
        Wed, 11 Dec 2019 07:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576048073;
        bh=8msHcIRu3PefYDklXS+Yt8ZWDv8UpIyQUU1KePcXvUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I6qcpZab4oL1uW14v+yRpdRAmH74HJX44/xxYLcSVUaU32XzcNP4JLGJBnNmveSFV
         MmDkfr/0zyM16WKOx7IBoLVqAnppDSdic4/Gy8TTKhNPvwZhbdT5BHxUZD9xkBq1XH
         rW0BSLiJ6z5+LOmelSd8ur+Vfj/c7gjpBRnM+27U=
Date:   Wed, 11 Dec 2019 15:07:40 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Peng Fan <peng.fan@nxp.com>
Cc:     "sboyd@kernel.org" <sboyd@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] clk: imx: pll14xx: fix clk_pll14xx_wait_lock
Message-ID: <20191211070739.GL15858@dragon>
References: <1575879445-15386-1-git-send-email-peng.fan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575879445-15386-1-git-send-email-peng.fan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 08:19:55AM +0000, Peng Fan wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> The usage of readl_poll_timeout is wrong, the 3rd parameter(cond)
> should be "val & LOCK_STATUS" not "val & LOCK_TIMEOUT_US",
> It is not check whether the pll locked, LOCK_STATUS reflects the mask,
> not LOCK_TIMEOUT_US.
> 
> Fixes: 8646d4dcc7fb ("clk: imx: Add PLLs driver for imx8mm soc")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Applied, thanks.
