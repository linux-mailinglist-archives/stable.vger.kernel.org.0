Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BED6A915F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 08:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjCCHBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 02:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCCHBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 02:01:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183FF2A6CE;
        Thu,  2 Mar 2023 23:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BC0B816BF;
        Fri,  3 Mar 2023 07:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FE9C433EF;
        Fri,  3 Mar 2023 07:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677826901;
        bh=7IsefbC3B8P/XH5T1+Xm5KfGsPeW+kju1yl0z8Zv4mU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w/QVsLNK+hqeBcAHRumCUiwDRGANnHt3/yshhAQ4/KkIAMTriF1BMufrcxAR6hBn/
         vhVV5hMm/oJ0U9unEAxKiS1gv5CxUo/SNCW89Vmy4PvwlIndzO1v2dY1oaR+K95J9l
         umYTLLkMHMaOJiRTheCh7UoGPnbP2RzRL16kDTa0=
Date:   Fri, 3 Mar 2023 08:01:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZAGbUsae7DHoI5k4@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org>
 <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com>
 <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
 <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 01:32:47AM +0530, Naresh Kamboju wrote:
> On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> > > > On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 6.1.15 release.
> > > > > There are 42 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > > Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.
> > > >
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >
> > > > ## Build
> > > > * kernel: 6.1.15-rc1
> > > > * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> > > > * git branch: linux-6.1.y
> > > > * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> > > > * git describe: v6.1.14-43-gb6150251d4dd
> > > > * test details:
> > > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd
> > > >
> > > > Regression test cases,
> > > > i386:
> > > > x15:
> > > >   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> > > >
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > >
> > > > test log:
> > > > ----------
> > > >
> > > > # selftests: net/mptcp: mptcp_sockopt.sh
> >
> > ....
> >
> > > Nit, wrapping a log like this makes it hard to read, don't you think?
> >
> > Me either.
> > That is the reason I have shared "Assertion" above.
> >
> > >
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > > # server killed by signal 6
> > > > #
> > > > # FAIL: SOL_MPTCP getsockopt
> > > > # PASS: TCP_INQ cmsg/ioctl -t tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -r tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> > > > not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1
> > >
> > > Any chance you can bisect?
> >
> > We are running our bisection scripts.
> 
> We have tested with 6.1.14 kselftests source again and it passes.
> Now that we have upgraded to 6.2.1 kselftests source, we find that
> there is this problem reported. so, not a kernel regression.

Where is this problem reported?  Is this a 6.2 test checking for
something that is not in 6.1?

thanks,

greg k-h
