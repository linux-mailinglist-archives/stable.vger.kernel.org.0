Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEED496DA4
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 20:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiAVT1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 14:27:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46888 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiAVT1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 14:27:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 484E760EBC;
        Sat, 22 Jan 2022 19:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DA2C004E1;
        Sat, 22 Jan 2022 19:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642879622;
        bh=bpWygTu4GoHO3WlLR0Dt+S1k5355VFM06lS1zO6jUBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ftYFrNkSEZw692aUftjrxvqgAzFTtO1rgS7BWhgvF2Z0QFVBdv/oPp06MLpsHccdo
         31X9liMyTx7BwHtfA668qlq41lNAkwgNk8tk4+uZN4IWtfX5flZoKLjeLyIBTG+D8o
         dzGC77P/TO3s2TfHlxATcskPGQ+ev9xEDV6FxnCTBkKneE7vF5GzUT5GoETnNKo85G
         0sd8K1kvSjFWAWhFSl//35NJ+rvQJzbttoI7X1JsWysvg3Xr3YT15DKmoEhOieQ2xE
         A4OcwF4rKQwFM1fo9BbVyx1MVaf95+/Nd5S768/vKjPv0QopCPJUaVD5l0PRYWaIgL
         ILlwcapQG4VCQ==
Date:   Sat, 22 Jan 2022 14:27:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        linux@armlinux.org.uk, linus.walleij@linaro.org, daniel@thingy.jp,
        avolmat@me.com, krzysztof.kozlowski@canonical.com,
        romain.perier@gmail.com, eugen.hristev@microchip.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.4 06/29] ARM: imx: rename
 DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART
Message-ID: <YexahcZZO1z/pM94@sashalap>
References: <20220118030822.1955469-1-sashal@kernel.org>
 <20220118030822.1955469-6-sashal@kernel.org>
 <20220120100849.GA14998@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220120100849.GA14998@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 11:08:49AM +0100, Pavel Machek wrote:
>Hi!
>
>> From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>>
>> [ Upstream commit b0100bce4ff82ec1ccd3c1f3d339fd2df6a81784 ]
>>
>> Since commit 4b563a066611 ("ARM: imx: Remove imx21 support"), the config
>> DEBUG_IMX21_IMX27_UART is really only debug support for IMX27.
>
>This is unsuitable for 4.4 as imx21 is still supported there.

I'll drop it, thanks!

-- 
Thanks,
Sasha
