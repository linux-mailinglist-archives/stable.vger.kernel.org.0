Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26FB6A9356
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCCJEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCCJEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:04:43 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F225FC5
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 01:04:19 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id d20so1736362vsf.11
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 01:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz00Tqp2vtUy2svpLhqgrc/9lCdlqQYI0Iiyegg93jE=;
        b=CPHtp3vSrP26nALKHfQarED/kNETYNYUQLVL0PuetjPrAthBn7Olz9gyYat9XJ/Jbc
         uAqr5Q7NLdlz/6jnOJVPClXlOXQbDviCx0F+kz/x33pq/CXVGVylQGw6fOSmZk0nfpzy
         m8ISNfilFU1VM2OH4H97LLa9J007eW0otluW1FX92zhrenCzENHK77Nfg72xLps4N/Gl
         VTMVO+DpRHFMw+/Q1DfPq2YNddgxV+xRsrv/BL6PH+tg+WYErXo6SNVNs3OWtMQ1eVpg
         iZUvflKKGakgtBkgo970lb6MLsxBbs/QGM408DHoY+zDfcWlF2iNiSWfcvQV6Cea5Hem
         STYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tz00Tqp2vtUy2svpLhqgrc/9lCdlqQYI0Iiyegg93jE=;
        b=V5gmFnu8DLaZ8P8nYEvsyebgGG5MeFA+Hvy/vJ3gdnOtuVEp0xxsSbtDeLayAxHPHh
         jwnvnKGe0riEMf0YXLLqRLEC9c1prBpQzlSYZpI6jfAjoe2yD1yZ7acgBreDwlH06hrR
         yXqvEkzRlDySPAZUZkuTjFS8x5roiDkdEbYuGlJGUwKw4NJVVV7Chg5tW4mtCm0EQFF+
         KUpnT1YiAwqDRQTvEDQPNo1ujfHDmapVEtc586LE4l2xZj9pXwCMF49VkhXXPxiSrWJ5
         0bTP8Jwzp27D22M0+p646zh27YnzOuExClx4/yyafqsLk91xYq/xudl9fNyDFNW9pCgD
         4OmA==
X-Gm-Message-State: AO0yUKXPNGUFK21HvmsUN9vROldAlzgUa5A/puXtP8bjdvSuqISwYsoc
        YynAbu64yUCWViOngPFMsoxa1ri3B77uI5BhRdzw8g==
X-Google-Smtp-Source: AK7set8xJnpf1kTF5ZChezlWGbocRssXwa0E/otBhr1eDuSz97X8AuHW4Z/rfCNxFvtBeZ3CbxcRQAot48c8dRuVFmg=
X-Received: by 2002:a67:cfc6:0:b0:402:999f:51dd with SMTP id
 h6-20020a67cfc6000000b00402999f51ddmr683904vsm.3.1677834256581; Fri, 03 Mar
 2023 01:04:16 -0800 (PST)
MIME-Version: 1.0
References: <20230301180657.003689969@linuxfoundation.org> <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com> <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
 <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com> <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
In-Reply-To: <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 Mar 2023 14:34:05 +0530
Message-ID: <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
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

On Fri, 3 Mar 2023 at 13:34, Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Fri, 2023-03-03 at 01:32 +0530, Naresh Kamboju wrote:
> > On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> > > > > On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > This is the start of the stable review cycle for the 6.1.15 release.
> > > > > > There are 42 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > > The whole patch series can be found in one patch at:
> > > > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > > > > and the diffstat can be found below.
> > > > > >
> > > > > > thanks,
> > > > > >
> > > > > > greg k-h
> > > > >
> > > > > Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.
> > > > >
> > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > >
> > > > > ## Build
> > > > > * kernel: 6.1.15-rc1
> > > > > * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> > > > > * git branch: linux-6.1.y
> > > > > * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> > > > > * git describe: v6.1.14-43-gb6150251d4dd
> > > > > * test details:
> > > > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd
> > > > >
> > > > > Regression test cases,
> > > > > i386:
> > > > > x15:
> > > > >   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> > > > >
> > > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > > >
> > > > > test log:
> > > > > ----------
> > > > >
> > > > > # selftests: net/mptcp: mptcp_sockopt.sh
> > >
> > > ....
> > >
> > > > Nit, wrapping a log like this makes it hard to read, don't you think?
> > >
> > > Me either.
> > > That is the reason I have shared "Assertion" above.
> > >
> > > >
> > > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > > Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> > > > > # server killed by signal 6
> > > > > #
> > > > > # FAIL: SOL_MPTCP getsockopt
> > > > > # PASS: TCP_INQ cmsg/ioctl -t tcp
> > > > > # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> > > > > # PASS: TCP_INQ cmsg/ioctl -r tcp
> > > > > # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> > > > > # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> > > > > not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1
> > > >
> > > > Any chance you can bisect?
> > >
> > > We are running our bisection scripts.
> >
> > We have tested with 6.1.14 kselftests source again and it passes.
> > Now that we have upgraded to 6.2.1 kselftests source, we find that
> > there is this problem reported. so, not a kernel regression.
>
> I read the above as you are running self-tests from 6.2.1 on top of an
> older (6.1) kernel. Is that correct?

correct.

> If so failures are expected;

Thanks for clarifying this.

> please use the self-tests and kernel from the same release.
>
> Otherwise, could you please re-phrase the above?
>
> Thanks,
>
> Paolo
>

- Naresh
