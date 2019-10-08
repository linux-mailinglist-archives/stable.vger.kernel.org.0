Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C77CF9A0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 14:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfJHMTH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 8 Oct 2019 08:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbfJHMTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 08:19:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE35511A1F
        for <stable@vger.kernel.org>; Tue,  8 Oct 2019 12:19:06 +0000 (UTC)
Received: from [172.54.55.131] (cpt-1039.paas.prod.upshift.rdu2.redhat.com [10.0.19.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42A911001B11;
        Tue,  8 Oct 2019 12:19:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Message-ID: <cki.91616E0A95.1C4INA3FS7@redhat.com>
X-Gitlab-Pipeline-ID: 213190
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/213190
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 08 Oct 2019 12:19:06 +0000 (UTC)
Date:   Tue, 8 Oct 2019 08:19:07 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 52020d3f6633 - Linux 5.3.5

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/213190

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
  Commit: 52020d3f6633 - Linux 5.3.5


We grabbed the da4f76bfb1e4 commit of the stable queue repository.

We then merged the patchset with `git am`:

  s390-process-avoid-potential-reading-of-freed-stack.patch
  s390-sclp-fix-bit-checked-for-has_sipl.patch
  kvm-s390-test-for-bad-access-register-and-size-at-the-start-of-s390_mem_op.patch
  s390-topology-avoid-firing-events-before-kobjs-are-created.patch
  s390-cio-avoid-calling-strlen-on-null-pointer.patch
  s390-cio-exclude-subchannels-with-no-parent-from-pseudo-check.patch
  s390-dasd-fix-error-handling-during-online-processing.patch
  revert-s390-dasd-add-discard-support-for-ese-volumes.patch
  kvm-s390-fix-__insn32_query-inline-assembly.patch
  kvm-ppc-book3s-enable-xive-native-capability-only-if-opal-has-required-functions.patch
  kvm-ppc-book3s-hv-xive-free-escalation-interrupts-before-disabling-the-vp.patch
  kvm-ppc-book3s-hv-don-t-push-xive-context-when-not-using-xive-device.patch
  kvm-ppc-book3s-hv-fix-race-in-re-enabling-xive-escalation-interrupts.patch
  kvm-ppc-book3s-hv-check-for-mmu-ready-on-piggybacked-virtual-cores.patch
  kvm-ppc-book3s-hv-don-t-lose-pending-doorbell-request-on-migration-on-p9.patch
  kvm-x86-fix-userspace-set-invalid-cr4.patch
  nbd-fix-max-number-of-supported-devs.patch
  pm-devfreq-tegra-fix-khz-to-hz-conversion.patch
  asoc-define-a-set-of-dapm-pre-post-up-events.patch
  asoc-sgtl5000-improve-vag-power-and-mute-control.patch
  powerpc-xive-implement-get_irqchip_state-method-for-xive-to-fix-shutdown-race.patch
  powerpc-mce-fix-mce-handling-for-huge-pages.patch
  powerpc-mce-schedule-work-from-irq_work.patch
  powerpc-603-fix-handling-of-the-dirty-flag.patch
  powerpc-32s-fix-boot-failure-with-debug_pagealloc-without-kasan.patch
  powerpc-ptdump-fix-addresses-display-on-ppc32.patch
  powerpc-powernv-restrict-opal-symbol-map-to-only-be-readable-by-root.patch
  powerpc-pseries-fix-cpu_hotplug_lock-acquisition-in-resize_hpt.patch
  powerpc-powernv-ioda-fix-race-in-tce-level-allocation.patch
  powerpc-kasan-fix-parallel-loading-of-modules.patch
  powerpc-kasan-fix-shadow-area-set-up-for-modules.patch
  powerpc-book3s64-mm-don-t-do-tlbie-fixup-for-some-hardware-revisions.patch
  powerpc-book3s64-radix-rename-cpu_ftr_p9_tlbie_bug-feature-flag.patch
  powerpc-mm-add-a-helper-to-select-page_kernel_ro-or-page_readonly.patch
  powerpc-mm-fix-an-oops-in-kasan_mmu_init.patch
  powerpc-mm-fixup-tlbie-vs-mtpidr-mtlpidr-ordering-issue-on-power9.patch
  can-mcp251x-mcp251x_hw_reset-allow-more-time-after-a-reset.patch
  tools-lib-traceevent-fix-robust-test-of-do_generate_dynamic_list_file.patch
  tools-lib-traceevent-do-not-free-tep-cmdlines-in-add_new_comm-on-failure.patch
  crypto-qat-silence-smp_processor_id-warning.patch
  crypto-skcipher-unmap-pages-after-an-external-error.patch
  crypto-cavium-zip-add-missing-single_release.patch
  crypto-caam-qi-fix-error-handling-in-ern-handler.patch
  crypto-caam-fix-concurrency-issue-in-givencrypt-descriptor.patch
  crypto-ccree-account-for-tee-not-ready-to-report.patch
  crypto-ccree-use-the-full-crypt-length-value.patch
  mips-treat-loongson-extensions-as-ases.patch
  power-supply-sbs-battery-use-correct-flags-field.patch
  power-supply-sbs-battery-only-return-health-when-battery-present.patch
  tracing-make-sure-variable-reference-alias-has-correct-var_ref_idx.patch
  usercopy-avoid-highmem-pfn-warning.patch
  timer-read-jiffies-once-when-forwarding-base-clk.patch

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

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ trace: ftrace/tracer

      Host 2:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite
         🚧 ✅ Storage blktests

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite
         🚧 ✅ Storage blktests

      Host 2:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ trace: ftrace/tracer

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

