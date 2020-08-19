Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DE124A395
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 17:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgHSPys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 11:54:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35199 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726636AbgHSPyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 11:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597852483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VNJRwo/GVEwxoFl2F1d5iQu2dSOlCxgijzbElC3Vtw=;
        b=KH1QJUYv/GSLnPuYcbLYqOimOMYKDCM7LUSpGQo+2Qc9Qnp/+nGMdloz8APn7/bjjYQjZH
        hRNZHShL3ElbBLQPfJldMIvTCnQsXnLShArwUFiUuyN+ku25qD5pJ0AGdc0HgcWRinQ0fH
        EMdzNB32FBqMviR1E2hz7CTuav/zRBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-zOYJBUOpM9GJwSuSFBd2qA-1; Wed, 19 Aug 2020 11:54:28 -0400
X-MC-Unique: zOYJBUOpM9GJwSuSFBd2qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76C86801AE5
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 15:54:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-232.rdu2.redhat.com [10.10.114.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79D8A5C1A3;
        Wed, 19 Aug 2020 15:54:19 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e8=2e2-?=
 =?UTF-8?Q?ad8c735=2ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     David Arcari <darcari@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
References: <cki.81A545788B.TQBX9O8LVS@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <3774b716-4440-f6c7-0c9b-60d3b599196e@redhat.com>
Date:   Wed, 19 Aug 2020 11:54:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.81A545788B.TQBX9O8LVS@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/19/20 11:48 AM, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>              Commit: ad8c735b1497 - Linux 5.8.2
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
>    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/08/19/612293
> 
> One or more kernel tests failed:
> 
>      s390x:
>       ❌ LTP
> 
>      ppc64le:
>       ❌ LTP
> 
>      aarch64:
>       ❌ LTP

For both s390x/aarch64 failures looks like we're missing the following kernel fixes for stable:

      1	<<<test_start>>>
      2	tag=ioctl_loop01 stime=1597824830
      3	cmdline="ioctl_loop01"
      4	contacts=""
      5	analysis=exit
      6	<<<test_output>>>
      7	tst_test.c:1245: INFO: Timeout per run is 0h 05m 00s
      8	tst_device.c:88: INFO: Found free device 0 '/dev/loop0'
      9	ioctl_loop01.c:85: PASS: /sys/block/loop0/loop/partscan = 0
     10	ioctl_loop01.c:86: PASS: /sys/block/loop0/loop/autoclear = 0
     11	ioctl_loop01.c:87: PASS: /sys/block/loop0/loop/backing_file = '/mnt/testarea/ltp-4l1XyCNbu8/h6pPv5/test.img'
     12	ioctl_loop01.c:57: PASS: get expected lo_flag 12
     13	ioctl_loop01.c:59: PASS: /sys/block/loop0/loop/partscan = 1
     14	ioctl_loop01.c:60: PASS: /sys/block/loop0/loop/autoclear = 1
     15	ioctl_loop01.c:71: FAIL: access /dev/loop0p1 fails
     16	ioctl_loop01.c:75: PASS: access /sys/block/loop0/loop0p1 succeeds
     17	ioctl_loop01.c:91: INFO: Test flag can be clear
     18	ioctl_loop01.c:57: PASS: get expected lo_flag 8
     19	ioctl_loop01.c:59: PASS: /sys/block/loop0/loop/partscan = 1
     20	ioctl_loop01.c:60: PASS: /sys/block/loop0/loop/autoclear = 0
     21	ioctl_loop01.c:71: FAIL: access /dev/loop0p1 fails
     22	ioctl_loop01.c:77: FAIL: access /sys/block/loop0/loop0p1 fails
     23	
     24	HINT: You _MAY_ be missing kernel fixes, see:
     25	
     26	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=10c70d95c0f2
     27	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6ac92fb5cdff

https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/08/19/612293/build_aarch64_redhat%3A958531/tests/LTP/8699601_aarch64_1_syscalls.fail.log

https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/08/19/612293/build_s390x_redhat%3A958533/tests/LTP/8699609_s390x_1_syscalls.fail.log

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
>        make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>      ppc64le:
>        make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>      s390x:
>        make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>      x86_64:
>        make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg
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
>         ✅ xfstests - ext4
>         ✅ xfstests - xfs
>         ✅ selinux-policy: serge-testsuite
>         ✅ storage: software RAID testing
>         ✅ stress: stress-ng
>         🚧 ✅ xfstests - btrfs
>         🚧 ✅ IPMI driver test
>         🚧 ✅ IPMItool loop stress test
>         🚧 ✅ Storage blktests
> 
>      Host 2:
>         ✅ Boot test
>         ✅ ACPI table test
>         ✅ ACPI enabled test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ❌ LTP
>         ✅ Loopdev Sanity
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
>         ✅ pciutils: update pci ids test
>         ✅ ALSA PCM loopback test
>         ✅ ALSA Control (mixer) Userspace Element test
>         ✅ storage: SCSI VPD
>         🚧 ✅ CIFS Connectathon
>         🚧 ✅ POSIX pjd-fstest suites
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ Networking firewall: basic netfilter test
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
>         🚧 ✅ kdump - kexec_boot
> 
>    ppc64le:
>      Host 1:
>         ✅ Boot test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ❌ LTP
>         ✅ Loopdev Sanity
>         ✅ Memory function: memfd_create
>         ✅ AMTU (Abstract Machine Test Utility)
>         ✅ Networking bridge: sanity
>         ✅ Ethernet drivers sanity
>         ✅ Networking socket: fuzz
>         ✅ Networking route: pmtu
>         ✅ Networking route_func - local
>         ✅ Networking route_func - forward
>         ✅ Networking TCP: keepalive test
>         ✅ Networking UDP: socket
>         ✅ Networking tunnel: geneve basic test
>         ✅ Networking tunnel: gre basic
>         ✅ L2TP basic test
>         ✅ Networking tunnel: vxlan basic
>         ✅ Networking ipsec: basic netns - tunnel
>         ✅ Libkcapi AF_ALG test
>         ✅ pciutils: update pci ids test
>         ✅ ALSA PCM loopback test
>         ✅ ALSA Control (mixer) Userspace Element test
>         🚧 ✅ CIFS Connectathon
>         🚧 ✅ POSIX pjd-fstest suites
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ Networking firewall: basic netfilter test
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
> 
>      Host 2:
>         ✅ Boot test
>         ✅ xfstests - ext4
>         ✅ xfstests - xfs
>         ✅ selinux-policy: serge-testsuite
>         ✅ storage: software RAID testing
>         🚧 ✅ xfstests - btrfs
>         🚧 ✅ IPMI driver test
>         🚧 ✅ IPMItool loop stress test
>         🚧 ✅ Storage blktests
> 
>      Host 3:
>         ✅ Boot test
>         🚧 ✅ kdump - sysrq-c
> 
>    s390x:
>      Host 1:
>         ✅ Boot test
>         ✅ selinux-policy: serge-testsuite
>         ✅ stress: stress-ng
>         🚧 ✅ Storage blktests
> 
>      Host 2:
>         ✅ Boot test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ❌ LTP
>         ✅ Loopdev Sanity
>         ✅ Memory function: memfd_create
>         ✅ AMTU (Abstract Machine Test Utility)
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
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ Networking firewall: basic netfilter test
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
> 
>    x86_64:
>      Host 1:
>         ✅ Boot test
>         ✅ ACPI table test
>         ✅ Podman system integration test - as root
>         ✅ Podman system integration test - as user
>         ✅ LTP
>         ✅ Loopdev Sanity
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
>         ✅ pciutils: update pci ids test
>         ✅ ALSA PCM loopback test
>         ✅ ALSA Control (mixer) Userspace Element test
>         ✅ storage: SCSI VPD
>         🚧 ✅ CIFS Connectathon
>         🚧 ✅ POSIX pjd-fstest suites
>         🚧 ✅ jvm - jcstress tests
>         🚧 ✅ Memory function: kaslr
>         🚧 ✅ Networking firewall: basic netfilter test
>         🚧 ✅ audit: audit testsuite test
>         🚧 ✅ trace: ftrace/tracer
>         🚧 ✅ kdump - kexec_boot
> 
>      Host 2:
>         ✅ Boot test
>         🚧 ✅ kdump - sysrq-c
>         🚧 ✅ kdump - file-load
> 
>      Host 3:
> 
>         ⚡ Internal infrastructure issues prevented one or more tests (marked
>         with ⚡⚡⚡) from running on this architecture.
>         This is not the fault of the kernel that was tested.
> 
>         ✅ Boot test
>         ✅ xfstests - ext4
>         ✅ xfstests - xfs
>         ✅ selinux-policy: serge-testsuite
>         ✅ storage: software RAID testing
>         ✅ stress: stress-ng
>         🚧 ❌ CPU: Frequency Driver Test
>         🚧 ✅ CPU: Idle Test
>         🚧 ✅ xfstests - btrfs
>         🚧 ⚡⚡⚡ IOMMU boot test
>         🚧 ⚡⚡⚡ IPMI driver test
>         🚧 ⚡⚡⚡ IPMItool loop stress test
>         🚧 ⚡⚡⚡ power-management: cpupower/sanity test
>         🚧 ⚡⚡⚡ Storage blktests
> 
>    Test sources: https://gitlab.com/cki-project/kernel-tests
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

