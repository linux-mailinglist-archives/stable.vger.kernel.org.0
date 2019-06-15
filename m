Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EDA4716D
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 19:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbfFORf7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 15 Jun 2019 13:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbfFORf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 13:35:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B86093091755
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 17:35:58 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B27D5B2F9;
        Sat, 15 Jun 2019 17:35:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-4.19
CC:     Petr Sklenar <psklenar@redhat.com>
Message-ID: <cki.005BE294DD.6A6VCIVMNR@redhat.com>
X-Gitlab-Pipeline-ID: 12440
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12440?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sat, 15 Jun 2019 17:35:58 +0000 (UTC)
Date:   Sat, 15 Jun 2019 13:35:59 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 7aa823a959e1 - Linux 4.19.51

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED


One or more kernel tests failed:

  aarch64:
    ❎ tuned: tune-processes-through-perf

  ppc64le:
    ❎ tuned: tune-processes-through-perf

  s390x:
    ❎ tuned: tune-processes-through-perf

  x86_64:
    ❎ tuned: tune-processes-through-perf

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

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
  Commit: 7aa823a959e1 - Linux 4.19.51


We then merged the patchset with `git am`:

  drm-nouveau-add-kconfig-option-to-turn-off-nouveau-legacy-contexts.-v3.patch
  nouveau-fix-build-with-config_nouveau_legacy_ctx_support-disabled.patch
  hid-multitouch-handle-faulty-elo-touch-device.patch
  hid-wacom-don-t-set-tool-type-until-we-re-in-range.patch
  hid-wacom-don-t-report-anything-prior-to-the-tool-entering-range.patch
  hid-wacom-send-btn_touch-in-response-to-intuosp2_bt-eraser-contact.patch
  hid-wacom-correct-button-numbering-2nd-gen-intuos-pro-over-bluetooth.patch
  hid-wacom-sync-intuosp2_bt-touch-state-after-each-frame-if-necessary.patch
  revert-alsa-hda-realtek-improve-the-headset-mic-for-acer-aspire-laptops.patch
  alsa-oxfw-allow-pcm-capture-for-stanton-scs.1m.patch
  alsa-hda-realtek-update-headset-mode-for-alc256.patch
  alsa-firewire-motu-fix-destruction-of-data-for-isochronous-resources.patch
  libata-extend-quirks-for-the-st1000lm024-drives-with-nolpm-quirk.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-e21aac1282457dc7676ad110df5fc329496eb63b.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-e21aac1282457dc7676ad110df5fc329496eb63b.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-e21aac1282457dc7676ad110df5fc329496eb63b.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-e21aac1282457dc7676ad110df5fc329496eb63b.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-e21aac1282457dc7676ad110df5fc329496eb63b.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-e21aac1282457dc7676ad110df5fc329496eb63b.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-e21aac1282457dc7676ad110df5fc329496eb63b.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-e21aac1282457dc7676ad110df5fc329496eb63b.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ audit: audit testsuite test [3]
       ✅ httpd: mod_ssl smoke sanity [4]
       ✅ iotop: sanity [5]
       ❎ tuned: tune-processes-through-perf [6]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [7]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ audit: audit testsuite test [3]
       ✅ httpd: mod_ssl smoke sanity [4]
       ✅ iotop: sanity [5]
       ❎ tuned: tune-processes-through-perf [6]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [7]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [7]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ audit: audit testsuite test [3]
       ✅ httpd: mod_ssl smoke sanity [4]
       ✅ iotop: sanity [5]
       ❎ tuned: tune-processes-through-perf [6]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ audit: audit testsuite test [3]
       ✅ httpd: mod_ssl smoke sanity [4]
       ✅ iotop: sanity [5]
       ❎ tuned: tune-processes-through-perf [6]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [7]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

