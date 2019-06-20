Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415364C9D4
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbfFTIuz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 20 Jun 2019 04:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbfFTIuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 04:50:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6528E307844A
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 08:50:54 +0000 (UTC)
Received: from [172.54.67.194] (cpt-large-cpu-02.paas.prod.upshift.rdu2.redhat.com [10.0.18.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC5391001E6F;
        Thu, 20 Jun 2019 08:50:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.B3F58C8B62.YP4KA7XT0V@redhat.com>
X-Gitlab-Pipeline-ID: 12850
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 20 Jun 2019 08:50:54 +0000 (UTC)
Date:   Thu, 20 Jun 2019 04:50:55 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 5752b50477da - Linux 5.1.12

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
  Commit: 5752b50477da - Linux 5.1.12


We then merged the patchset with `git am`:

  netfilter-nat-fix-udp-checksum-corruption.patch
  ax25-fix-inconsistent-lock-state-in-ax25_destroy_timer.patch
  be2net-fix-number-of-rx-queues-used-for-flow-hashing.patch
  hv_netvsc-set-probe-mode-to-sync.patch
  ipv6-flowlabel-fl6_sock_lookup-must-use-atomic_inc_not_zero.patch
  lapb-fixed-leak-of-control-blocks.patch
  neigh-fix-use-after-free-read-in-pneigh_get_next.patch
  net-dsa-rtl8366-fix-up-vlan-filtering.patch
  net-openvswitch-do-not-free-vport-if-register_netdevice-is-failed.patch
  net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
  net-tls-correctly-account-for-copied-bytes-with-multiple-sk_msgs.patch
  nfc-ensure-presence-of-required-attributes-in-the-deactivate_target-handler.patch
  sctp-free-cookie-before-we-memdup-a-new-one.patch
  sunhv-fix-device-naming-inconsistency-between-sunhv_console-and-sunhv_reg.patch
  tipc-purge-deferredq-list-for-each-grp-member-in-tipc_group_delete.patch
  vsock-virtio-set-sock_done-on-peer-shutdown.patch
  net-mlx5-avoid-reloading-already-removed-devices.patch
  vxlan-don-t-assume-linear-buffers-in-error-handler.patch
  geneve-don-t-assume-linear-buffers-in-error-handler.patch
  net-mvpp2-prs-fix-parser-range-for-vid-filtering.patch
  net-mvpp2-prs-use-the-correct-helpers-when-removing-all-vid-filters.patch
  net-dsa-microchip-don-t-try-to-read-stats-for-unused-ports.patch
  net-ethtool-allow-matching-on-vlan-dei-bit.patch
  net-mlx5-update-pci-error-handler-entries-and-command-translation.patch
  mlxsw-spectrum_router-refresh-nexthop-neighbour-when-it-becomes-dead.patch
  net-mlx5e-add-ndo_set_feature-for-uplink-representor.patch
  mlxsw-spectrum_flower-fix-tos-matching.patch
  net-mlx5e-fix-source-port-matching-in-fdb-peer-flow-rule.patch
  mlxsw-spectrum_buffers-reduce-pool-size-on-spectrum-2.patch
  net-mlx5e-support-tagged-tunnel-over-bond.patch
  net-correct-udp-zerocopy-refcnt-also-when-zerocopy-only-on-append.patch
  net-mlx5e-avoid-detaching-non-existing-netdev-under-switchdev-mode.patch
  iio-imu-mpu6050-fix-fifo-layout-for-icm20602.patch
  staging-erofs-set-sb-s_root-to-null-when-failing-fro.patch
  staging-vc04_services-fix-a-couple-error-codes.patch
  staging-wilc1000-fix-some-double-unlock-bugs-in-wilc.patch
  pinctrl-intel-clear-interrupt-status-in-mask-unmask-.patch
  netfilter-nf_tables-fix-oops-during-rule-dump.patch
  perf-x86-intel-ds-fix-event-vs.-uevent-pebs-constrai.patch
  netfilter-nf_queue-fix-reinject-verdict-handling.patch
  netfilter-nft_fib-fix-existence-check-support.patch
  ipvs-fix-use-after-free-in-ip_vs_in.patch
  selftests-netfilter-missing-error-check-when-setting.patch
  clk-ti-clkctrl-fix-clkdm_clk-handling.patch
  powerpc-powernv-return-for-invalid-imc-domain.patch
  usb-xhci-fix-a-potential-null-pointer-dereference-in.patch
  misdn-make-sure-device-name-is-nul-terminated.patch
  x86-cpu-amd-don-t-force-the-cpb-cap-when-running-und.patch
  perf-ring_buffer-fix-exposing-a-temporarily-decrease.patch
  perf-ring_buffer-add-ordering-to-rb-nest-increment.patch
  perf-ring-buffer-always-use-read-write-_once-for-rb-.patch
  gpio-fix-gpio-adp5588-build-errors.patch
  net-stmmac-update-rx-tail-pointer-register-to-fix-rx.patch
  net-stmmac-fix-csr_clk-can-t-be-zero-issue.patch
  net-stmmac-dwmac-mediatek-modify-csr_clk-value-to-fi.patch
  io_uring-fix-__io_uring_register-false-success.patch
  dpaa2-eth-fix-potential-spectre-issue.patch
  dpaa2-eth-use-ptr_err_or_zero-where-appropriate.patch
  net-tulip-de4x5-drop-redundant-module_device_table.patch
  acpi-pci-pm-add-missing-wakeup.flags.valid-checks.patch
  loop-don-t-change-loop-device-under-exclusive-opener.patch
  drm-etnaviv-lock-mmu-while-dumping-core.patch
  net-aquantia-tx-clean-budget-logic-error.patch
  net-aquantia-fix-lro-with-fcs-error.patch
  i2c-dev-fix-potential-memory-leak-in-i2cdev_ioctl_rd.patch
  alsa-hda-force-polling-mode-on-cnl-for-fixing-codec-.patch
  configfs-fix-use-after-free-when-accessing-sd-s_dent.patch
  perf-data-fix-strncat-may-truncate-build-failure-wit.patch
  s390-zcrypt-fix-wrong-dispatching-for-control-domain.patch
  perf-namespace-protect-reading-thread-s-namespace.patch
  perf-record-fix-s390-missing-module-symbol-and-warni.patch
  ia64-fix-build-errors-by-exporting-paddr_to_nid.patch
  dpaa_eth-use-only-online-cpu-portals.patch
  xen-pvcalls-remove-set-but-not-used-variable.patch
  xenbus-avoid-deadlock-during-suspend-due-to-open-tra.patch
  dfs_cache-fix-a-wrong-use-of-kfree-in-flush_cache_en.patch
  kvm-ppc-book3s-hv-use-new-mutex-to-synchronize-mmu-s.patch
  kvm-ppc-book3s-use-new-mutex-to-synchronize-access-t.patch
  kvm-ppc-book3s-hv-don-t-take-kvm-lock-around-kvm_for.patch
  alsa-fireface-use-ull-suffixes-for-64-bit-constants.patch
  arm64-fix-syscall_fn_t-type.patch
  arm64-use-the-correct-function-type-in-syscall_defin.patch
  arm64-use-the-correct-function-type-for-__arm64_sys_.patch
  net-sh_eth-fix-mdio-access-in-sh_eth_close-for-r-car.patch
  blk-mq-fix-memory-leak-in-error-handling.patch
  net-phylink-ensure-consistent-phy-interface-mode.patch
  net-phy-dp83867-fix-speed-10-in-sgmii-mode.patch
  net-phy-dp83867-increase-sgmii-autoneg-timer-duratio.patch
  net-phy-dp83867-set-up-rgmii-tx-delay.patch
  scsi-libcxgbi-add-a-check-for-null-pointer-in-cxgbi_.patch
  scsi-smartpqi-properly-set-both-the-dma-mask-and-the.patch
  scsi-scsi_dh_alua-fix-possible-null-ptr-deref.patch
  scsi-libsas-delete-sas-port-if-expander-discover-fai.patch
  mlxsw-spectrum-prevent-force-of-56g.patch
  ocfs2-fix-error-path-kobject-memory-leak.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-b3bea23e64b61e383261b6dc4a6a599ad733b2be.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-b3bea23e64b61e383261b6dc4a6a599ad733b2be.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-b3bea23e64b61e383261b6dc4a6a599ad733b2be.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-b3bea23e64b61e383261b6dc4a6a599ad733b2be.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-b3bea23e64b61e383261b6dc4a6a599ad733b2be.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-b3bea23e64b61e383261b6dc4a6a599ad733b2be.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-b3bea23e64b61e383261b6dc4a6a599ad733b2be.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-b3bea23e64b61e383261b6dc4a6a599ad733b2be.tar.gz


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
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ Usex - version 1.9-29 [9]
       ✅ lvm thinp sanity [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]
       🚧 ✅ Networking tunnel: vxlan basic [14]
       🚧 ✅ Networking tunnel: geneve basic test [15]
       🚧 ✅ tuned: tune-processes-through-perf [16]
       🚧 ✅ storage: SCSI VPD [17]
       🚧 ✅ storage: software RAID testing [18]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [19]
       ✅ selinux-policy: serge-testsuite [20]


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
       ✅ lvm thinp sanity [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]
       🚧 ✅ Networking tunnel: vxlan basic [14]
       🚧 ✅ Networking tunnel: geneve basic test [15]
       🚧 ✅ tuned: tune-processes-through-perf [16]
       🚧 ✅ storage: software RAID testing [18]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [19]
       ✅ selinux-policy: serge-testsuite [20]


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
       ✅ lvm thinp sanity [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]
       🚧 ✅ Networking tunnel: vxlan basic [14]
       🚧 ✅ Networking tunnel: geneve basic test [15]
       🚧 ✅ tuned: tune-processes-through-perf [16]
       🚧 ✅ storage: software RAID testing [18]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [20]


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
       ✅ lvm thinp sanity [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route_func: local [13]
       🚧 ✅ Networking route_func: forward [13]
       🚧 ✅ Networking tunnel: vxlan basic [14]
       🚧 ✅ Networking tunnel: geneve basic test [15]
       🚧 ✅ tuned: tune-processes-through-perf [16]
       🚧 ✅ storage: SCSI VPD [17]
       🚧 ✅ storage: software RAID testing [18]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [19]
       ✅ selinux-policy: serge-testsuite [20]


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
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
