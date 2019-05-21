Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE6259B7
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfEUVLp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 May 2019 17:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfEUVLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 17:11:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B220681F0D
        for <stable@vger.kernel.org>; Tue, 21 May 2019 21:11:44 +0000 (UTC)
Received: from [172.54.180.135] (cpt-0029.paas.prod.upshift.rdu2.redhat.com [10.0.18.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 325F9196F6;
        Tue, 21 May 2019 21:11:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.8CE3F64C95.TNFHPXJMW9@redhat.com>
X-Gitlab-Pipeline-ID: 10533
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10533?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 21 May 2019 21:11:44 +0000 (UTC)
Date:   Tue, 21 May 2019 17:11:45 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 7cb9c5d341b9 - Linux 5.1.3

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
  Commit: 7cb9c5d341b9 - Linux 5.1.3

We then merged the patchset with `git am`:

  locking-rwsem-prevent-decrement-of-reader-count-befo.patch
  x86-speculation-mds-revert-cpu-buffer-clear-on-double-fault-exit.patch
  x86-speculation-mds-improve-cpu-buffer-clear-documentation.patch
  objtool-fix-function-fallthrough-detection.patch
  arm64-dts-rockchip-fix-io-domain-voltage-setting-of-apio5-on-rockpro64.patch
  arm64-dts-rockchip-disable-dcmds-on-rk3399-s-emmc-controller.patch
  arm-dts-qcom-ipq4019-enlarge-pcie-bar-range.patch
  arm-dts-exynos-fix-interrupt-for-shared-eints-on-exynos5260.patch
  arm-dts-exynos-fix-audio-routing-on-odroid-xu3.patch
  arm-dts-exynos-fix-audio-microphone-routing-on-odroid-xu3.patch
  mmc-sdhci-of-arasan-add-dts-property-to-disable-dcmds.patch
  arm-exynos-fix-a-leaked-reference-by-adding-missing-of_node_put.patch
  power-supply-axp288_charger-fix-unchecked-return-value.patch
  power-supply-axp288_fuel_gauge-add-acepc-t8-and-t11-mini-pcs-to-the-blacklist.patch
  arm64-mmap-ensure-file-offset-is-treated-as-unsigned.patch
  arm64-arch_timer-ensure-counter-register-reads-occur-with-seqlock-held.patch
  arm64-compat-reduce-address-limit.patch
  arm64-clear-osdlr_el1-on-cpu-boot.patch
  arm64-save-and-restore-osdlr_el1-across-suspend-resume.patch
  sched-x86-save-flags-on-context-switch.patch
  x86-mce-add-an-mce-record-filtering-function.patch
  x86-mce-amd-don-t-report-l1-btb-mca-errors-on-some-family-17h-models.patch
  crypto-crypto4xx-fix-ctr-aes-missing-output-iv.patch
  crypto-crypto4xx-fix-cfb-and-ofb-overran-dst-buffer-issues.patch
  crypto-salsa20-don-t-access-already-freed-walk.iv.patch
  crypto-lrw-don-t-access-already-freed-walk.iv.patch
  crypto-chacha-generic-fix-use-as-arm64-no-neon-fallback.patch
  crypto-chacha20poly1305-set-cra_name-correctly.patch
  crypto-ccm-fix-incompatibility-between-ccm-and-ccm_base.patch
  crypto-ccp-do-not-free-psp_master-when-platform_init-fails.patch
  crypto-vmx-fix-copy-paste-error-in-ctr-mode.patch
  crypto-skcipher-don-t-warn-on-unprocessed-data-after-slow-walk-step.patch
  crypto-crct10dif-generic-fix-use-via-crypto_shash_digest.patch
  crypto-x86-crct10dif-pcl-fix-use-via-crypto_shash_digest.patch
  crypto-arm64-gcm-aes-ce-fix-no-neon-fallback-code.patch
  crypto-gcm-fix-incompatibility-between-gcm-and-gcm_base.patch
  crypto-rockchip-update-iv-buffer-to-contain-the-next-iv.patch
  crypto-caam-qi2-fix-zero-length-buffer-dma-mapping.patch
  crypto-caam-qi2-fix-dma-mapping-of-stack-memory.patch
  crypto-caam-qi2-generate-hash-keys-in-place.patch
  crypto-arm-aes-neonbs-don-t-access-already-freed-walk.iv.patch
  crypto-arm64-aes-neonbs-don-t-access-already-freed-walk.iv.patch
  drivers-dax-allow-to-include-dev_dax_pmem-as-builtin.patch
  dt-bindings-mmc-add-disable-cqe-dcmd-property.patch
  mmc-tegra-fix-ddr-signaling-for-non-ddr-modes.patch
  mmc-core-fix-tag-set-memory-leak.patch
  mmc-sdhci-pci-fix-byt-ocp-setting.patch
  alsa-line6-toneport-fix-broken-usage-of-timer-for-delayed-execution.patch
  alsa-usb-audio-fix-a-memory-leak-bug.patch
  alsa-hda-hdmi-read-the-pin-sense-from-register-when-repolling.patch
  alsa-hda-hdmi-consider-eld_valid-when-reporting-jack-event.patch
  alsa-hda-realtek-eapd-turn-on-later.patch
  alsa-hdea-realtek-headset-fixup-for-system76-gazelle-gaze14.patch
  asoc-max98090-fix-restore-of-dapm-muxes.patch
  asoc-rt5677-spi-disable-16bit-spi-transfers.patch
  asoc-fsl_esai-fix-missing-break-in-switch-statement.patch
  asoc-codec-hdac_hdmi-add-device_link-to-card-device.patch
  bpf-arm64-remove-prefetch-insn-in-xadd-mapping.patch
  bpf-fix-out-of-bounds-backwards-jmps-due-to-dead-code-removal.patch
  crypto-ccree-remove-special-handling-of-chained-sg.patch
  crypto-ccree-fix-mem-leak-on-error-path.patch
  crypto-ccree-don-t-map-mac-key-on-stack.patch
  crypto-ccree-use-correct-internal-state-sizes-for-export.patch
  crypto-ccree-don-t-map-aead-key-and-iv-on-stack.patch
  crypto-ccree-pm-resume-first-enable-the-source-clk.patch
  crypto-ccree-host_power_down_en-should-be-the-last-cc-access-during-suspend.patch
  crypto-ccree-add-function-to-handle-cryptocell-tee-fips-error.patch
  crypto-ccree-handle-tee-fips-error-during-power-management-resume.patch
  mm-mincore.c-make-mincore-more-conservative.patch
  mm-huge_memory-fix-vmf_insert_pfn_-pmd-pud-crash-handle-unaligned-addresses.patch
  mm-hugetlb.c-don-t-put_page-in-lock-of-hugetlb_lock.patch
  hugetlb-use-same-fault-hash-key-for-shared-and-private-mappings.patch
  ocfs2-fix-ocfs2-read-inode-data-panic-in-ocfs2_iget.patch
  userfaultfd-use-rcu-to-free-the-task-struct-when-fork-fails.patch
  acpi-pm-set-enable_for_wake-for-wakeup-gpes-during-suspend-to-idle.patch
  acpica-linux-move-acpi_debug_default-flag-out-of-ifndef.patch
  mfd-da9063-fix-otp-control-register-names-to-match-datasheets-for-da9063-63l.patch
  mfd-max77620-fix-swapped-fps_period_max_us-values.patch
  mtd-spi-nor-intel-spi-avoid-crossing-4k-address-boundary-on-read-write.patch
  mtd-maps-physmap-store-gpio_values-correctly.patch
  mtd-maps-allow-mtd_physmap-with-mtd_ram.patch
  tty-vt.c-fix-tiocl_blankscreen-console-blanking-if-blankinterval-0.patch
  tty-vt-fix-write-write-race-in-ioctl-kdskbsent-handler.patch
  jbd2-check-superblock-mapped-prior-to-committing.patch
  ext4-make-sanity-check-in-mballoc-more-strict.patch
  ext4-ignore-e_value_offs-for-xattrs-with-value-in-ea-inode.patch
  ext4-avoid-drop-reference-to-iloc.bh-twice.patch
  ext4-fix-use-after-free-race-with-debug_want_extra_isize.patch
  ext4-actually-request-zeroing-of-inode-table-after-grow.patch
  ext4-fix-ext4_show_options-for-file-systems-w-o-journal.patch
  btrfs-check-the-first-key-and-level-for-cached-extent-buffer.patch
  btrfs-correctly-free-extent-buffer-in-case-btree_read_extent_buffer_pages-fails.patch
  btrfs-honour-fitrim-range-constraints-during-free-space-trim.patch
  btrfs-send-flush-dellaloc-in-order-to-avoid-data-loss.patch
  btrfs-do-not-start-a-transaction-during-fiemap.patch
  btrfs-do-not-start-a-transaction-at-iterate_extent_inodes.patch
  btrfs-fix-race-between-send-and-deduplication-that-lead-to-failures-and-crashes.patch
  bcache-fix-a-race-between-cache-register-and-cacheset-unregister.patch
  bcache-never-set-key_ptrs-of-journal-key-to-0-in-journal_reclaim.patch
  ipmi-add-the-i2c-addr-property-for-ssif-interfaces.patch
  ipmi-ssif-compare-block-number-correctly-for-multi-part-return-messages.patch
  arm-dts-imx-fix-the-ar803x-phy-mode.patch
  mm-compaction.c-correct-zone-boundary-handling-when-isolating-pages-from-a-pageblock.patch
  fs-writeback.c-use-rcu_barrier-to-wait-for-inflight-wb-switches-going-into-workqueue-when-umount.patch
  tty-don-t-force-riscv-sbi-console-as-preferred-console.patch
  ext4-zero-out-the-unused-memory-region-in-the-extent-tree-block.patch
  ext4-fix-data-corruption-caused-by-overlapping-unaligned-and-aligned-io.patch
  ext4-fix-use-after-free-in-dx_release.patch
  ext4-avoid-panic-during-forced-reboot-due-to-aborted-journal.patch
  alsa-hda-realtek-corrected-fixup-for-system76-gazelle-gaze14.patch
  alsa-hda-realtek-fixup-headphone-noise-via-runtime-suspend.patch
  alsa-hda-realtek-fix-for-lenovo-b50-70-inverted-internal-microphone-bug.patch
  jbd2-fix-potential-double-free.patch
  revert-kvm-nvmx-expose-rdpmc-exiting-only-when-guest-supports-pmu.patch
  kvm-fix-the-bitmap-range-to-copy-during-clear-dirty.patch
  kvm-x86-skip-efer-vs.-guest-cpuid-checks-for-host-initiated-writes.patch
  kvm-lapic-busy-wait-for-timer-to-expire-when-using-hv_timer.patch
  smb3-display-session-id-in-debug-data.patch
  kbuild-turn-auto.conf.cmd-into-a-mandatory-include-file.patch
  xen-pvh-set-xen_domain_type-to-hvm-in-xen_pvh_init.patch
  xen-pvh-correctly-setup-the-pv-efi-interface-for-dom0.patch
  powerpc-32s-fix-flush_hash_pages-on-smp.patch
  libnvdimm-namespace-fix-label-tracking-error.patch
  s390-mm-make-the-pxd_offset-functions-more-robust.patch
  s390-mm-convert-to-the-generic-get_user_pages_fast-code.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-afc8066ae6eda5e1fbf54940c7fba3b84c222fc6.tar.gz


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
     ✅ Usex - version 1.9-29 [8]
     ✅ stress: stress-ng [9]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [10]
     ✅ xfstests: xfs [10]
     ✅ selinux-policy: serge-testsuite [11]

  ppc64le:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [10]
     ✅ xfstests: xfs [10]
     ✅ selinux-policy: serge-testsuite [11]
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

  s390x:

  x86_64:
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
     ✅ Boot test [0]
     ✅ xfstests: ext4 [10]
     ✅ xfstests: xfs [10]
     ✅ selinux-policy: serge-testsuite [11]

  Test source:
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
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

