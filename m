Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA54F5DB
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVNTG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 22 Jun 2019 09:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFVNTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 09:19:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E35233082E42
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 13:19:05 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37E14608CD;
        Sat, 22 Jun 2019 13:19:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Test report for kernel 5.1.14-5f0a74b.cki
 (stable)
CC:     Milos Malik <mmalik@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Message-ID: <cki.3157CB6A6A.NH1HFIJKAP@redhat.com>
X-Gitlab-Pipeline-ID: 13039
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 22 Jun 2019 13:19:05 +0000 (UTC)
Date:   Sat, 22 Jun 2019 09:19:06 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 5f0a74b46855 - Linux 5.1.14

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED



One or more kernel tests failed:

  x86_64:
    ❎ selinux-policy: serge-testsuite

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-5f0a74b4685567c2416d7bba1b5bc9d32f598fc3.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ AMTU (Abstract Machine Test Utility) [6]
       ✅ LTP: openposix test suite [7]
       ✅ Ethernet drivers sanity [8]
       ✅ audit: audit testsuite test [9]
       ✅ httpd: mod_ssl smoke sanity [10]
       ✅ iotop: sanity [11]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [12]
       ✅ Usex - version 1.9-29 [13]
       ✅ lvm thinp sanity [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking: igmp conformance test [17]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: gre basic [22]
       🚧 ✅ Networking tunnel: vxlan basic [23]
       🚧 ✅ Networking tunnel: geneve basic test [24]
       🚧 ✅ Networking ipsec: basic netns transport [25]
       🚧 ✅ Networking ipsec: basic netns tunnel [25]
       🚧 ✅ tuned: tune-processes-through-perf [26]
       🚧 ✅ storage: SCSI VPD [27]
       🚧 ✅ storage: software RAID testing [28]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [29]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ AMTU (Abstract Machine Test Utility) [6]
       ✅ LTP: openposix test suite [7]
       ✅ Ethernet drivers sanity [8]
       ✅ audit: audit testsuite test [9]
       ✅ httpd: mod_ssl smoke sanity [10]
       ✅ iotop: sanity [11]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [12]
       ✅ Usex - version 1.9-29 [13]
       ✅ lvm thinp sanity [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: gre basic [22]
       🚧 ✅ Networking tunnel: vxlan basic [23]
       🚧 ✅ Networking tunnel: geneve basic test [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [25]
       🚧 ✅ tuned: tune-processes-through-perf [26]
       🚧 ✅ storage: software RAID testing [28]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [29]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ LTP: openposix test suite [7]
       ✅ Ethernet drivers sanity [8]
       ✅ audit: audit testsuite test [9]
       ✅ httpd: mod_ssl smoke sanity [10]
       ✅ iotop: sanity [11]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [12]
       ✅ lvm thinp sanity [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking: igmp conformance test [17]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: gre basic [22]
       🚧 ✅ Networking tunnel: vxlan basic [23]
       🚧 ✅ Networking tunnel: geneve basic test [24]
       🚧 ✅ Networking ipsec: basic netns transport [25]
       🚧 ✅ Networking ipsec: basic netns tunnel [25]
       🚧 ✅ tuned: tune-processes-through-perf [26]
       🚧 ✅ storage: software RAID testing [28]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]

    Host 3:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [30]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
       ✅ xfstests: xfs [1]
       ❎ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [30]

    Host 3:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ AMTU (Abstract Machine Test Utility) [6]
       ✅ LTP: openposix test suite [7]
       ✅ Ethernet drivers sanity [8]
       ✅ audit: audit testsuite test [9]
       ✅ httpd: mod_ssl smoke sanity [10]
       ✅ iotop: sanity [11]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [12]
       ✅ Usex - version 1.9-29 [13]
       ✅ lvm thinp sanity [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking: igmp conformance test [17]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: gre basic [22]
       🚧 ✅ Networking tunnel: vxlan basic [23]
       🚧 ✅ Networking tunnel: geneve basic test [24]
       🚧 ✅ Networking ipsec: basic netns transport [25]
       🚧 ✅ Networking ipsec: basic netns tunnel [25]
       🚧 ✅ tuned: tune-processes-through-perf [26]
       🚧 ✅ storage: SCSI VPD [27]
       🚧 ✅ storage: software RAID testing [28]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [29]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
