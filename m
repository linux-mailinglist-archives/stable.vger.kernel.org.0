Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351261B1C7F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 05:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDUDVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 23:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDUDVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 23:21:25 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A86206F9;
        Tue, 21 Apr 2020 03:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587439285;
        bh=xEmUHAOoyZcRhEoFa4R3C3VggYvh9vMG39wtbPGgH1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yd21Ne0fDGlsG9hDF1efk/I564yGFpzgFZFsP1yBrZAVAz5nMXJ49sQTAqfnuRauF
         K4AIlzKFC8Fm2XVUUY2lL+xgOjxMvqxl0awzBrCWD/sUH3aEpbyM/4y0rlcmf8VLqu
         bTJ3cC3JKi5NI3xiVwEJxcK++wkD7P9AmlbIh+EE=
Date:   Tue, 21 Apr 2020 11:21:17 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        stable@vger.kernel.org,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: provide v7_cpu_resume() only on
 ARM_CPU_SUSPEND=y
Message-ID: <20200421032116.GD8571@dragon>
References: <20200323081933.31497-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323081933.31497-1-a.fatoum@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 09:19:33AM +0100, Ahmad Fatoum wrote:
> 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
> introduced an unintended linker error for i.MX6 configurations that have
> ARM_CPU_SUSPEND=n which can happen if neither CONFIG_PM, CONFIG_CPU_IDLE,
> nor ARM_PSCI_FW are selected.
> 
> Fix this by having v7_cpu_resume() compiled only when cpu_resume() it
> calls is available as well.
> 
> The C declaration for the function remains unguarded to avoid future code
> inadvertently using a stub and introducing a regression to the bug the
> original commit fixed.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
> Reported-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Applied, thanks.
