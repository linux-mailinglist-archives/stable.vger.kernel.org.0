Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC0F4C1A9
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 21:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfFSTo2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 19 Jun 2019 15:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfFSTo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 15:44:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B781D309703F
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 19:44:27 +0000 (UTC)
Received: from [172.54.67.194] (cpt-large-cpu-02.paas.prod.upshift.rdu2.redhat.com [10.0.18.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C33E06012D;
        Wed, 19 Jun 2019 19:44:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.12-5752b50.cki
 (stable)
Message-ID: <cki.04133F50A7.RT6JBFWUZ0@redhat.com>
X-Gitlab-Pipeline-ID: 12751
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 19 Jun 2019 19:44:27 +0000 (UTC)
Date:   Wed, 19 Jun 2019 15:44:28 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 5752b50477da - Linux 5.1.12

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-5752b50477dace442b8ca238a6957918436efeeb.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-5752b50477dace442b8ca238a6957918436efeeb.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-5752b50477dace442b8ca238a6957918436efeeb.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-5752b50477dace442b8ca238a6957918436efeeb.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-5752b50477dace442b8ca238a6957918436efeeb.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-5752b50477dace442b8ca238a6957918436efeeb.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-5752b50477dace442b8ca238a6957918436efeeb.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-5752b50477dace442b8ca238a6957918436efeeb.tar.gz


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
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ Usex - version 1.9-29 [10]
       ✅ lvm thinp sanity [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking: igmp conformance test [14]
       🚧 ✅ Networking route: pmtu [15]
       🚧 ✅ Networking route_func: local [16]
       🚧 ✅ Networking route_func: forward [16]
       🚧 ✅ Networking TCP: keepalive test [17]
       🚧 ✅ Networking UDP: socket [18]
       🚧 ✅ Networking tunnel: gre basic [19]
       🚧 ✅ Networking tunnel: vxlan basic [20]
       🚧 ✅ Networking tunnel: geneve basic test [21]
       🚧 ✅ Networking ipsec: basic netns transport [22]
       🚧 ✅ Networking ipsec: basic netns tunnel [22]
       🚧 ✅ tuned: tune-processes-through-perf [23]
       🚧 ✅ storage: SCSI VPD [24]
       🚧 ✅ storage: software RAID testing [25]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [26]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [27]
       ✅ xfstests: xfs [27]
       ✅ selinux-policy: serge-testsuite [28]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [27]
       ✅ xfstests: xfs [27]
       ✅ selinux-policy: serge-testsuite [28]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ Usex - version 1.9-29 [10]
       ✅ lvm thinp sanity [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking route: pmtu [15]
       🚧 ✅ Networking route_func: local [16]
       🚧 ✅ Networking route_func: forward [16]
       🚧 ✅ Networking TCP: keepalive test [17]
       🚧 ✅ Networking UDP: socket [18]
       🚧 ✅ Networking tunnel: gre basic [19]
       🚧 ✅ Networking tunnel: vxlan basic [20]
       🚧 ✅ Networking tunnel: geneve basic test [21]
       🚧 ✅ Networking ipsec: basic netns tunnel [22]
       🚧 ✅ tuned: tune-processes-through-perf [23]
       🚧 ✅ storage: software RAID testing [25]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [26]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ lvm thinp sanity [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking: igmp conformance test [14]
       🚧 ✅ Networking route: pmtu [15]
       🚧 ✅ Networking route_func: local [16]
       🚧 ✅ Networking route_func: forward [16]
       🚧 ✅ Networking TCP: keepalive test [17]
       🚧 ✅ Networking UDP: socket [18]
       🚧 ✅ Networking tunnel: gre basic [19]
       🚧 ✅ Networking tunnel: vxlan basic [20]
       🚧 ✅ Networking tunnel: geneve basic test [21]
       🚧 ✅ Networking ipsec: basic netns transport [22]
       🚧 ✅ Networking ipsec: basic netns tunnel [22]
       🚧 ✅ tuned: tune-processes-through-perf [23]
       🚧 ✅ storage: software RAID testing [25]

    Host 2:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [29]

    Host 3:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [28]


  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
