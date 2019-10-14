Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDC8D6A3F
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 21:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbfJNThu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Oct 2019 15:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbfJNThu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 15:37:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9451310C0938
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 19:37:49 +0000 (UTC)
Received: from [172.54.28.194] (cpt-1009.paas.prod.upshift.rdu2.redhat.com [10.0.19.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D592608C2;
        Mon, 14 Oct 2019 19:37:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Message-ID: <cki.4319C77053.I4TVSQ8J0N@redhat.com>
X-Gitlab-Pipeline-ID: 225296
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/225296
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 14 Oct 2019 19:37:49 +0000 (UTC)
Date:   Mon, 14 Oct 2019 15:37:50 -0400
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

  https://artifacts.cki-project.org/pipelines/225296

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


We grabbed the 2a712158cf24 commit of the stable queue repository.

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
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
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

      Host 2:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite

      Host 2:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ LTP: openposix test suite
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
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
         🚧 ⚡⚡⚡ LTP lite

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

