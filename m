Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3551A8C675
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfHNCPh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 13 Aug 2019 22:15:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfHNCPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:15:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9C25308FEDF
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 02:15:35 +0000 (UTC)
Received: from [172.54.89.110] (cpt-1048.paas.prod.upshift.rdu2.redhat.com [10.0.19.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57C8580616;
        Wed, 14 Aug 2019 02:15:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.23B08BD354.034Z07X22E@redhat.com>
X-Gitlab-Pipeline-ID: 98975
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/98975
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 14 Aug 2019 02:15:35 +0000 (UTC)
Date:   Tue, 13 Aug 2019 22:15:36 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d36a8d2fb62c - Linux 5.2.8

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/98975

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

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: d36a8d2fb62c - Linux 5.2.8


We grabbed the eedd757abb9e commit of the stable queue repository.

We then merged the patchset with `git am`:

  revert-pci-add-missing-link-delays-required-by-the-pcie-spec.patch
  iio-ingenic-jz47xx-set-clock-divider-on-probe.patch
  iio-cros_ec_accel_legacy-fix-incorrect-channel-setting.patch
  iio-imu-mpu6050-add-missing-available-scan-masks.patch
  iio-adc-gyroadc-fix-uninitialized-return-code.patch
  iio-adc-max9611-fix-misuse-of-genmask-macro.patch
  staging-gasket-apex-fix-copy-paste-typo.patch
  staging-wilc1000-flush-the-workqueue-before-deinit-the-host.patch
  staging-android-ion-bail-out-upon-sigkill-when-allocating-memory.patch
  staging-fbtft-fix-probing-of-gpio-descriptor.patch
  staging-fbtft-fix-reset-assertion-when-using-gpio-descriptor.patch
  crypto-ccp-fix-oops-by-properly-managing-allocated-structures.patch
  crypto-ccp-add-support-for-valid-authsize-values-less-than-16.patch
  crypto-ccp-ignore-tag-length-when-decrypting-gcm-ciphertext.patch
  driver-core-platform-return-enxio-for-missing-gpioint.patch
  usb-usbfs-fix-double-free-of-usb-memory-upon-submiturb-error.patch
  revert-usb-rio500-simplify-locking.patch
  usb-iowarrior-fix-deadlock-on-disconnect.patch
  sound-fix-a-memory-leak-bug.patch
  mmc-cavium-set-the-correct-dma-max-segment-size-for-mmc_host.patch
  mmc-cavium-add-the-missing-dma-unmap-when-the-dma-has-finished.patch
  loop-set-pf_memalloc_noio-for-the-worker-thread.patch
  bdev-fixup-error-handling-in-blkdev_get.patch
  input-usbtouchscreen-initialize-pm-mutex-before-using-it.patch
  input-elantech-enable-smbus-on-new-2018-systems.patch
  input-synaptics-enable-rmi-mode-for-hp-spectre-x360.patch
  x86-mm-check-for-pfn-instead-of-page-in-vmalloc_sync_one.patch
  x86-mm-sync-also-unmappings-in-vmalloc_sync_all.patch
  mm-vmalloc-sync-unmappings-in-__purge_vmap_area_lazy.patch
  coresight-fix-debug_locks_warn_on-for-uninitialized-attribute.patch
  perf-annotate-fix-s390-gap-between-kernel-end-and-module-start.patch
  perf-db-export-fix-thread__exec_comm.patch
  perf-record-fix-module-size-on-s390.patch
  x86-purgatory-do-not-use-__builtin_memcpy-and-__builtin_memset.patch
  x86-purgatory-use-cflags_remove-rather-than-reset-kbuild_cflags.patch
  genirq-affinity-create-affinity-mask-for-single-vector.patch
  gfs2-gfs2_walk_metadata-fix.patch
  usb-host-xhci-rcar-fix-timeout-in-xhci_suspend.patch
  usb-yurex-fix-use-after-free-in-yurex_delete.patch
  usb-typec-ucsi-ccg-fix-uninitilized-symbol-error.patch
  usb-typec-tcpm-free-log-buf-memory-when-remove-debug-file.patch
  usb-typec-tcpm-remove-tcpm-dir-if-no-children.patch
  usb-typec-tcpm-add-null-check-before-dereferencing-config.patch
  usb-typec-tcpm-ignore-unsupported-unknown-alternate-mode-requests.patch
  can-rcar_canfd-fix-possible-irq-storm-on-high-load.patch
  can-flexcan-fix-stop-mode-acknowledgment.patch
  can-flexcan-fix-an-use-after-free-in-flexcan_setup_stop_mode.patch
  can-peak_usb-fix-potential-double-kfree_skb.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ audit: audit testsuite test [7]
         ✅ httpd: mod_ssl smoke sanity [8]
         ✅ iotop: sanity [9]
         ✅ tuned: tune-processes-through-perf [10]
         ✅ pciutils: update pci ids test [11]
         ✅ Usex - version 1.9-29 [12]
         ✅ stress: stress-ng [13]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [14]
         ✅ selinux-policy: serge-testsuite [15]
         🚧 ✅ Storage blktests [16]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ audit: audit testsuite test [7]
         ✅ httpd: mod_ssl smoke sanity [8]
         ✅ iotop: sanity [9]
         ✅ tuned: tune-processes-through-perf [10]
         ✅ pciutils: update pci ids test [11]
         ✅ Usex - version 1.9-29 [12]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [14]
         ✅ selinux-policy: serge-testsuite [15]
         🚧 ✅ Storage blktests [16]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: xfs [14]
         ✅ selinux-policy: serge-testsuite [15]
         🚧 ✅ Storage blktests [16]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ audit: audit testsuite test [7]
         ✅ httpd: mod_ssl smoke sanity [8]
         ✅ iotop: sanity [9]
         ✅ tuned: tune-processes-through-perf [10]
         ✅ pciutils: sanity smoke test [17]
         ✅ pciutils: update pci ids test [11]
         ✅ Usex - version 1.9-29 [12]
         ✅ stress: stress-ng [13]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/update-pciids
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
