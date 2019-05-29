Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD2B2D346
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 03:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfE2B0N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 28 May 2019 21:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfE2B0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 21:26:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83686308A9E2
        for <stable@vger.kernel.org>; Wed, 29 May 2019 01:26:12 +0000 (UTC)
Received: from [172.54.187.96] (cpt-0031.paas.prod.upshift.rdu2.redhat.com [10.0.18.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3899660BDF;
        Wed, 29 May 2019 01:26:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.4820A2354D.405ATVWXQH@redhat.com>
X-Gitlab-Pipeline-ID: 11008
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11008?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 29 May 2019 01:26:12 +0000 (UTC)
Date:   Tue, 28 May 2019 21:26:13 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 835365932f0d - Linux 5.1.5

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
  Commit: 835365932f0d - Linux 5.1.5


We then merged the patchset with `git am`:

  x86-hide-the-int3_emulate_call-jmp-functions-from-uml.patch
  ext4-do-not-delete-unlinked-inode-from-orphan-list-on-failed-truncate.patch
  ext4-wait-for-outstanding-dio-during-truncate-in-nojournal-mode.patch
  kvm-x86-fix-return-value-for-reserved-efer.patch
  x86-kvm-pmu-set-amd-s-virt-pmu-version-to-1.patch
  bio-fix-improper-use-of-smp_mb__before_atomic.patch
  sbitmap-fix-improper-use-of-smp_mb__before_atomic.patch
  revert-scsi-sd-keep-disk-read-only-when-re-reading-partition.patch
  crypto-hash-fix-incorrect-hash_max_descsize.patch
  crypto-vmx-ctr-always-increment-iv-as-quadword.patch
  mmc-sdhci-iproc-cygnus-set-no_hispd-bit-to-fix-hs50-data-hold-time-problem.patch
  mmc-sdhci-iproc-set-no_hispd-bit-to-fix-hs50-data-hold-time-problem.patch
  tracing-add-a-check_val-check-before-updating-cond_snapshot-track_val.patch
  dax-arrange-for-dax_supported-check-to-span-multiple-devices.patch
  kvm-check-irqchip-mode-before-assign-irqfd.patch
  kvm-svm-avic-fix-off-by-one-in-checking-host-apic-id.patch
  kvm-nvmx-fix-using-__this_cpu_read-in-preemptible-context.patch
  libnvdimm-pmem-bypass-config_hardened_usercopy-overhead.patch
  arm64-kernel-kaslr-reduce-module-randomization-range-to-2-gb.patch
  arm64-kconfig-make-arm64_pseudo_nmi-depend-on-broken-for-now.patch
  arm64-iommu-handle-non-remapped-addresses-in-mmap-and-get_sgtable.patch
  gfs2-fix-sign-extension-bug-in-gfs2_update_stats.patch
  btrfs-don-t-double-unlock-on-error-in-btrfs_punch_hole.patch
  btrfs-check-the-compression-level-before-getting-a-workspace.patch
  btrfs-do-not-abort-transaction-at-btrfs_update_root-after-failure-to-cow-path.patch
  btrfs-avoid-fallback-to-transaction-commit-during-fsync-of-files-with-holes.patch
  btrfs-fix-race-between-ranged-fsync-and-writeback-of-adjacent-ranges.patch
  btrfs-sysfs-fix-error-path-kobject-memory-leak.patch
  btrfs-sysfs-don-t-leak-memory-when-failing-add-fsid.patch
  fbdev-fix-divide-error-in-fb_var_to_videomode.patch
  arm64-errata-add-workaround-for-cortex-a76-erratum-1463225.patch
  ovl-relax-warn_on-for-overlapping-layers-use-case.patch
  fbdev-fix-warning-in-__alloc_pages_nodemask-bug.patch
  media-cpia2-fix-use-after-free-in-cpia2_exit.patch
  media-serial_ir-fix-use-after-free-in-serial_ir_init_module.patch
  media-vb2-add-waiting_in_dqbuf-flag.patch
  media-vivid-use-vfree-instead-of-kfree-for-dev-bitmap_cap.patch
  ssb-fix-possible-null-pointer-dereference-in-ssb_host_pcmcia_exit.patch
  bpf-devmap-fix-use-after-free-read-in-__dev_map_entry_free.patch
  batman-adv-mcast-fix-multicast-tt-tvlv-worker-locking.patch
  at76c50x-usb-don-t-register-led_trigger-if-usb_register_driver-failed.patch
  acct_on-don-t-mess-with-freeze-protection.patch
  netfilter-ctnetlink-resolve-conntrack-l3-protocol-flush-regression.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-d9ca91edd42e0287c0c1f4d962d1b821c4ef1acd.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [11]
       ✅ xfstests: xfs [11]
       ✅ selinux-policy: serge-testsuite [12]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [11]
       ✅ xfstests: xfs [11]
       ✅ selinux-policy: serge-testsuite [12]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [12]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [11]
       ✅ xfstests: xfs [11]
       ✅ selinux-policy: serge-testsuite [12]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       ✅ stress: stress-ng [9]
       🚧 ✅ Networking socket: fuzz [10]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
