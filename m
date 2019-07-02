Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D15CE66
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 13:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbfGBL3r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 2 Jul 2019 07:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbfGBL3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 07:29:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 583A7882FD
        for <stable@vger.kernel.org>; Tue,  2 Jul 2019 11:29:46 +0000 (UTC)
Received: from [172.54.126.116] (cpt-1022.paas.prod.upshift.rdu2.redhat.com [10.0.19.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D25717253;
        Tue,  2 Jul 2019 11:29:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.78B99999BB.LZJX3RGX16@redhat.com>
X-Gitlab-Pipeline-ID: 14997
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 02 Jul 2019 11:29:46 +0000 (UTC)
Date:   Tue, 2 Jul 2019 07:29:47 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: f0fae702de30 - Linux 5.1.15

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
  Commit: f0fae702de30 - Linux 5.1.15


We grabbed the b928c8df27e4 commit of the stable queue repository.

We then merged the patchset with `git am`:

  arm64-don-t-unconditionally-add-wno-psabi-to-kbuild_cflags.patch
  revert-x86-uaccess-ftrace-fix-ftrace_likely_update-v.patch
  qmi_wwan-fix-out-of-bounds-read.patch
  fs-proc-array.c-allow-reporting-eip-esp-for-all-coredumping-threads.patch
  mm-mempolicy.c-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch
  fs-binfmt_flat.c-make-load_flat_shared_library-work.patch
  clk-tegra210-fix-default-rates-for-hda-clocks.patch
  clk-socfpga-stratix10-fix-divider-entry-for-the-emac-clocks.patch
  drm-i915-force-2-96-mhz-cdclk-on-glk-cnl-when-audio-power-is-enabled.patch
  drm-i915-save-the-old-cdclk-atomic-state.patch
  drm-i915-remove-redundant-store-of-logical-cdclk-state.patch
  drm-i915-skip-modeset-for-cdclk-changes-if-possible.patch
  mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails.patch
  mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge.patch
  mm-page_idle.c-fix-oops-because-end_pfn-is-larger-than-max_pfn.patch
  mm-swap-fix-thp-swap-out.patch
  dm-init-fix-incorrect-uses-of-kstrndup.patch
  dm-log-writes-make-sure-super-sector-log-updates-are-written-in-order.patch
  io_uring-ensure-req-file-is-cleared-on-allocation.patch
  scsi-vmw_pscsi-fix-use-after-free-in-pvscsi_queue_lck.patch
  x86-speculation-allow-guests-to-use-ssbd-even-if-host-does-not.patch
  x86-microcode-fix-the-microcode-load-on-cpu-hotplug-for-real.patch
  x86-resctrl-prevent-possible-overrun-during-bitmap-operations.patch
  mm-fix-page-cache-convergence-regression.patch
  efi-memreserve-deal-with-memreserve-entries-in-unmapped-memory.patch
  nfs-flexfiles-use-the-correct-tcp-timeout-for-flexfiles-i-o.patch
  cpu-speculation-warn-on-unsupported-mitigations-parameter.patch
  sunrpc-fix-up-calculation-of-client-message-length.patch
  irqchip-mips-gic-use-the-correct-local-interrupt-map-registers.patch
  af_packet-block-execution-of-tasks-waiting-for-transmit-to-complete-in-af_packet.patch
  bonding-always-enable-vlan-tx-offload.patch
  ipv4-use-return-value-of-inet_iif-for-__raw_v4_lookup-in-the-while-loop.patch
  net-packet-fix-memory-leak-in-packet_set_ring.patch
  net-remove-duplicate-fetch-in-sock_getsockopt.patch
  net-stmmac-fixed-new-system-time-seconds-value-calculation.patch
  net-stmmac-set-ic-bit-when-transmitting-frames-with-hw-timestamp.patch
  net-tls-fix-page-double-free-on-tx-cleanup.patch
  sctp-change-to-hold-sk-after-auth-shkey-is-created-successfully.patch
  team-always-enable-vlan-tx-offload.patch
  tipc-change-to-use-register_pernet_device.patch
  tipc-check-msg-req-data-len-in-tipc_nl_compat_bearer_disable.patch
  tun-wake-up-waitqueues-after-iff_up-is-set.patch
  net-aquantia-fix-vlans-not-working-over-bridged-network.patch
  bpf-simplify-definition-of-bpf_fib_lookup-related-flags.patch
  bpf-lpm_trie-check-left-child-of-last-leftmost-node-for-null.patch
  bpf-fix-nested-bpf-tracepoints-with-per-cpu-data.patch
  bpf-fix-unconnected-udp-hooks.patch
  bpf-udp-avoid-calling-reuseport-s-bpf_prog-from-udp_gro.patch
  bpf-udp-ipv6-avoid-running-reuseport-s-bpf_prog-from-__udp6_lib_err.patch
  arm64-futex-avoid-copying-out-uninitialised-stack-in-failed-cmpxchg.patch
  bpf-arm64-use-more-scalable-stadd-over-ldxr-stxr-loop-in-xadd.patch
  futex-update-comments-and-docs-about-return-values-of-arch-futex-code.patch
  rdma-directly-cast-the-sockaddr-union-to-sockaddr.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-be02705a335117e8f8131194ed98cf12eb916ecb.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-be02705a335117e8f8131194ed98cf12eb916ecb.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-be02705a335117e8f8131194ed98cf12eb916ecb.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-be02705a335117e8f8131194ed98cf12eb916ecb.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-be02705a335117e8f8131194ed98cf12eb916ecb.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-be02705a335117e8f8131194ed98cf12eb916ecb.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-be02705a335117e8f8131194ed98cf12eb916ecb.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-be02705a335117e8f8131194ed98cf12eb916ecb.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking UDP: socket [14]
       🚧 ✅ tuned: tune-processes-through-perf [15]
       🚧 ✅ storage: SCSI VPD [16]
       🚧 ✅ storage: software RAID testing [17]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [18]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking UDP: socket [14]
       🚧 ✅ tuned: tune-processes-through-perf [15]
       🚧 ✅ storage: software RAID testing [17]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [18]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking UDP: socket [14]
       🚧 ✅ tuned: tune-processes-through-perf [15]
       🚧 ✅ storage: software RAID testing [17]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking sctp-auth: sockopts test [13]
       🚧 ✅ Networking UDP: socket [14]
       🚧 ✅ tuned: tune-processes-through-perf [15]
       🚧 ✅ storage: SCSI VPD [16]
       🚧 ✅ storage: software RAID testing [17]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [18]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
