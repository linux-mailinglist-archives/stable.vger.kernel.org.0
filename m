Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302A825A59
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 00:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEUWfv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 May 2019 18:35:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfEUWfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 18:35:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 621FB368E0
        for <stable@vger.kernel.org>; Tue, 21 May 2019 22:35:50 +0000 (UTC)
Received: from [172.54.180.135] (cpt-0029.paas.prod.upshift.rdu2.redhat.com [10.0.18.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B13860CCD;
        Tue, 21 May 2019 22:35:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.4-rc2-2337ba4.cki
 (stable)
Message-ID: <cki.36A36AFC15.0ZY6VUFCRN@redhat.com>
X-Gitlab-Pipeline-ID: 10526
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10526?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 21 May 2019 22:35:50 +0000 (UTC)
Date:   Tue, 21 May 2019 18:35:51 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: a8112defa801 - Linux 5.1.4-rc2

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
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-a8112defa801e2b32d9da822880f32966d30158c.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-a8112defa801e2b32d9da822880f32966d30158c.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-a8112defa801e2b32d9da822880f32966d30158c.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-a8112defa801e2b32d9da822880f32966d30158c.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-a8112defa801e2b32d9da822880f32966d30158c.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-a8112defa801e2b32d9da822880f32966d30158c.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-a8112defa801e2b32d9da822880f32966d30158c.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-a8112defa801e2b32d9da822880f32966d30158c.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
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
     ✅ stress: stress-ng [14]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [15]
     ✅ xfstests: xfs [15]
     ✅ selinux-policy: serge-testsuite [16]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [17]
     🚧 ✅ Networking: igmp conformance test [18]
     🚧 ✅ Networking route: pmtu [19]
     🚧 ✅ Networking route_func: local [20]
     🚧 ✅ Networking route_func: forward [20]
     🚧 ✅ Networking TCP: keepalive test [21]
     🚧 ✅ Storage blktests [22]

  ppc64le:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [15]
     ✅ xfstests: xfs [15]
     ✅ selinux-policy: serge-testsuite [16]
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
     ✅ stress: stress-ng [14]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [17]
     🚧 ✅ Networking route: pmtu [19]
     🚧 ✅ Networking route_func: local [20]
     🚧 ✅ Networking route_func: forward [20]
     🚧 ✅ Networking TCP: keepalive test [21]
     🚧 ✅ Storage blktests [22]

  s390x:

  x86_64:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [15]
     ✅ xfstests: xfs [15]
     ✅ selinux-policy: serge-testsuite [16]
     ✅ Boot test [0]
     ✅ kdump: sysrq-c [23]
     ✅ Boot test [0]
     ✅ kdump: sysrq-c - megaraid_sas [23]
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
     ✅ stress: stress-ng [14]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [17]
     🚧 ✅ Networking: igmp conformance test [18]
     🚧 ✅ Networking route: pmtu [19]
     🚧 ✅ Networking route_func: local [20]
     🚧 ✅ Networking route_func: forward [20]
     🚧 ✅ Networking TCP: keepalive test [21]
     🚧 ✅ Storage blktests [22]

  Test source:
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
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
