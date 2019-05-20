Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0682D22C1E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 08:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbfETGdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 02:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbfETGde (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 02:33:34 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DEA2206B6;
        Mon, 20 May 2019 06:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558334014;
        bh=QRKYgLNzDZOhAn3LHJcZN2xR9Hu+AIL+I/Vtp5mmIME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBVaXPLrUn3UyIT7oDINmTX9zltWSxVAo/QDBoofDh2yNPXYBXsPmNL/FBWWtjlgY
         NqD3Bv9Nf9mLSqaqmi5ApY8mP5ivyuIWRKWNzLI5qsA/D6IEO/6nKJ88/ymq0Bw1fE
         3zAm38KkwaMLc3r4oYBisNl1koNsujGEbJGCf7Z8=
Date:   Mon, 20 May 2019 14:32:45 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, anson.huang@nxp.com,
        kernel@pengutronix.de, linux-imx@nxp.com,
        cniedermaier@dh-electronics.com, sebastien.szymanski@armadeus.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO
 increase to i.MX6SX
Message-ID: <20190520063244.GR15856@dragon>
References: <20190513031531.7879-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190513031531.7879-1-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 12:15:31AM -0300, Fabio Estevam wrote:
> Since commit 1e434b703248 ("ARM: imx: update the cpu power up timing
> setting on i.mx6sx") some characters loss is noticed on i.MX6ULL UART
> as reported by Christoph Niedermaier.
> 
> The intention of such commit was to increase the SW2ISO field for i.MX6SX
> only, but since cpuidle-imx6sx is also used on i.MX6UL/i.MX6ULL this caused
> unintended side effects on other SoCs.
> 
> Fix this problem by keeping the original SW2ISO value for i.MX6UL/i.MX6ULL
> and only increase SW2ISO in the i.MX6SX case.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1e434b703248 ("ARM: imx: update the cpu power up timing setting on i.mx6sx")
> Reported-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> Tested-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
> Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>

Applied, thanks.
