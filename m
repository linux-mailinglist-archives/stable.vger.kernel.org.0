Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B60A4122
	for <lists+stable@lfdr.de>; Sat, 31 Aug 2019 01:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfH3XlT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 30 Aug 2019 19:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbfH3XlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 19:41:18 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B5A910F23F9
        for <stable@vger.kernel.org>; Fri, 30 Aug 2019 23:41:18 +0000 (UTC)
Received: from [172.54.40.213] (cpt-1017.paas.prod.upshift.rdu2.redhat.com [10.0.19.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABE7519C6A;
        Fri, 30 Aug 2019 23:41:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.2
Message-ID: <cki.976D5B108D.TTD37OAOWX@redhat.com>
X-Gitlab-Pipeline-ID: 133683
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/133683
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 30 Aug 2019 23:41:18 +0000 (UTC)
Date:   Fri, 30 Aug 2019 19:41:18 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: c3915fe1bf12 - Linux 5.2.11

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/133683



One or more kernel tests failed:

  aarch64:
    ❌ Boot test

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

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
  Commit: c3915fe1bf12 - Linux 5.2.11


We grabbed the 3f740c3323de commit of the stable queue repository.

We then merged the patchset with `git am`:

  dmaengine-ste_dma40-fix-unneeded-variable-warning.patch
  nvme-multipath-revalidate-nvme_ns_head-gendisk-in-nv.patch
  afs-fix-the-cb.probeuuid-service-handler-to-reply-co.patch
  afs-fix-loop-index-mixup-in-afs_deliver_vl_get_entry.patch
  fs-afs-fix-a-possible-null-pointer-dereference-in-af.patch
  afs-fix-off-by-one-in-afs_rename-expected-data-versi.patch
  afs-only-update-d_fsdata-if-different-in-afs_d_reval.patch
  afs-fix-missing-dentry-data-version-updating.patch
  nvmet-fix-use-after-free-bug-when-a-port-is-removed.patch
  nvmet-loop-flush-nvme_delete_wq-when-removing-the-po.patch
  nvmet-file-fix-nvmet_file_flush-always-returning-an-.patch
  nvme-core-fix-extra-device_put-call-on-error-path.patch
  nvme-fix-a-possible-deadlock-when-passthru-commands-.patch
  nvme-rdma-fix-possible-use-after-free-in-connect-err.patch
  nvme-fix-controller-removal-race-with-scan-work.patch
  nvme-pci-fix-async-probe-remove-race.patch
  soundwire-cadence_master-fix-register-definition-for.patch
  soundwire-cadence_master-fix-definitions-for-intstat.patch
  auxdisplay-panel-need-to-delete-scan_timer-when-misc.patch
  btrfs-trim-check-the-range-passed-into-to-prevent-ov.patch
  ib-mlx5-fix-implicit-mr-release-flow.patch
  dmaengine-stm32-mdma-fix-a-possible-null-pointer-der.patch
  omap-dma-omap_vout_vrfb-fix-off-by-one-fi-value.patch
  iommu-dma-handle-sg-length-overflow-better.patch
  dma-direct-don-t-truncate-dma_required_mask-to-bus-a.patch
  usb-gadget-composite-clear-suspended-on-reset-discon.patch
  usb-gadget-mass_storage-fix-races-between-fsg_disabl.patch
  habanalabs-fix-dram-usage-accounting-on-context-tear.patch
  habanalabs-fix-endianness-handling-for-packets-from-.patch
  habanalabs-fix-completion-queue-handling-when-host-i.patch
  habanalabs-fix-endianness-handling-for-internal-qman.patch
  habanalabs-fix-device-irq-unmasking-for-be-host.patch
  xen-blkback-fix-memory-leaks.patch
  arm64-cpufeature-don-t-treat-granule-sizes-as-strict.patch
  riscv-fix-flush_tlb_range-end-address-for-flush_tlb_.patch
  i2c-rcar-avoid-race-when-unregistering-slave-client.patch
  i2c-emev2-avoid-race-when-unregistering-slave-client.patch
  drm-scheduler-use-job-count-instead-of-peek.patch
  drm-ast-fixed-reboot-test-may-cause-system-hanged.patch
  usb-host-fotg2-restart-hcd-after-port-reset.patch
  tools-hv-fixed-python-pep8-flake8-warnings-for-lsvmb.patch
  tools-hv-fix-kvp-and-vss-daemons-exit-code.patch
  locking-rwsem-add-missing-acquire-to-read_slowpath-e.patch
  lcoking-rwsem-add-missing-acquire-to-read_slowpath-s.patch
  watchdog-bcm2835_wdt-fix-module-autoload.patch
  selftests-bpf-install-files-test_xdp_vlan.sh.patch
  drm-bridge-tfp410-fix-memleak-in-get_modes.patch
  mt76-usb-fix-rx-a-msdu-support.patch

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
         ✅ selinux-policy: serge-testsuite [1]
         🚧 ✅ Storage blktests [2]

      Host 2:
         ❌ Boot test [0]
         ⚡⚡⚡ Podman system integration test (as root) [3]
         ⚡⚡⚡ Podman system integration test (as user) [3]
         ⚡⚡⚡ Loopdev Sanity [4]
         ⚡⚡⚡ jvm test suite [5]
         ⚡⚡⚡ AMTU (Abstract Machine Test Utility) [6]
         ⚡⚡⚡ LTP: openposix test suite [7]
         ⚡⚡⚡ audit: audit testsuite test [8]
         ⚡⚡⚡ httpd: mod_ssl smoke sanity [9]
         ⚡⚡⚡ iotop: sanity [10]
         ⚡⚡⚡ tuned: tune-processes-through-perf [11]
         ⚡⚡⚡ Usex - version 1.9-29 [12]
         ⚡⚡⚡ stress: stress-ng [13]
         🚧 ⚡⚡⚡ LTP lite [14]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]
         🚧 ✅ Storage blktests [2]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ✅ Loopdev Sanity [4]
         ✅ jvm test suite [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ audit: audit testsuite test [8]
         ✅ httpd: mod_ssl smoke sanity [9]
         ✅ iotop: sanity [10]
         ✅ tuned: tune-processes-through-perf [11]
         ✅ Usex - version 1.9-29 [12]
         🚧 ✅ LTP lite [14]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]
         🚧 ✅ Storage blktests [2]
         🚧 ✅ IOMMU boot test [15]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ✅ Loopdev Sanity [4]
         ✅ jvm test suite [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ audit: audit testsuite test [8]
         ✅ httpd: mod_ssl smoke sanity [9]
         ✅ iotop: sanity [10]
         ✅ tuned: tune-processes-through-perf [11]
         ✅ pciutils: sanity smoke test [16]
         ✅ Usex - version 1.9-29 [12]
         ✅ stress: stress-ng [13]
         🚧 ✅ LTP lite [14]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
