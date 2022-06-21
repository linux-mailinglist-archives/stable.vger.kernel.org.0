Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6470B552FCF
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiFUKf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFUKf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:35:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E928992;
        Tue, 21 Jun 2022 03:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0724616AE;
        Tue, 21 Jun 2022 10:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E4AC3411C;
        Tue, 21 Jun 2022 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655807727;
        bh=jT5AulgH64dsnmHs3aAyEDc7vv1kewlaFAqQ7BeBlqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ii6wg2yxwXexbcmBmDjKrultdv9eK3ub2CwcWP+Wgm9B8+6MitNMk7eyVxvTBn0UY
         gQRqVK1OHaw9blnvXaBzSlMMejhqTT0BtKAHsF0Co6e+IIFG9oPMlhGgjQSbhlFD27
         uqB013dHtjzWtfuat4+aTlrx5BI51mt0QCEFn7Ck=
Date:   Tue, 21 Jun 2022 12:35:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Message-ID: <YrGe64z7Al+V3bvB@kroah.com>
References: <20220620124724.380838401@linuxfoundation.org>
 <CA+G9fYsvY-0ub_CXbb5is0vRLQ9+SaPS8Op=9mZzCkeccUN+mg@mail.gmail.com>
 <YrGHheX8D0iIz+db@kroah.com>
 <YrGTT/MLbCuHanhB@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGTT/MLbCuHanhB@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 11:45:51AM +0200, Jason A. Donenfeld wrote:
> On Tue, Jun 21, 2022 at 10:55:33AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jun 21, 2022 at 02:06:06PM +0530, Naresh Kamboju wrote:
> > > On Mon, 20 Jun 2022 at 18:36, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.15.49 release.
> > > > There are 106 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > Following commit causing regression while building allmodconfig for clang-13
> > > on arm64, riscv and x86_64.
> > > 
> > > > Linus Torvalds <torvalds@linux-foundation.org>
> > > >     netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
> > > 
> > > fs/afs/inode.c:29:32: error: unknown warning group
> > > '-Wattribute-warning', ignored [-Werror,-Wunknown-warning-option]
> > > #pragma GCC diagnostic ignored "-Wattribute-warning"
> > >                                ^
> > > 1 error generated.
> > > 
> > > Regressions:
> > >   - arm64/build/clang-13-allmodconfig - Failed
> > >   - riscv/build/clang-13-allmodconfig - Failed
> > >   - x86_64/build/clang-13-allmodconfig - Failed
> > 
> > Does Linus's tree also show this issue?
> 
> Linus' tree got rid of the pragma with:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=874c8ca1e60b2c564a48f7e7acc40d328d5c8733

That isn't going to work on 5.15.y at all without a lot of hand tweaking :(

> and then a subsequent cleanup:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=e81fb4198e27925b151aad1450e0fd607d6733f

That doesn't work on 5.18 either.

I guess I'll go revert the 5.15 patch here for now and let others sort
it all out when they want to build 5.15 with gcc-12.

thanks,

greg k-h
