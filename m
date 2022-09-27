Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25515EC329
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 14:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiI0Mor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 08:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiI0Moq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 08:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961046566B;
        Tue, 27 Sep 2022 05:44:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAE226192C;
        Tue, 27 Sep 2022 12:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1963C433C1;
        Tue, 27 Sep 2022 12:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664282681;
        bh=iFJNB9IF7c9JwRLPUmOtdA7wNApz0bNIanQuvIX4Ugo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZjyAIOaDMI0e0n2iyDYlUrw3znzYgCifpWR9ifv9SI7nuNOMLkZYvdZJBGbNFefj
         A1eMeNZ6k15w/PY95MuTtExep1RGH74ymg00F7Nihhzg2qHzUKsXbLbXEWtsLlGn2q
         hOWyekgrjz3+Y83O+TGX9NDa5LKzZurURVsTRba8=
Date:   Tue, 27 Sep 2022 14:44:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
Message-ID: <YzLwNqCLQClDpyKA@kroah.com>
References: <20220926163546.791705298@linuxfoundation.org>
 <CA+G9fYu6DQvRuD8b1C93qWjfJJrVGUatvatX0ij9nzZhkcf7uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu6DQvRuD8b1C93qWjfJJrVGUatvatX0ij9nzZhkcf7uQ@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 03:18:14PM +0530, Naresh Kamboju wrote:
> On Mon, 26 Sept 2022 at 22:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.215 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
> NOTE:
> Following powerpc mpc83xx defconfig with new gcc-12 build warnings.
> 
> kernel/extable.c: In function 'sort_main_extable':
> kernel/extable.c:37:59: warning: comparison between two arrays [-Warray-compare]
>    37 |         if (main_extable_sort_needed && __stop___ex_table >
> __start___ex_table) {
>       |                                                           ^
> kernel/extable.c:37:59: note: use '&__stop___ex_table[0] >
> &__start___ex_table[0]' to compare the addresses
> arch/powerpc/boot/main.c: In function 'prep_initrd':
> arch/powerpc/boot/main.c:107:25: warning: comparison between two
> arrays [-Warray-compare]
>   107 |         if (_initrd_end > _initrd_start) {
>       |                         ^

Is this a new warning?

I don't think anyone is attempting to build 5.4 with gcc12 just yet...

thanks,

greg k-h
