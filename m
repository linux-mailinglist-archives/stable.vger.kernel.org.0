Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D68563EB02
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 09:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLAI0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 03:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLAI0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 03:26:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B8C64543;
        Thu,  1 Dec 2022 00:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F1461ECE;
        Thu,  1 Dec 2022 08:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921A6C433D6;
        Thu,  1 Dec 2022 08:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669883202;
        bh=bYN7sFnrzXsqdokyyNjsM57Xzrjedk4SiEcICca4yv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBziYPIcz32Zipj7BRwvOAXfBQOI7SAumemnTscF+KrvwpcQ6o6LPYwqi465aB2cN
         zwgN9DbsD4LMtEgamCL8UVshzL4U0OJeXGgJ5ieVLBX74ESoA+n1jJjJUL6WEDodKw
         g7R9/qpkKEb7oSxwnYCIWEc0NAyKKq+GpVd5Fd7M=
Date:   Thu, 1 Dec 2022 08:56:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4heSvsjubdeCT1P@kroah.com>
References: <20221130180544.105550592@linuxfoundation.org>
 <CA+G9fYuJVxhKbeN9OGCr2_zyfa1k3j4DS1gAoTW0P89Eyz2FHg@mail.gmail.com>
 <Y4hQVCBYfwU0abvO@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4hQVCBYfwU0abvO@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 11:57:24PM -0700, Nathan Chancellor wrote:
> On Thu, Dec 01, 2022 at 11:44:53AM +0530, Naresh Kamboju wrote:
> > On Thu, 1 Dec 2022 at 00:13, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.0.11 release.
> > > There are 289 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Results from Linaro's test farm.
> > Regressions found on x86_64:
> > 
> >     - build-clang-15-allmodconfig-x86_64
> >     - build-clang-nightly-allmodconfig-x86_64
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> >     bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
> >     [ Upstream commit c86df29d11dfba27c0a1f5039cd6fe387fbf4239 ]
> > 
> > Causing the following build warnings / errors with clang-15 allmodconfig
> > on x86_64,
> > 
> > Build error:
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> > ARCH=x86_64 SRCARCH=x86 CROSS_COMPILE=x86_64-linux-gnu-
> > 'HOSTCC=sccache clang' 'CC=sccache clang'
> > kernel/bpf/dispatcher.c:126:33: error: pointer type mismatch ('void *'
> > and 'unsigned int (*)(const void *, const struct bpf_insn *,
> > bpf_func_t)' (aka 'unsigned int (*)(const void *, const struct
> > bpf_insn *, unsigned int (*)(const void *, const struct bpf_insn
> > *))')) [-Werror,-Wpointer-type-mismatch]
> >         __BPF_DISPATCHER_UPDATE(d, new ?: &bpf_dispatcher_nop_func);
> >                                    ~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~
> > include/linux/bpf.h:938:54: note: expanded from macro '__BPF_DISPATCHER_UPDATE'
> >         __static_call_update((_d)->sc_key, (_d)->sc_tramp, (_new))
> >                                                             ^~~~
> > 1 error generated.
> 
> Thanks for the report! This is fixed with upstream commit a679120edfcf
> ("bpf: Add explicit cast to 'void *' for __BPF_DISPATCHER_UPDATE()"),
> which was marked as a fix for c86df29d11df.

Now queued up.  I forgot to run my "do we need fixes for the fixes"
script on the queues, sorry about that.

greg k-h
