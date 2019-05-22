Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985F2262AD
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfEVLAm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 22 May 2019 07:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbfEVLAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 07:00:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E0A010F6F
        for <stable@vger.kernel.org>; Wed, 22 May 2019 11:00:41 +0000 (UTC)
Received: from [172.54.180.135] (cpt-0029.paas.prod.upshift.rdu2.redhat.com [10.0.18.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F401D2854E;
        Wed, 22 May 2019 11:00:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.C86ED1C024.Y2Q4PFKOI7@redhat.com>
X-Gitlab-Pipeline-ID: 10566
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10566?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 22 May 2019 11:00:41 +0000 (UTC)
Date:   Wed, 22 May 2019 07:00:42 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e0e8106a6cf1 - Linux 5.1.4

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

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: e0e8106a6cf1 - Linux 5.1.4

We then merged the patchset with `git am`:

  ipv6-fix-src-addr-routing-with-the-exception-table.patch
  ipv6-prevent-possible-fib6-leaks.patch
  net-always-descend-into-dsa.patch
  net-avoid-weird-emergency-message.patch
  net-mlx4_core-change-the-error-print-to-info-print.patch
  net-test-nouarg-before-dereferencing-zerocopy-pointers.patch
  net-usb-qmi_wwan-add-telit-0x1260-and-0x1261-compositions.patch
  nfp-flower-add-rcu-locks-when-accessing-netdev-for-tunnels.patch
  ppp-deflate-fix-possible-crash-in-deflate_init.patch
  rtnetlink-always-put-ifla_link-for-links-with-a-link-netnsid.patch
  tipc-switch-order-of-device-registration-to-fix-a-crash.patch
  vsock-virtio-free-packets-during-the-socket-release.patch
  tipc-fix-modprobe-tipc-failed-after-switch-order-of-device-registration.patch
  mlxsw-core-prevent-qsfp-module-initialization-for-old-hardware.patch
  mlxsw-core-prevent-reading-unsupported-slave-address-from-sfp-eeprom.patch
  flow_offload-support-cvlan-match.patch
  net-mlx5e-fix-calling-wrong-function-to-get-inner-vlan-key-and-mask.patch
  net-mlx5-fix-peer-pf-disable-hca-command.patch
  vsock-virtio-initialize-core-virtio-vsock-before-registering-the-driver.patch
  net-mlx5e-add-missing-ethtool-driver-info-for-representors.patch
  net-mlx5e-additional-check-for-flow-destination-comparison.patch
  net-mlx5-imply-mlxfw-in-mlx5_core.patch
  net-mlx5e-fix-ethtool-rxfh-commands-when-config_mlx5_en_rxnfc-is-disabled.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-b57173cbeb9d93c5f6a492fdbfdc6949d0f21a60.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [10]
     🚧 ✅ Networking route_func: local [11]
     🚧 ✅ Networking route_func: forward [11]

  ppc64le:
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [10]
     🚧 ✅ Networking route_func: local [11]
     🚧 ✅ Networking route_func: forward [11]

  s390x:
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Ethernet drivers sanity [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [10]
     🚧 ✅ Networking route_func: local [11]
     🚧 ✅ Networking route_func: forward [11]

  x86_64:
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [10]
     🚧 ✅ Networking route_func: local [11]
     🚧 ✅ Networking route_func: forward [11]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
