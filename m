Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64025C32D
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 20:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfGASmr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 1 Jul 2019 14:42:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfGASmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 14:42:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 471D830C5846
        for <stable@vger.kernel.org>; Mon,  1 Jul 2019 18:42:46 +0000 (UTC)
Received: from [172.54.126.116] (cpt-1022.paas.prod.upshift.rdu2.redhat.com [10.0.19.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CE44171F1;
        Mon,  1 Jul 2019 18:42:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.E878C55BE2.0WMHO0LD2B@redhat.com>
X-Gitlab-Pipeline-ID: 13742
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 01 Jul 2019 18:42:46 +0000 (UTC)
Date:   Mon, 1 Jul 2019 14:42:47 -0400
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


We grabbed the 95e35cd7b2a8 commit of the stable queue repository.

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

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-c47caeeb8e3d3b048179d3b9288c581340d5b9bc.tar.gz


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
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]
       🚧 ✅ storage: SCSI VPD [13]
       🚧 ✅ storage: software RAID testing [14]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [15]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]
       🚧 ✅ storage: software RAID testing [14]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [15]

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
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]
       🚧 ✅ storage: software RAID testing [14]


  x86_64:
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
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]
       🚧 ✅ storage: SCSI VPD [13]
       🚧 ✅ storage: software RAID testing [14]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [15]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
