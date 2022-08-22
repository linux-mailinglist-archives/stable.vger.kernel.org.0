Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26AD59BFAB
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiHVMrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbiHVMrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DA233429
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 946F860FF9
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8677DC433D6;
        Mon, 22 Aug 2022 12:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661172420;
        bh=sba0YQ6AQ2JPuC2r2/PYB720sY3mChELgM9dD4Q2tJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPojq1IrlFgDYhN6T/KXvq+Lk9tlClC7LALv/zg7NEh6eahoJQoMR3JzNQfgr4cK+
         SzPoaJo0ZgRshYrTOKCcaPUGBeCKKHDWhCiaubJMoXSRDm9VaP0c/jnoWB7syO7++O
         Yvnp+Gzbj/9bZSgvW1Ntv/PXSkjMqLP7tU+GXOxI=
Date:   Mon, 22 Aug 2022 14:46:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Kochetkov <al.kochet@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Fix ethernet for rk3188 for 4.19, 5.4 stable
Message-ID: <YwN6wWSj6enfqQFL@kroah.com>
References: <512449D6-77E3-4FD5-A719-85DC186C4871@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512449D6-77E3-4FD5-A719-85DC186C4871@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 01:54:55PM +0300, Alexander Kochetkov wrote:
> Hi Greg,
> 
> Please apply to 4.19, 5.4 stable following:
> 
> commit	ef990bcad58cf1d13c5a49191a2c2342eb8d6709
> 
> clk: rockchip: add sclk_mac_lbtest to rk3188_critical_clocks
> Since the loopbacktest clock is not exported and is not touched in the
> driver, it has to be added to rk3188_critical_clocks to be protected from
> being disabled and in order to get the emac working.
> 
> Signed-off-by: Alex Bee <knaerzche@gmail.com>
> Link: 
> https://lore.kernel.org/r/20200722161820.5316-1-knaerzche@gmail.com
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 

Does not apply to the 4.19.y tree, please provide a working backport if
you wish to see it there.

thanks,

greg k-h
