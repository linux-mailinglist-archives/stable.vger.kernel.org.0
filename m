Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04BC51104E
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 06:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357737AbiD0E6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 00:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiD0E6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 00:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330FB2665;
        Tue, 26 Apr 2022 21:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3000260BD6;
        Wed, 27 Apr 2022 04:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6872CC385A9;
        Wed, 27 Apr 2022 04:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651035302;
        bh=lb0749tNeujoajvrbWKtsMVUVmfSzSAh3mOQ5OSWbws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r7wYa8F18+PZLTDUmJKFzhLYYO74EtPmmL3519tYSUTYar7ruzcYYcSW3ukXFgBRj
         eP0aKTMAlRWZ+qVsuW85TATNJpZJBLVZ3CNb4Vum8W2xpAgk95jYFmr9BFPjaaQc8L
         odJZTZuVF4tTUZAFoESZOQNg6Jnyvi2WVwr9MDXg=
Date:   Wed, 27 Apr 2022 06:54:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Hartley Sweeten <hsweeten@visionengravers.com>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ep93xx: clock: Fix UAF in mach-ep93xx/clock.c
Message-ID: <YmjMoeDNd2cNMjRt@kroah.com>
References: <20220427022111.772457-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022111.772457-1-wanjiabing@vivo.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022 at 10:21:11AM +0800, Wan Jiabing wrote:
> Fix following coccicheck errors:
> ./arch/arm/mach-ep93xx/clock.c:351:9-12: ERROR: reference preceded by free on line 349
> ./arch/arm/mach-ep93xx/clock.c:458:9-12: ERROR: reference preceded by free on line 456
> 
> Fix two more potential UAF errors.
> 
> Link: https://lore.kernel.org/all/20220418121212.634259061@linuxfoundation.org/
> Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  arch/arm/mach-ep93xx/clock.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
