Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79BE32E76
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 13:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfFCLSx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 3 Jun 2019 07:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfFCLSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 07:18:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40ED83082211
        for <stable@vger.kernel.org>; Mon,  3 Jun 2019 11:18:52 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB08A4E6B2;
        Mon,  3 Jun 2019 11:18:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.C75366FB2B.VOUG2B1LQ0@redhat.com>
X-Gitlab-Pipeline-ID: 11318
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11318?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 03 Jun 2019 11:18:52 +0000 (UTC)
Date:   Mon, 3 Jun 2019 07:18:52 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 98e4b991db5a - Linux 5.1.6

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
  Commit: 98e4b991db5a - Linux 5.1.6


We then merged the patchset with `git am`:

  bonding-802.3ad-fix-slave-link-initialization-transition-states.patch
  cxgb4-offload-vlan-flows-regardless-of-vlan-ethtype.patch
  ethtool-check-for-vlan-etype-or-vlan-tci-when-parsing-flow_rule.patch
  inet-switch-ip-id-generator-to-siphash.patch
  ipv4-igmp-fix-another-memory-leak-in-igmpv3_del_delrec.patch
  ipv4-igmp-fix-build-error-if-config_ip_multicast.patch
  ipv6-consider-sk_bound_dev_if-when-binding-a-raw-socket-to-an-address.patch
  ipv6-fix-redirect-with-vrf.patch
  llc-fix-skb-leak-in-llc_build_and_send_ui_pkt.patch
  mlxsw-spectrum_acl-avoid-warning-after-identical-rules-insertion.patch
  net-dsa-mv88e6xxx-fix-handling-of-upper-half-of-stats_type_port.patch
  net-fec-fix-the-clk-mismatch-in-failed_reset-path.patch
  net-gro-fix-use-after-free-read-in-napi_gro_frags.patch
  net-mvneta-fix-err-code-path-of-probe.patch
  net-mvpp2-fix-bad-mvpp2_txq_sched_token_cntr_reg-queue-value.patch
  net-phy-marvell10g-report-if-the-phy-fails-to-boot-firmware.patch
  net-sched-don-t-use-tc_action-order-during-action-dump.patch
  net-stmmac-fix-reset-gpio-free-missing.patch
  r8169-fix-mac-address-being-lost-in-pci-d3.patch
  usbnet-fix-kernel-crash-after-disconnect.patch
  net-mlx5-avoid-double-free-in-fs-init-error-unwinding-path.patch
  tipc-avoid-copying-bytes-beyond-the-supplied-data.patch
  net-mlx5-allocate-root-ns-memory-using-kzalloc-to-match-kfree.patch
  net-mlx5e-disable-rxhash-when-cqe-compress-is-enabled.patch
  net-stmmac-fix-ethtool-flow-control-not-able-to-get-set.patch
  net-stmmac-dma-channel-control-register-need-to-be-init-first.patch
  bnxt_en-fix-aggregation-buffer-leak-under-oom-condition.patch
  bnxt_en-fix-possible-bug-condition-when-calling-pci_disable_msix.patch
  bnxt_en-reduce-memory-usage-when-running-in-kdump-kernel.patch
  net-tls-fix-lowat-calculation-if-some-data-came-from-previous-record.patch
  selftests-tls-test-for-lowat-overshoot-with-multiple-records.patch
  net-tls-fix-no-wakeup-on-partial-reads.patch
  selftests-tls-add-test-for-sleeping-even-though-there-is-data.patch
  net-tls-fix-state-removal-with-feature-flags-off.patch
  net-tls-don-t-ignore-netdev-notifications-if-no-tls-features.patch
  cxgb4-revert-cxgb4-remove-sge_host_page_size-dependency-on-page-size.patch
  net-correct-zerocopy-refcnt-with-udp-msg_more.patch
  crypto-vmx-ghash-do-nosimd-fallback-manually.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-58e7c27e45b490f036a58383f3555379b4c3a6f8.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-58e7c27e45b490f036a58383f3555379b4c3a6f8.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-58e7c27e45b490f036a58383f3555379b4c3a6f8.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-58e7c27e45b490f036a58383f3555379b4c3a6f8.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-58e7c27e45b490f036a58383f3555379b4c3a6f8.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-58e7c27e45b490f036a58383f3555379b4c3a6f8.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-58e7c27e45b490f036a58383f3555379b4c3a6f8.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-58e7c27e45b490f036a58383f3555379b4c3a6f8.tar.gz


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
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]
       🚧 ✅ Networking: igmp conformance test [11]
       🚧 ✅ Networking route: pmtu [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]


  ppc64le:
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
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]
       🚧 ✅ Networking route: pmtu [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]
       🚧 ✅ Networking: igmp conformance test [11]
       🚧 ✅ Networking route: pmtu [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


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
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]
       🚧 ✅ Networking: igmp conformance test [11]
       🚧 ✅ Networking route: pmtu [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]

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
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
