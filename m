Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE67BC5D4
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 12:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440721AbfIXKsX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 24 Sep 2019 06:48:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438486AbfIXKsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 06:48:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 618EC20260
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 10:48:22 +0000 (UTC)
Received: from [172.54.46.6] (cpt-1015.paas.prod.upshift.rdu2.redhat.com [10.0.19.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DFF85D713;
        Tue, 24 Sep 2019 10:48:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Message-ID: <cki.C37C42D46E.B47CT9H5JV@redhat.com>
X-Gitlab-Pipeline-ID: 184478
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/184478
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 24 Sep 2019 10:48:22 +0000 (UTC)
Date:   Tue, 24 Sep 2019 06:48:23 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: c9a59a82366b - Linux 5.3.1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/184478

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
  Commit: c9a59a82366b - Linux 5.3.1


We grabbed the 5fb55c40dd07 commit of the stable queue repository.

We then merged the patchset with `git am`:

  netfilter-add-missing-is_enabled-config_nf_tables-check-to-header-file.patch
  clocksource-drivers-timer-of-do-not-warn-on-deferred-probe.patch
  clocksource-drivers-do-not-warn-on-probe-defer.patch
  drm-amd-display-allow-cursor-async-updates-for-framebuffer-swaps.patch
  drm-amd-display-skip-determining-update-type-for-async-updates.patch
  drm-amd-display-don-t-replace-the-dc_state-for-fast-updates.patch
  drm-amd-display-readd-msse2-to-prevent-clang-from-emitting-libcalls-to-undefined-sw-fp-routines.patch
  powerpc-xive-fix-bogus-error-code-returned-by-opal.patch
  hid-prodikeys-fix-general-protection-fault-during-probe.patch
  hid-sony-fix-memory-corruption-issue-on-cleanup.patch
  hid-logitech-fix-general-protection-fault-caused-by-logitech-driver.patch
  hid-logitech-dj-fix-crash-when-initial-logi_dj_recv_query_paired_devices-fails.patch
  hid-hidraw-fix-invalid-read-in-hidraw_ioctl.patch
  hid-add-quirk-for-hp-x500-pixart-oem-mouse.patch
  mtd-cfi_cmdset_0002-use-chip_good-to-retry-in-do_write_oneword.patch

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
