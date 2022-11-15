Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDDA629B6D
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 15:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiKOOEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 09:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiKOOEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 09:04:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF532A407;
        Tue, 15 Nov 2022 06:04:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BFAD6179E;
        Tue, 15 Nov 2022 14:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BDFC433C1;
        Tue, 15 Nov 2022 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668521056;
        bh=5XfEws0XxenbR1aaxjGfPQA/NHGpOviAp/wU2OUyGak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uazHyIiP/ZDF9RWhPjWv9fwddsNOIEllgYPecu1+L8USFxr/5kxMPXF9JceD8058b
         SP+TWFVAiomPiun/wKC3+14Mykkp4E0pUSN+XYJ3D5cxCguGhcrKdanpsHTcKelvgT
         74V+WlGnzkMdY3LcLp0tc0/lOtYBebdKPK3DsilM=
Date:   Tue, 15 Nov 2022 15:04:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3OcXqRrAKka7ILe@kroah.com>
References: <20221114124448.729235104@linuxfoundation.org>
 <20221114192650.GA1452278@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114192650.GA1452278@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 11:26:50AM -0800, Guenter Roeck wrote:
> On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.79 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build reference: v5.15.78-132-gb6ea7e152210
> Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
> Assembler version: GNU assembler (GNU Binutils) 2.39
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
> drivers/net/ethernet/mediatek/mtk_star_emac.c:980:29: error: 'struct mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
>   980 |         napi_disable(&priv->rx_napi);
>       |                             ^~~~~~~
>       |                             napi
> drivers/net/ethernet/mediatek/mtk_star_emac.c:981:29: error: 'struct mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
>   981 |         napi_disable(&priv->tx_napi);
>       |                             ^~~~~~~
>       |                             napi
> 
> Guenter

Thanks, should now be fixed in -rc2
