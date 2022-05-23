Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1347D53133C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbiEWPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237712AbiEWPTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91745DA5A
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 311DE612A0
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374CFC385AA;
        Mon, 23 May 2022 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653319154;
        bh=+r60ibFCnWAhGrZYJ9zU/SjDeivOAM1qgVGoGYi8Lhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZYjllT7U2Tjl6Qs44b1yfPTmBZrXjhmg3bCuCUavm4qzYd9LJz+CtPIK175ch924
         CDMfupUGQa0MidZvq6hs4Y8SGrWm1AOqe8eZcUxrnIMlg5zLA9RrAOGmLKh7NLd3v7
         bz1QCmxO74kbkQu1i2DzjIsW2YRN8r7RrM4I/xn0=
Date:   Mon, 23 May 2022 17:19:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Philippe Schenker <dev@pschenker.ch>
Cc:     abel.vesa@nxp.com, francesco.dolcini@toradex.com, peng.fan@nxp.com,
        philippe.schenker@toradex.com, stable@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 5.4] ARM: dts: imx7: Use audio_mclk_post_div instead
 audio_mclk_root_clk
Message-ID: <Youl7/TNGYaKQRc6@kroah.com>
References: <20220523101227.194594-1-dev@pschenker.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523101227.194594-1-dev@pschenker.ch>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 12:12:27PM +0200, Philippe Schenker wrote:
> From: Abel Vesa <abel.vesa@nxp.com>
> 
> commit 4cb7df64c732b2b9918424095c11660c2a8c4a33 upstream.
> 
> The audio_mclk_root_clk was added as a gate with the CCGR121 (0x4790),
> but according to the reference manual, there is no such gate. Moreover,
> the consumer driver of the mentioned clock might gate it and leave
> the ECSPI2 (the true owner of that gate) hanging. So lets use the
> audio_mclk_post_div, which is the parent.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> [ps: backport to 5.4]
> Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>

Now queued up, thanks.

greg k-h
