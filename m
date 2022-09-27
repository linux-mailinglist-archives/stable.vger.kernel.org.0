Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F285EC326
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 14:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiI0MoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 08:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiI0MoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 08:44:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE10160E61;
        Tue, 27 Sep 2022 05:44:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B928EB81A97;
        Tue, 27 Sep 2022 12:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF02C433C1;
        Tue, 27 Sep 2022 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664282649;
        bh=Tmjoqlzr2zwcf+4aNsRU775L0o26yCiBDztlcxxpSM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gz17JomT+cGvXzsP2TwzLsbgyw/H5gJ0o1EoPKragnAluRv6Zv2ab3fEt7zD8O8TB
         mevPvRL3B9lJb2b1jgU3TtDt2zlr0pgEWGSOFiUE4Qe+cHl8yw8co6tMM5ci21ezXW
         ic4zIfQ629t1uib/tUIFwNo2NDa6JAwbeUsuT5U8=
Date:   Tue, 27 Sep 2022 14:44:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/138] 5.10.146-rc2 review
Message-ID: <YzLwFupmxRmMOOlB@kroah.com>
References: <20220926163550.904900693@linuxfoundation.org>
 <CA+G9fYu=ydivmC6Hv77NyHEPkR+c_rsUbycMCKBhtvLEM_k+Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu=ydivmC6Hv77NyHEPkR+c_rsUbycMCKBhtvLEM_k+Nw@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 02:29:06PM +0530, Naresh Kamboju wrote:
> On Mon, 26 Sept 2022 at 22:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.146 release.
> > There are 138 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro's test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Following new build warning noticed on all the builds,
> net/core/dev_ioctl.c: In function 'dev_ifconf':
> net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-variable]
>    41 |  int i;
>       |      ^
> 
> Due to patch,
> net: socket: remove register_gifconf
> [ Upstream commit b0e99d03778b2418aec20db99d97d19d25d198b6 ]

Thanks, build warning now fixed up.

greg k-h
