Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD232E7D
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 13:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfFCLUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 07:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfFCLUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 07:20:00 -0400
Received: from dragon (li1232-89.members.linode.com [45.79.133.89])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71F2248FE;
        Mon,  3 Jun 2019 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559560799;
        bh=51bKqvI2Kh1iIsbEEX1iYpa3HSCjXs9uBGXPd8wvuP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDVP7lay24TybY1VpQ1VnqW1oABadoI+k+LLsl4bRjiQuVoYsAN6y9COAJHDqlhZY
         m66hFh5zTqaZH2OU8SZO8qJ+xppQicaQatCPxa2bIw3z8tWX8xdxY0RnemDOxqZEfH
         vJVu95BZ8U90k63FFY6stxhTo+W4t4L86BD/VBKg=
Date:   Mon, 3 Jun 2019 19:19:48 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     peng.fan@nxp.com
Cc:     mturquette@baylibre.com, sboyd@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Message-ID: <20190603111947.GA15919@dragon>
References: <20190531075638.7892-1-peng.fan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531075638.7892-1-peng.fan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 03:56:38PM +0800, peng.fan@nxp.com wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> There is no audio_pll2_clk registered, it should be audio_pll2_out.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for imx8mm")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Applied, thanks.
