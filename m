Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7560573310
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 11:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiGMJmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 05:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiGMJmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 05:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F99F5D7D;
        Wed, 13 Jul 2022 02:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D787B61CD9;
        Wed, 13 Jul 2022 09:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CF5C341C6;
        Wed, 13 Jul 2022 09:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657705339;
        bh=ScMnWiiKn2psw/0D6HtXm9bWIIpUFJWCsTxQal5vPuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPp986dSPVjsJKSg4Rksb/rvPfwomFF0HZi+2b+1KpocHSnChOSwJB/wBwUAsCYm+
         FF/hbVNG8LHtJtVg5+Iz+9XVcHvwmj20S4/qIhqpdAh8GXiE5gZDRNN5boYz+dTQXG
         SE0pRKzqPGCAe+vjFs4/kG/IupGtHt++/1DpAhHs=
Date:   Wed, 13 Jul 2022 11:42:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5.10 000/130] 5.10.131-rc1 review
Message-ID: <Ys6TeKHEep1PO5Yk@kroah.com>
References: <20220712183246.394947160@linuxfoundation.org>
 <6acd1cd0-25aa-eb9c-4176-49f623f79301@gmail.com>
 <CA+G9fYsBFy65-Y1Yo_Zr_bJWGV6QYhMaEhyaShOG+qoOD7pu+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsBFy65-Y1Yo_Zr_bJWGV6QYhMaEhyaShOG+qoOD7pu+w@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 03:05:26PM +0530, Naresh Kamboju wrote:
> On Wed, 13 Jul 2022 at 04:45, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > On 7/12/22 11:37, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.131 release.
> > > There are 130 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.131-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> 
> 
> > perf fails to build with:
> 
> I have also noticed perf build failed.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> In file included from util/intel-pt-decoder/intel-pt-insn-decoder.c:15:
> util/intel-pt-decoder/../../../arch/x86/lib/insn.c:13:10: fatal error:
> asm/inat.h: No such file or directory
>    13 | #include <asm/inat.h> /* __ignore_sync_check__ */
>       |          ^~~~~~~~~~~~
> compilation terminated.
> 
> Build log:
> https://builds.tuxbuild.com/2BrKWlDZbrZwQIfxzeMf6fv37sn/

Should now be fixed in the tree, I'll push out a -rc2 so that your build
tools will pick it up.

thanks,

greg k-h
