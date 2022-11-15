Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F106629B55
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 14:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKON7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 08:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiKON7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 08:59:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86211C93D;
        Tue, 15 Nov 2022 05:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EFD061796;
        Tue, 15 Nov 2022 13:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31184C433D6;
        Tue, 15 Nov 2022 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668520770;
        bh=rb5W412jHJ/fNXONcq6nglbdvHNvzF+Z6trcJyoQiqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZmIZuK+5K/X909vL/BiLFOSl9OxbdgweO1tD51w1yrv8K+Ok3QSrf8r1ppfXy+St
         ibj2tKPCR5uvlIQc7Iop6dXHehLMyVklgOdZmZbAXJqyWbn23t49eiZIzbK3oPQO5F
         YJpwLcpL3rAIKA3cbola/HXrqCJuFKYQy3/n60t4=
Date:   Tue, 15 Nov 2022 14:59:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3ObPwyWx4bEAoAt@kroah.com>
References: <20221114124448.729235104@linuxfoundation.org>
 <CA+G9fYvdqK23zAa+=-x29Hq7BGVd2pN1_1XOp5U1X-GUWM4MAA@mail.gmail.com>
 <f0136268-63d4-66ec-98fe-b7584b388906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0136268-63d4-66ec-98fe-b7584b388906@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 11:34:12AM +0800, shaozhengchao wrote:
> 
> 
> On 2022/11/15 10:56, Naresh Kamboju wrote:
> > On Mon, 14 Nov 2022 at 18:24, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 5.15.79 release.
> > > There are 131 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > As others reported,
> > arm: allmodconfig  failed [1] due to following warnings / errors.
> > 
> > drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
> > drivers/net/ethernet/mediatek/mtk_star_emac.c:980:22: error: 'struct
> > mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
> >    980 |  napi_disable(&priv->rx_napi);
> >        |                      ^~~~~~~
> >        |                      napi
> > drivers/net/ethernet/mediatek/mtk_star_emac.c:981:22: error: 'struct
> > mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
> >    981 |  napi_disable(&priv->tx_napi);
> >        |                      ^~~~~~~
> >        |                      napi
> > 
> > 
> > ---
> > net: ethernet: mtk-star-emac: disable napi when connect and start PHY
> > failed in mtk_star_enable()
> > [ Upstream commit b0c09c7f08c2467b2089bdf4adb2fbbc2464f4a8 ]
> > 
> > 
> > [1] https://builds.tuxbuild.com/2HXmwUDUvmWI1Uc7zsdXNcsTqW1/
> > 
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
> 
> Yes ,For stable-5.10, commit 0a8bd81fd6aaace14979152e0540da8ff158a00a
> ("net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs")
> is not merged. So, please use napi_disable(&priv->napi) instead of
> napi_disable(&priv->rx_napi) and napi_disable(&priv->tx_napi).

I think you mean 5.15 here, not 5.10, right?

Can you send a properly backported version of this commit for 5.10.y and
5.15.y so that I can queue it up?  I'll go drop this offending one from
the queue now and push out a -rc2 so that it doesn't stall the release.

thanks,

greg k-h
