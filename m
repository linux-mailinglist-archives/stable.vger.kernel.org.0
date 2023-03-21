Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0976C3896
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 18:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjCURtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 13:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCURte (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 13:49:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC7C26BE;
        Tue, 21 Mar 2023 10:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C291161CF8;
        Tue, 21 Mar 2023 17:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B7FC433EF;
        Tue, 21 Mar 2023 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679420972;
        bh=u7PjId7iazAyhBt4jDN0Jch13r3LdRa8fHt+fYQFnhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oE8u5aDD7DeHDOh8mWLVnjfqMr0MjU6HLCNeuvKgMy3bc19prla+DxE0Ek0ZwqmQg
         2NGgsbICqXXyzU54k25jL362wVIOo92YUtdykN/a8Trv/5vseKFbUSGtkB/3MES4if
         FPul7Q3cbnqBjX8JnU5inOtJbAHJpbdtdmTFlnDY=
Date:   Tue, 21 Mar 2023 18:49:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        llvm@lists.linux.dev,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
Message-ID: <ZBnuKVIfOCK42k7C@kroah.com>
References: <20230321080705.245176209@linuxfoundation.org>
 <CA+G9fYsD6PVkfrpS+k6TBye5r1JzWVOzRwAsndSYzVwgB+dTxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsD6PVkfrpS+k6TBye5r1JzWVOzRwAsndSYzVwgB+dTxg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 09:33:59PM +0530, Naresh Kamboju wrote:
> On Tue, 21 Mar 2023 at 14:09, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.21 release.
> > There are 198 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Same powerpc clang build problem on 6.1.21-rc2 as reported on 6.2.8-rc2.
> 
> Following patch needed,
> 
> Upstream commit: 77e82fa1f9781a958a6ea4aed7aec41239a5a22f
>      powerpc/64: Replace -mcpu=e500mc64 by -mcpu=e5500

Thanks, now queued up.
greg k-h
