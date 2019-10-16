Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0674EDA072
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392856AbfJPWLg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Oct 2019 18:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395420AbfJPWLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 18:11:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA89C2F30D1
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 22:11:34 +0000 (UTC)
Received: from [172.54.96.74] (cpt-1049.paas.prod.upshift.rdu2.redhat.com [10.0.19.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AF2454292;
        Wed, 16 Oct 2019 22:11:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
CC:     Zhaojuan Guo <zguo@redhat.com>
Message-ID: <cki.3C6882785B.RW80EYEPUN@redhat.com>
X-Gitlab-Pipeline-ID: 229324
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/229324
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 16 Oct 2019 22:11:34 +0000 (UTC)
Date:   Wed, 16 Oct 2019 18:11:35 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d980f67059db - Linux 5.3.6

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/229324

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

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: d980f67059db - Linux 5.3.6


We grabbed the 09aa22322bfd commit of the stable queue repository.

We then merged the patchset with `git am`:

  panic-ensure-preemption-is-disabled-during-panic.patch
  usb-rio500-remove-rio-500-kernel-driver.patch
  usb-yurex-don-t-retry-on-unexpected-errors.patch
  usb-yurex-fix-null-derefs-on-disconnect.patch
  usb-usb-skeleton-fix-runtime-pm-after-driver-unbind.patch
  usb-usb-skeleton-fix-null-deref-on-disconnect.patch
  xhci-fix-false-warning-message-about-wrong-bounce-buffer-write-length.patch
  xhci-prevent-device-initiated-u1-u2-link-pm-if-exit-latency-is-too-long.patch
  xhci-check-all-endpoints-for-lpm-timeout.patch
  xhci-fix-usb-3.1-capability-detection-on-early-xhci-1.1-spec-based-hosts.patch
  usb-xhci-wait-for-cnr-controller-not-ready-bit-in-xhci-resume.patch
  xhci-prevent-deadlock-when-xhci-adapter-breaks-during-init.patch
  xhci-increase-sts_save-timeout-in-xhci_suspend.patch
  xhci-fix-null-pointer-dereference-in-xhci_clear_tt_buffer_complete.patch
  usb-adutux-fix-use-after-free-on-disconnect.patch
  usb-adutux-fix-null-derefs-on-disconnect.patch
  usb-adutux-fix-use-after-free-on-release.patch
  usb-iowarrior-fix-use-after-free-on-disconnect.patch
  usb-iowarrior-fix-use-after-free-on-release.patch
  usb-iowarrior-fix-use-after-free-after-driver-unbind.patch
  usb-usblp-fix-runtime-pm-after-driver-unbind.patch
  usb-chaoskey-fix-use-after-free-on-release.patch
  usb-ldusb-fix-null-derefs-on-driver-unbind.patch
  serial-uartlite-fix-exit-path-null-pointer.patch
  serial-uartps-fix-uartps_major-handling.patch
  usb-serial-keyspan-fix-null-derefs-on-open-and-write.patch
  usb-serial-ftdi_sio-add-device-ids-for-sienna-and-echelon-pl-20.patch
  usb-serial-option-add-telit-fn980-compositions.patch
  usb-serial-option-add-support-for-cinterion-cls8-devices.patch
  usb-serial-fix-runtime-pm-after-driver-unbind.patch
  usb-usblcd-fix-i-o-after-disconnect.patch
  usb-microtek-fix-info-leak-at-probe.patch
  usb-dummy-hcd-fix-power-budget-for-superspeed-mode.patch
  usb-renesas_usbhs-gadget-do-not-discard-queues-in-usb_ep_set_-halt-wedge.patch
  usb-renesas_usbhs-gadget-fix-usb_ep_set_-halt-wedge-behavior.patch
  usb-typec-tcpm-usb-typec-tcpm-fix-a-signedness-bug-in-tcpm_fw_get_caps.patch
  usb-typec-ucsi-ccg-remove-run_isr-flag.patch
  usb-typec-ucsi-displayport-fix-for-the-mode-entering-routine.patch
  usb-legousbtower-fix-slab-info-leak-at-probe.patch
  usb-legousbtower-fix-deadlock-on-disconnect.patch
  usb-legousbtower-fix-potential-null-deref-on-disconnect.patch
  usb-legousbtower-fix-open-after-failed-reset-request.patch
  usb-legousbtower-fix-use-after-free-on-release.patch
  mei-me-add-comet-point-lake-lp-device-ids.patch
  mei-avoid-fw-version-request-on-ibex-peak-and-earlier.patch
  gpio-eic-sprd-fix-the-incorrect-eic-offset-when-toggling.patch
  staging-fbtft-depend-on-of.patch
  staging-bcm2835-audio-fix-draining-behavior-regression.patch
  staging-fbtft-fix-memory-leak-in-fbtft_framebuffer_alloc.patch
  staging-rtl8188eu-fix-highestrate-check-in-odm_arfbrefresh_8188e.patch
  staging-vt6655-fix-memory-leak-in-vt6655_probe.patch
  iio-adc-hx711-fix-bug-in-sampling-of-data.patch
  iio-adc-ad799x-fix-probe-error-handling.patch
  iio-adc-axp288-override-ts-pin-bias-current-for-some-models.patch
  iio-adc-stm32-adc-move-registers-definitions.patch
  iio-adc-stm32-adc-fix-a-race-when-using-several-adcs-with-dma-and-irq.patch
  iio-light-opt3001-fix-mutex-unlock-race.patch
  iio-light-add-missing-vcnl4040-of_compatible.patch
  iio-accel-adxl372-fix-remove-limitation-for-fifo-samples.patch
  iio-accel-adxl372-fix-push-to-buffers-lost-samples.patch
  iio-accel-adxl372-perform-a-reset-at-start-up.patch
  efivar-ssdt-don-t-iterate-over-efi-vars-if-no-ssdt-override-was-specified.patch
  efi-tpm-don-t-access-event-count-when-it-isn-t-mapped.patch
  efi-tpm-don-t-traverse-an-event-log-with-no-events.patch
  efi-tpm-only-set-efi_tpm_final_log_size-after-successful-event-log-parsing.patch
  perf-llvm-don-t-access-out-of-scope-array.patch
  perf-inject-jit-fix-jit_code_move-filename.patch
  drm-i915-perform-ggtt-restore-much-earlier-during-resume.patch
  blk-wbt-fix-performance-regression-in-wbt-scale_up-scale_down.patch
  selinux-fix-context-string-corruption-in-convert_context.patch
  cifs-gracefully-handle-queryinfo-errors-during-open.patch
  cifs-force-revalidate-inode-when-dentry-is-stale.patch
  cifs-force-reval-dentry-if-lookup_reval-flag-is-set.patch
  cifs-use-cifsinodeinfo-open_file_lock-while-iterating-to-avoid-a-panic.patch
  kernel-sysctl.c-do-not-override-max_threads-provided-by-userspace.patch
  mm-z3fold.c-claim-page-in-the-beginning-of-free.patch
  mm-page_alloc.c-fix-a-crash-in-free_pages_prepare.patch
  mm-vmpressure.c-fix-a-signedness-bug-in-vmpressure_register_event.patch
  ib-core-fix-wrong-iterating-on-ports.patch
  firmware-google-increment-vpd-key_len-properly.patch
  gpio-fix-getting-nonexclusive-gpiods-from-dt.patch
  gpiolib-don-t-clear-flag_is_out-when-emulating-open-.patch
  btrfs-relocation-fix-use-after-free-on-dead-relocation-roots.patch
  btrfs-allocate-new-inode-in-nofs-context.patch
  btrfs-fix-balance-convert-to-single-on-32-bit-host-cpus.patch
  btrfs-fix-memory-leak-due-to-concurrent-append-writes-with-fiemap.patch
  btrfs-fix-incorrect-updating-of-log-root-tree.patch
  btrfs-fix-uninitialized-ret-in-ref-verify.patch
  nfs-fix-o_direct-accounting-of-number-of-bytes-read-written.patch
  mips-disable-loongson-mmi-instructions-for-kernel-build.patch
  mips-elf_hwcap-export-userspace-ases.patch
  rdma-vmw_pvrdma-free-srq-only-once.patch
  acpi-pptt-add-support-for-acpi-6.3-thread-flag.patch
  arm64-topology-use-pptt-to-determine-if-pe-is-a-thre.patch
  iio-light-fix-vcnl4000-devicetree-hooks.patch
  fix-the-locking-in-dcache_readdir-and-friends.patch
  drm-i915-bump-skl-max-plane-width-to-5k-for-linear-x-tiled.patch
  drm-i915-whitelist-common_slice_chicken2.patch
  drm-i915-mark-contents-as-dirty-on-a-write-fault.patch
  drm-msm-use-the-correct-dma_sync-calls-harder.patch
  media-stkwebcam-fix-runtime-pm-after-driver-unbind.patch
  arm64-sve-fix-wrong-free-for-task-thread.sve_state.patch
  tracing-hwlat-report-total-time-spent-in-all-nmis-during-the-sample.patch
  tracing-hwlat-don-t-ignore-outer-loop-duration-when-calculating-max_latency.patch
  ftrace-get-a-reference-counter-for-the-trace_array-on-filter-files.patch
  tracing-get-trace_array-reference-for-available_tracers-files.patch
  hwmon-fix-hwmon_p_min_alarm-mask.patch
  mtd-rawnand-au1550nd-fix-au_read_buf16-prototype.patch
  x86-asm-fix-mwaitx-c-state-hint-value.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 2:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ CIFS Connectathon
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ trace: ftrace/tracer

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite
         🚧 ✅ CIFS Connectathon
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ trace: ftrace/tracer

      Host 2:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ CIFS Connectathon
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ trace: ftrace/tracer

      Host 2:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 3:
         ✅ Boot test
         🚧 ❌ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity
      Host 4:
         ✅ Boot test
         🚧 ❌ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity

      Host 5:
         ✅ Boot test
         🚧 ✅ /kernel/infiniband/env_setup
         🚧 ✅ /kernel/infiniband/sanity
      Host 6:
         ✅ Boot test
         🚧 ✅ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with ⏱. Reports for non-upstream kernels have
a Beaker recipe linked to next to each host.
