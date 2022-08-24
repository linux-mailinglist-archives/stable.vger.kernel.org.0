Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A4D5A029B
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 22:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbiHXUT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 16:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiHXUT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 16:19:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909BD3E74A;
        Wed, 24 Aug 2022 13:19:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35491617FF;
        Wed, 24 Aug 2022 20:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6530C433C1;
        Wed, 24 Aug 2022 20:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661372366;
        bh=ccfR9j7H5+zwytd5yJssldgbE67m5JiYpCDczl7Vyd0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nbE9LA9Kklk3QcaZY3gKIg//jDIRDyS7nx3MLg6fkpOpRPzQa1rlZXPxHnP+Prmb+
         zEx4KniX38txlsePASkExz7HArpgttcf251MhgokOXhOTVaUXDWBktUkZp2S/RbY2t
         zss3cIR+PoMGZG52KhiUzN4OijeMfnCDNNR8J2oZ0EZ8wpaB+upajMxSrpRcMPtYSt
         nj4HND4iNYutJsynl03ETAVJV7gPEpgM8YG3eieQwpIgf6zY3mbZHABrqvfwfOXZcQ
         7POzXUZDCYNiGPhRWmF2CaJ6tbZBkG00j1GVoYGee9E6wsuO1nRKR753xdXxujVCGJ
         mpjC0HrAw36Kg==
Date:   Wed, 24 Aug 2022 13:19:23 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
Message-ID: <YwaHy9An68xJkxdu@dev-arch.thelio-3990X>
References: <20220824065936.861377531@linuxfoundation.org>
 <CA+G9fYuTOvKfHz7t0GppiNqLx-9n-yycsLX-rdMQogrh9guX_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuTOvKfHz7t0GppiNqLx-9n-yycsLX-rdMQogrh9guX_w@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh,

On Thu, Aug 25, 2022 at 01:43:09AM +0530, Naresh Kamboju wrote:
> On Wed, 24 Aug 2022 at 12:31, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.19.4 release.
> > There are 362 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.4-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
> x86_64 and arm64 clang nightly allmodconfig build failed.
> sound/soc/atmel/mchp-spdiftx.c:508:20: error: implicit truncation from
> 'int' to bit-field changes value from 1 to -1
> [-Werror,-Wbitfield-constant-conversion]
> dev->gclk_enabled = 1;
>                   ^ ~
> 1 error generated.

This should be fixed in mainline soon:

https://git.kernel.org/broonie/sound/c/5c5c2baad2b55cc0a4b190266889959642298f79
https://github.com/ClangBuiltLinux/linux/issues/1686

It will conflict due to a lack of commit 403fcb5118a0 ("ASoC:
mchp-spdiftx: remove references to mchp_i2s_caps") in the stable trees
but I think that change can just be taken along with my change to
minimize any future conflicts. I'll send a separate email with that
information when my patch hits mainline.

Thanks as always for all the testing that you do!

Cheers,
Nathan
