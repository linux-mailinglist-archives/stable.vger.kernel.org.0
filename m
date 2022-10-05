Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E849F5F5A9D
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiJETaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 15:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiJETaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 15:30:01 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9907E165A6;
        Wed,  5 Oct 2022 12:29:55 -0700 (PDT)
Received: from quatroqueijos.cascardo.eti.br (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 668A83F092;
        Wed,  5 Oct 2022 19:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664998189;
        bh=V8v8Hd5g+UPe3KQqKbmHroAK7N5dt5vEwospoXaQV68=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=cOSSas9aTJgRHNw+FGaqQGpktiiQqk/Ingypp/PIvA7HtKQzSsePtnbdTnQ0+vnk+
         55n9Zy6Ak6yL4r2GHCFPL8fpEZJeKzEbynd7qFJMnyc+XQqVRGqjjOnGC7QGsXaqQH
         Nw6swSg2ISMbODUlXoPY0gJnppC6rLeUZGOvA70EIkOJg5W1g9wx3h9Jg2JbUoDhbW
         qjalONtlmtiQeJGIrxNYc75y+SHqfjuFZcZ2yKfF3+6YWxusIHE6a6w9E62vIpntfJ
         jzow3wDuqFyQwYtw1Opn06hMVFlwxcHedHqdgIESejmDOqqQDmLgrZlIN5L7nJFZda
         VqS3cv8LzdGjg==
Date:   Wed, 5 Oct 2022 16:29:38 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/51] 5.4.217-rc1 review
Message-ID: <Yz3bIr7eSpSoU7T8@quatroqueijos.cascardo.eti.br>
References: <20221005113210.255710920@linuxfoundation.org>
 <68134b95-ea83-cb02-0ded-fd147b117820@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68134b95-ea83-cb02-0ded-fd147b117820@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 02:12:46PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 05/10/22 06:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.217 release.
> > There are 51 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We are seeing a new warning on x86_64:
> 
>   /builds/linux/arch/x86/entry/entry_64.S: Assembler messages:
>   /builds/linux/arch/x86/entry/entry_64.S:1756: Warning: no instruction mnemonic suffix given and no register operands; using default for `sysret'
>   arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x151: unsupported intra-function call
>   x86_64-linux-gnu-ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
>   x86_64-linux-gnu-ld: warning: creating DT_TEXTREL in a PIE

You mean only the third line here with objtool complaining about unsupported
intra-function call, right? The other warnings were likely there before.

> 
> This started happening after 984b78c4ecea49b0b4b5729a502b689a623fde27 ("x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n").

This is, in fact, introduced by the previous commit, 65e5a1959296e16a3566ff75e527f211f0bf5a26 ("x86/speculation: Change FILL_RETURN_BUFFER to work with objtool").

You see it once 984b78c4ecea is applied because your configs do not have
CONFIG_RETPOLINE.

Notice that I note in 65e5a1959296 that intra-function validation is
missing in objtool in 5.4, which is why you are seeing this warning.

Cascardo.

> 
> The following configurations are affected:
> 
> * x86_64, build
>   - gcc-8-allnoconfig-warnings
>   - gcc-8-tinyconfig-warnings
>   - gcc-8-x86_64_defconfig-warnings
>   - gcc-9-allnoconfig-warnings
>   - gcc-9-tinyconfig-warnings
>   - gcc-9-x86_64_defconfig-warnings
>   - gcc-10-allnoconfig-warnings
>   - gcc-10-defconfig-warnings
>   - gcc-10-tinyconfig-warnings
>   - gcc-11-allnoconfig-warnings
>   - gcc-11-defconfig-warnings
>   - gcc-11-lkftconfig-debug-kmemleak-warnings
>   - gcc-11-lkftconfig-debug-warnings
>   - gcc-11-lkftconfig-kasan-warnings
>   - gcc-11-lkftconfig-kselftest-kernel-warnings
>   - gcc-11-lkftconfig-kselftest-warnings
>   - gcc-11-lkftconfig-kunit-warnings
>   - gcc-11-lkftconfig-libgpiod-warnings
>   - gcc-11-lkftconfig-perf-warnings
>   - gcc-11-lkftconfig-rcutorture-warnings
>   - gcc-11-lkftconfig-warnings
>   - gcc-11-tinyconfig-warnings
>   - gcc-12-allnoconfig-warnings
>   - gcc-12-defconfig-warnings
>   - gcc-12-tinyconfig-warnings
>   - clang-11-allnoconfig-warnings
>   - clang-11-tinyconfig-warnings
>   - clang-11-x86_64_defconfig-warnings
>   - clang-12-allnoconfig-warnings
>   - clang-12-lkftconfig-warnings
>   - clang-12-tinyconfig-warnings
>   - clang-12-x86_64_defconfig-warnings
>   - clang-13-allnoconfig-warnings
>   - clang-13-lkftconfig-warnings
>   - clang-13-tinyconfig-warnings
>   - clang-13-x86_64_defconfig-warnings
>   - clang-14-allnoconfig-warnings
>   - clang-14-lkftconfig-kcsan-warnings
>   - clang-14-lkftconfig-warnings
>   - clang-14-tinyconfig-warnings
>   - clang-14-x86_64_defconfig-warnings
>   - clang-nightly-lkftconfig-warnings
>   - clang-nightly-tinyconfig-warnings
>   - clang-nightly-x86_64_defconfig-warnings
> 
> 
> Greetings!
> 
> Daniel Díaz
> daniel.diaz@linaro.org
