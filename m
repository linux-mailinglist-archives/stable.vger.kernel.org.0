Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42C2CEC0
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 20:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfE1SdL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 28 May 2019 14:33:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbfE1SdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 14:33:09 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C30B181114
        for <stable@vger.kernel.org>; Tue, 28 May 2019 18:33:08 +0000 (UTC)
Received: from [172.54.254.151] (cpt-0020.paas.prod.upshift.rdu2.redhat.com [10.0.18.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FEBF1F8;
        Tue, 28 May 2019 18:33:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.0B6F2412FE.EQ4H2DDPUC@redhat.com>
X-Gitlab-Pipeline-ID: 10965
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10965?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 28 May 2019 18:33:08 +0000 (UTC)
Date:   Tue, 28 May 2019 14:33:09 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 8b2fc0058255 - Linux 4.19.46

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
  Commit: 8b2fc0058255 - Linux 4.19.46


We then merged the patchset with `git am`:

  x86-hide-the-int3_emulate_call-jmp-functions-from-uml.patch
  ext4-do-not-delete-unlinked-inode-from-orphan-list-on-failed-truncate.patch
  ext4-wait-for-outstanding-dio-during-truncate-in-nojournal-mode.patch
  f2fs-fix-use-of-number-of-devices.patch
  kvm-x86-fix-return-value-for-reserved-efer.patch
  bio-fix-improper-use-of-smp_mb__before_atomic.patch
  sbitmap-fix-improper-use-of-smp_mb__before_atomic.patch
  revert-scsi-sd-keep-disk-read-only-when-re-reading-partition.patch
  crypto-vmx-ctr-always-increment-iv-as-quadword.patch
  mmc-sdhci-iproc-cygnus-set-no_hispd-bit-to-fix-hs50-data-hold-time-problem.patch
  mmc-sdhci-iproc-set-no_hispd-bit-to-fix-hs50-data-hold-time-problem.patch
  kvm-svm-avic-fix-off-by-one-in-checking-host-apic-id.patch
  libnvdimm-pmem-bypass-config_hardened_usercopy-overhead.patch
  arm64-kernel-kaslr-reduce-module-randomization-range-to-2-gb.patch
  arm64-iommu-handle-non-remapped-addresses-in-mmap-and-get_sgtable.patch
  gfs2-fix-sign-extension-bug-in-gfs2_update_stats.patch
  btrfs-don-t-double-unlock-on-error-in-btrfs_punch_hole.patch
  btrfs-do-not-abort-transaction-at-btrfs_update_root-after-failure-to-cow-path.patch
  btrfs-avoid-fallback-to-transaction-commit-during-fsync-of-files-with-holes.patch
  btrfs-fix-race-between-ranged-fsync-and-writeback-of-adjacent-ranges.patch
  btrfs-sysfs-fix-error-path-kobject-memory-leak.patch
  btrfs-sysfs-don-t-leak-memory-when-failing-add-fsid.patch
  udlfb-fix-some-inconsistent-null-checking.patch
  fbdev-fix-divide-error-in-fb_var_to_videomode.patch
  nfsv4.2-fix-unnecessary-retry-in-nfs4_copy_file_range.patch
  nfsv4.1-fix-incorrect-return-value-in-copy_file_range.patch
  bpf-add-bpf_jit_limit-knob-to-restrict-unpriv-allocations.patch
  brcmfmac-assure-ssid-length-from-firmware-is-limited.patch
  brcmfmac-add-subtype-check-for-event-handling-in-data-path.patch
  arm64-errata-add-workaround-for-cortex-a76-erratum-1463225.patch
  btrfs-honor-path-skip_locking-in-backref-code.patch
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

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-03664ad1a8a766394a608825a05064da8e26b0b5.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-03664ad1a8a766394a608825a05064da8e26b0b5.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-03664ad1a8a766394a608825a05064da8e26b0b5.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-03664ad1a8a766394a608825a05064da8e26b0b5.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-03664ad1a8a766394a608825a05064da8e26b0b5.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-03664ad1a8a766394a608825a05064da8e26b0b5.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-03664ad1a8a766394a608825a05064da8e26b0b5.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-03664ad1a8a766394a608825a05064da8e26b0b5.tar.gz


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
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [1]
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
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
