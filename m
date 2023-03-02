Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C016A7FD9
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 11:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjCBKTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 05:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCBKTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 05:19:48 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE22314992
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 02:19:42 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id f31so21993479vsv.1
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 02:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mW7Qsc+LkNwU49jW8ZjK3kQHecamHHcZN3+W1tt/rQg=;
        b=JsKhM0TT7s7H2OljB5H9Nm0PFnlZuEsCXnmRTJs26tsebRJRNSAo25HE6/DzEsQYyw
         0dDBERm/heL+5CZZ6g6gSCak2GZN7RgF0VfezOUiMzcj1Cfl/RN2tw0CSXjAMaWV6LEe
         eCDkpPeYtp4rwVSxvCBjagzrfJ/sKF7CARUm2mw1BSipvUPk8zgXg6aP/LqG8ramibkn
         SGmy6r6T80UeUzLtH6zwXKThQr758t2/M9XNhYYrEGUjJjH4kx8hIHRMx9b357Fk275M
         m2RPFsC9i2XtolJsL2R2xsKzLJTJkDhByP+lmdKAoKIzy7RW5wnGp0z2g9at/SIGjwsN
         otjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mW7Qsc+LkNwU49jW8ZjK3kQHecamHHcZN3+W1tt/rQg=;
        b=oCwa8UvVwNIlzdo2va+miaaVjMiUcqq0NucCbOsVeK1ue4Ip0s05qIOB2iMKvPSCVk
         HJ8lDbnHj+QaokJdpuYYBpgnhKsd6gs6tduRDtK4WFstEvmRpm5VDKO1s30wT05EqII7
         /t3mvoApmu7+Ox/QE35Cmn5g4AuJcyJaOMf05PdEMhJjIQ8KXlCYVArxJZ4Mc9W42MBR
         582+IeAAr6q0t+Z+E9HKWJ+VZtIEbcw0B3DEsdf5pCKWbMcjSCoB8Wu6NziZZ1wgxXwl
         hAGnuSOvAf96AJbsKHX9sDQJmmKx7QeGjx6ByMnyqDHu82yEOx2u3RVLfcEeosviL9mx
         MR3g==
X-Gm-Message-State: AO0yUKWF2Vk3Gr4GHr19MDEgaVicKU/Ey0GzX+Hmwd7FbUNTOsTKOSGt
        VFvn5YeMSSi0E/xDW/pEtKYqGQuEZ3pcV2rdiX+khA==
X-Google-Smtp-Source: AK7set92AkVKpvk5FqJ1Qjq+5W0UKJQNGj5d50Jv+hTSG3ohEWHYn7dbfUpzFKUsCFk6ttfjcXZ+GkYkYW8AP4abWYQ=
X-Received: by 2002:a05:6102:3202:b0:412:2f46:4073 with SMTP id
 r2-20020a056102320200b004122f464073mr6147566vsf.3.1677752381868; Thu, 02 Mar
 2023 02:19:41 -0800 (PST)
MIME-Version: 1.0
References: <20230301180657.003689969@linuxfoundation.org>
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Mar 2023 15:49:31 +0530
Message-ID: <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
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

On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: b6150251d4ddf8a80510c185d839631e252e6317
* git describe: v6.1.14-43-gb6150251d4dd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd

Regression test cases,
i386:
x15:
  * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh

# mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
# mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.

test log:
----------

# selftests: net/mptcp: mptcp_sockopt.sh
[  918.263983] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[  918.398851] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[  918.538987] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[  918.678270] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[  918.800671] audit: type=1325 audit(1677748585.128:33): table=filter
family=2 entries=0 op=xt_register pid=18489 subj=kernel
comm=\"iptables\"
[  918.813228] audit: type=1300 audit(1677748585.128:33):
arch=40000003 syscall=102 success=yes exit=0 a0=f a1=bf94ed3c a2=40
a3=b7edfe3c items=0 ppid=18412 pid=18489 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
key=(null)
[  918.842987] audit: type=1327 audit(1677748585.128:33):
proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D73796E002D6D006D61726B002D2D6D61726B0031002D6A00414343455054
[  918.859285] audit: type=1325 audit(1677748585.128:34): table=filter
family=2 entries=4 op=xt_replace pid=18489 subj=kernel
comm=\"iptables\"
[  918.871788] audit: type=1300 audit(1677748585.128:34):
arch=40000003 syscall=102 success=yes exit=0 a0=e a1=bf94ef64 a2=40
a3=b7edfe3c items=0 ppid=18412 pid=18489 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
key=(null)
[  918.901496] audit: type=1327 audit(1677748585.128:34):
proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D73796E002D6D006D61726B002D2D6D61726B0031002D6A00414343455054
[  918.934555] audit: type=1325 audit(1677748585.262:35): table=filter
family=2 entries=5 op=xt_replace pid=18490 subj=kernel
comm=\"iptables\"
[  918.947242] audit: type=1300 audit(1677748585.262:35):
arch=40000003 syscall=102 success=yes exit=0 a0=e a1=bfc21cd4 a2=40
a3=b7f27e3c items=0 ppid=18412 pid=18490 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
key=(null)
[  918.976905] audit: type=1327 audit(1677748585.262:35):
proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D7463702D666C6167730052535400525354002D6D006D61726B002D2D6D61726B0030002D6A00414343455054
[  919.013445] audit: type=1325 audit(1677748585.341:36): table=filter
family=2 entries=6 op=xt_replace pid=18491 subj=kernel
comm=\"iptables\"
# Created /tmp/tmp.CG4evZjYl7 (size 1 KB) containing data sent by client
# Created /tmp/tmp.urARJfNrFp (size 1 KB) containing data sent by server
# PASS: all packets had packet mark set
# mptcp_[  944.426054] kauditd_printk_skb: 50 callbacks suppressed
sockopt: mptcp_s[  944.426057] audit: type=1701
audit(1677748610.753:53): auid=4294967295 uid=0 gid=0 ses=4294967295
subj=kernel pid=18532 comm=\"mptcp_sockopt\"
exe=\"/opt/kselftests/default-in-kernel/net/mptcp/mptcp_sockopt\"
sig=6 res=1
[  944.452415] audit: type=1701 audit(1677748610.753:54):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=18533
comm=\"mptcp_sockopt\"
exe=\"/opt/kselftests/default-in-kernel/net/mptcp/mptcp_sockopt\"
sig=6 res=1
ockopt.c:353: do_getsockopt_tcp_info: Assertion `ti.d.size_user ==
sizeof(struct tcp_info)' failed.
# mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
# server killed by signal 6
#
# FAIL: SOL_MPTCP getsockopt
# PASS: TCP_INQ cmsg/ioctl -t tcp
# PASS: TCP_INQ cmsg/ioctl -6 -t tcp
# PASS: TCP_INQ cmsg/ioctl -r tcp
# PASS: TCP_INQ cmsg/ioctl -6 -r tcp
# PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1


Test results comparision link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd/testrun/15204254/suite/kselftest-net-mptcp/test/net_mptcp_mptcp_sockopt_sh/history/?page=1
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd/testrun/15204254/suite/kselftest-net-mptcp/test/net_mptcp_mptcp_sockopt_sh/details/
https://lkft.validation.linaro.org/scheduler/job/6211923#L2664

--
Linaro LKFT
https://lkft.linaro.org
