Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E701D7A9D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgEROCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:02:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43102 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726800AbgEROCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589810531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7ZhJvRx/Uoad26hpV6NugqrvcpRhfNNoEtqd7nlYUk=;
        b=YdQc+yHEarQDL5sEApoZ5zUSc8CXTq6JS2B7BqPYjijLAsrWeiig+dfRvShE6jtMuIg0TJ
        9+GVRpLGcmgVkQfxFk4iNZZ8ZzKPH4P4u/xw48y2bTUDpXdGMx6Mw7woeA2Im3/6is0yQx
        O0UtrXfpwczScCg6COqSYSipSXDKCyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-5oWAW9hgM6mejwbnAr_neA-1; Mon, 18 May 2020 10:01:38 -0400
X-MC-Unique: 5oWAW9hgM6mejwbnAr_neA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64E1519057A2
        for <stable@vger.kernel.org>; Mon, 18 May 2020 14:00:40 +0000 (UTC)
Received: from localhost.localdomain (ovpn-113-33.rdu2.redhat.com [10.10.113.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3ADE60BF3;
        Mon, 18 May 2020 14:00:39 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e6=2e13?=
 =?UTF-8?Q?-3f0cc50=2ecki_=28stable-queue=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
References: <cki.1A49C7CD82.EYM9JXWA38@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <89124b8f-c77f-5601-9e4f-8abce7e7050f@redhat.com>
Date:   Mon, 18 May 2020 10:00:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.1A49C7CD82.EYM9JXWA38@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/20 9:58 AM, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>              Commit: 3f0cc50b2470 - net: broadcom: Select BROADCOM_PHY for BCMGENET
> 
> The results of these automated tests are provided below.
> 
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/05/16/570411
> 
> One or more kernel tests failed:
> 
>      s390x:
>       ❌ LTP
> 
>      aarch64:
>       ❌ LTP
> 
>      x86_64:
>       ❌ LTP

Hi! Looks like fanotify09 is still failing as we're missing the following commits:
https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/05/16/570411/LTP/aarch64_1_ltp_syscalls.fail.log

     23	HINT: You _MAY_ be missing kernel fixes, see:
     24	
     25	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=54a307ba8d3c
     26	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b469e7e47c8a
     27	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=55bf882c7f13

-Rachel

> 
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> ______________________________________________________________________________
> 
> Compile testing
> ---------------
> 
> We compiled the kernel for 4 architectures:
> 
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>      ppc64le:
>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>      s390x:
>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>      x86_64:
>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
> 
> 
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
> 
>    aarch64:
>      Host 1:
>         ✅ Boot test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ❌ LTP
>         ✅ Memory function: memfd_create
>         ✅ AMTU (Abstract Machine Test Utility)
>         ✅ Networking bridge: sanity
>         ✅ Ethernet drivers sanity
>         ✅ Networking socket: fuzz
>         ✅ Networking: igmp conformance test
>         ✅ Networking route: pmtu
>         ✅ Networking route_func - local
>         ✅ Networking route_func - forward
>         ✅ Networking TCP: keepalive test
>         ✅ Networking UDP: socket
>         ✅ Networking tunnel: geneve basic test
>         ✅ Networking tunnel: gre basic
>         ✅ L2TP basic test
>         ✅ Networking tunnel: vxlan basic
>         ✅ Networking ipsec: basic netns - transport
>         ✅ Networking ipsec: basic netns - tunnel
>         ✅ Libkcapi AF_ALG test
>         ✅ ALSA PCM loopback test
>         ✅ ALSA Control (mixer) Userspace Element test
>         ✅ storage: SCSI VPD
>         🚧 ✅ CIFS Connectathon
>         🚧 ✅ POSIX pjd-fstest suites
>         🚧 ✅ jvm - DaCapo Benchmark Suite
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
> 
>      Host 2:
>         ✅ Boot test
>         ✅ xfstests - ext4
>         ✅ xfstests - xfs
>         ✅ selinux-policy: serge-testsuite
>         ✅ storage: software RAID testing
>         ✅ stress: stress-ng
>         🚧 ✅ IPMI driver test
>         🚧 ✅ IPMItool loop stress test
>         🚧 ✅ Storage blktests
> 
>    ppc64le:
>      Host 1:
> 
>         ⚡ Internal infrastructure issues prevented one or more tests (marked
>         with ⚡⚡⚡) from running on this architecture.
>         This is not the fault of the kernel that was tested.
> 
>         ⚡⚡⚡ Boot test
>         ⚡⚡⚡ Podman system integration test - as root
>         ⚡⚡⚡ Podman system integration test - as user
>         ⚡⚡⚡ LTP
>         ⚡⚡⚡ Memory function: memfd_create
>         ⚡⚡⚡ AMTU (Abstract Machine Test Utility)
>         ⚡⚡⚡ Networking bridge: sanity
>         ⚡⚡⚡ Ethernet drivers sanity
>         ⚡⚡⚡ Networking socket: fuzz
>         ⚡⚡⚡ Networking route: pmtu
>         ⚡⚡⚡ Networking route_func - local
>         ⚡⚡⚡ Networking route_func - forward
>         ⚡⚡⚡ Networking TCP: keepalive test
>         ⚡⚡⚡ Networking UDP: socket
>         ⚡⚡⚡ Networking tunnel: geneve basic test
>         ⚡⚡⚡ Networking tunnel: gre basic
>         ⚡⚡⚡ L2TP basic test
>         ⚡⚡⚡ Networking tunnel: vxlan basic
>         ⚡⚡⚡ Networking ipsec: basic netns - tunnel
>         ⚡⚡⚡ Libkcapi AF_ALG test
>         ⚡⚡⚡ ALSA PCM loopback test
>         ⚡⚡⚡ ALSA Control (mixer) Userspace Element test
>         🚧 ⚡⚡⚡ CIFS Connectathon
>         🚧 ⚡⚡⚡ POSIX pjd-fstest suites
>         🚧 ⚡⚡⚡ jvm - DaCapo Benchmark Suite
>         🚧 ⚡⚡⚡ jvm - jcstress tests
>         🚧 ⚡⚡⚡ Memory function: kaslr
>         🚧 ⚡⚡⚡ audit: audit testsuite test
>         🚧 ⚡⚡⚡ trace: ftrace/tracer
> 
>      Host 2:
> 
>         ⚡ Internal infrastructure issues prevented one or more tests (marked
>         with ⚡⚡⚡) from running on this architecture.
>         This is not the fault of the kernel that was tested.
> 
>         ⚡⚡⚡ Boot test
>         🚧 ⚡⚡⚡ kdump - sysrq-c
> 
>      Host 3:
> 
>         ⚡ Internal infrastructure issues prevented one or more tests (marked
>         with ⚡⚡⚡) from running on this architecture.
>         This is not the fault of the kernel that was tested.
> 
>         ✅ Boot test
>         ✅ xfstests - ext4
>         ⚡⚡⚡ xfstests - xfs
>         ⚡⚡⚡ selinux-policy: serge-testsuite
>         ⚡⚡⚡ storage: software RAID testing
>         🚧 ⚡⚡⚡ IPMI driver test
>         🚧 ⚡⚡⚡ IPMItool loop stress test
>         🚧 ⚡⚡⚡ Storage blktests
> 
>      Host 4:
> 
>         ⚡ Internal infrastructure issues prevented one or more tests (marked
>         with ⚡⚡⚡) from running on this architecture.
>         This is not the fault of the kernel that was tested.
> 
>         ✅ Boot test
>         🚧 ⚡⚡⚡ kdump - sysrq-c
> 
>    s390x:
>      Host 1:
>         ✅ Boot test
>         🚧 ✅ kdump - sysrq-c
> 
>      Host 2:
>         ✅ Boot test
>         ✅ selinux-policy: serge-testsuite
>         ✅ stress: stress-ng
>         🚧 ✅ Storage blktests
> 
>      Host 3:
>         ✅ Boot test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ❌ LTP
>         ✅ Memory function: memfd_create
>         ✅ Networking bridge: sanity
>         ✅ Ethernet drivers sanity
>         ✅ Networking route: pmtu
>         ✅ Networking route_func - local
>         ✅ Networking route_func - forward
>         ✅ Networking TCP: keepalive test
>         ✅ Networking UDP: socket
>         ✅ Networking tunnel: geneve basic test
>         ✅ Networking tunnel: gre basic
>         ✅ L2TP basic test
>         ✅ Networking tunnel: vxlan basic
>         ✅ Networking ipsec: basic netns - transport
>         ✅ Networking ipsec: basic netns - tunnel
>         ✅ Libkcapi AF_ALG test
>         🚧 ✅ CIFS Connectathon
>         🚧 ✅ POSIX pjd-fstest suites
>         🚧 ✅ jvm - DaCapo Benchmark Suite
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
> 
>    x86_64:
>      Host 1:
>         ✅ Boot test
>         ✅ xfstests - ext4
>         ✅ xfstests - xfs
>         ✅ selinux-policy: serge-testsuite
>         ✅ storage: software RAID testing
>         ✅ stress: stress-ng
>         🚧 ✅ IOMMU boot test
>         🚧 ✅ IPMI driver test
>         🚧 ✅ IPMItool loop stress test
>         🚧 ✅ Storage blktests
> 
>      Host 2:
>         ✅ Boot test
>         🚧 ✅ kdump - sysrq-c
> 
>      Host 3:
> 
>         ⚡ Internal infrastructure issues prevented one or more tests (marked
>         with ⚡⚡⚡) from running on this architecture.
>         This is not the fault of the kernel that was tested.
> 
>         ⚡⚡⚡ Boot test
>         ⚡⚡⚡ Podman system integration test - as root
>         ⚡⚡⚡ Podman system integration test - as user
>         ⚡⚡⚡ LTP
>         ⚡⚡⚡ Memory function: memfd_create
>         ⚡⚡⚡ AMTU (Abstract Machine Test Utility)
>         ⚡⚡⚡ Networking bridge: sanity
>         ⚡⚡⚡ Ethernet drivers sanity
>         ⚡⚡⚡ Networking socket: fuzz
>         ⚡⚡⚡ Networking: igmp conformance test
>         ⚡⚡⚡ Networking route: pmtu
>         ⚡⚡⚡ Networking route_func - local
>         ⚡⚡⚡ Networking route_func - forward
>         ⚡⚡⚡ Networking TCP: keepalive test
>         ⚡⚡⚡ Networking UDP: socket
>         ⚡⚡⚡ Networking tunnel: geneve basic test
>         ⚡⚡⚡ Networking tunnel: gre basic
>         ⚡⚡⚡ L2TP basic test
>         ⚡⚡⚡ Networking tunnel: vxlan basic
>         ⚡⚡⚡ Networking ipsec: basic netns - transport
>         ⚡⚡⚡ Networking ipsec: basic netns - tunnel
>         ⚡⚡⚡ Libkcapi AF_ALG test
>         ⚡⚡⚡ pciutils: sanity smoke test
>         ⚡⚡⚡ ALSA PCM loopback test
>         ⚡⚡⚡ ALSA Control (mixer) Userspace Element test
>         ⚡⚡⚡ storage: SCSI VPD
>         🚧 ⚡⚡⚡ CIFS Connectathon
>         🚧 ⚡⚡⚡ POSIX pjd-fstest suites
>         🚧 ⚡⚡⚡ jvm - DaCapo Benchmark Suite
>         🚧 ⚡⚡⚡ jvm - jcstress tests
>         🚧 ⚡⚡⚡ Memory function: kaslr
>         🚧 ⚡⚡⚡ audit: audit testsuite test
>         🚧 ⚡⚡⚡ trace: ftrace/tracer
> 
>      Host 4:
>         ✅ Boot test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ❌ LTP
>         ✅ Memory function: memfd_create
>         ✅ AMTU (Abstract Machine Test Utility)
>         ✅ Networking bridge: sanity
>         ✅ Ethernet drivers sanity
>         ✅ Networking socket: fuzz
>         ✅ Networking: igmp conformance test
>         ✅ Networking route: pmtu
>         ✅ Networking route_func - local
>         ✅ Networking route_func - forward
>         ✅ Networking TCP: keepalive test
>         ✅ Networking UDP: socket
>         ✅ Networking tunnel: geneve basic test
>         ✅ Networking tunnel: gre basic
>         ✅ L2TP basic test
>         ✅ Networking tunnel: vxlan basic
>         ✅ Networking ipsec: basic netns - transport
>         ✅ Networking ipsec: basic netns - tunnel
>         ✅ Libkcapi AF_ALG test
>         ✅ pciutils: sanity smoke test
>         ✅ ALSA PCM loopback test
>         ✅ ALSA Control (mixer) Userspace Element test
>         ✅ storage: SCSI VPD
>         🚧 ✅ CIFS Connectathon
>         🚧 ✅ POSIX pjd-fstest suites
>         🚧 ✅ jvm - DaCapo Benchmark Suite
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
> 
>    Test sources: https://github.com/CKI-project/tests-beaker
>      💚 Pull requests are welcome for new tests or improvements to existing tests!
> 
> Aborted tests
> -------------
> Tests that didn't complete running successfully are marked with ⚡⚡⚡.
> If this was caused by an infrastructure issue, we try to mark that
> explicitly in the report.
> 
> Waived tests
> ------------
> If the test run included waived tests, they are marked with 🚧. Such tests are
> executed but their results are not taken into account. Tests are waived when
> their results are not reliable enough, e.g. when they're just introduced or are
> being fixed.
> 
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven't
> finished running yet are marked with ⏱.
> 
> 

