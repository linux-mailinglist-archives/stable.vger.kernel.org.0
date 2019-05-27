Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4C02B91C
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfE0Qbe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 May 2019 12:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfE0Qbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 12:31:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 340D5308622D
        for <stable@vger.kernel.org>; Mon, 27 May 2019 16:31:33 +0000 (UTC)
Received: from [172.54.69.168] (cpt-large-cpu-01.paas.prod.upshift.rdu2.redhat.com [10.0.18.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93BA662926;
        Mon, 27 May 2019 16:31:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.C1E52A4F53.2ZTKQXHCB6@redhat.com>
X-Gitlab-Pipeline-ID: 10911
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10911?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 27 May 2019 16:31:33 +0000 (UTC)
Date:   Mon, 27 May 2019 12:31:34 -0400
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

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3028a775bee8994a623c50ff1998b8c45c750300.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3028a775bee8994a623c50ff1998b8c45c750300.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3028a775bee8994a623c50ff1998b8c45c750300.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3028a775bee8994a623c50ff1998b8c45c750300.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3028a775bee8994a623c50ff1998b8c45c750300.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3028a775bee8994a623c50ff1998b8c45c750300.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3028a775bee8994a623c50ff1998b8c45c750300.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3028a775bee8994a623c50ff1998b8c45c750300.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [9]
     ✅ selinux-policy: serge-testsuite [10]

  ppc64le:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [9]
     ✅ selinux-policy: serge-testsuite [10]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [10]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ audit: audit testsuite test [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [9]
     ✅ selinux-policy: serge-testsuite [10]

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
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

