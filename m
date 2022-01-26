Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DD449C456
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 08:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbiAZHb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 02:31:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52260 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiAZHb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 02:31:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67D48618F9;
        Wed, 26 Jan 2022 07:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C20BC340E3;
        Wed, 26 Jan 2022 07:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643182285;
        bh=pzTxdma95vGuWAhv02sMo8LFXxy5LlpL3uN24ABQErw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEn+IRF+FqztAnn0/mTUwkuLI9tT4dAwgphxLl4jNjU36zi6Nc4pioFbIHCWPBfpA
         8vtULXHstkxHgAif971VOdVMQZHSRJdVagVETrDXukXo1HiI3GPaHn5J4Tv++VLXcC
         Spf7imZRiU2mGMVSiM69JuVqMaM9iV9KciZz1jf4=
Date:   Wed, 26 Jan 2022 08:31:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 127/239] ARM: imx: rename DEBUG_IMX21_IMX27_UART to
 DEBUG_IMX27_UART
Message-ID: <YfD4yjDphIdPkqQe@kroah.com>
References: <20220124183943.102762895@linuxfoundation.org>
 <20220124183947.149798691@linuxfoundation.org>
 <20220125191546.GA5395@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125191546.GA5395@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 08:15:46PM +0100, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit b0100bce4ff82ec1ccd3c1f3d339fd2df6a81784 ]
> > 
> > Since commit 4b563a066611 ("ARM: imx: Remove imx21 support"), the config
> > DEBUG_IMX21_IMX27_UART is really only debug support for IMX27.
> > 
> > So, rename this option to DEBUG_IMX27_UART and adjust dependencies in
> > Kconfig and rename the definitions to IMX27 as further clean-up.
> > 
> > This issue was discovered with ./scripts/checkkconfigsymbols.py, which
> > reported that DEBUG_IMX21_IMX27_UART depends on the non-existing config
> > SOC_IMX21.
> 
> This is unsuitable for 4.19, as CONFIG_SOC_IMX21 is still present
> there. It is probably okay for 5.10. I did not check others.

Good point, I will drop this from 5.4 and older now.

thanks,

greg k-h
