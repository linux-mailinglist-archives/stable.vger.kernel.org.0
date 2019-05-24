Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A3129F0D
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 21:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfEXTZY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 24 May 2019 15:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbfEXTZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 15:25:24 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F10544E938
        for <stable@vger.kernel.org>; Fri, 24 May 2019 19:25:23 +0000 (UTC)
Received: from [172.54.241.148] (cpt-med-0003.paas.prod.upshift.rdu2.redhat.com [10.0.18.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 440D063BA1;
        Fri, 24 May 2019 19:25:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
CC:     Xiumei Mu <xmu@redhat.com>, Hangbin Liu <haliu@redhat.com>
Message-ID: <cki.05F79EA29A.EPF7AAYU2G@redhat.com>
X-Gitlab-Pipeline-ID: 10785
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10785?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 24 May 2019 19:25:24 +0000 (UTC)
Date:   Fri, 24 May 2019 15:25:24 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: c3a072597748 - Linux 4.19.45

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
  Commit: c3a072597748 - Linux 4.19.45


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
  vsock-virtio-initialize-core-virtio-vsock-before-registering-the-driver.patch
  net-mlx5-imply-mlxfw-in-mlx5_core.patch
  net-mlx5e-fix-ethtool-rxfh-commands-when-config_mlx5_en_rxnfc-is-disabled.patch
  parisc-export-running_on_qemu-symbol-for-modules.patch
  parisc-skip-registering-led-when-running-in-qemu.patch
  parisc-use-pa_asm_level-in-boot-code.patch
  parisc-rename-level-to-pa_asm_level-to-avoid-name-clash-with-drbd-code.patch
  stm-class-fix-channel-free-in-stm-output-free-path.patch
  stm-class-fix-channel-bitmap-on-32-bit-systems.patch
  brd-re-enable-__gfp_highmem-in-brd_insert_page.patch
  proc-prevent-changes-to-overridden-credentials.patch
  revert-md-fix-lock-contention-for-flush-bios.patch
  md-batch-flush-requests.patch
  md-add-mddev-pers-to-avoid-potential-null-pointer-dereference.patch
  dcache-sort-the-freeing-without-rcu-delay-mess-for-good.patch
  intel_th-msu-fix-single-mode-with-iommu.patch
  p54-drop-device-reference-count-if-fails-to-enable-device.patch
  of-fix-clang-wunsequenced-for-be32_to_cpu.patch
  cifs-fix-strcat-buffer-overflow-and-reduce-raciness-in-smb21_set_oplock_level.patch
  phy-ti-pipe3-fix-missing-bit-wise-or-operator-when-assigning-val.patch
  media-ov6650-fix-sensor-possibly-not-detected-on-probe.patch
  media-imx-csi-allow-unknown-nearest-upstream-entities.patch
  media-imx-clear-fwnode-link-struct-for-each-endpoint-iteration.patch
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
  iommu-tegra-smmu-fix-invalid-asid-bits-on-tegra30-114.patch
  ceph-flush-dirty-inodes-before-proceeding-with-remount.patch
  x86_64-add-gap-to-int3-to-allow-for-call-emulation.patch
  x86_64-allow-breakpoints-to-emulate-call-instructions.patch
  ftrace-x86_64-emulate-call-function-while-updating-in-breakpoint-handler.patch
  tracing-fix-partial-reading-of-trace-event-s-id-file.patch
  memory-tegra-fix-integer-overflow-on-tick-value-calculation.patch
  perf-intel-pt-fix-instructions-sampling-rate.patch
  perf-intel-pt-fix-improved-sample-timestamp.patch
  perf-intel-pt-fix-sample-timestamp-wrt-non-taken-branches.patch
  mips-perf-fix-build-with-config_cpu_bmips5000-enabled.patch
  objtool-allow-ar-to-be-overridden-with-hostar.patch
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
  pci-init-pcie-feature-bits-for-managed-host-bridge-alloc.patch
  pci-aer-change-pci_aer_init-stub-to-return-void.patch
  pci-rcar-add-the-initialization-of-pcie-link-in-resume_noirq.patch
  pci-factor-out-pcie_retrain_link-function.patch
  pci-work-around-pericom-pcie-to-pci-bridge-retrain-link-erratum.patch
  dm-cache-metadata-fix-loading-discard-bitset.patch
  dm-zoned-fix-zone-report-handling.patch
  dm-delay-fix-a-crash-when-invalid-device-is-specified.patch
  dm-integrity-correctly-calculate-the-size-of-metadata-area.patch
  dm-mpath-always-free-attached_handler_name-in-parse_path.patch
  fuse-add-fopen_stream-to-use-stream_open.patch
  xfrm-policy-fix-out-of-bound-array-accesses-in-__xfr.patch
  xfrm6_tunnel-fix-potential-panic-when-unloading-xfrm.patch
  vti4-ipip-tunnel-deregistration-fixes.patch
  xfrm-clean-up-xfrm-protocol-checks.patch
  esp4-add-length-check-for-udp-encapsulation.patch
  xfrm-honor-original-l3-slave-device-in-xfrmi-policy-.patch
  xfrm4-fix-uninitialized-memory-read-in-_decode_sessi.patch
  clk-sunxi-ng-nkmp-avoid-genmask-1-0.patch
  power-supply-cpcap-battery-fix-division-by-zero.patch
  securityfs-fix-use-after-free-on-symlink-traversal.patch
  apparmorfs-fix-use-after-free-on-symlink-traversal.patch
  pci-fix-issue-with-pci-disable_acs_redir-parameter-b.patch
  x86-kvm-hyper-v-deal-with-buggy-tlb-flush-requests-f.patch
  mac80211-fix-kernel-panic-due-to-use-of-txq-after-fr.patch
  net-ieee802154-fix-missing-checks-for-regmap_update_.patch
  kvm-arm-arm64-ensure-vcpu-target-is-unset-on-reset-f.patch
  power-supply-sysfs-prevent-endless-uevent-loop-with-.patch
  bpf-fix-preempt_enable_no_resched-abuse.patch
  qmi_wwan-new-wistron-zte-and-d-link-devices.patch
  iwlwifi-mvm-check-for-length-correctness-in-iwl_mvm_.patch
  sched-cpufreq-fix-kobject-memleak.patch
  x86-mm-mem_encrypt-disable-all-instrumentation-for-e.patch
  ufs-fix-braino-in-ufs_get_inode_gid-for-solaris-ufs-.patch
  perf-bench-numa-add-define-for-rusage_thread-if-not-.patch
  perf-x86-intel-fix-race-in-intel_pmu_disable_event.patch
  revert-don-t-jump-to-compute_result-state-from-check_result-state.patch
  md-raid-raid5-preserve-the-writeback-action-after-the-parity-check.patch
  driver-core-postpone-dma-tear-down-until-after-devres-release-for-probe-failure.patch
  revert-selftests-bpf-skip-verifier-tests-for-unsupported-program-types.patch
  bpf-relax-inode-permission-check-for-retrieving-bpf-program.patch
  bpf-add-map_lookup_elem_sys_only-for-lookups-from-syscall-side.patch
  bpf-lru-avoid-messing-with-eviction-heuristics-upon-syscall-lookup.patch
  fbdev-sm712fb-fix-memory-frequency-by-avoiding-a-switch-case-fallthrough.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-f006d16615aa45f95e70ab2d9395d07ae545b293.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-f006d16615aa45f95e70ab2d9395d07ae545b293.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-f006d16615aa45f95e70ab2d9395d07ae545b293.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-f006d16615aa45f95e70ab2d9395d07ae545b293.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-f006d16615aa45f95e70ab2d9395d07ae545b293.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-f006d16615aa45f95e70ab2d9395d07ae545b293.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-f006d16615aa45f95e70ab2d9395d07ae545b293.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-f006d16615aa45f95e70ab2d9395d07ae545b293.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ audit: audit testsuite test [7]
     ✅ httpd: mod_ssl smoke sanity [8]
     ✅ iotop: sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ stress: stress-ng [12]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]
     🚧 ❎ Networking ipsec: basic netns transport [16]
     🚧 ✅ Networking ipsec: basic netns tunnel [16]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ audit: audit testsuite test [7]
     ✅ httpd: mod_ssl smoke sanity [8]
     ✅ iotop: sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ stress: stress-ng [12]
     ✅ Boot test [0]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]
     🚧 ✅ Networking ipsec: basic netns tunnel [16]

  s390x:
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [2]
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ Ethernet drivers sanity [6]
     ✅ audit: audit testsuite test [7]
     ✅ httpd: mod_ssl smoke sanity [8]
     ✅ iotop: sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ stress: stress-ng [12]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]
     🚧 ✅ Networking ipsec: basic netns transport [16]
     🚧 ✅ Networking ipsec: basic netns tunnel [16]

  x86_64:
     ✅ Boot test [0]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ audit: audit testsuite test [7]
     ✅ httpd: mod_ssl smoke sanity [8]
     ✅ iotop: sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ stress: stress-ng [12]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]
     🚧 ✅ Networking ipsec: basic netns transport [16]
     🚧 ✅ Networking ipsec: basic netns tunnel [16]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
