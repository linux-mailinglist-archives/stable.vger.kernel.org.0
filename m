Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD51ED04
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfEOLEQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 May 2019 07:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbfEOLEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F21489C36
        for <stable@vger.kernel.org>; Wed, 15 May 2019 11:04:15 +0000 (UTC)
Received: from [172.54.252.220] (cpt-0020.paas.prod.upshift.rdu2.redhat.com [10.0.18.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77E3E600D4;
        Wed, 15 May 2019 11:04:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.42E670DE27.4VDC889R9U@redhat.com>
X-Gitlab-Pipeline-ID: 10110
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10110?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 15 May 2019 11:04:15 +0000 (UTC)
Date:   Wed, 15 May 2019 07:04:15 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 3351e9d39947 - Linux 4.19.43

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
  Commit: 3351e9d39947 - Linux 4.19.43

We then merged the patchset with `git am`:

  bfq-update-internal-depth-state-when-queue-depth-cha.patch
  platform-x86-sony-laptop-fix-unintentional-fall-through.patch
  platform-x86-thinkpad_acpi-disable-bluetooth-for-some-machines.patch
  platform-x86-dell-laptop-fix-rfkill-functionality.patch
  hwmon-pwm-fan-disable-pwm-if-fetching-cooling-data-fails.patch
  kernfs-fix-barrier-usage-in-__kernfs_new_node.patch
  virt-vbox-sanity-check-parameter-types-for-hgcm-calls-coming-from-userspace.patch
  usb-serial-fix-unthrottle-races.patch
  iio-adc-xilinx-fix-potential-use-after-free-on-remov.patch
  iio-adc-xilinx-fix-potential-use-after-free-on-probe.patch
  iio-adc-xilinx-prevent-touching-unclocked-h-w-on-rem.patch
  acpi-nfit-always-dump-_dsm-output-payload.patch
  libnvdimm-namespace-fix-a-potential-null-pointer-der.patch
  hid-input-add-mapping-for-expose-overview-key.patch
  hid-input-add-mapping-for-keyboard-brightness-up-dow.patch
  hid-input-add-mapping-for-toggle-display-key.patch
  libnvdimm-btt-fix-a-kmemdup-failure-check.patch
  s390-dasd-fix-capacity-calculation-for-large-volumes.patch
  mac80211-fix-unaligned-access-in-mesh-table-hash-fun.patch
  mac80211-increase-max_msg_len.patch
  cfg80211-handle-wmm-rules-in-regulatory-domain-inter.patch
  mac80211-fix-memory-accounting-with-a-msdu-aggregati.patch
  nl80211-add-nl80211_flag_clear_skb-flag-for-other-nl.patch
  libnvdimm-pmem-fix-a-possible-oob-access-when-read-a.patch
  s390-3270-fix-lockdep-false-positive-on-view-lock.patch
  drm-amd-display-extending-aux-sw-timeout.patch
  clocksource-drivers-npcm-select-timer_of.patch
  clocksource-drivers-oxnas-fix-ox820-compatible.patch
  selftests-fib_tests-fix-command-line-is-not-complete.patch
  misdn-check-address-length-before-reading-address-fa.patch
  vxge-fix-return-of-a-free-d-memblock-on-a-failed-dma.patch
  qede-fix-write-to-free-d-pointer-error-and-double-fr.patch
  afs-unlock-pages-for-__pagevec_release.patch
  drm-amd-display-if-one-stream-full-updates-full-upda.patch
  s390-pkey-add-one-more-argument-space-for-debug-feat.patch
  x86-build-lto-fix-truncated-.bss-with-fdata-sections.patch
  x86-reboot-efi-use-efi-reboot-for-acer-travelmate-x5.patch
  kvm-fix-spectrev1-gadgets.patch
  kvm-x86-avoid-misreporting-level-triggered-irqs-as-e.patch
  tools-lib-traceevent-fix-missing-equality-check-for-.patch
  ipmi-ipmi_si_hardcode.c-init-si_type-array-to-fix-a-.patch
  ocelot-don-t-sleep-in-atomic-context-irqs_disabled.patch
  scsi-aic7xxx-fix-eisa-support.patch
  mm-fix-inactive-list-balancing-between-numa-nodes-an.patch
  init-initialize-jump-labels-before-command-line-opti.patch
  selftests-netfilter-check-icmp-pkttoobig-errors-are-.patch
  ipvs-do-not-schedule-icmp-errors-from-tunnels.patch
  netfilter-ctnetlink-don-t-use-conntrack-expect-objec.patch
  netfilter-nf_tables-prevent-shift-wrap-in-nft_chain_.patch
  mips-perf-ath79-fix-perfcount-irq-assignment.patch
  s390-ctcm-fix-ctcm_new_device-error-return-code.patch
  drm-sun4i-set-device-driver-data-at-bind-time-for-us.patch
  drm-sun4i-fix-component-unbinding-and-component-mast.patch
  selftests-net-correct-the-return-value-for-run_netso.patch
  netfilter-fix-nf_l4proto_log_invalid-to-log-invalid-.patch
  gpu-ipu-v3-dp-fix-csc-handling.patch
  drm-imx-don-t-skip-dp-channel-disable-for-background.patch
  arm-8856-1-nommu-fix-ccr-register-faulty-initializat.patch
  spi-micrel-eth-switch-declare-missing-of-table.patch
  spi-st-st95hf-nfc-declare-missing-of-table.patch
  drm-sun4i-unbind-components-before-releasing-drm-and.patch
  input-synaptics-rmi4-fix-possible-double-free.patch
  rdma-hns-bugfix-for-mapping-user-db.patch
  mm-memory_hotplug.c-drop-memory-device-reference-aft.patch
  powerpc-smp-fix-nmi-ipi-timeout.patch
  powerpc-smp-fix-nmi-ipi-xmon-timeout.patch
  net-dsa-mv88e6xxx-fix-few-issues-in-mv88e6390x_port_.patch
  mm-memory.c-fix-modifying-of-page-protection-by-inse.patch
  usb-typec-fix-unchecked-return-value.patch
  netfilter-nf_tables-use-after-free-in-dynamic-operat.patch
  netfilter-nf_tables-add-missing-release_ops-in-error.patch
  net-fec-manage-ahb-clock-in-runtime-pm.patch
  mlxsw-spectrum_switchdev-add-mdb-entries-in-prepare-.patch
  mlxsw-core-do-not-use-wq_mem_reclaim-for-emad-workqu.patch
  mlxsw-core-do-not-use-wq_mem_reclaim-for-mlxsw-order.patch
  mlxsw-core-do-not-use-wq_mem_reclaim-for-mlxsw-workq.patch
  net-tls-fix-the-iv-leaks.patch
  net-strparser-partially-revert-strparser-call-skb_un.patch
  nfc-nci-add-some-bounds-checking-in-nci_hci_cmd_rece.patch
  nfc-nci-potential-off-by-one-in-pipes-array.patch
  x86-kprobes-avoid-kretprobe-recursion-bug.patch
  cw1200-fix-missing-unlock-on-error-in-cw1200_hw_scan.patch
  mwl8k-fix-rate_idx-underflow.patch
  rtlwifi-rtl8723ae-fix-missing-break-in-switch-statement.patch
  don-t-jump-to-compute_result-state-from-check_result-state.patch
  um-don-t-hardcode-path-as-it-is-architecture-dependent.patch
  powerpc-64s-include-cpu-header.patch
  bonding-fix-arp_validate-toggling-in-active-backup-mode.patch
  bridge-fix-error-path-for-kobject_init_and_add.patch
  dpaa_eth-fix-sg-frame-cleanup.patch
  fib_rules-return-0-directly-if-an-exactly-same-rule-exists-when-nlm_f_excl-not-supplied.patch
  ipv4-fix-raw-socket-lookup-for-local-traffic.patch
  net-dsa-fix-error-cleanup-path-in-dsa_init_module.patch
  net-ethernet-stmmac-dwmac-sun8i-enable-support-of-unicast-filtering.patch
  net-macb-change-interrupt-and-napi-enable-order-in-open.patch
  net-seeq-fix-crash-caused-by-not-set-dev.parent.patch
  net-ucc_geth-fix-oops-when-changing-number-of-buffers-in-the-ring.patch
  packet-fix-error-path-in-packet_init.patch
  selinux-do-not-report-error-on-connect-af_unspec.patch
  vlan-disable-siocshwtstamp-in-container.patch
  vrf-sit-mtu-should-not-be-updated-when-vrf-netdev-is-the-link.patch
  tuntap-fix-dividing-by-zero-in-ebpf-queue-selection.patch
  tuntap-synchronize-through-tfiles-array-instead-of-tun-numqueues.patch
  isdn-bas_gigaset-use-usb_fill_int_urb-properly.patch
  tipc-fix-hanging-clients-using-poll-with-epollout-flag.patch
  drivers-virt-fsl_hypervisor.c-dereferencing-error-pointers-in-ioctl.patch
  drivers-virt-fsl_hypervisor.c-prevent-integer-overflow-in-ioctl.patch
  powerpc-book3s-64-check-for-null-pointer-in-pgd_alloc.patch
  powerpc-powernv-idle-restore-iamr-after-idle.patch
  powerpc-booke64-set-ri-in-default-msr.patch
  pci-hv-fix-a-memory-leak-in-hv_eject_device_work.patch
  pci-hv-add-hv_pci_remove_slots-when-we-unload-the-driver.patch
  pci-hv-add-pci_destroy_slot-in-pci_devices_present_work-if-necessary.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-b0f26decee8f08320a6241fafa4972ab8af5d4ee.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-b0f26decee8f08320a6241fafa4972ab8af5d4ee.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-b0f26decee8f08320a6241fafa4972ab8af5d4ee.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-b0f26decee8f08320a6241fafa4972ab8af5d4ee.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-b0f26decee8f08320a6241fafa4972ab8af5d4ee.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-b0f26decee8f08320a6241fafa4972ab8af5d4ee.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-b0f26decee8f08320a6241fafa4972ab8af5d4ee.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-b0f26decee8f08320a6241fafa4972ab8af5d4ee.tar.gz


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
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ stress: stress-ng [11]
     🚧 ✅ selinux-policy: serge-testsuite [12]

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
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ stress: stress-ng [11]
     🚧 ✅ selinux-policy: serge-testsuite [12]

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
     ✅ lvm thinp sanity [9]
     🚧 ✅ selinux-policy: serge-testsuite [12]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ stress: stress-ng [11]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [10]
     🚧 ✅ stress: stress-ng [11]
     🚧 ✅ selinux-policy: serge-testsuite [12]

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
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
