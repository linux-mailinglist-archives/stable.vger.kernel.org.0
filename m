Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A73A10ECF3
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfLBQUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:20:14 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59999 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727615AbfLBQUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 11:20:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F39C0DF3;
        Mon,  2 Dec 2019 11:20:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 11:20:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        from:date:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=g
        ekzQoo7pY0vAzk4aZHnv48STk3tZcFu6464PZHVti4=; b=VsGE1kPLaHeZsA/jm
        hHMOzyxYG7BI1hNRRNXLfec0ej/pENeDvvEEDFxMzjCVvLvC2dZQ7708EX73QBeW
        1y9VSeiixzUunOLHaoCUHLJ3/ZmKuHlwi/s5ZO9QeVJidGswC+9GKf6Ljv7t3kLJ
        EeGVMXYgJBjZbFiv441788FAfzoW9r61SsmWqsZ0BaKxlFJJw9ewgor9dMmhMf8V
        m1GfaOnMC8sq8tbpna+EYlnSF+nFTJat/458dLw1XpfrO1vH0Z8eajgXZEDezrSC
        cZBeqYRdUCEdV5CPC1K1aunANe3mK1944E1hzWAc0LiqrnxFiOn0S37RAPT1Ycx6
        YMcWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=gekzQoo7pY0vAzk4aZHnv48STk3tZcFu6464PZHVt
        i4=; b=jUxcsasFzuMe3kFBiFJbdzLZPyagewl9GLB+b3/s446TAAYapENXBZeDH
        yW0C6YBuKalynQrj0eN90X1ULzIJV9f1XV93zjrgmJPCDMCZfE1vWhfCdmz6sFy3
        tumrqOZjvxjvCgwfvaC+5b0JPi6DOp9QL1TCQ71LEU8BBASCtw/3i2KpLraRR56a
        U5yT+5hwEGsU8UGwIY82jttfGF95kEISneA5NRVC1m6X1lXrji58bH760tT+HlX1
        qVSHI2FN5Ub7Bu0FnXekfVy2RwzorgdZMEsLWxMkP5GfHJi+0R8I2EO3y4KvVqaP
        qkzRwv/+ynls58qOFnfESSRA4SzGg==
X-ME-Sender: <xms:vDnlXZ-elCq0x5Yu2JmXyztZS9xSQUiVkRW0oemiMRnyhYzLqI3POw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephfffvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomhenucfkphepkeegrddvgedurdduleeirdejfeenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:vDnlXY1URTuusCxiyZYv8YsWPu78SPF9HuiAU7j8thG48_dIvOnvIg>
    <xmx:vDnlXRXe65WF5ql6_WZXQUrZfnrlZuuqbD1CIjlPPp7Iz67aSZt48g>
    <xmx:vDnlXaBkGU9BpETqJPEw4g7X0lIPGRUNpeRH8uUWL7jj4apXwUBuAQ>
    <xmx:vDnlXZ80xHbFW5glxhE5HWZ6jO3TGTTgCFSD6tMloShAMZj4Jsadkg>
Received: from localhost (unknown [84.241.196.73])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1A3080066;
        Mon,  2 Dec 2019 11:20:11 -0500 (EST)
From:   greg@kroah.com
Date:   Mon, 2 Dec 2019 17:20:09 +0100
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 1/4] arm: add missing include platform-data/atmel.h
Message-ID: <20191202162009.GB701632@kroah.com>
References: <20191202094150.32485-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191202094150.32485-1-lee.jones@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 09:41:47AM +0000, Lee Jones wrote:
> From: Philippe Mazenauer <philippe.mazenauer@outlook.de>
> 
> [ Upstream commit 95701b1c3c8fe36368361394e3950094eece4723 ]
> 
> Include corresponding headerfile <linux/platform-data/atmel.h> for
> function at91_suspend_entering_slow_clock().
> 
> ../arch/arm/mach-at91/pm.c:279:5: warning: no previous prototype for ‘at91_suspend_entering_slow_clock’ [-Wmissing-prototypes]
>  int at91_suspend_entering_slow_clock(void)
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Philippe Mazenauer <philippe.mazenauer@outlook.de>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-at91/pm.c | 1 +
>  1 file changed, 1 insertion(+)

Does this show up on a "normal" build?  Or do you have to run with "W=1"
to see it?  There's no need for stable patches for stuff that only shows
up with W=1, thanks.

greg k-h
