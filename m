Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD3337B1
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfFCSSK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 3 Jun 2019 14:18:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfFCSSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 14:18:09 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F057C18B2EE
        for <stable@vger.kernel.org>; Mon,  3 Jun 2019 18:18:09 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88F57601B6;
        Mon,  3 Jun 2019 18:18:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.6B057C2086.431VGH2YOL@redhat.com>
X-Gitlab-Pipeline-ID: 11326
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11326?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 03 Jun 2019 18:18:09 +0000 (UTC)
Date:   Mon, 3 Jun 2019 14:18:09 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 0df021b2e841 - Linux 4.19.47

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
  Commit: 0df021b2e841 - Linux 4.19.47


We then merged the patchset with `git am`:

  bonding-802.3ad-fix-slave-link-initialization-transition-states.patch
  cxgb4-offload-vlan-flows-regardless-of-vlan-ethtype.patch
  inet-switch-ip-id-generator-to-siphash.patch
  ipv4-igmp-fix-another-memory-leak-in-igmpv3_del_delrec.patch
  ipv4-igmp-fix-build-error-if-config_ip_multicast.patch
  ipv6-consider-sk_bound_dev_if-when-binding-a-raw-socket-to-an-address.patch
  ipv6-fix-redirect-with-vrf.patch
  llc-fix-skb-leak-in-llc_build_and_send_ui_pkt.patch
  net-dsa-mv88e6xxx-fix-handling-of-upper-half-of-stats_type_port.patch
  net-fec-fix-the-clk-mismatch-in-failed_reset-path.patch
  net-gro-fix-use-after-free-read-in-napi_gro_frags.patch
  net-mvneta-fix-err-code-path-of-probe.patch
  net-mvpp2-fix-bad-mvpp2_txq_sched_token_cntr_reg-queue-value.patch
  net-phy-marvell10g-report-if-the-phy-fails-to-boot-firmware.patch
  net-sched-don-t-use-tc_action-order-during-action-dump.patch
  net-stmmac-fix-reset-gpio-free-missing.patch
  usbnet-fix-kernel-crash-after-disconnect.patch
  net-mlx5-avoid-double-free-in-fs-init-error-unwinding-path.patch
  tipc-avoid-copying-bytes-beyond-the-supplied-data.patch
  net-mlx5-allocate-root-ns-memory-using-kzalloc-to-match-kfree.patch
  net-mlx5e-disable-rxhash-when-cqe-compress-is-enabled.patch
  net-stmmac-dma-channel-control-register-need-to-be-init-first.patch
  bnxt_en-fix-aggregation-buffer-leak-under-oom-condition.patch
  net-tls-fix-state-removal-with-feature-flags-off.patch
  net-tls-don-t-ignore-netdev-notifications-if-no-tls-features.patch
  crypto-vmx-ghash-do-nosimd-fallback-manually.patch
  include-linux-compiler-.h-define-asm_volatile_goto.patch
  compiler.h-give-up-__compiletime_assert_fallback.patch
  jump_label-move-asm-goto-support-test-to-kconfig.patch
  xen-pciback-don-t-disable-pci_command-on-pci-device-reset.patch
  revert-tipc-fix-modprobe-tipc-failed-after-switch-order-of-device-registration.patch
  tipc-fix-modprobe-tipc-failed-after-switch-order-of-device-registration.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-bf5441f7df155c3a9c059d9fca05cf933d9de552.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-bf5441f7df155c3a9c059d9fca05cf933d9de552.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-bf5441f7df155c3a9c059d9fca05cf933d9de552.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-bf5441f7df155c3a9c059d9fca05cf933d9de552.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-bf5441f7df155c3a9c059d9fca05cf933d9de552.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-bf5441f7df155c3a9c059d9fca05cf933d9de552.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-bf5441f7df155c3a9c059d9fca05cf933d9de552.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-bf5441f7df155c3a9c059d9fca05cf933d9de552.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       ✅ stress: stress-ng [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking: igmp conformance test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       ✅ stress: stress-ng [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ stress: stress-ng [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking: igmp conformance test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       ✅ stress: stress-ng [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking: igmp conformance test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
