Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E282EE1E
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 03:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbfD3BFu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Apr 2019 21:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729238AbfD3BFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 21:05:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A99273082208
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 01:05:49 +0000 (UTC)
Received: from [172.54.25.52] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E086D1001E63;
        Tue, 30 Apr 2019 01:05:45 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.D59BAE31EA.FXGBH08ZWK@redhat.com>
X-Gitlab-Pipeline-ID: 8881
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/8881
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 30 Apr 2019 01:05:49 +0000 (UTC)
Date:   Mon, 29 Apr 2019 21:05:50 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d3da1f09fff2 - Linux 5.0.10

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
  Commit: d3da1f09fff2 - Linux 5.0.10

We then merged the patchset with `git am`:

  netfilter-nf_tables-bogus-ebusy-when-deleting-set-af.patch
  netfilter-nf_tables-bogus-ebusy-in-helper-removal-fr.patch
  intel_th-gth-fix-an-off-by-one-in-output-unassigning.patch
  powerpc-vdso32-fix-clock_monotonic-on-ppc64.patch
  alsa-hda-realtek-move-to-act_init-state.patch
  fs-proc-proc_sysctl.c-fix-a-null-pointer-dereference.patch
  block-bfq-fix-use-after-free-in-bfq_bfqq_expire.patch
  cifs-fix-memory-leak-in-smb2_read.patch
  cifs-fix-page-reference-leak-with-readv-writev.patch
  cifs-do-not-attempt-cifs-operation-on-smb2-rename-error.patch
  tracing-fix-a-memory-leak-by-early-error-exit-in-trace_pid_write.patch
  tracing-fix-buffer_ref-pipe-ops.patch
  crypto-xts-fix-atomic-sleep-when-walking-skcipher.patch
  crypto-lrw-fix-atomic-sleep-when-walking-skcipher.patch
  gpio-eic-sprd-fix-incorrect-irq-type-setting-for-the-sync-eic.patch
  zram-pass-down-the-bvec-we-need-to-read-into-in-the-work-struct.patch
  lib-kconfig.debug-fix-build-error-without-config_block.patch
  mips-scall64-o32-fix-indirect-syscall-number-load.patch
  trace-fix-preempt_enable_no_resched-abuse.patch
  mm-do-not-boost-watermarks-to-avoid-fragmentation-for-the-discontig-memory-model.patch
  arm64-mm-ensure-tail-of-unaligned-initrd-is-reserved.patch
  ib-rdmavt-fix-frwr-memory-registration.patch
  rdma-mlx5-do-not-allow-the-user-to-write-to-the-clock-page.patch
  rdma-mlx5-use-rdma_user_map_io-for-mapping-bar-pages.patch
  rdma-ucontext-fix-regression-with-disassociate.patch
  sched-numa-fix-a-possible-divide-by-zero.patch
  ceph-only-use-d_name-directly-when-parent-is-locked.patch
  ceph-ensure-d_name-stability-in-ceph_dentry_hash.patch
  ceph-fix-ci-i_head_snapc-leak.patch
  nfsd-don-t-release-the-callback-slot-unless-it-was-actually-held.patch
  nfsd-wake-waiters-blocked-on-file_lock-before-deleting-it.patch
  nfsd-wake-blocked-file-lock-waiters-before-sending-callback.patch
  sunrpc-don-t-mark-uninitialised-items-as-valid.patch
  perf-x86-intel-update-kbl-package-c-state-events-to-also-include-pc8-pc9-pc10-counters.patch
  input-synaptics-rmi4-write-config-register-values-to-the-right-offset.patch
  vfio-type1-limit-dma-mappings-per-container.patch
  dmaengine-sh-rcar-dmac-with-cyclic-dma-residue-0-is-valid.patch
  dmaengine-sh-rcar-dmac-fix-glitch-in-dmaengine_tx_status.patch
  dmaengine-mediatek-cqdma-fix-wrong-register-usage-in-mtk_cqdma_start.patch
  arm-8857-1-efi-enable-cp15-dmb-instructions-before-cleaning-the-cache.patch
  powerpc-mm-radix-make-radix-require-hugetlb_page.patch
  drm-vc4-fix-memory-leak-during-gpu-reset.patch
  drm-ttm-fix-re-init-of-global-structures.patch
  revert-drm-i915-fbdev-actually-configure-untiled-displays.patch
  drm-vc4-fix-compilation-error-reported-by-kbuild-test-bot.patch
  usb-add-new-usb-lpm-helpers.patch
  usb-consolidate-lpm-checks-to-avoid-enabling-lpm-twice.patch
  ext4-fix-some-error-pointer-dereferences.patch
  loop-do-not-print-warn-message-if-partition-scan-is-successful.patch
  tipc-handle-the-err-returned-from-cmd-header-function.patch
  slip-make-slhc_free-silently-accept-an-error-pointer.patch
  workqueue-try-to-catch-flush_work-without-init_work.patch
  binder-fix-handling-of-misaligned-binder-object.patch
  sched-deadline-correctly-handle-active-0-lag-timers.patch
  mac80211_hwsim-calculate-if_combination.max_interfaces.patch
  nfs-forbid-setting-af_inet6-to-struct-sockaddr_in-sin_family.patch
  netfilter-ebtables-config_compat-drop-a-bogus-warn_on.patch
  fm10k-fix-a-potential-null-pointer-dereference.patch
  tipc-check-bearer-name-with-right-length-in-tipc_nl_compat_bearer_enable.patch
  tipc-check-link-name-with-right-length-in-tipc_nl_compat_link_set.patch
  net-netrom-fix-error-cleanup-path-of-nr_proto_init.patch
  net-rds-check-address-length-before-reading-address-family.patch
  rxrpc-fix-race-condition-in-rxrpc_input_packet.patch
  pin-iocb-through-aio.patch
  aio-fold-lookup_kiocb-into-its-sole-caller.patch
  aio-keep-io_event-in-aio_kiocb.patch
  aio-store-event-at-final-iocb_put.patch
  fix-aio_poll-races.patch
  x86-retpolines-raise-limit-for-generating-indirect-calls-from-switch-case.patch
  x86-retpolines-disable-switch-jump-tables-when-retpolines-are-enabled.patch
  rdma-fix-build-errors-on-s390-and-mips-due-to-bad-zero_page-use.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-069bd18ccf3b29aebc75aee3ad598c14f1674728.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-069bd18ccf3b29aebc75aee3ad598c14f1674728.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-069bd18ccf3b29aebc75aee3ad598c14f1674728.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-069bd18ccf3b29aebc75aee3ad598c14f1674728.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-069bd18ccf3b29aebc75aee3ad598c14f1674728.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-069bd18ccf3b29aebc75aee3ad598c14f1674728.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-069bd18ccf3b29aebc75aee3ad598c14f1674728.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-069bd18ccf3b29aebc75aee3ad598c14f1674728.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [10]
     ✅ xfstests: xfs [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ stress: stress-ng [12]

  ppc64le:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [10]
     ✅ xfstests: xfs [10]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ stress: stress-ng [12]

  s390x:

  x86_64:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [10]
     ✅ xfstests: xfs [10]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ stress: stress-ng [12]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
