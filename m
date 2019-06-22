Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD424F7EB
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 21:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFVT0b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 22 Jun 2019 15:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFVT0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 15:26:31 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2A0030842A8
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 19:26:30 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DB7519C6A;
        Sat, 22 Jun 2019 19:26:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.15-rc1-63107af.cki
 (stable)
Message-ID: <cki.2798A2B3BF.Q92TLMXL13@redhat.com>
X-Gitlab-Pipeline-ID: 13045
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sat, 22 Jun 2019 19:26:30 +0000 (UTC)
Date:   Sat, 22 Jun 2019 15:26:31 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 63107af0b542 - Linux 5.1.15-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK


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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-63107af0b542ae1e35c077a93b884cff3e00eed3.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-63107af0b542ae1e35c077a93b884cff3e00eed3.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-63107af0b542ae1e35c077a93b884cff3e00eed3.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-63107af0b542ae1e35c077a93b884cff3e00eed3.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-63107af0b542ae1e35c077a93b884cff3e00eed3.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-63107af0b542ae1e35c077a93b884cff3e00eed3.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-63107af0b542ae1e35c077a93b884cff3e00eed3.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-63107af0b542ae1e35c077a93b884cff3e00eed3.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ LTP: openposix test suite [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [10]
       ✅ Usex - version 1.9-29 [11]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ Networking sctp-auth: sockopts test [14]
       🚧 ✅ Networking: igmp conformance test [15]
       🚧 ✅ Networking route: pmtu [16]
       🚧 ✅ Networking route_func: local [17]
       🚧 ✅ Networking route_func: forward [17]
       🚧 ✅ Networking TCP: keepalive test [18]
       🚧 ✅ Networking UDP: socket [19]
       🚧 ✅ Networking tunnel: gre basic [20]
       🚧 ✅ Networking tunnel: vxlan basic [21]
       🚧 ✅ Networking tunnel: geneve basic test [22]
       🚧 ✅ Networking ipsec: basic netns transport [23]
       🚧 ✅ Networking ipsec: basic netns tunnel [23]
       🚧 ✅ tuned: tune-processes-through-perf [24]
       🚧 ✅ storage: SCSI VPD [25]
       🚧 ✅ storage: software RAID testing [26]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [27]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [28]
       ✅ xfstests: xfs [28]
       ✅ selinux-policy: serge-testsuite [29]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [28]
       ✅ xfstests: xfs [28]
       ✅ selinux-policy: serge-testsuite [29]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ LTP: openposix test suite [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [10]
       ✅ Usex - version 1.9-29 [11]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ Networking sctp-auth: sockopts test [14]
       🚧 ✅ Networking route: pmtu [16]
       🚧 ✅ Networking route_func: local [17]
       🚧 ✅ Networking route_func: forward [17]
       🚧 ✅ Networking TCP: keepalive test [18]
       🚧 ✅ Networking UDP: socket [19]
       🚧 ✅ Networking tunnel: gre basic [20]
       🚧 ✅ Networking tunnel: vxlan basic [21]
       🚧 ✅ Networking tunnel: geneve basic test [22]
       🚧 ✅ Networking ipsec: basic netns tunnel [23]
       🚧 ✅ tuned: tune-processes-through-perf [24]
       🚧 ✅ storage: software RAID testing [26]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [27]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [30]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [29]

    Host 3:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ LTP: openposix test suite [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [10]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ Networking sctp-auth: sockopts test [14]
       🚧 ✅ Networking: igmp conformance test [15]
       🚧 ✅ Networking route: pmtu [16]
       🚧 ✅ Networking route_func: local [17]
       🚧 ✅ Networking route_func: forward [17]
       🚧 ✅ Networking TCP: keepalive test [18]
       🚧 ✅ Networking UDP: socket [19]
       🚧 ✅ Networking tunnel: gre basic [20]
       🚧 ✅ Networking tunnel: vxlan basic [21]
       🚧 ✅ Networking tunnel: geneve basic test [22]
       🚧 ✅ Networking ipsec: basic netns transport [23]
       🚧 ✅ Networking ipsec: basic netns tunnel [23]
       🚧 ✅ tuned: tune-processes-through-perf [24]
       🚧 ✅ storage: software RAID testing [26]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [30]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ LTP: openposix test suite [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [10]
       ✅ Usex - version 1.9-29 [11]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ Networking sctp-auth: sockopts test [14]
       🚧 ✅ Networking: igmp conformance test [15]
       🚧 ✅ Networking route: pmtu [16]
       🚧 ✅ Networking route_func: local [17]
       🚧 ✅ Networking route_func: forward [17]
       🚧 ✅ Networking TCP: keepalive test [18]
       🚧 ✅ Networking UDP: socket [19]
       🚧 ✅ Networking tunnel: gre basic [20]
       🚧 ✅ Networking tunnel: vxlan basic [21]
       🚧 ✅ Networking tunnel: geneve basic test [22]
       🚧 ✅ Networking ipsec: basic netns transport [23]
       🚧 ✅ Networking ipsec: basic netns tunnel [23]
       🚧 ✅ tuned: tune-processes-through-perf [24]
       🚧 ✅ storage: SCSI VPD [25]
       🚧 ✅ storage: software RAID testing [26]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [27]

    Host 3:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [28]
       ✅ xfstests: xfs [28]
       ✅ selinux-policy: serge-testsuite [29]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
