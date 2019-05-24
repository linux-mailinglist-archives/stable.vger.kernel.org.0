Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4350129FDA
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 22:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404009AbfEXU1v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 24 May 2019 16:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403852AbfEXU1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 16:27:51 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BAA7307D915
        for <stable@vger.kernel.org>; Fri, 24 May 2019 20:27:50 +0000 (UTC)
Received: from [172.54.241.148] (cpt-med-0003.paas.prod.upshift.rdu2.redhat.com [10.0.18.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94CA45D9E5;
        Fri, 24 May 2019 20:27:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.2275800D1D.AXIEGECRZL@redhat.com>
X-Gitlab-Pipeline-ID: 10786
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10786?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 24 May 2019 20:27:50 +0000 (UTC)
Date:   Fri, 24 May 2019 16:27:51 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e0e8106a6cf1 - Linux 5.1.4

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
  Commit: e0e8106a6cf1 - Linux 5.1.4


We then merged the patchset with `git am`:

  ipv6-fix-src-addr-routing-with-the-exception-table.patch
  ipv6-prevent-possible-fib6-leaks.patch
  net-always-descend-into-dsa.patch
  net-avoid-weird-emergency-message.patch
  net-mlx4_core-change-the-error-print-to-info-print.patch
  net-test-nouarg-before-dereferencing-zerocopy-pointers.patch
  net-usb-qmi_wwan-add-telit-0x1260-and-0x1261-compositions.patch
  nfp-flower-add-rcu-locks-when-accessing-netdev-for-tunnels.patch
  ppp-deflate-fix-possible-crash-in-deflate_init.patch
  rtnetlink-always-put-ifla_link-for-links-with-a-link-netnsid.patch
  tipc-switch-order-of-device-registration-to-fix-a-crash.patch
  vsock-virtio-free-packets-during-the-socket-release.patch
  tipc-fix-modprobe-tipc-failed-after-switch-order-of-device-registration.patch
  mlxsw-core-prevent-qsfp-module-initialization-for-old-hardware.patch
  mlxsw-core-prevent-reading-unsupported-slave-address-from-sfp-eeprom.patch
  flow_offload-support-cvlan-match.patch
  net-mlx5e-fix-calling-wrong-function-to-get-inner-vlan-key-and-mask.patch
  net-mlx5-fix-peer-pf-disable-hca-command.patch
  vsock-virtio-initialize-core-virtio-vsock-before-registering-the-driver.patch
  net-mlx5e-add-missing-ethtool-driver-info-for-representors.patch
  net-mlx5e-additional-check-for-flow-destination-comparison.patch
  net-mlx5-imply-mlxfw-in-mlx5_core.patch
  net-mlx5e-fix-ethtool-rxfh-commands-when-config_mlx5_en_rxnfc-is-disabled.patch
  blk-mq-free-hw-queue-s-resource-in-hctx-s-release-handler.patch
  regulator-core-fix-error-path-for-regulator_set_voltage_unlocked.patch
  parisc-export-running_on_qemu-symbol-for-modules.patch
  parisc-add-memory-clobber-to-tlb-purges.patch
  parisc-skip-registering-led-when-running-in-qemu.patch
  parisc-add-memory-barrier-to-asm-pdc-and-sync-instructions.patch
  parisc-allow-live-patching-of-__meminit-functions.patch
  parisc-use-pa_asm_level-in-boot-code.patch
  parisc-rename-level-to-pa_asm_level-to-avoid-name-clash-with-drbd-code.patch
  stm-class-fix-channel-free-in-stm-output-free-path.patch
  stm-class-fix-channel-bitmap-on-32-bit-systems.patch
  brd-re-enable-__gfp_highmem-in-brd_insert_page.patch
  proc-prevent-changes-to-overridden-credentials.patch
  revert-md-fix-lock-contention-for-flush-bios.patch
  md-batch-flush-requests.patch
  md-add-mddev-pers-to-avoid-potential-null-pointer-dereference.patch
  md-add-a-missing-endianness-conversion-in-check_sb_changes.patch
  dcache-sort-the-freeing-without-rcu-delay-mess-for-good.patch
  intel_th-msu-fix-single-mode-with-iommu.patch
  p54-drop-device-reference-count-if-fails-to-enable-device.patch
  of-fix-clang-wunsequenced-for-be32_to_cpu.patch
  brcmfmac-add-dmi-nvram-filename-quirk-for-acepc-t8-and-t11-mini-pcs.patch
  cifs-fix-credits-leak-for-smb1-oplock-breaks.patch
  cifs-fix-strcat-buffer-overflow-and-reduce-raciness-in-smb21_set_oplock_level.patch
  phy-ti-pipe3-fix-missing-bit-wise-or-operator-when-assigning-val.patch
  media-ov6650-fix-sensor-possibly-not-detected-on-probe.patch
  media-seco-cec-fix-building-with-rc_core-m.patch
  media-imx-csi-allow-unknown-nearest-upstream-entities.patch
  media-imx-clear-fwnode-link-struct-for-each-endpoint-iteration.patch
  media-imx-rename-functions-that-add-ipu-internal-subdevs.patch
  media-imx-don-t-register-ipu-subdevs-links-if-csi-port-missing.patch
  rdma-mlx5-use-get_zeroed_page-for-clock_info.patch
  rdma-ipoib-allow-user-space-differentiate-between-valid-dev_port.patch
  nfs4-fix-v4.0-client-state-corruption-when-mount.patch
  pnfs-fallback-to-mds-if-no-deviceid-found.patch
  clk-hi3660-mark-clk_gate_ufs_subsys-as-critical.patch
  clk-tegra-fix-pllm-programming-on-tegra124-when-pmc-overrides-divider.patch
  clk-mediatek-disable-tuner_en-before-change-pll-rate.patch
  clk-rockchip-fix-wrong-clock-definitions-for-rk3328.patch
  udlfb-delete-the-unused-parameter-for-dlfb_handle_damage.patch
  udlfb-fix-sleeping-inside-spinlock.patch
  udlfb-introduce-a-rendering-mutex.patch
  fuse-fix-writepages-on-32bit.patch
  fuse-honor-rlimit_fsize-in-fuse_file_fallocate.patch
  ovl-fix-missing-upper-fs-freeze-protection-on-copy-up-for-ioctl.patch
  fsnotify-fix-unlink-performance-regression.patch
  gcc-plugins-arm_ssp_per_task_plugin-fix-for-older-gcc-6.patch
  iommu-tegra-smmu-fix-invalid-asid-bits-on-tegra30-114.patch
  ceph-flush-dirty-inodes-before-proceeding-with-remount.patch
  x86_64-add-gap-to-int3-to-allow-for-call-emulation.patch
  x86_64-allow-breakpoints-to-emulate-call-instructions.patch
  ftrace-x86_64-emulate-call-function-while-updating-in-breakpoint-handler.patch
  tracing-fix-partial-reading-of-trace-event-s-id-file.patch
  tracing-probeevent-fix-to-make-the-type-of-comm-string.patch
  memory-tegra-fix-integer-overflow-on-tick-value-calculation.patch
  perf-intel-pt-fix-instructions-sampling-rate.patch
  perf-intel-pt-fix-improved-sample-timestamp.patch
  perf-intel-pt-fix-sample-timestamp-wrt-non-taken-branches.patch
  mips-perf-fix-build-with-config_cpu_bmips5000-enabled.patch
  objtool-allow-ar-to-be-overridden-with-hostar.patch
  x86-mpx-mm-core-fix-recursive-munmap-corruption.patch
  fbdev-efifb-ignore-framebuffer-memmap-entries-that-lack-any-memory-types.patch
  fbdev-sm712fb-fix-brightness-control-on-reboot-don-t-set-sr30.patch
  fbdev-sm712fb-fix-vram-detection-don-t-set-sr70-71-74-75.patch
  fbdev-sm712fb-fix-white-screen-of-death-on-reboot-don-t-set-cr3b-cr3f.patch
  fbdev-sm712fb-fix-boot-screen-glitch-when-sm712fb-replaces-vga.patch
  fbdev-sm712fb-fix-crashes-during-framebuffer-writes-by-correctly-mapping-vram.patch
  fbdev-sm712fb-fix-support-for-1024x768-16-mode.patch
  fbdev-sm712fb-use-1024x768-by-default-on-non-mips-fix-garbled-display.patch
  fbdev-sm712fb-fix-crashes-and-garbled-display-during-dpms-modesetting.patch
  pci-mark-amd-stoney-radeon-r7-gpu-ats-as-broken.patch
  pci-mark-atheros-ar9462-to-avoid-bus-reset.patch
  pci-reset-lenovo-thinkpad-p50-nvgpu-at-boot-if-necessary.patch
  pci-init-pcie-feature-bits-for-managed-host-bridge-alloc.patch
  pci-aer-change-pci_aer_init-stub-to-return-void.patch
  pci-rcar-add-the-initialization-of-pcie-link-in-resume_noirq.patch
  pci-factor-out-pcie_retrain_link-function.patch
  pci-work-around-pericom-pcie-to-pci-bridge-retrain-link-erratum.patch
  dm-cache-metadata-fix-loading-discard-bitset.patch
  dm-zoned-fix-zone-report-handling.patch
  dm-init-fix-max-devices-targets-checks.patch
  dm-delay-fix-a-crash-when-invalid-device-is-specified.patch
  dm-crypt-move-detailed-message-into-debug-level.patch
  dm-integrity-correctly-calculate-the-size-of-metadata-area.patch
  dm-ioctl-fix-hang-in-early-create-error-condition.patch
  dm-mpath-always-free-attached_handler_name-in-parse_path.patch
  fuse-add-fopen_stream-to-use-stream_open.patch
  dm-make-sure-to-obey-max_io_len_target_boundary.patch
  revert-don-t-jump-to-compute_result-state-from-check_result-state.patch
  md-raid-raid5-preserve-the-writeback-action-after-the-parity-check.patch
  dmaengine-imx-sdma-only-check-ratio-on-parts-that-support-1-1.patch
  driver-core-postpone-dma-tear-down-until-after-devres-release-for-probe-failure.patch
  bpf-relax-inode-permission-check-for-retrieving-bpf-program.patch
  bpf-add-map_lookup_elem_sys_only-for-lookups-from-syscall-side.patch
  bpf-lru-avoid-messing-with-eviction-heuristics-upon-syscall-lookup.patch
  y2038-make-config_64bit_time-unconditional.patch
  btrfs-reloc-fix-null-pointer-dereference-due-to-expanded-reloc_root-lifespan.patch
  arm-dts-imx6q-logicpd-reduce-inrush-current-on-usbh1.patch
  arm-dts-imx6q-logicpd-reduce-inrush-current-on-start.patch
  fbdev-sm712fb-fix-memory-frequency-by-avoiding-a-switch-case-fallthrough.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-d8dfcae9d6d2768e236303155f20e1b55245aebc.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-d8dfcae9d6d2768e236303155f20e1b55245aebc.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-d8dfcae9d6d2768e236303155f20e1b55245aebc.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-d8dfcae9d6d2768e236303155f20e1b55245aebc.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-d8dfcae9d6d2768e236303155f20e1b55245aebc.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-d8dfcae9d6d2768e236303155f20e1b55245aebc.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-d8dfcae9d6d2768e236303155f20e1b55245aebc.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-d8dfcae9d6d2768e236303155f20e1b55245aebc.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ audit: audit testsuite test [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ tuned: tune-processes-through-perf [8]
     ✅ Usex - version 1.9-29 [9]
     ✅ lvm thinp sanity [10]
     ✅ stress: stress-ng [11]
     ✅ Boot test [0]
     ✅ xfstests: xfs [12]
     ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ Networking socket: fuzz [14]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ Networking route_func: local [16]
     🚧 ✅ Networking route_func: forward [16]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ audit: audit testsuite test [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ tuned: tune-processes-through-perf [8]
     ✅ Usex - version 1.9-29 [9]
     ✅ lvm thinp sanity [10]
     ✅ stress: stress-ng [11]
     ✅ Boot test [0]
     ✅ xfstests: xfs [12]
     ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ Networking socket: fuzz [14]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ Networking route_func: local [16]
     🚧 ✅ Networking route_func: forward [16]

  s390x:
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [13]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Ethernet drivers sanity [4]
     ✅ audit: audit testsuite test [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ tuned: tune-processes-through-perf [8]
     ✅ Usex - version 1.9-29 [9]
     ✅ lvm thinp sanity [10]
     ✅ stress: stress-ng [11]
     🚧 ✅ Networking socket: fuzz [14]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ Networking route_func: local [16]
     🚧 ✅ Networking route_func: forward [16]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ audit: audit testsuite test [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ tuned: tune-processes-through-perf [8]
     ✅ Usex - version 1.9-29 [9]
     ✅ lvm thinp sanity [10]
     ✅ stress: stress-ng [11]
     ✅ Boot test [0]
     ✅ xfstests: xfs [12]
     ✅ selinux-policy: serge-testsuite [13]
     🚧 ✅ Networking socket: fuzz [14]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ Networking route_func: local [16]
     🚧 ✅ Networking route_func: forward [16]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
