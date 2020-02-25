Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B0D16BC12
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 09:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgBYIpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 03:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgBYIpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 03:45:41 -0500
Received: from localhost (unknown [122.167.120.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B3B420CC7;
        Tue, 25 Feb 2020 08:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582620341;
        bh=I1N06m9H8JQ9n2bGaqanCvfsSQpjqak5lJJ5OOW0dUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GGsnqIh5k9qaitFovTeMIC74Y8ev54Z8gYaHXGKw3uTGmA52z/i0Y/ZskvvFUL8Mv
         9RC8VaNyPsI+UCC+g/mH1vNhtQkjDQsqVvC9sjgv0HjUAVgojyMRwdX8Fs4qiLo9ec
         2HwgDw3Ti0QO6+baBzbhEYB4EqZ9/GkNtffE1gwk=
Date:   Tue, 25 Feb 2020 14:15:37 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
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
Subject: Re: [PATCH v2] dmaengine: imx-sdma: Fix the event id check to
 include RX event for UART6
Message-ID: <20200225084537.GM2618@vkoul-mobl>
References: <20200225082139.7646-1-frieder.schrempf@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225082139.7646-1-frieder.schrempf@kontron.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25-02-20, 08:23, Schrempf Frieder wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> On i.MX6UL/ULL and i.MX6SX the DMA event id for the RX channel of
> UART6 is '0'. To fix the broken DMA support for UART6, we change
> the check for event_id0 to include '0' as a valid id.

Applied, thanks

-- 
~Vinod
