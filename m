Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4094A9B0F1
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393442AbfHWN2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 09:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388055AbfHWN2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 09:28:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A84B218C4277
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 13:28:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-195.rdu2.redhat.com [10.10.120.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 310C41001925;
        Fri, 23 Aug 2019 13:28:43 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e2=2e10?=
 =?UTF-8?Q?-rc1-f5284fb=2ecki_=28stable=29?=
From:   Rachel Sibley <rasibley@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Jeff Bastian <jbastian@redhat.com>
References: <cki.66AF037CBA.ROCU3L6TFM@redhat.com>
 <b851881f-7bf0-fb91-f6c1-ec101f5d8fd4@redhat.com>
Message-ID: <c237686d-78b3-0c81-430c-49b0fd467a85@redhat.com>
Date:   Fri, 23 Aug 2019 09:28:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b851881f-7bf0-fb91-f6c1-ec101f5d8fd4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 23 Aug 2019 13:28:46 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry about that, pasted the wrong link, here's the correct url for the log:
https://artifacts.cki-project.org/pipelines/117364/logs/aarch64_host_2_stress_stressng_dmesg.log

-Rachel

On 8/23/19 8:02 AM, Rachel Sibley wrote:
> The IOMMU test didn't exit properly after skip, and has since been 
> fixed. Looks like the stress-ng
> test resulted in a call trace, which can be observed in this log:
> http://beaker-archive.host.prod.eng.bos.redhat.com/beaker-logs/2019/08/37443/3744374/7270379/98159897/451777568/resultoutputfile.log 
>
>
> -Rachel
>
> On 8/22/19 8:30 PM, CKI Project wrote:
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>         Kernel repo: 
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>              Commit: f5284fbdcd34 - Linux 5.2.10-rc1
>>
>> The results of these automated tests are provided below.
>>
>>      Overall result: FAILED (see details below)
>>               Merge: OK
>>             Compile: OK
>>               Tests: FAILED
>>
>> All kernel binaries, config files, and logs are available for 
>> download here:
>>
>>    https://artifacts.cki-project.org/pipelines/117364
>>
>>
>>
>> One or more kernel tests failed:
>>
>>    x86_64:
>>      ❌ stress: stress-ng
>>
>> We hope that these logs can help you find the problem quickly. For 
>> the full
>> detail on our testing procedures, please scroll to the bottom of this 
>> message.
>>
>> Please reply to this email if you have any questions about the tests 
>> that we
>> ran or if you have any suggestions on how to make future tests more 
>> effective.
>>
>>          ,-.   ,-.
>>         ( C ) ( K )  Continuous
>>          `-',-.`-'   Kernel
>>            ( I )     Integration
>>             `-'
>> ______________________________________________________________________________ 
>>
>>
>> Compile testing
>> ---------------
>>
>> We compiled the kernel for 4 architectures:
>>
>>      aarch64:
>>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>>
>>      ppc64le:
>>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>>
>>      s390x:
>>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>>
>>      x86_64:
>>        make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>>
>>
>> Hardware testing
>> ----------------
>> We booted each kernel and ran the following tests:
>>
>>    aarch64:
>>        Host 1:
>>
>>           ⚡ Internal infrastructure issues prevented one or more 
>> tests (marked
>>           with ⚡⚡⚡) from running on this architecture.
>>           This is not the fault of the kernel that was tested.
>>
>>           ✅ Boot test [0]
>>           ✅ xfstests: ext4 [1]
>>           ✅ xfstests: xfs [1]
>>           ✅ selinux-policy: serge-testsuite [2]
>>           ✅ lvm thinp sanity [3]
>>           ✅ storage: software RAID testing [4]
>>           🚧 ✅ Storage blktests [5]
>>           🚧 ⚡⚡⚡ IOMMU boot test [6]
>>
>>        Host 2:
>>           ✅ Boot test [0]
>>           ✅ Podman system integration test (as root) [7]
>>           ✅ Podman system integration test (as user) [7]
>>           ✅ LTP lite [8]
>>           ✅ Loopdev Sanity [9]
>>           ✅ jvm test suite [10]
>>           ✅ Memory function: memfd_create [11]
>>           ✅ AMTU (Abstract Machine Test Utility) [12]
>>           ✅ LTP: openposix test suite [13]
>>           ✅ Ethernet drivers sanity [14]
>>           ✅ Networking socket: fuzz [15]
>>           ✅ Networking sctp-auth: sockopts test [16]
>>           ✅ Networking: igmp conformance test [17]
>>           ✅ Networking TCP: keepalive test [18]
>>           ✅ Networking UDP: socket [19]
>>           ✅ Networking tunnel: gre basic [20]
>>           ✅ Networking tunnel: vxlan basic [21]
>>           ✅ audit: audit testsuite test [22]
>>           ✅ httpd: mod_ssl smoke sanity [23]
>>           ✅ iotop: sanity [24]
>>           ✅ tuned: tune-processes-through-perf [25]
>>           ✅ Usex - version 1.9-29 [26]
>>           ✅ storage: SCSI VPD [27]
>>           ✅ stress: stress-ng [28]
>>           🚧 ✅ Networking route: pmtu [29]
>>           🚧 ✅ Networking route_func: local [30]
>>           🚧 ✅ Networking route_func: forward [30]
>>           🚧 ✅ Networking tunnel: geneve basic test [31]
>>           🚧 ✅ Networking ipsec: basic netns transport [32]
>>           🚧 ✅ Networking ipsec: basic netns tunnel [32]
>>           🚧 ✅ trace: ftrace/tracer [33]
>>
>>
>>    ppc64le:
>>        Host 1:
>>           ✅ Boot test [0]
>>           ✅ xfstests: ext4 [1]
>>           ✅ xfstests: xfs [1]
>>           ✅ selinux-policy: serge-testsuite [2]
>>           ✅ lvm thinp sanity [3]
>>           ✅ storage: software RAID testing [4]
>>           🚧 ✅ Storage blktests [5]
>>
>>        Host 2:
>>           ✅ Boot test [0]
>>           ✅ Podman system integration test (as root) [7]
>>           ✅ Podman system integration test (as user) [7]
>>           ✅ LTP lite [8]
>>           ✅ Loopdev Sanity [9]
>>           ✅ jvm test suite [10]
>>           ✅ Memory function: memfd_create [11]
>>           ✅ AMTU (Abstract Machine Test Utility) [12]
>>           ✅ LTP: openposix test suite [13]
>>           ✅ Ethernet drivers sanity [14]
>>           ✅ Networking socket: fuzz [15]
>>           ✅ Networking sctp-auth: sockopts test [16]
>>           ✅ Networking TCP: keepalive test [18]
>>           ✅ Networking UDP: socket [19]
>>           ✅ Networking tunnel: gre basic [20]
>>           ✅ Networking tunnel: vxlan basic [21]
>>           ✅ audit: audit testsuite test [22]
>>           ✅ httpd: mod_ssl smoke sanity [23]
>>           ✅ iotop: sanity [24]
>>           ✅ tuned: tune-processes-through-perf [25]
>>           ✅ Usex - version 1.9-29 [26]
>>           🚧 ✅ Networking route: pmtu [29]
>>           🚧 ✅ Networking route_func: local [30]
>>           🚧 ✅ Networking route_func: forward [30]
>>           🚧 ✅ Networking tunnel: geneve basic test [31]
>>           🚧 ✅ Networking ipsec: basic netns tunnel [32]
>>           🚧 ✅ trace: ftrace/tracer [33]
>>
>>
>>    s390x:
>>
>>      ⚡ Internal infrastructure issues prevented one or more tests 
>> (marked
>>      with ⚡⚡⚡) from running on this architecture.
>>      This is not the fault of the kernel that was tested.
>>
>>
>>    x86_64:
>>        Host 1:
>>           ✅ Boot test [0]
>>           ✅ xfstests: ext4 [1]
>>           ✅ xfstests: xfs [1]
>>           ✅ selinux-policy: serge-testsuite [2]
>>           ✅ lvm thinp sanity [3]
>>           ✅ storage: software RAID testing [4]
>>           🚧 ✅ Storage blktests [5]
>>           🚧 ✅ IOMMU boot test [6]
>>
>>        Host 2:
>>           ✅ Boot test [0]
>>           ✅ Podman system integration test (as root) [7]
>>           ✅ Podman system integration test (as user) [7]
>>           ✅ LTP lite [8]
>>           ✅ Loopdev Sanity [9]
>>           ✅ jvm test suite [10]
>>           ✅ Memory function: memfd_create [11]
>>           ✅ AMTU (Abstract Machine Test Utility) [12]
>>           ✅ LTP: openposix test suite [13]
>>           ✅ Ethernet drivers sanity [14]
>>           ✅ Networking socket: fuzz [15]
>>           ✅ Networking sctp-auth: sockopts test [16]
>>           ✅ Networking: igmp conformance test [17]
>>           ✅ Networking TCP: keepalive test [18]
>>           ✅ Networking UDP: socket [19]
>>           ✅ Networking tunnel: gre basic [20]
>>           ✅ Networking tunnel: vxlan basic [21]
>>           ✅ audit: audit testsuite test [22]
>>           ✅ httpd: mod_ssl smoke sanity [23]
>>           ✅ iotop: sanity [24]
>>           ✅ tuned: tune-processes-through-perf [25]
>>           ✅ pciutils: sanity smoke test [34]
>>           ✅ Usex - version 1.9-29 [26]
>>           ✅ storage: SCSI VPD [27]
>>           ❌ stress: stress-ng [28]
>>           🚧 ✅ Networking route: pmtu [29]
>>           🚧 ✅ Networking route_func: local [30]
>>           🚧 ✅ Networking route_func: forward [30]
>>           🚧 ✅ Networking tunnel: geneve basic test [31]
>>           🚧 ✅ Networking ipsec: basic netns transport [32]
>>           🚧 ✅ Networking ipsec: basic netns tunnel [32]
>>           🚧 ✅ trace: ftrace/tracer [33]
>>
>>
>>    Test source:
>>      💚 Pull requests are welcome for new tests or improvements to 
>> existing tests!
>>      [0]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>>      [1]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
>>      [2]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
>>      [3]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
>>      [4]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
>>      [5]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
>>      [6]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
>>      [7]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
>>      [8]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
>>      [9]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>>      [10]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
>>      [11]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
>>      [12]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>>      [13]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
>>      [14]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
>>      [15]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
>>      [16]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
>>      [17]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
>>      [18]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
>>      [19]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
>>      [20]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
>>      [21]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
>>      [22]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>>      [23]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>>      [24]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>>      [25]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>>      [26]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
>>      [27]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
>>      [28]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
>>      [29]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
>>      [30]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
>>      [31]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
>>      [32]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
>>      [33]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
>>      [34]: 
>> https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
>>
>> Waived tests
>> ------------
>> If the test run included waived tests, they are marked with 🚧. Such 
>> tests are
>> executed but their results are not taken into account. Tests are 
>> waived when
>> their results are not reliable enough, e.g. when they're just 
>> introduced or are
>> being fixed.
>>
>

