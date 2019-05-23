Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EA327F1C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfEWOIK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 10:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbfEWOIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 10:08:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E07CE9B3B7
        for <stable@vger.kernel.org>; Thu, 23 May 2019 14:08:09 +0000 (UTC)
Received: from [172.54.114.147] (cpt-0011.paas.prod.upshift.rdu2.redhat.com [10.0.18.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A11610027C5;
        Thu, 23 May 2019 14:08:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.DA3EF38E33.R86MVIC53T@redhat.com>
X-Gitlab-Pipeline-ID: 10680
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10680?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 23 May 2019 14:08:09 +0000 (UTC)
Date:   Thu, 23 May 2019 10:08:10 -0400
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

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-d460dd0360b2506a26b1c50da007574b8e65ebd2.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-d460dd0360b2506a26b1c50da007574b8e65ebd2.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-d460dd0360b2506a26b1c50da007574b8e65ebd2.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-d460dd0360b2506a26b1c50da007574b8e65ebd2.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-d460dd0360b2506a26b1c50da007574b8e65ebd2.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-d460dd0360b2506a26b1c50da007574b8e65ebd2.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-d460dd0360b2506a26b1c50da007574b8e65ebd2.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-d460dd0360b2506a26b1c50da007574b8e65ebd2.tar.gz


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
     ✅ stress: stress-ng [9]
     ✅ Boot test [0]
     ✅ xfstests: xfs [10]
     ✅ selinux-policy: serge-testsuite [11]
     🚧 ✅ Networking socket: fuzz [12]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [13]
     🚧 ✅ Networking route_func: local [14]
     🚧 ✅ Networking route_func: forward [14]

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
     ✅ stress: stress-ng [9]
     ✅ Boot test [0]
     ✅ xfstests: xfs [10]
     ✅ selinux-policy: serge-testsuite [11]
     🚧 ✅ Networking socket: fuzz [12]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [13]
     🚧 ✅ Networking route_func: local [14]
     🚧 ✅ Networking route_func: forward [14]

  s390x:

  x86_64:
     ✅ Boot test [0]
     ✅ xfstests: xfs [10]
     ✅ selinux-policy: serge-testsuite [11]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ audit: audit testsuite test [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ tuned: tune-processes-through-perf [8]
     ✅ stress: stress-ng [9]
     🚧 ✅ Networking socket: fuzz [12]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking route: pmtu [13]
     🚧 ✅ Networking route_func: local [14]
     🚧 ✅ Networking route_func: forward [14]

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
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
