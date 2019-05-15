Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED21F98A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfEORqW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 May 2019 13:46:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfEORqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 13:46:22 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CD233083045
        for <stable@vger.kernel.org>; Wed, 15 May 2019 17:46:21 +0000 (UTC)
Received: from [172.54.252.220] (cpt-0020.paas.prod.upshift.rdu2.redhat.com [10.0.18.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2634D100033F;
        Wed, 15 May 2019 17:46:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.C7AD9FFDDC.3FHMWLNEZS@redhat.com>
X-Gitlab-Pipeline-ID: 10132
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10132?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 15 May 2019 17:46:21 +0000 (UTC)
Date:   Wed, 15 May 2019 13:46:22 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: eb5d65a82f5c - Linux 5.1.2

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
  Commit: eb5d65a82f5c - Linux 5.1.2

We then merged the patchset with `git am`:

  platform-x86-sony-laptop-fix-unintentional-fall-through.patch
  platform-x86-thinkpad_acpi-disable-bluetooth-for-some-machines.patch
  platform-x86-dell-laptop-fix-rfkill-functionality.patch
  hwmon-pwm-fan-disable-pwm-if-fetching-cooling-data-fails.patch
  hwmon-occ-fix-extended-status-bits.patch
  selftests-seccomp-handle-namespace-failures-gracefully.patch
  i2c-core-ratelimit-transfer-when-suspended-errors.patch
  kernfs-fix-barrier-usage-in-__kernfs_new_node.patch
  virt-vbox-sanity-check-parameter-types-for-hgcm-calls-coming-from-userspace.patch
  usb-serial-fix-unthrottle-races.patch
  mwl8k-fix-rate_idx-underflow.patch
  rtlwifi-rtl8723ae-fix-missing-break-in-switch-statement.patch
  don-t-jump-to-compute_result-state-from-check_result-state.patch
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
  tipc-fix-hanging-clients-using-poll-with-epollout-flag.patch
  vlan-disable-siocshwtstamp-in-container.patch
  vrf-sit-mtu-should-not-be-updated-when-vrf-netdev-is-the-link.patch
  tuntap-fix-dividing-by-zero-in-ebpf-queue-selection.patch
  tuntap-synchronize-through-tfiles-array-instead-of-tun-numqueues.patch
  net-phy-fix-phy_validate_pause.patch
  flow_dissector-disable-preemption-around-bpf-calls.patch
  isdn-bas_gigaset-use-usb_fill_int_urb-properly.patch
  drivers-virt-fsl_hypervisor.c-dereferencing-error-pointers-in-ioctl.patch
  drivers-virt-fsl_hypervisor.c-prevent-integer-overflow-in-ioctl.patch
  powerpc-book3s-64-check-for-null-pointer-in-pgd_alloc.patch
  powerpc-powernv-idle-restore-iamr-after-idle.patch
  powerpc-booke64-set-ri-in-default-msr.patch
  virtio_ring-fix-potential-mem-leak-in-virtqueue_add_indirect_packed.patch
  pci-hv-fix-a-memory-leak-in-hv_eject_device_work.patch
  pci-hv-add-hv_pci_remove_slots-when-we-unload-the-driver.patch
  pci-hv-add-pci_destroy_slot-in-pci_devices_present_work-if-necessary.patch
  f2fs-fix-use-of-number-of-devices.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-da218361a5a64b3b31306fa27d4f157cfea3c5c0.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-da218361a5a64b3b31306fa27d4f157cfea3c5c0.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-da218361a5a64b3b31306fa27d4f157cfea3c5c0.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-da218361a5a64b3b31306fa27d4f157cfea3c5c0.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-da218361a5a64b3b31306fa27d4f157cfea3c5c0.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-da218361a5a64b3b31306fa27d4f157cfea3c5c0.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-da218361a5a64b3b31306fa27d4f157cfea3c5c0.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-da218361a5a64b3b31306fa27d4f157cfea3c5c0.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  ppc64le:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]
     🚧 ✅ selinux-policy: serge-testsuite [8]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
