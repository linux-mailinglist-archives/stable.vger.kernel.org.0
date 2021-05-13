Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E600B37F3C0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 09:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhEMHz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 03:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhEMHzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 03:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDEE761406;
        Thu, 13 May 2021 07:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620892486;
        bh=yw6CC4ec20AVtlwDLA1HnhqdCK9r2gaclRhdjuStguA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOjO2dVBeI8bdwy3l5ei0dw5ZFrbDQbOfNYfO360PF00crPYMS7oFd7FGmIbGlckh
         b4AuO6B7r14sxCaB9VLoRjTSJTNNnuVerrKDbsJo7HWC1Er8oTgmpOUk8srWvn5JlK
         S4A8gmFjTk6sHuy7X3QcjHNuVDZZwM5CSSoF3zvHGnWInqtNQrTNDZCkjdsFLooOBn
         sel+A1csrEtP5tskAQDLlsVHUayKgbD9Q78Gcz6yxKosRpJXsj8Hr36Q+CGmJbNuBg
         di58AU7ut0fKNK+XP7NuNYc9OpHdBapuPlJipPKbAXa7fRpb9L7JNcOLQY7Bqrrx1C
         W10wwuXI4BQnw==
Date:   Thu, 13 May 2021 15:54:41 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        Fabio Estevam <festevam@gmail.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org
Subject: Re: [PATCH V3] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
Message-ID: <20210513075440.GW3425@dragon>
References: <20210426102321.5039-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426102321.5039-1-marex@denx.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 12:23:21PM +0200, Marek Vasut wrote:
> Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
> via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
> from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.
> 
> While no instability or problems are currently observed, the regulators
> should be fully described in DT and that description should fully match
> the hardware, else this might lead to unforseen issues later. Fix this.
> 
> Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Ludwig Zenz <lzenz@dh-electronics.com>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: stable@vger.kernel.org

Applied, thanks.
