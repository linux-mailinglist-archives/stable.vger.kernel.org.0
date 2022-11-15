Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40B8629B75
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 15:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiKOOEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 09:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbiKOOEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 09:04:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232892C101;
        Tue, 15 Nov 2022 06:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55020B8190A;
        Tue, 15 Nov 2022 14:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4DDC433C1;
        Tue, 15 Nov 2022 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668521071;
        bh=VgTmIjPgaRmVRscM/fYcJA1oTDBFIUWXKRYDHy6M25U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vi1RKXLoR4YYS14VCvQjChktMJuT10B873jt+DWrqmB3Jld2LCA1eaLYDWZyuGaqQ
         NayCJ9hsk/FJgZgg2niY02h86lFfTmApuXb9fQ2mY30j9PT0GMgHEqMyTA/WGP/c3Q
         3a5H/poU2ZAAyxLwAEQmkNSo6nngKBvHh87tuAZk=
Date:   Tue, 15 Nov 2022 15:04:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3OcbKfsaCAYpLRN@kroah.com>
References: <20221114124448.729235104@linuxfoundation.org>
 <CA+G9fYvdqK23zAa+=-x29Hq7BGVd2pN1_1XOp5U1X-GUWM4MAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvdqK23zAa+=-x29Hq7BGVd2pN1_1XOp5U1X-GUWM4MAA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 08:26:08AM +0530, Naresh Kamboju wrote:
> On Mon, 14 Nov 2022 at 18:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.79 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> As others reported,
> arm: allmodconfig  failed [1] due to following warnings / errors.
> 
> drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
> drivers/net/ethernet/mediatek/mtk_star_emac.c:980:22: error: 'struct
> mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
>   980 |  napi_disable(&priv->rx_napi);
>       |                      ^~~~~~~
>       |                      napi
> drivers/net/ethernet/mediatek/mtk_star_emac.c:981:22: error: 'struct
> mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
>   981 |  napi_disable(&priv->tx_napi);
>       |                      ^~~~~~~
>       |                      napi
> 

Should now be fixed in -rc2
