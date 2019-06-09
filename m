Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1591C3ABE0
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 22:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfFIUsH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 9 Jun 2019 16:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFIUsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 16:48:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A24813082A24
        for <stable@vger.kernel.org>; Sun,  9 Jun 2019 20:48:06 +0000 (UTC)
Received: from [172.54.141.148] (cpt-large-cpu-05.paas.prod.upshift.rdu2.redhat.com [10.0.18.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 314B419729;
        Sun,  9 Jun 2019 20:48:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.9-rc1-6ae0324.cki
 (stable)
Message-ID: <cki.2DB66C69C8.4KM0LJXD37@redhat.com>
X-Gitlab-Pipeline-ID: 11865
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11865?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sun, 09 Jun 2019 20:48:06 +0000 (UTC)
Date:   Sun, 9 Jun 2019 16:48:07 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 5b3d375b3838 - Linux 5.1.9-rc1

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-5b3d375b3838a28e769a56fdcb67d5422579d53b.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-5b3d375b3838a28e769a56fdcb67d5422579d53b.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-5b3d375b3838a28e769a56fdcb67d5422579d53b.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-5b3d375b3838a28e769a56fdcb67d5422579d53b.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-5b3d375b3838a28e769a56fdcb67d5422579d53b.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-5b3d375b3838a28e769a56fdcb67d5422579d53b.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-5b3d375b3838a28e769a56fdcb67d5422579d53b.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-5b3d375b3838a28e769a56fdcb67d5422579d53b.tar.gz


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
       ✅ tuned: tune-processes-through-perf [11]
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
       🚧 ✅ Libhugetlbfs - version 2.2.1 [26]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [27]
       ✅ xfstests: xfs [27]
       ✅ selinux-policy: serge-testsuite [28]


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
       ✅ tuned: tune-processes-through-perf [11]
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
       🚧 ✅ Libhugetlbfs - version 2.2.1 [26]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [27]
       ✅ xfstests: xfs [27]
       ✅ selinux-policy: serge-testsuite [28]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [28]

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
       ✅ tuned: tune-processes-through-perf [11]
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

    Host 3:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [29]


  x86_64:
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
       ✅ tuned: tune-processes-through-perf [11]
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
       🚧 ✅ Libhugetlbfs - version 2.2.1 [26]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [27]
       ✅ xfstests: xfs [27]
       ✅ selinux-policy: serge-testsuite [28]

    Host 3:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c - megaraid_sas [29]

    Host 4:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [29]


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
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
