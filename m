Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63C31935
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 05:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfFADMg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 31 May 2019 23:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbfFADMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 23:12:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88CDE7FDE5
        for <stable@vger.kernel.org>; Sat,  1 Jun 2019 03:12:35 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1910419C67;
        Sat,  1 Jun 2019 03:12:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.E3FB8BA58A.3Y4857T6AW@redhat.com>
X-Gitlab-Pipeline-ID: 11270
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11270?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sat, 01 Jun 2019 03:12:35 +0000 (UTC)
Date:   Fri, 31 May 2019 23:12:36 -0400
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

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-a7775c34b124a0b99e44000b71daf8d5a1b6059d.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-a7775c34b124a0b99e44000b71daf8d5a1b6059d.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-a7775c34b124a0b99e44000b71daf8d5a1b6059d.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-a7775c34b124a0b99e44000b71daf8d5a1b6059d.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-a7775c34b124a0b99e44000b71daf8d5a1b6059d.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-a7775c34b124a0b99e44000b71daf8d5a1b6059d.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-a7775c34b124a0b99e44000b71daf8d5a1b6059d.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-a7775c34b124a0b99e44000b71daf8d5a1b6059d.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ stress: stress-ng [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking: igmp conformance test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [13]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ stress: stress-ng [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [13]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ stress: stress-ng [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking: igmp conformance test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [13]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [13]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ stress: stress-ng [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking: igmp conformance test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
