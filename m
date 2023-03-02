Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81556A8094
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCBLAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCBLAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:00:45 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74C02698
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 03:00:43 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id f13so22012005vsg.6
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 03:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hGGp1huIjHilYwe/4uFA3bcAQwtP2TUgiQM8pX+fYZw=;
        b=Q64QGr9JH9sYwJ9ce1tlziuiFrZ/Nzp0JLqjHqgm6t2MLd87/LkywFrNH0AYEohreu
         rLBa+zFtxk84ArOjPf20jJPwBCGXv/qtvW2sMF51Wadg9qaXXHqDtjIm7K9wjMZgKz0K
         6c0iztihMu8WzURM5xnJoXZQFy2x6pqz4xFMtLWmz4KYR1GCXm++JyPPc9BFaV78WX2P
         bkWjIsOsNAGXVFUdB7X/Os1s5mkc6rJ3udAYCKkVURfWRV5HgKzfbBeyF1XMyDvAF410
         ze3zxf3jbx76q6pv2mBZAw1BSlmisirvZvcH3YCuMc6M08yqZ1QyWM36VChncMsfuwN2
         gWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hGGp1huIjHilYwe/4uFA3bcAQwtP2TUgiQM8pX+fYZw=;
        b=l12pdqX45xY1BsAtBJ3D6sDA5U7pT3G1dERQz/EM35Hf2kx29tbGgIUgEsdZN74jZd
         Yrcrg94Ws/KTMek6GvkInJjGX2b9KuiwUiQEo3+vD8lj8z6hkFBjBImTiLeBQpuErU9D
         7NoEZMy0wZLgaFdpw+NFMggufhcYOt2kc5h4ekoXI+ZvS7vujBReBpdIY+lIitojh3tb
         D4jt1tyLI9etc4dv+byk2QRVtJe8K4eaRISbv1b+R43ahH9G3/cjmAZBkUQGMAEdBoXv
         D3ju6HybwlPj3JzWLtx8fr5AEQOXCazrfX3xq46ihZvPyPVa0kkWsjae+grTEEJW2zcr
         uQGQ==
X-Gm-Message-State: AO0yUKVaYExDzvx+r1TI/9QnlmifqVBZwJW5qCznTHSMrEb5wsM1YIg8
        YQoS6WZm0E7ljCdurgH2rsPmMo++moV1EnlECnYHBQ==
X-Google-Smtp-Source: AK7set9L4dn9ZH/fYt1gJPc8bF15yhL8MO8BN26LYR0+8tTZexWQiXaoqoG0VEoV3Nl54+itzkAqhy3UVsIMlNTO7G4=
X-Received: by 2002:a05:6102:186:b0:412:d18:c718 with SMTP id
 r6-20020a056102018600b004120d18c718mr6416498vsq.3.1677754842411; Thu, 02 Mar
 2023 03:00:42 -0800 (PST)
MIME-Version: 1.0
References: <20230301180657.003689969@linuxfoundation.org> <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com>
In-Reply-To: <ZAB6pP3MNy152f+7@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Mar 2023 16:30:31 +0530
Message-ID: <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> > On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.15 release.
> > > There are 42 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ## Build
> > * kernel: 6.1.15-rc1
> > * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> > * git branch: linux-6.1.y
> > * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> > * git describe: v6.1.14-43-gb6150251d4dd
> > * test details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd
> >
> > Regression test cases,
> > i386:
> > x15:
> >   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> >
> > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> >
> > test log:
> > ----------
> >
> > # selftests: net/mptcp: mptcp_sockopt.sh

....

> Nit, wrapping a log like this makes it hard to read, don't you think?

Me either.
That is the reason I have shared "Assertion" above.

>
> > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > # server killed by signal 6
> > #
> > # FAIL: SOL_MPTCP getsockopt
> > # PASS: TCP_INQ cmsg/ioctl -t tcp
> > # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> > # PASS: TCP_INQ cmsg/ioctl -r tcp
> > # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> > # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> > not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1
>
> Any chance you can bisect?

We are running our bisection scripts.

>
> And is this an issue on 6.2 and/or Linus's tree?

Not seen on Linux mainline, next and 6.2.

> I don't see any mptcp
> changes in this 6.1-rc cycle, they were in the last one...
>
> thanks,
>
> greg k-h
