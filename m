Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB4B2255EB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 04:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgGTCfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 22:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgGTCfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jul 2020 22:35:17 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671A12177B;
        Mon, 20 Jul 2020 02:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595211992;
        bh=W0z8d5qH3x7QCjjyviao8AG2I2YewxaLkn0dH6EbAww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=174jfQF1ya4CfPfNO/bkjW/Dy75FAiqbzXEQuQ8dlncYDwQ9jhDjmJBOqX+ZuaAPF
         QNolXfTw8BsCnl7d/F4c/FgltZqsQErSVboRJMP0WCxXm1cYKLeKLattNN2JLz+Yex
         RpTl5Vthu2KIO5e3JLIQDOb3zKBJQSH5EHcKtTtE=
Date:   Mon, 20 Jul 2020 10:26:25 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: imx6sx-sdb: Fix the phy-mode on fec2
Message-ID: <20200720022625.GG11560@dragon>
References: <20200713142325.24601-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713142325.24601-1-festevam@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 13, 2020 at 11:23:24AM -0300, Fabio Estevam wrote:
> Commit 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode") fixed the
> phy-mode for fec1, but missed to fix it for the fec2 node.
> 
> Fix fec2 to also use "rgmii-id" as the phy-mode.
> 
> Cc: <stable@vger.kernel.org> 
> Fixes: 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Applied both, thanks.
