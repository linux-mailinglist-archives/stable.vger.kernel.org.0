Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF896A89FA
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 21:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCBUDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 15:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCBUDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 15:03:22 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788CE12078
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 12:03:00 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id d20so380285vsf.11
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 12:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ytPEWIqhwaCarWJc5HTAE9DnXoPRR9+OJ57LsDquhy8=;
        b=Yce9ojHEdVsInJzWr3wZCZrAHq+GwsLhfKhWAgWBe9rPqACHGlIwU00inP24k0sv3k
         i0zj1pF+ZP8maq7o/Fv0gl/+7HDrfStCJA3LF9lVWmUSE+7ChVY7LR+3D+RNTeXJIfhv
         DtpRIS9tJudFQcjjPgY7inCX0F4+dyABmSL62SGNhO5KoF7QlF97/qByL3/UAHGrU6uN
         q20kW3Xfc6SNIzI1ngDOrj2EfALoh7rsdaJmq610WALbpxEYS9XJBDvPW+iUPHzF1Ut0
         1VxfvPP2dhQVsm/BtXBTDXkLIh+52xnjrew33YdWNttOHO67qyA0VUr+7Hl+6UuzdUka
         CKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytPEWIqhwaCarWJc5HTAE9DnXoPRR9+OJ57LsDquhy8=;
        b=ZQJ8piXbsFy0VBvPhoeT7Qqf6WPOcT8EzWXzx0UP/g8EtyhztMbnjG5tuHbPcKBeM6
         3s3lWZAISAPROYu1/oou+RRb06yST1oWVJ+dZ5AKyyFL9yFWA1kwJ2bYa4xkFPMkI78Z
         QEobv7YNotjNvSud2rZTN705d9zZE6ZMogalS4alUl4miSdg8EtKN4P8amhCw7AJgS/U
         wsQWrr1qjaYqq61kqQc8RJo/RrHDfPjuC5rV1AdK3dkkxm7td9q2J9K+8aoFRX8QweEG
         P0L7lT9l8GxH3vbF+M4jDT4XnYfmC7OCHEjvGsJBUebsLhBYx0E9HYGUzzyq4vm39j36
         qKzg==
X-Gm-Message-State: AO0yUKVmrb98BdA5MfqEjs5nHOG22stH+Dmep3uFJU+vRlei60Zk++bR
        jzCzMuD/VKSYWz6dUd4mjzS6NsZ5fwjt/0wicdTC1Q==
X-Google-Smtp-Source: AK7set+eVyokK1v5FAUJHHwSpcbcC+NkbL9iwTxddN0InqDlQuz/M6pEyf0rzQmaP/Vf/VhSyBB3gxvQhFmom/1DaHo=
X-Received: by 2002:a67:a641:0:b0:411:c62b:6bf0 with SMTP id
 r1-20020a67a641000000b00411c62b6bf0mr7584347vsh.3.1677787378333; Thu, 02 Mar
 2023 12:02:58 -0800 (PST)
MIME-Version: 1.0
References: <20230301180657.003689969@linuxfoundation.org> <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com> <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
In-Reply-To: <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 Mar 2023 01:32:47 +0530
Message-ID: <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> > > On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.1.15 release.
> > > > There are 42 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > ## Build
> > > * kernel: 6.1.15-rc1
> > > * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> > > * git branch: linux-6.1.y
> > > * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> > > * git describe: v6.1.14-43-gb6150251d4dd
> > > * test details:
> > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd
> > >
> > > Regression test cases,
> > > i386:
> > > x15:
> > >   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> > >
> > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > >
> > > test log:
> > > ----------
> > >
> > > # selftests: net/mptcp: mptcp_sockopt.sh
>
> ....
>
> > Nit, wrapping a log like this makes it hard to read, don't you think?
>
> Me either.
> That is the reason I have shared "Assertion" above.
>
> >
> > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > # server killed by signal 6
> > > #
> > > # FAIL: SOL_MPTCP getsockopt
> > > # PASS: TCP_INQ cmsg/ioctl -t tcp
> > > # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> > > # PASS: TCP_INQ cmsg/ioctl -r tcp
> > > # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> > > # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> > > not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1
> >
> > Any chance you can bisect?
>
> We are running our bisection scripts.

We have tested with 6.1.14 kselftests source again and it passes.
Now that we have upgraded to 6.2.1 kselftests source, we find that
there is this problem reported. so, not a kernel regression.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: b6150251d4ddf8a80510c185d839631e252e6317
* git describe: v6.1.14-43-gb6150251d4dd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd


--
Linaro LKFT
https://lkft.linaro.org
