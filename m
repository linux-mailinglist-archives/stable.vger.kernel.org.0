Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6734F60597
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 13:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfGELxr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 5 Jul 2019 07:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbfGELxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 07:53:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B672F308FC20
        for <stable@vger.kernel.org>; Fri,  5 Jul 2019 11:53:46 +0000 (UTC)
Received: from [172.54.129.25] (cpt-1023.paas.prod.upshift.rdu2.redhat.com [10.0.19.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3122880693;
        Fri,  5 Jul 2019 11:53:44 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.164A4B84E2.U4DSH10EGF@redhat.com>
X-Gitlab-Pipeline-ID: 21377
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 05 Jul 2019 11:53:46 +0000 (UTC)
Date:   Fri, 5 Jul 2019 07:53:47 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 8584aaf1c326 - Linux 5.1.16

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
  Commit: 8584aaf1c326 - Linux 5.1.16


We grabbed the 2727a0c226da commit of the stable queue repository.

We then merged the patchset with `git am`:

  bluetooth-fix-faulty-expression-for-minimum-encryption-key-size-check.patch
  signal-remove-the-wrong-signal_pending-check-in-restore_user_sigmask.patch
  netfilter-nf_flow_table-ignore-df-bit-setting.patch
  netfilter-nft_flow_offload-set-liberal-tracking-mode-for-tcp.patch
  netfilter-nft_flow_offload-don-t-offload-when-sequence-numbers-need-adjustment.patch
  netfilter-nft_flow_offload-ipcb-is-only-valid-for-ipv4-family.patch
  idr-fix-idr_get_next-race-with-idr_remove.patch
  hid-i2c-hid-add-iball-aer3-to-descriptor-override.patch
  asoc-cs4265-readable-register-too-low.patch
  asoc-ak4458-add-return-value-for-ak4458_probe.patch
  asoc-soc-pcm-be-dai-needs-prepare-when-pause-release.patch
  asoc-ak4458-rstn_control-return-a-non-zero-on-error-.patch
  spi-bitbang-fix-null-pointer-dereference-in-spi_unre.patch
  asoc-core-lock-client_mutex-while-removing-link-comp.patch
  iommu-vt-d-set-the-right-field-for-page-walk-snoop.patch
  hid-a4tech-fix-horizontal-scrolling.patch
  asoc-intel-baytrail-add-quirk-for-aegex-10-ru2-table.patch
  asoc-hda-fix-unbalanced-codec-dev-refcount-for-hda_d.patch
  drm-mediatek-fix-unbind-functions.patch
  drm-mediatek-unbind-components-in-mtk_drm_unbind.patch
  drm-mediatek-call-drm_atomic_helper_shutdown-when-un.patch
  drm-mediatek-clear-num_pipes-when-unbind-driver.patch
  drm-mediatek-call-mtk_dsi_stop-after-mtk_drm_crtc_at.patch
  asoc-max98090-remove-24-bit-format-support-if-rj-is-.patch
  asoc-sun4i-i2s-fix-sun8i-tx-channel-offset-mask.patch
  asoc-sun4i-i2s-add-offset-to-rx-channel-select.patch
  x86-cpu-add-more-icelake-model-numbers.patch
  usb-gadget-fusb300_udc-fix-memory-leak-of-fusb300-ep.patch
  usb-gadget-udc-lpc32xx-allocate-descriptor-with-gfp_.patch
  usb-gadget-dwc2-fix-zlp-handling.patch
  asoc-intel-cht_bsw_max98090-fix-kernel-oops-with-pla.patch
  asoc-intel-bytcht_es8316-fix-kernel-oops-with-platfo.patch
  asoc-intel-cht_bsw_nau8824-fix-kernel-oops-with-plat.patch
  asoc-intel-cht_bsw_rt5672-fix-kernel-oops-with-platf.patch
  asoc-core-move-dai-pre-links-initiation-to-snd_soc_i.patch
  alsa-hdac-fix-memory-release-for-sst-and-sof-drivers.patch
  soc-rt274-fix-internal-jack-assignment-in-set_jack-c.patch
  scsi-hpsa-correct-ioaccel2-chaining.patch
  gpio-pca953x-hack-to-fix-24-bit-gpio-expanders.patch
  drm-panel-orientation-quirks-add-quirk-for-gpd-pocke.patch
  drm-panel-orientation-quirks-add-quirk-for-gpd-micro.patch
  asoc-core-fix-deadlock-in-snd_soc_instantiate_card.patch
  asoc-intel-sst-fix-kmalloc-call-with-wrong-flags.patch
  platform-x86-asus-wmi-only-tell-ec-the-os-will-handl.patch
  platform-x86-intel-vbtn-report-switch-events-when-ev.patch
  platform-x86-mlx-platform-fix-parent-device-in-i2c-m.patch
  platform-mellanox-mlxreg-hotplug-add-devm_free_irq-c.patch
  i2c-pca-platform-fix-gpio-lookup-code.patch
  arm64-tlbflush-ensure-start-end-of-address-range-are.patch
  cpuset-restore-sanity-to-cpuset_cpus_allowed_fallbac.patch
  scripts-decode_stacktrace.sh-prefix-addr2line-with-c.patch
  mm-mlock.c-change-count_mm_mlocked_page_nr-return-ty.patch
  tracing-avoid-build-warning-with-have_nop_mcount.patch
  module-fix-livepatch-ftrace-module-text-permissions-.patch
  ftrace-fix-null-pointer-dereference-in-free_ftrace_f.patch
  ptrace-fix-ptracer_cred-handling-for-ptrace_traceme.patch
  crypto-user-prevent-operating-on-larval-algorithms.patch
  crypto-cryptd-fix-skcipher-instance-memory-leak.patch
  alsa-seq-fix-incorrect-order-of-dest_client-dest_ports-arguments.patch
  alsa-firewire-lib-fireworks-fix-miss-detection-of-received-midi-messages.patch
  alsa-line6-fix-write-on-zero-sized-buffer.patch
  alsa-usb-audio-fix-sign-unintended-sign-extension-on-left-shifts.patch
  alsa-hda-realtek-add-quirks-for-several-clevo-notebook-barebones.patch
  alsa-hda-realtek-change-front-mic-location-for-lenovo-m710q.patch
  dax-fix-xarray-entry-association-for-mixed-mappings.patch
  lib-mpi-fix-karactx-leak-in-mpi_powm.patch
  fs-userfaultfd.c-disable-irqs-for-fault_pending-and-event-locks.patch
  swap_readpage-avoid-blk_wake_io_task-if-synchronous.patch
  tracing-snapshot-resize-spare-buffer-if-size-changed.patch
  arm-dts-armada-xp-98dx3236-switch-to-armada-38x-uart-serial-node.patch
  arm64-kaslr-keep-modules-inside-module-region-when-kasan-is-enabled.patch
  drm-i915-ringbuffer-emit_invalidate-before-switch-context.patch
  drm-amd-powerplay-use-hardware-fan-control-if-no-powerplay-fan-table.patch
  drm-amdgpu-don-t-skip-display-settings-in-hwmgr_resume.patch
  drm-amdgpu-gfx9-use-reset-default-for-pa_sc_fifo_size.patch
  drm-virtio-move-drm_connector_update_edid_property-call.patch
  drm-etnaviv-add-missing-failure-path-to-destroy-suballoc.patch
  drm-imx-notify-drm-core-before-sending-event-during-crtc-disable.patch
  drm-imx-only-send-event-on-crtc-disable-if-kept-disabled.patch
  ftrace-x86-remove-possible-deadlock-between-register_kprobe-and-ftrace_run_update_code.patch
  mm-vmscan.c-prevent-useless-kswapd-loops.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-3455c228a2b09e9e39584831d86e8ddd7a0b64c8.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]
       🚧 ✅ storage: SCSI VPD [11]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [12]
       ✅ selinux-policy: serge-testsuite [13]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [12]
       ✅ selinux-policy: serge-testsuite [13]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [13]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]
       🚧 ✅ storage: SCSI VPD [11]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [12]
       ✅ selinux-policy: serge-testsuite [13]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
