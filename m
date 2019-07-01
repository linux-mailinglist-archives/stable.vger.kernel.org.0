Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130EA3196F
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 06:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfFAEHe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 1 Jun 2019 00:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfFAEHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 00:07:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B7AE30832CE
        for <stable@vger.kernel.org>; Sat,  1 Jun 2019 04:07:33 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 044011001DC8;
        Sat,  1 Jun 2019 04:07:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Test report for kernel 4.19.48-rc1-baa2ff4.cki
 (stable)
CC:     Xiong Zhou <xzhou@redhat.com>
Message-ID: <cki.49913B359B.I5P0A66ZVQ@redhat.com>
X-Gitlab-Pipeline-ID: 11272
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11272?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sat, 01 Jun 2019 04:07:33 +0000 (UTC)
Date:   Sat, 1 Jun 2019 00:07:34 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 822c65132427 - Linux 4.19.48-rc1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED


One or more kernel tests failed:

  ppc64le:
    ❎ xfstests: xfs

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-822c6513242770ce895c1cf4a684e91c6081bdc8.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-822c6513242770ce895c1cf4a684e91c6081bdc8.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-822c6513242770ce895c1cf4a684e91c6081bdc8.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-822c6513242770ce895c1cf4a684e91c6081bdc8.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-822c6513242770ce895c1cf4a684e91c6081bdc8.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-822c6513242770ce895c1cf4a684e91c6081bdc8.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-822c6513242770ce895c1cf4a684e91c6081bdc8.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-822c6513242770ce895c1cf4a684e91c6081bdc8.tar.gz


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
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
       ✅ tuned: tune-processes-through-perf [13]
       ✅ Usex - version 1.9-29 [14]
       ✅ lvm thinp sanity [15]
       ✅ storage: SCSI VPD [16]
       ✅ stress: stress-ng [17]
       🚧 ✅ Networking socket: fuzz [18]
       🚧 ✅ Networking sctp-auth: sockopts test [19]
       🚧 ✅ Networking: igmp conformance test [20]
       🚧 ✅ Networking route: pmtu [21]
       🚧 ✅ Networking route_func: local [22]
       🚧 ✅ Networking route_func: forward [22]
       🚧 ✅ Networking TCP: keepalive test [23]
       🚧 ✅ Networking UDP: socket [24]
       🚧 ✅ Networking tunnel: vxlan basic [25]
       🚧 ✅ Networking tunnel: geneve basic test [26]
       🚧 ✅ Networking ipsec: basic netns transport [27]
       🚧 ✅ Networking ipsec: basic netns tunnel [27]
       🚧 ✅ Storage blktests [28]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ AMTU (Abstract Machine Test Utility) [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
       ✅ tuned: tune-processes-through-perf [13]
       ✅ Usex - version 1.9-29 [14]
       ✅ lvm thinp sanity [15]
       ✅ stress: stress-ng [17]
       🚧 ✅ Networking socket: fuzz [18]
       🚧 ✅ Networking sctp-auth: sockopts test [19]
       🚧 ✅ Networking route: pmtu [21]
       🚧 ✅ Networking route_func: local [22]
       🚧 ✅ Networking route_func: forward [22]
       🚧 ✅ Networking TCP: keepalive test [23]
       🚧 ✅ Networking UDP: socket [24]
       🚧 ✅ Networking tunnel: vxlan basic [25]
       🚧 ✅ Networking tunnel: geneve basic test [26]
       🚧 ✅ Networking ipsec: basic netns tunnel [27]
       🚧 ✅ Storage blktests [28]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
       ❎ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
       ✅ tuned: tune-processes-through-perf [13]
       ✅ lvm thinp sanity [15]
       ✅ stress: stress-ng [17]
       🚧 ✅ Networking socket: fuzz [18]
       🚧 ✅ Networking sctp-auth: sockopts test [19]
       🚧 ✅ Networking: igmp conformance test [20]
       🚧 ✅ Networking route: pmtu [21]
       🚧 ✅ Networking route_func: local [22]
       🚧 ✅ Networking route_func: forward [22]
       🚧 ✅ Networking TCP: keepalive test [23]
       🚧 ✅ Networking UDP: socket [24]
       🚧 ✅ Networking tunnel: vxlan basic [25]
       🚧 ✅ Networking tunnel: geneve basic test [26]
       🚧 ✅ Networking ipsec: basic netns transport [27]
       🚧 ✅ Networking ipsec: basic netns tunnel [27]
       🚧 ✅ Storage blktests [28]

    Host 2:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [29]

    Host 3:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c - megaraid_sas [29]

    Host 3:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Memory function: memfd_create [5]
       ✅ AMTU (Abstract Machine Test Utility) [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
       ✅ tuned: tune-processes-through-perf [13]
       ✅ Usex - version 1.9-29 [14]
       ✅ lvm thinp sanity [15]
       ✅ storage: SCSI VPD [16]
       ✅ stress: stress-ng [17]
       🚧 ✅ Networking socket: fuzz [18]
       🚧 ✅ Networking sctp-auth: sockopts test [19]
       🚧 ✅ Networking: igmp conformance test [20]
       🚧 ✅ Networking route: pmtu [21]
       🚧 ✅ Networking route_func: local [22]
       🚧 ✅ Networking route_func: forward [22]
       🚧 ✅ Networking TCP: keepalive test [23]
       🚧 ✅ Networking UDP: socket [24]
       🚧 ✅ Networking tunnel: vxlan basic [25]
       🚧 ✅ Networking tunnel: geneve basic test [26]
       🚧 ✅ Networking ipsec: basic netns transport [27]
       🚧 ✅ Networking ipsec: basic netns tunnel [27]
       🚧 ✅ Storage blktests [28]

    Host 4:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [29]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
