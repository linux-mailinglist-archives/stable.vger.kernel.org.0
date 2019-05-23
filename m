Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45910280C8
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfEWPRA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 11:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbfEWPRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 11:17:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0114D4E72
        for <stable@vger.kernel.org>; Thu, 23 May 2019 15:16:59 +0000 (UTC)
Received: from [172.54.114.147] (cpt-0011.paas.prod.upshift.rdu2.redhat.com [10.0.18.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA5AA1802F;
        Thu, 23 May 2019 15:16:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.065DF6B4F9.9AYG0DCV64@redhat.com>
X-Gitlab-Pipeline-ID: 10676
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10676?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 23 May 2019 15:17:00 +0000 (UTC)
Date:   Thu, 23 May 2019 11:17:00 -0400
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

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-e97d24e4f2f6be4fc69d58476e100a88fee2dfea.tar.gz


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
     ✅ lvm thinp sanity [11]
     ✅ stress: stress-ng [12]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]

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
     ✅ lvm thinp sanity [11]
     ✅ stress: stress-ng [12]
     ✅ Boot test [0]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ Ethernet drivers sanity [6]
     ✅ audit: audit testsuite test [7]
     ✅ httpd: mod_ssl smoke sanity [8]
     ✅ iotop: sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ lvm thinp sanity [11]
     ✅ stress: stress-ng [12]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [2]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ audit: audit testsuite test [7]
     ✅ httpd: mod_ssl smoke sanity [8]
     ✅ iotop: sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ lvm thinp sanity [11]
     ✅ stress: stress-ng [12]
     ✅ Boot test [0]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     🚧 ✅ Networking socket: fuzz [13]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ Networking route_func: local [15]
     🚧 ✅ Networking route_func: forward [15]

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
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
