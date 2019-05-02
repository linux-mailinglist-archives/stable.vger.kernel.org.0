Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C441202F
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEBQaq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 2 May 2019 12:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfEBQaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 12:30:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 210B83082E72
        for <stable@vger.kernel.org>; Thu,  2 May 2019 16:30:46 +0000 (UTC)
Received: from [172.54.27.0] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A42174274;
        Thu,  2 May 2019 16:30:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.EC6BBB104B.LJZ6E2NA5G@redhat.com>
X-Gitlab-Pipeline-ID: 9235
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9235
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 02 May 2019 16:30:46 +0000 (UTC)
Date:   Thu, 2 May 2019 12:30:46 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d5a2675b207d - Linux 5.0.11

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
  Commit: d5a2675b207d - Linux 5.0.11

We then merged the patchset with `git am`:

  selinux-use-kernel-linux-socket.h-for-genheaders-and-mdp.patch
  revert-acpica-clear-status-of-gpes-before-enabling-them.patch
  drm-i915-do-not-enable-fec-without-dsc.patch
  mm-make-page-ref-count-overflow-check-tighter-and-more-explicit.patch
  mm-add-try_get_page-helper-function.patch
  mm-prevent-get_user_pages-from-overflowing-page-refcount.patch
  fs-prevent-page-refcount-overflow-in-pipe_buf_get.patch
  arm64-dts-renesas-r8a77990-fix-scif5-dma-channels.patch
  arm-dts-bcm283x-fix-hdmi-hpd-gpio-pull.patch
  s390-limit-brk-randomization-to-32mb.patch
  mt76x02-fix-hdr-pointer-in-write-txwi-for-usb.patch
  mt76-mt76x2-fix-external-lna-gain-settings.patch
  mt76-mt76x2-fix-2.4-ghz-channel-gain-settings.patch
  net-ieee802154-fix-a-potential-null-pointer-derefere.patch
  ieee802154-hwsim-propagate-genlmsg_reply-return-code.patch
  btrfs-fix-file-corruption-after-snapshotting-due-to-.patch
  net-stmmac-don-t-set-own-bit-too-early-for-jumbo-fra.patch
  net-stmmac-fix-jumbo-frame-sending-with-non-linear-s.patch
  qlcnic-avoid-potential-null-pointer-dereference.patch
  xsk-fix-umem-memory-leak-on-cleanup.patch
  staging-axis-fifo-add-config_of-dependency.patch
  staging-mt7621-pci-fix-build-without-pci-support.patch
  netfilter-nft_set_rbtree-check-for-inactive-element-.patch
  netfilter-bridge-set-skb-transport_header-before-ent.patch
  netfilter-fix-netfilter_xt_target_tee-dependencies.patch
  netfilter-ip6t_srh-fix-null-pointer-dereferences.patch
  s390-qeth-fix-race-when-initializing-the-ip-address-.patch
  arm-imx51-fix-a-leaked-reference-by-adding-missing-o.patch
  sc16is7xx-missing-unregister-delete-driver-on-error-.patch
  serial-ar933x_uart-fix-build-failure-with-disabled-c.patch
  kvm-arm64-reset-the-pmu-in-preemptible-context.patch
  arm64-kvm-always-set-ich_hcr_el2.en-if-gicv4-is-enab.patch
  kvm-arm-arm64-vgic-its-take-the-srcu-lock-when-writi.patch
  kvm-arm-arm64-vgic-its-take-the-srcu-lock-when-parsi.patch
  usb-dwc3-pci-add-support-for-comet-lake-pch-id.patch
  usb-gadget-net2280-fix-overrun-of-out-messages.patch
  usb-gadget-net2280-fix-net2280_dequeue.patch
  usb-gadget-net2272-fix-net2272_dequeue.patch
  arm-dts-pfla02-increase-phy-reset-duration.patch
  i2c-i801-add-support-for-intel-comet-lake.patch
  kvm-arm-arm64-fix-handling-of-stage2-huge-mappings.patch
  net-ks8851-dequeue-rx-packets-explicitly.patch
  net-ks8851-reassert-reset-pin-if-chip-id-check-fails.patch
  net-ks8851-delay-requesting-irq-until-opened.patch
  net-ks8851-set-initial-carrier-state-to-down.patch
  staging-rtl8188eu-fix-potential-null-pointer-derefer.patch
  staging-rtlwifi-rtl8822b-fix-to-avoid-potential-null.patch
  staging-rtl8712-uninitialized-memory-in-read_bbreg_h.patch
  staging-rtlwifi-fix-potential-null-pointer-dereferen.patch
  net-phy-add-dp83825i-to-the-dp83822-driver.patch
  net-macb-add-null-check-for-pclk-and-hclk.patch
  net-sched-don-t-dereference-a-goto_chain-to-read-the.patch
  arm-dts-imx6qdl-fix-typo-in-imx6qdl-icore-rqs.dtsi.patch
  drm-tegra-hub-fix-dereference-before-check.patch
  nfs-fix-a-typo-in-nfs_init_timeout_values.patch
  net-xilinx-fix-possible-object-reference-leak.patch
  net-ibm-fix-possible-object-reference-leak.patch
  net-ethernet-ti-fix-possible-object-reference-leak.patch
  drm-fix-drm_release-and-device-unplug.patch
  gpio-aspeed-fix-a-potential-null-pointer-dereference.patch
  drm-meson-fix-invalid-pointer-in-meson_drv_unbind.patch
  drm-meson-uninstall-irq-handler.patch
  arm-davinci-fix-build-failure-with-allnoconfig.patch
  sbitmap-order-read-write-freed-instance-and-setting-.patch
  staging-vc04_services-fix-an-error-code-in-vchiq_pro.patch
  scsi-mpt3sas-fix-kernel-panic-during-expander-reset.patch
  scsi-aacraid-insure-we-don-t-access-pcie-space-durin.patch
  scsi-qla4xxx-fix-a-potential-null-pointer-dereferenc.patch
  usb-usb251xb-fix-to-avoid-potential-null-pointer-der.patch
  leds-trigger-netdev-fix-refcnt-leak-on-interface-ren.patch
  sunrpc-fix-uninitialized-variable-warning.patch
  x86-realmode-don-t-leak-the-trampoline-kernel-addres.patch
  usb-u132-hcd-fix-resource-leak.patch
  ceph-fix-use-after-free-on-symlink-traversal.patch
  scsi-zfcp-reduce-flood-of-fcrscn1-trace-records-on-m.patch
  x86-mm-don-t-exceed-the-valid-physical-address-space.patch
  libata-fix-using-dma-buffers-on-stack.patch
  kbuild-skip-parsing-pre-sub-make-code-for-recursion.patch
  afs-fix-storedata-op-marshalling.patch
  gpio-of-check-propname-before-applying-cs-gpios-quir.patch
  gpio-of-check-for-spi-cs-high-in-child-instead-of-pa.patch
  kvm-nvmx-do-not-inherit-quadrant-and-invalid-for-the.patch
  kvm-svm-workaround-errata-1096-insn_len-maybe-zero-o.patch
  kvm-x86-move-msr_ia32_arch_capabilities-to-array-emu.patch
  x86-kvm-hyper-v-avoid-spurious-pending-stimer-on-vcp.patch
  kvm-selftests-assert-on-exit-reason-in-cr4-cpuid-syn.patch
  kvm-selftests-explicitly-disable-pie-for-tests.patch
  kvm-selftests-disable-stack-protector-for-all-kvm-te.patch
  kvm-selftests-complete-io-before-migrating-guest-sta.patch
  gpio-of-fix-of_gpiochip_add-error-path.patch
  nvme-multipath-relax-ana-state-check.patch
  nvmet-fix-building-bvec-from-sg-list.patch
  nvmet-fix-error-flow-during-ns-enable.patch
  perf-cs-etm-add-missing-case-value.patch
  perf-machine-update-kernel-map-address-and-re-order-.patch
  kconfig-mn-conf-handle-backspace-h-key.patch
  iommu-amd-reserve-exclusion-range-in-iova-domain.patch
  kasan-fix-variable-tag-set-but-not-used-warning.patch
  ptrace-take-into-account-saved_sigmask-in-ptrace-get.patch
  leds-pca9532-fix-a-potential-null-pointer-dereferenc.patch
  leds-trigger-netdev-use-memcpy-in-device_name_store.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-79d54b45545cea1f42ffce383f96dcc7bc385e00.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-79d54b45545cea1f42ffce383f96dcc7bc385e00.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-79d54b45545cea1f42ffce383f96dcc7bc385e00.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-79d54b45545cea1f42ffce383f96dcc7bc385e00.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-79d54b45545cea1f42ffce383f96dcc7bc385e00.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-79d54b45545cea1f42ffce383f96dcc7bc385e00.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-79d54b45545cea1f42ffce383f96dcc7bc385e00.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-79d54b45545cea1f42ffce383f96dcc7bc385e00.tar.gz


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
     ✅ Boot test [0]
     ✅ xfstests: xfs [9]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ Storage blktests [11]
     🚧 ✅ stress: stress-ng [12]
     🚧 ✅ selinux-policy: serge-testsuite [13]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ Boot test [0]
     ✅ xfstests: xfs [9]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ Storage blktests [11]
     🚧 ✅ stress: stress-ng [12]
     🚧 ✅ selinux-policy: serge-testsuite [13]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     🚧 ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ Storage blktests [11]
     🚧 ✅ stress: stress-ng [12]

  x86_64:
     ✅ Boot test [0]
     ✅ xfstests: xfs [9]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     🚧 ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ Storage blktests [11]
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
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
