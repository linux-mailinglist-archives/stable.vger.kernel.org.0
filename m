Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E284FB13A
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 03:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiDKBEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 21:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiDKBEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 21:04:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8E6A5;
        Sun, 10 Apr 2022 18:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A701EB80ED6;
        Mon, 11 Apr 2022 01:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D737C385A4;
        Mon, 11 Apr 2022 01:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649638917;
        bh=dJPdSEIt6ybe5JLJYd0CgJVb5MPO9KkLpDoosd80+FE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KUsTcZof8OIhlBr6wdF0c07aORCVlGoJD7dEvJL8DUHamM1YyaNEZo+NN03iJuuJq
         9l5LCKQKM/Uq16fUtdPyZuQzG4OvdDt5umWOrc9C8rYI40Sdj3Cq6MPGHbpwJPG1Ib
         DDTl3SUh4fm8PgKJejKa7rycB5YofglrE/fIJT+criSaKrHy8xULEJR6RiXusV2rDY
         XJci2Ss8yyO5u91McYvp1+IqcqFE5fceR/ZyHaDVxG5hXmzOi7LYbRLGfK5j7p59oJ
         cXe3tatYE6zwCDReStnLaX6+5gt9vBPc6vPub1lJLRwqfSoj/NxNC5vegz3xsRVt5v
         1q8GPw0a8j6kg==
Date:   Mon, 11 Apr 2022 09:01:50 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: imx8mm-venice-gw{72xx,73xx}: fix OTG
 controller OC mode
Message-ID: <20220411010150.GX129381@dragon>
References: <20220401174249.10252-1-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401174249.10252-1-tharvey@gateworks.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 10:42:49AM -0700, Tim Harvey wrote:
> Both the GW72xx and GW73xx boards have USB1 routed to a USB OTG
> connector and USB2 routed to a USB hub.
> 
> The OTG connector has over-current protection with an active-low
> pin and the USB1 to HUB connection has no over-current protection (as
> the HUB itself implements this for its downstream ports).
> 
> Add proper dt nodes to specify the over-current pin polarity for USB1
> and disable over-current protection for USB2.
> 
> Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Applied, thanks!
