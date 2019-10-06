Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30297CCEA7
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 06:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfJFE5R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 6 Oct 2019 00:57:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfJFE5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 00:57:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FD97A44AD8
        for <stable@vger.kernel.org>; Sun,  6 Oct 2019 04:57:16 +0000 (UTC)
Received: from [172.54.19.159] (cpt-1010.paas.prod.upshift.rdu2.redhat.com [10.0.19.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AD525DAAD;
        Sun,  6 Oct 2019 04:57:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
Message-ID: <cki.6B4B0B61D9.QAE5F6OWIG@redhat.com>
X-Gitlab-Pipeline-ID: 208531
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/208531
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Sun, 06 Oct 2019 04:57:16 +0000 (UTC)
Date:   Sun, 6 Oct 2019 00:57:16 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 40ce0335271a - Linux 5.3.4

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/208531

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
  Commit: 40ce0335271a - Linux 5.3.4


We grabbed the 6a00b417bec3 commit of the stable queue repository.

We then merged the patchset with `git am`:

  drm-vkms-fix-crc-worker-races.patch
  drm-mcde-fix-uninitialized-variable.patch
  drm-bridge-tc358767-increase-aux-transfer-length-lim.patch
  drm-vkms-avoid-assigning-0-for-possible_crtc.patch
  drm-panel-simple-fix-auo-g185han01-horizontal-blanki.patch
  drm-amd-display-add-monitor-patch-to-add-t7-delay.patch
  drm-amd-display-power-gate-all-dscs-at-driver-init-t.patch
  drm-amd-display-fix-not-calling-ppsmu-to-trigger-pme.patch
  drm-amd-display-clear-fec_ready-shadow-register-if-d.patch
  drm-amd-display-copy-gsl-groups-when-committing-a-ne.patch
  video-ssd1307fb-start-page-range-at-page_offset.patch
  drm-tinydrm-kconfig-drivers-select-backlight_class_d.patch
  drm-stm-attach-gem-fence-to-atomic-state.patch
  drm-bridge-sii902x-fix-missing-reference-to-mclk-clo.patch
  drm-panel-check-failure-cases-in-the-probe-func.patch
  drm-rockchip-check-for-fast-link-training-before-ena.patch
  drm-amdgpu-fix-hard-hang-for-s-g-display-bos.patch
  drm-amd-display-use-proper-enum-conversion-functions.patch
  drm-radeon-fix-eeh-during-kexec.patch
  gpu-drm-radeon-fix-a-possible-null-pointer-dereferen.patch
  clk-imx8mq-mark-ahb-clock-as-critical.patch
  pci-rpaphp-avoid-a-sometimes-uninitialized-warning.patch
  pinctrl-stmfx-update-pinconf-settings.patch
  ipmi_si-only-schedule-continuously-in-the-thread-in-.patch
  clk-qoriq-fix-wunused-const-variable.patch
  clk-ingenic-jz4740-fix-pll-half-divider-not-read-wri.patch
  clk-sunxi-ng-v3s-add-missing-clock-slices-for-mmc2-m.patch
  drm-amd-display-fix-issue-where-252-255-values-are-c.patch
  drm-amd-display-fix-frames_to_insert-math.patch
  drm-amd-display-reprogram-vm-config-when-system-resu.patch
  drm-amd-display-register-vupdate_no_lock-interrupts-.patch
  powerpc-powernv-ioda2-allocate-tce-table-levels-on-d.patch
  clk-actions-don-t-reference-clk_init_data-after-regi.patch
  clk-sirf-don-t-reference-clk_init_data-after-registr.patch
  clk-meson-axg-audio-don-t-reference-clk_init_data-af.patch
  clk-sprd-don-t-reference-clk_init_data-after-registr.patch
  clk-zx296718-don-t-reference-clk_init_data-after-reg.patch
  clk-sunxi-don-t-call-clk_hw_get_name-on-a-hw-that-is.patch
  powerpc-xmon-check-for-hv-mode-when-dumping-xive-inf.patch
  powerpc-rtas-use-device-model-apis-and-serialization.patch
  powerpc-ptdump-fix-walk_pagetables-address-mismatch.patch
  powerpc-futex-fix-warning-oldval-may-be-used-uniniti.patch
  powerpc-64s-radix-fix-memory-hotplug-section-page-ta.patch
  powerpc-pseries-mobility-use-cond_resched-when-updat.patch
  powerpc-perf-fix-imc-allocation-failure-handling.patch
  pinctrl-tegra-fix-write-barrier-placement-in-pmx_wri.patch
  powerpc-eeh-clear-stale-eeh_dev_no_handler-flag.patch
  vfio_pci-restore-original-state-on-release.patch
  drm-amdgpu-sdma5-fix-number-of-sdma5-trap-irq-types-.patch
  drm-nouveau-kms-tu102-disable-input-lut-when-input-i.patch
  drm-nouveau-volt-fix-for-some-cards-having-0-maximum.patch
  pinctrl-amd-disable-spurious-firing-gpio-irqs.patch
  clk-renesas-mstp-set-genpd_flag_always_on-for-clock-.patch
  clk-renesas-cpg-mssr-set-genpd_flag_always_on-for-cl.patch
  drm-amd-display-support-spdif.patch
  drm-amd-powerpaly-fix-navi-series-custom-peak-level-.patch
  drm-amd-display-fix-mpo-hubp-underflow-with-scatter-.patch
  drm-amd-display-fix-trigger-not-generated-for-freesy.patch
  selftests-powerpc-retry-on-host-facility-unavailable.patch
  kbuild-do-not-enable-wimplicit-fallthrough-for-clang.patch
  drm-amdgpu-si-fix-asic-tests.patch
  powerpc-64s-exception-machine-check-use-correct-cfar.patch
  pstore-fs-superblock-limits.patch
  powerpc-eeh-clean-up-eeh-pes-after-recovery-finishes.patch
  clk-qcom-gcc-sdm845-use-floor-ops-for-sdcc-clks.patch
  powerpc-pseries-correctly-track-irq-state-in-default.patch
  pinctrl-meson-gxbb-fix-wrong-pinning-definition-for-.patch
  mailbox-mediatek-cmdq-clear-the-event-in-cmdq-initia.patch
  arm-dts-dir685-drop-spi-cpol-from-the-display.patch
  arm64-fix-unreachable-code-issue-with-cmpxchg.patch
  clk-at91-select-parent-if-main-oscillator-or-bypass-.patch
  clk-imx-pll14xx-avoid-glitch-when-set-rate.patch
  clk-imx-clk-pll14xx-unbypass-pll-by-default.patch
  clk-make-clk_bulk_get_all-return-a-valid-id.patch
  powerpc-dump-kernel-log-before-carrying-out-fadump-o.patch
  mbox-qcom-add-apcs-child-device-for-qcs404.patch
  clk-sprd-add-missing-kfree.patch
  scsi-core-reduce-memory-required-for-scsi-logging.patch
  dma-buf-sw_sync-synchronize-signal-vs-syncpt-free.patch
  f2fs-fix-to-drop-meta-node-pages-during-umount.patch
  ext4-fix-potential-use-after-free-after-remounting-w.patch
  mips-ingenic-disable-broken-btb-lookup-optimization.patch
  clk-jz4740-add-tcu-clock.patch
  mips-don-t-use-bc_false-uninitialized-in-__mm_isbran.patch
  mips-tlbex-explicitly-cast-_page_no_exec-to-a-boolea.patch
  i2c-cht-wc-fix-lockdep-warning.patch
  mfd-intel-lpss-remove-d3cold-delay.patch
  pci-tegra-fix-of-node-reference-leak.patch
  hid-wacom-fix-several-minor-compiler-warnings.patch
  rtc-bd70528-fix-driver-dependencies.patch
  mips-atomic-fix-loongson_llsc_mb-wreckage.patch
  pci-pci-hyperv-fix-build-errors-on-non-sysfs-config.patch
  pci-layerscape-add-the-bar_fixed_64bit-property-to-t.patch
  livepatch-nullify-obj-mod-in-klp_module_coming-s-err.patch
  mips-atomic-fix-smp_mb__-before-after-_atomic.patch
  arm-8898-1-mm-don-t-treat-faults-reported-from-cache.patch
  soundwire-intel-fix-channel-number-reported-by-hardw.patch
  pci-mobiveil-fix-the-cpu-base-address-setup-in-inbou.patch
  arm-8875-1-kconfig-default-to-aeabi-w-clang.patch
  rtc-snvs-fix-possible-race-condition.patch
  rtc-pcf85363-pcf85263-fix-regmap-error-in-set_time.patch
  power-supply-register-hwmon-devices-with-valid-names.patch
  selinux-fix-residual-uses-of-current_security-for-th.patch
  pci-add-pci_info_ratelimited-to-ratelimit-pci-separa.patch
  hid-apple-fix-stuck-function-keys-when-using-fn.patch
  pci-rockchip-propagate-errors-for-optional-regulator.patch
  pci-histb-propagate-errors-for-optional-regulators.patch
  pci-imx6-propagate-errors-for-optional-regulators.patch
  pci-exynos-propagate-errors-for-optional-phys.patch
  security-smack-fix-possible-null-pointer-dereference.patch
  pci-use-static-const-struct-not-const-static-struct.patch
  arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-10..patch
  arm-8903-1-ensure-that-usable-memory-in-bank-0-start.patch
  i2c-tegra-move-suspend-handling-to-noirq-phase.patch
  block-bfq-push-up-injection-only-after-setting-servi.patch
  fat-work-around-race-with-userspace-s-read-via-block.patch
  pktcdvd-remove-warning-on-attempting-to-register-non.patch
  hypfs-fix-error-number-left-in-struct-pointer-member.patch
  tools-power-x86-intel-speed-select-fix-high-priority.patch
  crypto-hisilicon-fix-double-free-in-sec_free_hw_sgl.patch
  mm-add-dummy-can_do_mlock-helper.patch
  kbuild-clean-compressed-initramfs-image.patch
  ocfs2-wait-for-recovering-done-after-direct-unlock-r.patch
  kmemleak-increase-debug_kmemleak_early_log_size-defa.patch
  arm64-consider-stack-randomization-for-mmap-base-onl.patch
  mips-properly-account-for-stack-randomization-and-st.patch
  arm-properly-account-for-stack-randomization-and-sta.patch
  arm-use-stack_top-when-computing-mmap-base-address.patch

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
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites

      Host 2:
         ❌ Boot test
         ⚡⚡⚡ xfstests: ext4
         ⚡⚡⚡ selinux-policy: serge-testsuite
         ⚡⚡⚡ lvm thinp sanity
         ⚡⚡⚡ storage: software RAID testing
         🚧 ⚡⚡⚡ Storage blktests

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites

      Host 2:
         ✅ Boot test
         ✅ xfstests: ext4
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites

      Host 2:
         ✅ Boot test
         ✅ xfstests: ext4
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 3:
         ✅ Boot test
         🚧 ✅ IPMI driver test
         🚧 ✅ IPMItool loop stress test

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

