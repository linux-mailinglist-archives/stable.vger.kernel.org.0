Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240A85535A7
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352608AbiFUPOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352963AbiFUPN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 11:13:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FC62C675;
        Tue, 21 Jun 2022 08:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5923ACE1AD9;
        Tue, 21 Jun 2022 15:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF077C3411C;
        Tue, 21 Jun 2022 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655824365;
        bh=N33miZAbj1eyWWxBmejWAKLKM/v6H0vsxvVkz0oDr90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w6nBDsLTQo0L9K20Lm6+yJi/09kP6uhk/T9noNNCe/HlHzKyBovLVjyOCVOxlAe0x
         vsjL0YS3rLHF2kmeM7Xp8pagK13r/qNvIG3UaqM+NCSzXMM4pUdAQL+5hKfLPqvy+2
         lWCsL4cMyjr/GBchGs8kgszG5BMzhwV2O11eExyY=
Date:   Tue, 21 Jun 2022 17:12:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Message-ID: <YrHf6j/9ZvBWaNRd@kroah.com>
References: <20220620124724.380838401@linuxfoundation.org>
 <CA+G9fYsvY-0ub_CXbb5is0vRLQ9+SaPS8Op=9mZzCkeccUN+mg@mail.gmail.com>
 <YrGHheX8D0iIz+db@kroah.com>
 <YrGTT/MLbCuHanhB@zx2c4.com>
 <YrGe64z7Al+V3bvB@kroah.com>
 <CA+G9fYs7+kA6pzCZZNBxrwx-2-OFZfV+5Zk4B8a=uE=VUFykFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs7+kA6pzCZZNBxrwx-2-OFZfV+5Zk4B8a=uE=VUFykFg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 05:06:08PM +0530, Naresh Kamboju wrote:
> On Tue, 21 Jun 2022 at 16:05, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 21, 2022 at 11:45:51AM +0200, Jason A. Donenfeld wrote:
> > > On Tue, Jun 21, 2022 at 10:55:33AM +0200, Greg Kroah-Hartman wrote:
> > > > On Tue, Jun 21, 2022 at 02:06:06PM +0530, Naresh Kamboju wrote:
> > > > > On Mon, 20 Jun 2022 at 18:36, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > This is the start of the stable review cycle for the 5.15.49 release.
> > > > > > There are 106 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > > The whole patch series can be found in one patch at:
> > > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > > > and the diffstat can be found below.
> > > > > >
> > > > > > thanks,
> > > > > >
> > > > > > greg k-h
> > > > >
> > > > > Following commit causing regression while building allmodconfig for clang-13
> > > > > on arm64, riscv and x86_64.
> > > > >
> > > > > > Linus Torvalds <torvalds@linux-foundation.org>
> > > > > >     netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
> > > > >
> > > > > fs/afs/inode.c:29:32: error: unknown warning group
> > > > > '-Wattribute-warning', ignored [-Werror,-Wunknown-warning-option]
> > > > > #pragma GCC diagnostic ignored "-Wattribute-warning"
> > > > >                                ^
> > > > > 1 error generated.
> > > > >
> > > > > Regressions:
> > > > >   - arm64/build/clang-13-allmodconfig - Failed
> > > > >   - riscv/build/clang-13-allmodconfig - Failed
> > > > >   - x86_64/build/clang-13-allmodconfig - Failed
> > > >
> > > > Does Linus's tree also show this issue?
> > >
> > > Linus' tree got rid of the pragma with:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=874c8ca1e60b2c564a48f7e7acc40d328d5c8733
> >
> > That isn't going to work on 5.15.y at all without a lot of hand tweaking :(
> >
> > > and then a subsequent cleanup:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=e81fb4198e27925b151aad1450e0fd607d6733f
> >
> > That doesn't work on 5.18 either.
> >
> > I guess I'll go revert the 5.15 patch here for now and let others sort
> > it all out when they want to build 5.15 with gcc-12.
> 
> Whereas clang-14 builds pass. I am considering this as a waiver.
> The problem is with clang-13. you may keep the above patch which is
> adding support for gcc-12.
> 
> We will stop building with clang-13 and we will upgrade our toolchains to
> clang-15 (when released and current clang-nightly builds are in production)
> and gcc-12 builds are running in staging. We would like to bump versions soon.

No, for now I've dropped this.  If people want to run gcc-12 builds then
I need backported patches for them.

thanks,

greg k-h
