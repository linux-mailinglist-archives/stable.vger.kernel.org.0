Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12E134F89
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFDSFd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Jun 2019 14:05:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDSFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 14:05:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A85167FDF8
        for <stable@vger.kernel.org>; Tue,  4 Jun 2019 18:05:32 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3783D2BE79;
        Tue,  4 Jun 2019 18:05:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.5556BA4292.1QS0JW5RGD@redhat.com>
X-Gitlab-Pipeline-ID: 11492
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11492?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 04 Jun 2019 18:05:32 +0000 (UTC)
Date:   Tue, 4 Jun 2019 14:05:32 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e109a984cf38 - Linux 4.19.48

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
  Commit: e109a984cf38 - Linux 4.19.48


We then merged the patchset with `git am`:

  sparc64-fix-regression-in-non-hypervisor-tlb-flush-xcall.patch
  include-linux-bitops.h-sanitize-rotate-primitives.patch
  xhci-update-bounce-buffer-with-correct-sg-num.patch
  xhci-use-zu-for-printing-size_t-type.patch
  xhci-convert-xhci_handshake-to-use-readl_poll_timeout_atomic.patch
  usb-xhci-avoid-null-pointer-deref-when-bos-field-is-null.patch
  usbip-usbip_host-fix-bug-sleeping-function-called-from-invalid-context.patch
  usbip-usbip_host-fix-stub_dev-lock-context-imbalance-regression.patch
  usb-fix-slab-out-of-bounds-write-in-usb_get_bos_descriptor.patch
  usb-sisusbvga-fix-oops-in-error-path-of-sisusb_probe.patch
  usb-add-lpm-quirk-for-surface-dock-gige-adapter.patch
  usb-rio500-refuse-more-than-one-device-at-a-time.patch
  usb-rio500-fix-memory-leak-in-close-after-disconnect.patch
  media-usb-siano-fix-general-protection-fault-in-smsusb.patch
  media-usb-siano-fix-false-positive-uninitialized-variable-warning.patch
  media-smsusb-better-handle-optional-alignment.patch
  brcmfmac-fix-null-pointer-derefence-during-usb-disconnect.patch
  scsi-zfcp-fix-missing-zfcp_port-reference-put-on-ebusy-from-port_remove.patch
  scsi-zfcp-fix-to-prevent-port_remove-with-pure-auto-scan-luns-only-sdevs.patch
  tracing-avoid-memory-leak-in-predicate_parse.patch
  btrfs-fix-wrong-ctime-and-mtime-of-a-directory-after-log-replay.patch
  btrfs-fix-race-updating-log-root-item-during-fsync.patch
  btrfs-fix-fsync-not-persisting-changed-attributes-of-a-directory.patch
  btrfs-incremental-send-fix-file-corruption-when-no-holes-feature-is-enabled.patch
  iio-dac-ds4422-ds4424-fix-chip-verification.patch
  iio-adc-ti-ads8688-fix-timestamp-is-not-updated-in-buffer.patch
  s390-crypto-fix-gcm-aes-s390-selftest-failures.patch
  s390-crypto-fix-possible-sleep-during-spinlock-aquired.patch
  kvm-ppc-book3s-hv-xive-do-not-clear-irq-data-of-passthrough-interrupts.patch
  powerpc-perf-fix-mmcra-corruption-by-bhrb_filter.patch
  alsa-line6-assure-canceling-delayed-work-at-disconnection.patch
  alsa-hda-realtek-set-default-power-save-node-to-0.patch
  alsa-hda-realtek-improve-the-headset-mic-for-acer-aspire-laptops.patch
  kvm-s390-do-not-report-unusabled-ids-via-kvm_cap_max_vcpu_id.patch
  drm-nouveau-i2c-disable-i2c-bus-access-after-fini.patch
  i2c-mlxcpld-fix-wrong-initialization-order-in-probe.patch
  i2c-synquacer-fix-synquacer_i2c_doxfer-return-value.patch
  tty-serial-msm_serial-fix-xon-xoff.patch
  tty-max310x-fix-external-crystal-register-setup.patch
  memcg-make-it-work-on-sparse-non-0-node-systems.patch
  kernel-signal.c-trace_signal_deliver-when-signal_group_exit.patch
  arm64-fix-the-arm64_personality-syscall-wrapper-redirection.patch
  docs-fix-conf.py-for-sphinx-2.0.patch
  doc-cope-with-the-deprecation-of-autoreporter.patch
  doc-cope-with-sphinx-logging-deprecations.patch
  ima-show-rules-with-ima_inmask-correctly.patch
  evm-check-hash-algorithm-passed-to-init_desc.patch
  vt-fbcon-deinitialize-resources-in-visual_init-after-failed-memory-allocation.patch
  serial-sh-sci-disable-dma-for-uart_console.patch
  staging-vc04_services-prevent-integer-overflow-in-create_pagelist.patch
  staging-wlan-ng-fix-adapter-initialization-failure.patch
  cifs-fix-memory-leak-of-pneg_inbuf-on-eopnotsupp-ioctl-case.patch
  cifs-cifs_read_allocate_pages-don-t-iterate-through-whole-page-array-on-enomem.patch
  revert-lockd-show-pid-of-lockd-for-remote-locks.patch
  gcc-plugins-fix-build-failures-under-darwin-host.patch
  drm-tegra-gem-fix-cpu-cache-maintenance-for-bo-s-allocated-using-get_pages.patch
  drm-vmwgfx-don-t-send-drm-sysfs-hotplug-events-on-initial-master-set.patch
  drm-sun4i-fix-sun8i-hdmi-phy-clock-initialization.patch
  drm-sun4i-fix-sun8i-hdmi-phy-configuration-for-148.5-mhz.patch
  drm-rockchip-shutdown-drm-subsystem-on-shutdown.patch
  drm-lease-make-sure-implicit-planes-are-leased.patch
  compiler-attributes-add-support-for-__copy-gcc-9.patch
  include-linux-module.h-copy-__init-__exit-attrs-to-init-cleanup_module.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-84a5342f83a4f2bd712d23181820d6914bdecc65.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-84a5342f83a4f2bd712d23181820d6914bdecc65.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-84a5342f83a4f2bd712d23181820d6914bdecc65.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-84a5342f83a4f2bd712d23181820d6914bdecc65.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-84a5342f83a4f2bd712d23181820d6914bdecc65.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-84a5342f83a4f2bd712d23181820d6914bdecc65.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-84a5342f83a4f2bd712d23181820d6914bdecc65.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-84a5342f83a4f2bd712d23181820d6914bdecc65.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ stress: stress-ng [10]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ stress: stress-ng [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ stress: stress-ng [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
