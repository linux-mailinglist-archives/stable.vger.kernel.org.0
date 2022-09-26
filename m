Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4375F5EAD6E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIZRAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIZQ7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:59:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E051A071;
        Mon, 26 Sep 2022 09:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFC05B80B06;
        Mon, 26 Sep 2022 16:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73F5C433C1;
        Mon, 26 Sep 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208010;
        bh=rec9eiaOYJA4wQp4tsdjMCmeHCugjNV+vS3YksDQ7jE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JD18BsJ8F7bF7qkwg2lPLIg0oEnETVfnUPphTx0A9DcwTfXxKUiqhIgNtYk6Y9c1e
         pBiEj5oFZ0jHyjywA3+XO4IOYnXF/yNFZWFEBo8trys/uB/0HDcmBNLtGZuU/EWzeK
         F9adpxK7RBvkRLlf71GEI3DbCJBEq6Ts1CPy5Xu8=
Date:   Mon, 26 Sep 2022 18:00:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH 5.4 000/120] 5.4.215-rc1 review
Message-ID: <YzHMh/je4bH8dQT8@kroah.com>
References: <20220926100750.519221159@linuxfoundation.org>
 <CA+G9fYsaviCxmAqWzOxgkU7HcmzU=e0LKci2_+5uPUOc+8xb3A@mail.gmail.com>
 <8635ce8b60.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8635ce8b60.wl-maz@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 10:25:59AM -0400, Marc Zyngier wrote:
> On Mon, 26 Sep 2022 10:13:31 -0400,
> Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > 
> > On Mon, 26 Sept 2022 at 16:00, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.4.215 release.
> > > There are 120 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Following build warnings / errors noticed on arm on stable-rc 5.4.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Regressions found on arm:
> > 
> >    - build-gcc-8-ixp4xx_defconfig
> >    - build-gcc-11-ixp4xx_defconfig
> >    - build-gcc-12-ixp4xx_defconfig
> >    - build-gcc-9-ixp4xx_defconfig
> >    - build-gcc-10-ixp4xx_defconfig
> 
> Colour me surprised. [1] explained why this was a bad idea...
> 
> 	M.
> 
> [1] https://lore.kernel.org/all/CAMRc=Md9JKdW8wmbun_0_1y2RQbck7q=vzOkdw6n+FBgpf0h8w@mail.gmail.com/

Should now be fixed, sorry.

greg k-h
