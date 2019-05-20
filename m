Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E1E23E75
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733307AbfETRZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390216AbfETRZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 13:25:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DBB7307D860
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:25:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-200.rdu2.redhat.com [10.10.120.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0313D46E61;
        Mon, 20 May 2019 17:25:25 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8e_FAIL=3a_Test_report_for_kernel_5=2e1=2e4-?=
 =?UTF-8?Q?rc1-2683da8=2ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Xiong Zhou <xzhou@redhat.com>
References: <cki.30F349B00C.9VYWGI0LHP@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <89b71b36-c9e1-da13-f889-fa38747cdb06@redhat.com>
Date:   Mon, 20 May 2019 13:25:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <cki.30F349B00C.9VYWGI0LHP@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 20 May 2019 17:25:28 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please disregard, this appears to be an infrastructure failure related 
to a timeout when attempting
to curl the rpcgen package, we will look into updating the test to abort 
in this case (infra failure), sorry
for the noise !

- Rachel

On 5/20/19 12:59 PM, CKI Project wrote:
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>              Commit: cce3bc9ebd2f - Linux 5.1.4-rc1
>
> The results of these automated tests are provided below.
>
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>
>
> One or more kernel tests failed:
>
>    aarch64:
>      ❎ xfstests: ext4
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
>    aarch64:
>      build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>      configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.config
>      kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.tar.gz
>
>    ppc64le:
>      build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>      configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.config
>      kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.tar.gz
>
>    s390x:
>      build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>      configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.config
>      kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.tar.gz
>
>    x86_64:
>      build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>      configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.config
>      kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45.tar.gz
>
>
> Hardware testing
> ----------------
>
> We booted each kernel and ran the following tests:
>
>    aarch64:
>       ✅ Boot test [0]
>       ❎ xfstests: ext4 [1]
>       ✅ xfstests: xfs [1]
>       ✅ selinux-policy: serge-testsuite [2]
>       ✅ Boot test [0]
>       ✅ LTP lite [3]
>       ✅ Loopdev Sanity [4]
>       ✅ Memory function: memfd_create [5]
>       ✅ AMTU (Abstract Machine Test Utility) [6]
>       ✅ Ethernet drivers sanity [7]
>       ✅ audit: audit testsuite test [8]
>       ✅ httpd: mod_ssl smoke sanity [9]
>       ✅ iotop: sanity [10]
>       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
>       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
>       ✅ tuned: tune-processes-through-perf [13]
>       ✅ Usex - version 1.9-29 [14]
>       ✅ lvm thinp sanity [15]
>       ✅ stress: stress-ng [16]
>       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
>       🚧 ✅ Networking sctp-auth: sockopts test [17]
>       🚧 ✅ Networking: igmp conformance test [18]
>       🚧 ✅ Networking route: pmtu [19]
>       🚧 ✅ Networking route_func: local [20]
>       🚧 ✅ Networking route_func: forward [20]
>       🚧 ✅ Networking TCP: keepalive test [21]
>       🚧 ✅ Storage blktests [22]
>
>    ppc64le:
>       ✅ Boot test [0]
>       ✅ LTP lite [3]
>       ✅ Loopdev Sanity [4]
>       ✅ Memory function: memfd_create [5]
>       ✅ AMTU (Abstract Machine Test Utility) [6]
>       ✅ Ethernet drivers sanity [7]
>       ✅ audit: audit testsuite test [8]
>       ✅ httpd: mod_ssl smoke sanity [9]
>       ✅ iotop: sanity [10]
>       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
>       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
>       ✅ tuned: tune-processes-through-perf [13]
>       ✅ Usex - version 1.9-29 [14]
>       ✅ lvm thinp sanity [15]
>       ✅ stress: stress-ng [16]
>       ✅ Boot test [0]
>       ✅ xfstests: ext4 [1]
>       ✅ xfstests: xfs [1]
>       ✅ selinux-policy: serge-testsuite [2]
>       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
>       🚧 ✅ Networking sctp-auth: sockopts test [17]
>       🚧 ✅ Networking route: pmtu [19]
>       🚧 ✅ Networking route_func: local [20]
>       🚧 ✅ Networking route_func: forward [20]
>       🚧 ✅ Networking TCP: keepalive test [21]
>       🚧 ✅ Storage blktests [22]
>
>    s390x:
>       ✅ Boot test [0]
>       ✅ LTP lite [3]
>       ✅ Loopdev Sanity [4]
>       ✅ Memory function: memfd_create [5]
>       ✅ Ethernet drivers sanity [7]
>       ✅ audit: audit testsuite test [8]
>       ✅ httpd: mod_ssl smoke sanity [9]
>       ✅ iotop: sanity [10]
>       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
>       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
>       ✅ tuned: tune-processes-through-perf [13]
>       ✅ Usex - version 1.9-29 [14]
>       ✅ lvm thinp sanity [15]
>       ✅ stress: stress-ng [16]
>       ✅ Boot test [0]
>       ✅ kdump: sysrq-c [23]
>       ✅ Boot test [0]
>       ✅ selinux-policy: serge-testsuite [2]
>       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
>       🚧 ✅ Networking sctp-auth: sockopts test [17]
>       🚧 ✅ Networking: igmp conformance test [18]
>       🚧 ✅ Networking route: pmtu [19]
>       🚧 ✅ Networking route_func: local [20]
>       🚧 ✅ Networking route_func: forward [20]
>       🚧 ✅ Networking TCP: keepalive test [21]
>       🚧 ✅ Storage blktests [22]
>
>    x86_64:
>       ✅ Boot test [0]
>       ✅ xfstests: ext4 [1]
>       ✅ xfstests: xfs [1]
>       ✅ selinux-policy: serge-testsuite [2]
>       ✅ Boot test [0]
>       ✅ LTP lite [3]
>       ✅ Loopdev Sanity [4]
>       ✅ Memory function: memfd_create [5]
>       ✅ AMTU (Abstract Machine Test Utility) [6]
>       ✅ Ethernet drivers sanity [7]
>       ✅ audit: audit testsuite test [8]
>       ✅ httpd: mod_ssl smoke sanity [9]
>       ✅ iotop: sanity [10]
>       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
>       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
>       ✅ tuned: tune-processes-through-perf [13]
>       ✅ Usex - version 1.9-29 [14]
>       ✅ lvm thinp sanity [15]
>       ✅ stress: stress-ng [16]
>       ✅ Boot test [0]
>       ✅ kdump: sysrq-c - megaraid_sas [23]
>       ✅ Boot test [0]
>       ✅ kdump: sysrq-c [23]
>       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
>       🚧 ✅ Networking sctp-auth: sockopts test [17]
>       🚧 ✅ Networking: igmp conformance test [18]
>       🚧 ✅ Networking route: pmtu [19]
>       🚧 ✅ Networking route_func: local [20]
>       🚧 ✅ Networking route_func: forward [20]
>       🚧 ✅ Networking TCP: keepalive test [21]
>       🚧 ✅ Storage blktests [22]
>
>    Test source:
>      [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>      [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
>      [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
>      [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
>      [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>      [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
>      [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>      [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
>      [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>      [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>      [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>      [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
>      [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
>      [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>      [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
>      [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
>      [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
>      [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
>      [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
>      [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
>      [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
>      [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
>      [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
>      [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c
>
> Waived tests (marked with 🚧)
> -----------------------------
> This test run included waived tests. Such tests are executed but their results
> are not taken into account. Tests are waived when their results are not
> reliable enough, e.g. when they're just introduced or are being fixed.
>

