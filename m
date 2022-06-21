Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283DD552F10
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiFUJqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349456AbiFUJqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:46:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6248E27CCD;
        Tue, 21 Jun 2022 02:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3CE161628;
        Tue, 21 Jun 2022 09:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCCFC3411C;
        Tue, 21 Jun 2022 09:45:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OrO52xo7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655804755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aqCiLi/zLc1fIDxZ5du7gZ2tEOLG2K2TWdFZtkoR7TA=;
        b=OrO52xo7iUvQewYm/6UZ/mAKtIa3L9VbN3pt7P2XR7NEuSukSHpOcgzggCw1PklVQHcGA5
        kZNWhlbUKNuoiRJPtXY3W3Z7r680jol85xcPV4bQmMBJHAZWDR9ti2O7cPs3lXwu5Vv6By
        JCmv5lYOwVe1vxyfinXfxMLy3FDQL3g=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b628248c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 21 Jun 2022 09:45:55 +0000 (UTC)
Date:   Tue, 21 Jun 2022 11:45:51 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Message-ID: <YrGTT/MLbCuHanhB@zx2c4.com>
References: <20220620124724.380838401@linuxfoundation.org>
 <CA+G9fYsvY-0ub_CXbb5is0vRLQ9+SaPS8Op=9mZzCkeccUN+mg@mail.gmail.com>
 <YrGHheX8D0iIz+db@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrGHheX8D0iIz+db@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 10:55:33AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 21, 2022 at 02:06:06PM +0530, Naresh Kamboju wrote:
> > On Mon, 20 Jun 2022 at 18:36, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.49 release.
> > > There are 106 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Following commit causing regression while building allmodconfig for clang-13
> > on arm64, riscv and x86_64.
> > 
> > > Linus Torvalds <torvalds@linux-foundation.org>
> > >     netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
> > 
> > fs/afs/inode.c:29:32: error: unknown warning group
> > '-Wattribute-warning', ignored [-Werror,-Wunknown-warning-option]
> > #pragma GCC diagnostic ignored "-Wattribute-warning"
> >                                ^
> > 1 error generated.
> > 
> > Regressions:
> >   - arm64/build/clang-13-allmodconfig - Failed
> >   - riscv/build/clang-13-allmodconfig - Failed
> >   - x86_64/build/clang-13-allmodconfig - Failed
> 
> Does Linus's tree also show this issue?

Linus' tree got rid of the pragma with:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=874c8ca1e60b2c564a48f7e7acc40d328d5c8733
and then a subsequent cleanup:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/afs/inode.c?id=e81fb4198e27925b151aad1450e0fd607d6733f


> 
> thanks,
> 
> greg k-h
