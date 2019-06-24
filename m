Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6807A501C2
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 08:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfFXGBJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 24 Jun 2019 02:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFXGBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 02:01:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80DAB3087931
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 06:01:08 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EBB45D9C5;
        Mon, 24 Jun 2019 06:01:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.521BC5E059.SPV8IYJBD6@redhat.com>
X-Gitlab-Pipeline-ID: 13082
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 24 Jun 2019 06:01:08 +0000 (UTC)
Date:   Mon, 24 Jun 2019 02:01:09 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 78778071092e - Linux 4.19.55

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
  Commit: 78778071092e - Linux 4.19.55


We grabbed the 320db32b25ea commit of the stable queue repository.

We then merged the patchset with `git am`:

  tracing-silence-gcc-9-array-bounds-warning.patch
  objtool-support-per-function-rodata-sections.patch
  gcc-9-silence-address-of-packed-member-warning.patch
  ovl-support-the-fs_ioc_fs-sg-etxattr-ioctls.patch
  ovl-fix-wrong-flags-check-in-fs_ioc_fs-sg-etxattr-io.patch
  ovl-make-i_ino-consistent-with-st_ino-in-more-cases.patch
  ovl-detect-overlapping-layers.patch
  ovl-don-t-fail-with-disconnected-lower-nfs.patch
  ovl-fix-bogus-wmaybe-unitialized-warning.patch
  s390-jump_label-use-jdd-constraint-on-gcc9.patch
  s390-ap-rework-assembler-functions-to-use-unions-for.patch
  mmc-sdhci-sdhci-pci-o2micro-correctly-set-bus-width-when-tuning.patch
  mmc-core-api-to-temporarily-disable-retuning-for-sdio-crc-errors.patch
  mmc-core-add-sdio_retune_hold_now-and-sdio_retune_release.patch
  mmc-core-prevent-processing-sdio-irqs-when-the-card-is-suspended.patch
  scsi-ufs-avoid-runtime-suspend-possibly-being-blocked-forever.patch
  usb-chipidea-udc-workaround-for-endpoint-conflict-issue.patch
  xhci-detect-usb-3.2-capable-host-controllers-correctly.patch
  usb-xhci-don-t-try-to-recover-an-endpoint-if-port-is-in-error-state.patch
  ib-hfi1-validate-fault-injection-opcode-user-input.patch
  ib-hfi1-silence-txreq-allocation-warnings.patch
  iio-temperature-mlx90632-relax-the-compatibility-check.patch
  input-synaptics-enable-smbus-on-thinkpad-e480-and-e580.patch
  input-uinput-add-compat-ioctl-number-translation-for-ui_-_ff_upload.patch
  input-silead-add-mssl0017-to-acpi_device_id.patch
  apparmor-fix-profile_mediates-for-untrusted-input.patch
  apparmor-enforce-nullbyte-at-end-of-tag-string.patch
  brcmfmac-sdio-disable-auto-tuning-around-commands-expected-to-fail.patch
  brcmfmac-sdio-don-t-tune-while-the-card-is-off.patch
  arc-fix-build-warnings.patch
  dmaengine-dw-axi-dmac-fix-null-dereference-when-poin.patch
  dmaengine-sprd-fix-block-length-overflow.patch
  arc-plat-hsdk-add-missing-multicast-filter-bins-numb.patch
  arc-plat-hsdk-add-missing-fifo-size-entry-in-gmac-no.patch
  fpga-dfl-afu-pass-the-correct-device-to-dma_mapping_.patch
  fpga-dfl-add-lockdep-classes-for-pdata-lock.patch
  parport-fix-mem-leak-in-parport_register_dev_model.patch
  parisc-fix-compiler-warnings-in-float-emulation-code.patch
  ib-rdmavt-fix-alloc_qpn-warn_on.patch
  ib-hfi1-insure-freeze_work-work_struct-is-canceled-o.patch
  ib-qib-hfi1-rdmavt-correct-ibv_devinfo-max_mr-value.patch
  ib-hfi1-validate-page-aligned-for-a-given-virtual-ad.patch
  mips-uprobes-remove-set-but-not-used-variable-epc.patch
  xtensa-fix-section-mismatch-between-memblock_reserve.patch
  kselftest-cgroup-fix-unexpected-testing-failure-on-t.patch
  kselftest-cgroup-fix-unexpected-testing-failure-on-t.patch
  kselftest-cgroup-fix-incorrect-test_core-skip.patch
  selftests-vm-install-test_vmalloc.sh-for-run_vmtests.patch
  net-dsa-mv88e6xxx-avoid-error-message-on-remove-from.patch
  net-hns-fix-loopback-test-failed-at-copper-ports.patch
  mdesc-fix-a-missing-check-bug-in-get_vdev_port_node_.patch
  sparc-perf-fix-updated-event-period-in-response-to-p.patch
  net-ethernet-mediatek-use-hw_feature-to-judge-if-hwl.patch
  net-ethernet-mediatek-use-net_ip_align-to-judge-if-h.patch
  drm-arm-mali-dp-add-a-loop-around-the-second-set-cva.patch
  drm-arm-hdlcd-actually-validate-crtc-modes.patch
  drm-arm-hdlcd-allow-a-bit-of-clock-tolerance.patch
  nvmet-fix-data_len-to-0-for-bdev-backed-write_zeroes.patch
  scripts-checkstack.pl-fix-arm64-wrong-or-unknown-arc.patch
  scsi-ufs-check-that-space-was-properly-alloced-in-co.patch
  scsi-smartpqi-unlock-on-error-in-pqi_submit_raid_req.patch
  net-ipvlan-fix-ipvlan-device-tso-disabled-while-neti.patch
  s390-qeth-fix-vlan-attribute-in-bridge_hostnotify-ud.patch
  hwmon-core-add-thermal-sensors-only-if-dev-of_node-i.patch
  hwmon-pmbus-core-treat-parameters-as-paged-if-on-mul.patch
  arm64-silence-gcc-warnings-about-arch-abi-drift.patch
  nvme-fix-u32-overflow-in-the-number-of-namespace-lis.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-f521877164270443a1ac5c86a510da6d41091863.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-f521877164270443a1ac5c86a510da6d41091863.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-f521877164270443a1ac5c86a510da6d41091863.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-f521877164270443a1ac5c86a510da6d41091863.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-f521877164270443a1ac5c86a510da6d41091863.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-f521877164270443a1ac5c86a510da6d41091863.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-f521877164270443a1ac5c86a510da6d41091863.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-f521877164270443a1ac5c86a510da6d41091863.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ LTP: openposix test suite [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       🚧 ✅ tuned: tune-processes-through-perf [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]
       🚧 ✅ storage: SCSI VPD [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
