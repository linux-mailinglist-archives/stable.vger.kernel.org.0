Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E5D4FBFA
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfFWOCW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 23 Jun 2019 10:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfFWOCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Jun 2019 10:02:22 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8E9F81F07
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 14:02:21 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44F9119C78;
        Sun, 23 Jun 2019 14:02:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.03DF7E62D7.TMCW9XYLTD@redhat.com>
X-Gitlab-Pipeline-ID: 13068
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sun, 23 Jun 2019 14:02:21 +0000 (UTC)
Date:   Sun, 23 Jun 2019 10:02:22 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 5f0a74b46855 - Linux 5.1.14

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
  Commit: 5f0a74b46855 - Linux 5.1.14


We grabbed the 6754ff8d88d7 commit of the stable queue repository.

We then merged the patchset with `git am`:

  tracing-silence-gcc-9-array-bounds-warning.patch
  mmc-sdhci-sdhci-pci-o2micro-correctly-set-bus-width-when-tuning.patch
  mmc-sdhi-disallow-hs400-for-m3-w-es1.2-rz-g2m-and-v3h.patch
  mmc-mediatek-fix-sdio-irq-interrupt-handle-flow.patch
  mmc-mediatek-fix-sdio-irq-detection-issue.patch
  mmc-core-api-to-temporarily-disable-retuning-for-sdio-crc-errors.patch
  mmc-core-add-sdio_retune_hold_now-and-sdio_retune_release.patch
  mmc-core-prevent-processing-sdio-irqs-when-the-card-is-suspended.patch
  scsi-ufs-avoid-runtime-suspend-possibly-being-blocked-forever.patch
  usb-chipidea-udc-workaround-for-endpoint-conflict-issue.patch
  xhci-detect-usb-3.2-capable-host-controllers-correctly.patch
  usb-xhci-don-t-try-to-recover-an-endpoint-if-port-is-in-error-state.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-9d81e70e55aa86d8cd19fb22d15ad16307483167.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-9d81e70e55aa86d8cd19fb22d15ad16307483167.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-9d81e70e55aa86d8cd19fb22d15ad16307483167.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-9d81e70e55aa86d8cd19fb22d15ad16307483167.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-9d81e70e55aa86d8cd19fb22d15ad16307483167.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-9d81e70e55aa86d8cd19fb22d15ad16307483167.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-9d81e70e55aa86d8cd19fb22d15ad16307483167.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-9d81e70e55aa86d8cd19fb22d15ad16307483167.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ Usex - version 1.9-29 [7]
       🚧 ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ storage: SCSI VPD [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ Usex - version 1.9-29 [7]
       🚧 ✅ tuned: tune-processes-through-perf [8]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ tuned: tune-processes-through-perf [8]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ Usex - version 1.9-29 [7]
       🚧 ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ storage: SCSI VPD [9]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
