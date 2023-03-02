Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB0C6A7FF7
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 11:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCBKaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 05:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCBKaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 05:30:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C383136EF;
        Thu,  2 Mar 2023 02:30:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1257B8121B;
        Thu,  2 Mar 2023 10:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D117BC433EF;
        Thu,  2 Mar 2023 10:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677752999;
        bh=VvcAnQ+5Q4FRZDFzuGAf9xyjKRrbK5mQvXIVydLiOVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ts9RSQVZs75WtFtpUl4k/CkEqhJd+vGaa2xhEsIcF43LwKqWX2Di5vHzdhS+OSfr9
         4afjz9Q9yCG9KDzvenW7NfiIor5twdOilctuAgzBondmBt3zL9DKuHIxwvIo4fwZHP
         54ihnB9lmVpF+vHm7mlQKjkkjo/w051hISgLGfkk=
Date:   Thu, 2 Mar 2023 11:29:56 +0100
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
Message-ID: <ZAB6pP3MNy152f+7@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org>
 <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.15 release.
> > There are 42 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build
> * kernel: 6.1.15-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-6.1.y
> * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> * git describe: v6.1.14-43-gb6150251d4dd
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd
> 
> Regression test cases,
> i386:
> x15:
>   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> 
> # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> 
> test log:
> ----------
> 
> # selftests: net/mptcp: mptcp_sockopt.sh
> [  918.263983] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [  918.398851] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [  918.538987] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [  918.678270] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [  918.800671] audit: type=1325 audit(1677748585.128:33): table=filter
> family=2 entries=0 op=xt_register pid=18489 subj=kernel
> comm=\"iptables\"
> [  918.813228] audit: type=1300 audit(1677748585.128:33):
> arch=40000003 syscall=102 success=yes exit=0 a0=f a1=bf94ed3c a2=40
> a3=b7edfe3c items=0 ppid=18412 pid=18489 auid=4294967295 uid=0 gid=0
> euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
> comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
> key=(null)
> [  918.842987] audit: type=1327 audit(1677748585.128:33):
> proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D73796E002D6D006D61726B002D2D6D61726B0031002D6A00414343455054
> [  918.859285] audit: type=1325 audit(1677748585.128:34): table=filter
> family=2 entries=4 op=xt_replace pid=18489 subj=kernel
> comm=\"iptables\"
> [  918.871788] audit: type=1300 audit(1677748585.128:34):
> arch=40000003 syscall=102 success=yes exit=0 a0=e a1=bf94ef64 a2=40
> a3=b7edfe3c items=0 ppid=18412 pid=18489 auid=4294967295 uid=0 gid=0
> euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
> comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
> key=(null)
> [  918.901496] audit: type=1327 audit(1677748585.128:34):
> proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D73796E002D6D006D61726B002D2D6D61726B0031002D6A00414343455054
> [  918.934555] audit: type=1325 audit(1677748585.262:35): table=filter
> family=2 entries=5 op=xt_replace pid=18490 subj=kernel
> comm=\"iptables\"
> [  918.947242] audit: type=1300 audit(1677748585.262:35):
> arch=40000003 syscall=102 success=yes exit=0 a0=e a1=bfc21cd4 a2=40
> a3=b7f27e3c items=0 ppid=18412 pid=18490 auid=4294967295 uid=0 gid=0
> euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
> comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
> key=(null)
> [  918.976905] audit: type=1327 audit(1677748585.262:35):
> proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D7463702D666C6167730052535400525354002D6D006D61726B002D2D6D61726B0030002D6A00414343455054
> [  919.013445] audit: type=1325 audit(1677748585.341:36): table=filter
> family=2 entries=6 op=xt_replace pid=18491 subj=kernel
> comm=\"iptables\"
> # Created /tmp/tmp.CG4evZjYl7 (size 1 KB) containing data sent by client
> # Created /tmp/tmp.urARJfNrFp (size 1 KB) containing data sent by server
> # PASS: all packets had packet mark set
> # mptcp_[  944.426054] kauditd_printk_skb: 50 callbacks suppressed
> sockopt: mptcp_s[  944.426057] audit: type=1701
> audit(1677748610.753:53): auid=4294967295 uid=0 gid=0 ses=4294967295
> subj=kernel pid=18532 comm=\"mptcp_sockopt\"
> exe=\"/opt/kselftests/default-in-kernel/net/mptcp/mptcp_sockopt\"
> sig=6 res=1
> [  944.452415] audit: type=1701 audit(1677748610.753:54):
> auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=18533
> comm=\"mptcp_sockopt\"
> exe=\"/opt/kselftests/default-in-kernel/net/mptcp/mptcp_sockopt\"
> sig=6 res=1
> ockopt.c:353: do_getsockopt_tcp_info: Assertion `ti.d.size_user ==
> sizeof(struct tcp_info)' failed.


Nit, wrapping a log like this makes it hard to read, don't you think?

> # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
> # server killed by signal 6
> #
> # FAIL: SOL_MPTCP getsockopt
> # PASS: TCP_INQ cmsg/ioctl -t tcp
> # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> # PASS: TCP_INQ cmsg/ioctl -r tcp
> # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1

Any chance you can bisect?

And is this an issue on 6.2 and/or Linus's tree?  I don't see any mptcp
changes in this 6.1-rc cycle, they were in the last one...

thanks,

greg k-h
