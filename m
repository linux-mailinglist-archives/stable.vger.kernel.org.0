Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4546B1089
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 19:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCHSBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 13:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCHSBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 13:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6849DC5ACA;
        Wed,  8 Mar 2023 10:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D64CB8199F;
        Wed,  8 Mar 2023 18:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB152C433EF;
        Wed,  8 Mar 2023 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678298474;
        bh=36z7JsjW1FtWV0KV3rqWtnvlzfxSrcWjPrZxaEf2Esg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMNqwkd4HYKTXC0rpgC65JtFDlJ9BBwOpvpZ2nS0DQPo+x/h2i8LPENUUo82bhTBN
         wp+IH1u9W9OplSi0VqXJuJEWLsSHnAIwbNbODXlntN3Dbcf9Rb+pk8HRz8igZOFXx3
         oOLwAPZ9ak5bfRlRANEN7k/bwn8JiE0J92IrOz6EjFEEiG5WmbS3g8PVEwx6QDag56
         86TtTEmm1cc+l3ooX0omspbIzDpU3W8RfM+M064di4QYPkwB4coB939PduZVYBuHu2
         nt2FgLz+FPT7v5QHu74DztdMN7bjqCMasFPNScYBUGQWWLwhMTsk7+tUcY1PewyNyi
         xcA9nUMB6NXfA==
Received: by pali.im (Postfix)
        id 66BEA6AE; Wed,  8 Mar 2023 19:01:11 +0100 (CET)
Date:   Wed, 8 Mar 2023 19:01:11 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <20230308180111.cxa2fdyfwbqwzdgg@pali>
References: <20230307170022.094103862@linuxfoundation.org>
 <81cd2720-0414-1213-3826-31bd240d5c75@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81cd2720-0414-1213-3826-31bd240d5c75@linaro.org>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 07 March 2023 18:01:42 Daniel Díaz wrote:
> Hello!
> 
> On 07/03/23 10:46, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.2.3 release.
> > There are 1001 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We see a regression with PowerPC's ppc64e_defconfig, using GCC 8 and GCC 12:
> -----8<-----
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
> [...]
> make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
> make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:242: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
> ----->8-----
> 
> Bisection points to "powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage" (upstream ff7c76f66d8bad4e694c264c789249e1d3a8205d).

Hello! You hit another issue that CONFIG_TARGET_CPU_BOOL is set but
CONFIG_TARGET_CPU is not. This issue was fixed in upstream by commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=45f7091aac3546ef8112bf62836650ca0bbf0b79

See discussion about that issue:
https://lore.kernel.org/linuxppc-dev/20221208191602.diywrt3g2f6zmt4s@pali/

Can you check that above commit was also backported during your testing?
If not then apply it too and test again.

Commit ff7c76f66d8bad4e694c264c789249e1d3a8205d is needed to backport
because it is fixing compile error issue for e500v2 platforms when
compiling kernel with e500v2 cross compiler.

> Reproducer:
>   tuxmake \
>     --runtime podman \
>     --target-arch powerpc \
>     --toolchain gcc-8 \
>     --kconfig ppc64e_defconfig \
>     config debugkernel dtbs kernel modules xipkernel
> 
> Greetings!
> 
> Daniel Díaz
> daniel.diaz@linaro.org
> 
> 
