Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068ABE6AB9
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfJ1CTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727775AbfJ1CTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 22:19:19 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789E72070B;
        Mon, 28 Oct 2019 02:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572229158;
        bh=Ooys5L+8V//Sns55VinsxJARaA6m2QRYb6IyFJTCdtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQhwRQ/3nHp908TPJ7774bqZ+4AEL3R/14X8ZNES9se557S/0mCQ4vgqRJY9s1+qn
         GrmOiL3ABss+CsCqocabdwqyH03xkBBn53P6WRu4m87lVWpEHPkjSznSdmxIE7RB0K
         etl4cZfFKHP48RL8OYm4mdSzBCOAWyY7TBVJY9sY=
Date:   Mon, 28 Oct 2019 10:18:59 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, adam.ford@logicpd.com,
        stable <stable@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Anson Huang <Anson.Huang@nxp.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx6-logicpd: Re-enable SNVS power key
Message-ID: <20191028021858.GE16985@dragon>
References: <20191016144005.9863-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016144005.9863-1-aford173@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 09:40:05AM -0500, Adam Ford wrote:
> The baseboard of the Logic PD i.MX6 development kit has a power
> button routed which can both power down and power up the board.
> It can also wake the board from sleep.  This functionality was
> marked as disabled by default in imx6qdl.dtsi, so it needs to
> be explicitly enabled for each board.
> 
> This patch enables the snvs power key again.
> Fixes: 770856f0da5d ("ARM: dts: imx6qdl: Enable SNVS power key according to board design")

So this is fixing powerkey, while the previous fix on som was actually
about poweroff.  I was confused.

> 
> Cc: stable <stable@vger.kernel.org> #5.3+
> Signed-off-by: Adam Ford <aford173@gmail.com>

Applied, thanks.
