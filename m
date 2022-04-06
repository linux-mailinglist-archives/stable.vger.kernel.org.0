Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716054F6452
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiDFQCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiDFQAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:00:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A708A1C4069;
        Wed,  6 Apr 2022 06:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B18B823DC;
        Wed,  6 Apr 2022 13:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAF8C385A3;
        Wed,  6 Apr 2022 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649251883;
        bh=Xc7+Od94RAwOKTzuYqP9McmHPkRVyqgshD8F5nfq0IQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DEviX4osjrypqtzkbq3NvjTNXgHYAd2izpUe3KiGInTFbeSZMJEPaL+ZBPtYa7K4U
         c7Nj41Z9HsnKOGqD0bf1x9vRhQKKT9TSYFUOt6ORGC89Cei2QJGTqCJuIUXFE2VdLP
         ftuGxgNTa1j5uv+bAfUHwrhsl70Bu3jpURXWw5xsIBXJLIZ+aQzhAhrLK5Z58GOiVS
         kcttVX0IISnn9tMvtPzbeuTRASFYD8RtATjadyheoX6rnS+2slASa+U/HP7cBi6kOZ
         kVVAn3X4DdrpnCxD0+ruxgQIcYFhWgkmXWxcUcOwQ76RSqr97HIO89fjFyySn0kzpF
         o4pPFwtJkNXDQ==
Date:   Wed, 6 Apr 2022 21:31:17 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH] arm64: dts: imx8mm-venice: fix spi2 pin configuration
Message-ID: <20220406133117.GT129381@dragon>
References: <20220228101617.12694-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228101617.12694-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 11:16:17AM +0100, Johan Hovold wrote:
> Due to what looks like a copy-paste error, the ECSPI2_MISO pad is not
> muxed for SPI mode and causes reads from a slave-device connected to the
> SPI header to always return zero.
> 
> Configure the ECSPI2_MISO pad for SPI mode on the gw71xx, gw72xx and
> gw73xx families of boards that got this wrong.
> 
> Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
> Cc: stable@vger.kernel.org      # 5.12
> Cc: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied, thanks!
