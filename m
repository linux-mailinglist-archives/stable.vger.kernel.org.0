Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D24BB877
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 17:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbfIWPua convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 23 Sep 2019 11:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfIWPua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 11:50:30 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F35130860B9
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 15:50:30 +0000 (UTC)
Received: from [172.54.46.6] (cpt-1015.paas.prod.upshift.rdu2.redhat.com [10.0.19.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6108E672D5;
        Mon, 23 Sep 2019 15:50:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Message-ID: <cki.172D838899.V4I2QPDKL7@redhat.com>
X-Gitlab-Pipeline-ID: 182653
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/182653
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 23 Sep 2019 15:50:30 +0000 (UTC)
Date:   Mon, 23 Sep 2019 11:50:30 -0400
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

  https://artifacts.cki-project.org/pipelines/182653

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


We grabbed the f4246fab7da0 commit of the stable queue repository.

We then merged the patchset with `git am`:

  netfilter-add-missing-is_enabled-config_nf_tables-check-to-header-file.patch
  clocksource-drivers-timer-of-do-not-warn-on-deferred-probe.patch
  clocksource-drivers-do-not-warn-on-probe-defer.patch
  drm-amd-display-allow-cursor-async-updates-for-framebuffer-swaps.patch
  drm-amd-display-skip-determining-update-type-for-async-updates.patch
  drm-amd-display-don-t-replace-the-dc_state-for-fast-updates.patch
  drm-amd-display-readd-msse2-to-prevent-clang-from-emitting-libcalls-to-undefined-sw-fp-routines.patch
  powerpc-xive-fix-bogus-error-code-returned-by-opal.patch

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

      Host 2:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite

  x86_64:
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
         ✅ pciutils: sanity smoke test
         ✅ stress: stress-ng
         🚧 ✅ LTP lite

      Host 2:
         ✅ Boot test
         ✅ selinux-policy: serge-testsuite

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
