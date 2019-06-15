Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6D4723B
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 23:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfFOViT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 15 Jun 2019 17:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfFOViT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 17:38:19 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 897BE308FC47
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 21:38:18 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDE79600C7;
        Sat, 15 Jun 2019 21:38:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Test report for kernel 4.19.51-.cki (stable)
CC:     Petr Sklenar <psklenar@redhat.com>
Message-ID: <cki.7F4E76883C.8DHXEH6S7L@redhat.com>
X-Gitlab-Pipeline-ID: 12443
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12443?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sat, 15 Jun 2019 21:38:18 +0000 (UTC)
Date:   Sat, 15 Jun 2019 17:38:19 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 7aa823a959e1 - Linux 4.19.51

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED


One or more kernel tests failed:

  aarch64:
    ❎ tuned: tune-processes-through-perf

  ppc64le:
    ❎ tuned: tune-processes-through-perf

  s390x:
    ❎ tuned: tune-processes-through-perf

  x86_64:
    ❎ tuned: tune-processes-through-perf

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-7aa823a959e1f50c0dab9e01c1940235eccc04cc.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-7aa823a959e1f50c0dab9e01c1940235eccc04cc.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-7aa823a959e1f50c0dab9e01c1940235eccc04cc.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-7aa823a959e1f50c0dab9e01c1940235eccc04cc.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-7aa823a959e1f50c0dab9e01c1940235eccc04cc.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-7aa823a959e1f50c0dab9e01c1940235eccc04cc.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-7aa823a959e1f50c0dab9e01c1940235eccc04cc.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-7aa823a959e1f50c0dab9e01c1940235eccc04cc.tar.gz


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
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ❎ tuned: tune-processes-through-perf [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       🚧 ✅ Networking socket: fuzz [14]
       🚧 ✅ Networking sctp-auth: sockopts test [15]
       🚧 ✅ Networking: igmp conformance test [16]
       🚧 ✅ Networking route: pmtu [17]
       🚧 ✅ Networking route_func: local [18]
       🚧 ✅ Networking route_func: forward [18]
       🚧 ✅ Networking TCP: keepalive test [19]
       🚧 ✅ Networking UDP: socket [20]
       🚧 ✅ Networking tunnel: gre basic [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
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
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ❎ tuned: tune-processes-through-perf [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       🚧 ✅ Networking socket: fuzz [14]
       🚧 ✅ Networking sctp-auth: sockopts test [15]
       🚧 ✅ Networking route: pmtu [17]
       🚧 ✅ Networking route_func: local [18]
       🚧 ✅ Networking route_func: forward [18]
       🚧 ✅ Networking TCP: keepalive test [19]
       🚧 ✅ Networking UDP: socket [20]
       🚧 ✅ Networking tunnel: gre basic [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ storage: software RAID testing [26]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [27]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [28]
       ✅ xfstests: xfs [28]
       ✅ selinux-policy: serge-testsuite [29]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [29]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ❎ tuned: tune-processes-through-perf [11]
       ✅ lvm thinp sanity [13]
       🚧 ✅ Networking socket: fuzz [14]
       🚧 ✅ Networking sctp-auth: sockopts test [15]
       🚧 ✅ Networking: igmp conformance test [16]
       🚧 ✅ Networking route: pmtu [17]
       🚧 ✅ Networking route_func: local [18]
       🚧 ✅ Networking route_func: forward [18]
       🚧 ✅ Networking TCP: keepalive test [19]
       🚧 ✅ Networking UDP: socket [20]
       🚧 ✅ Networking tunnel: gre basic [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ storage: software RAID testing [26]

    Host 3:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [30]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c - megaraid_sas [30]

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
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ❎ tuned: tune-processes-through-perf [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       🚧 ✅ Networking socket: fuzz [14]
       🚧 ✅ Networking sctp-auth: sockopts test [15]
       🚧 ✅ Networking: igmp conformance test [16]
       🚧 ✅ Networking route: pmtu [17]
       🚧 ✅ Networking route_func: local [18]
       🚧 ✅ Networking route_func: forward [18]
       🚧 ✅ Networking TCP: keepalive test [19]
       🚧 ✅ Networking UDP: socket [20]
       🚧 ✅ Networking tunnel: gre basic [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ storage: SCSI VPD [25]
       🚧 ✅ storage: software RAID testing [26]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [27]

    Host 3:
       ✅ Boot test [0]
       🚧 ✅ Storage SAN device stress [31]

    Host 4:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [30]

    Host 5:
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
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
