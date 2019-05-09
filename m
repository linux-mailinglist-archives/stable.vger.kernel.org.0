Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0F192D6
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfEITVG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 May 2019 15:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbfEITUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 15:20:37 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AFDD86668
        for <stable@vger.kernel.org>; Thu,  9 May 2019 19:20:36 +0000 (UTC)
Received: from [172.54.105.48] (cpt-0019.paas.prod.upshift.rdu2.redhat.com [10.0.18.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C216A60CD7;
        Thu,  9 May 2019 19:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.50660F1890.WDSRU27JIS@redhat.com>
X-Gitlab-Pipeline-ID: 9629
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9629
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 09 May 2019 19:20:36 +0000 (UTC)
Date:   Thu, 9 May 2019 15:20:37 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e93c9c99a629 - Linux 5.1

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
  Commit: e93c9c99a629 - Linux 5.1

We then merged the patchset with `git am`:

  drivers-hv-vmbus-remove-the-undesired-put_cpu_ptr-in-hv_synic_cleanup.patch
  ubsan-fix-nasty-wbuiltin-declaration-mismatch-gcc-9-warnings.patch
  staging-greybus-power_supply-fix-prop-descriptor-request-size.patch
  staging-wilc1000-avoid-gfp_kernel-allocation-from-atomic-context.patch
  staging-most-cdev-fix-chrdev_region-leak-in-mod_exit.patch
  staging-most-sound-pass-correct-device-when-creating-a-sound-card.patch
  usb-dwc3-allow-building-usb_dwc3_qcom-without-extcon.patch
  usb-dwc3-fix-default-lpm_nyet_threshold-value.patch
  usb-serial-f81232-fix-interrupt-worker-not-stop.patch
  usb-cdc-acm-fix-unthrottle-races.patch
  usb-storage-set-virt_boundary_mask-to-avoid-sg-overflows.patch
  genirq-prevent-use-after-free-and-work-list-corruption.patch
  intel_th-pci-add-comet-lake-support.patch
  iio-adc-qcom-spmi-adc5-fix-of-based-module-autoloading.patch
  cpufreq-armada-37xx-fix-frequency-calculation-for-opp.patch
  acpi-lpss-use-acpi_lpss_-instead-of-acpi_subsys_-functions-for-hibernate.patch
  soc-sunxi-fix-missing-dependency-on-regmap_mmio.patch
  scsi-lpfc-change-snprintf-to-scnprintf-for-possible-overflow.patch
  scsi-qla2xxx-fix-incorrect-region-size-setting-in-optrom-sysfs-routines.patch
  scsi-qla2xxx-set-remote-port-devloss-timeout-to-0.patch
  scsi-qla2xxx-fix-device-staying-in-blocked-state.patch
  bluetooth-hidp-fix-buffer-overflow.patch
  bluetooth-align-minimum-encryption-key-size-for-le-and-br-edr-connections.patch
  bluetooth-fix-not-initializing-l2cap-tx_credits.patch
  bluetooth-hci_bcm-fix-empty-regulator-supplies-for-intel-macs.patch
  uas-fix-alignment-of-scatter-gather-segments.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-c82e8c01f5d35d794bb5ab119414c197a9f87939.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-c82e8c01f5d35d794bb5ab119414c197a9f87939.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-c82e8c01f5d35d794bb5ab119414c197a9f87939.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-c82e8c01f5d35d794bb5ab119414c197a9f87939.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-c82e8c01f5d35d794bb5ab119414c197a9f87939.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-c82e8c01f5d35d794bb5ab119414c197a9f87939.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-c82e8c01f5d35d794bb5ab119414c197a9f87939.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-c82e8c01f5d35d794bb5ab119414c197a9f87939.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  ppc64le:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
