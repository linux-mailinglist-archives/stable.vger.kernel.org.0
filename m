Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635AF5C186
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 18:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfGAQ5H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 1 Jul 2019 12:57:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbfGAQ5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 12:57:07 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80BD318DF7C
        for <stable@vger.kernel.org>; Mon,  1 Jul 2019 16:57:06 +0000 (UTC)
Received: from [172.54.126.116] (cpt-1022.paas.prod.upshift.rdu2.redhat.com [10.0.19.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C97BE2C8F4;
        Mon,  1 Jul 2019 16:57:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.E5DB2B71BA.4AS807BQ6Z@redhat.com>
X-Gitlab-Pipeline-ID: 13616
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 01 Jul 2019 16:57:06 +0000 (UTC)
Date:   Mon, 1 Jul 2019 12:57:07 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: aec3002d07fd - Linux 4.19.56

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
  Commit: aec3002d07fd - Linux 4.19.56


We grabbed the a8a67be8daa7 commit of the stable queue repository.

We then merged the patchset with `git am`:

  perf-ui-helpline-use-strlcpy-as-a-shorter-form-of-strncpy-explicit-set-nul.patch
  perf-help-remove-needless-use-of-strncpy.patch
  perf-header-fix-unchecked-usage-of-strncpy.patch
  arm64-don-t-unconditionally-add-wno-psabi-to-kbuild_cflags.patch
  revert-x86-uaccess-ftrace-fix-ftrace_likely_update-v.patch
  ib-hfi1-close-psm-sdma_progress-sleep-window.patch
  9p-xen-fix-check-for-xenbus_read-error-in-front_prob.patch
  9p-use-a-slab-for-allocating-requests.patch
  9p-embed-fcall-in-req-to-round-down-buffer-allocs.patch
  9p-add-a-per-client-fcall-kmem_cache.patch
  9p-rename-p9_free_req-function.patch
  9p-add-refcount-to-p9_req_t.patch
  9p-rdma-do-not-disconnect-on-down_interruptible-eaga.patch
  9p-rename-req-to-rreq-in-trans_fd.patch
  9p-acl-fix-uninitialized-iattr-access.patch
  9p-rdma-remove-useless-check-in-cm_event_handler.patch
  9p-p9dirent_read-check-network-provided-name-length.patch
  9p-potential-null-dereference.patch
  9p-trans_fd-abort-p9_read_work-if-req-status-changed.patch
  9p-trans_fd-put-worker-reqs-on-destroy.patch
  net-9p-include-trans_common.h-to-fix-missing-prototy.patch
  qmi_wwan-fix-out-of-bounds-read.patch
  revert-usb-dwc3-gadget-clear-req-needs_extra_trb-fla.patch
  usb-dwc3-gadget-combine-unaligned-and-zero-flags.patch
  usb-dwc3-gadget-track-number-of-trbs-per-request.patch
  usb-dwc3-gadget-use-num_trbs-when-skipping-trbs-on-d.patch
  usb-dwc3-gadget-extract-dwc3_gadget_ep_skip_trbs.patch
  usb-dwc3-gadget-introduce-cancelled_list.patch
  usb-dwc3-gadget-move-requests-to-cancelled_list.patch
  usb-dwc3-gadget-remove-wait_end_transfer.patch
  usb-dwc3-gadget-clear-req-needs_extra_trb-flag-on-cl.patch
  fs-proc-array.c-allow-reporting-eip-esp-for-all-coredumping-threads.patch
  mm-mempolicy.c-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch
  fs-binfmt_flat.c-make-load_flat_shared_library-work.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-9b16bfd12bf476b8c4a981e85375934c6f77786f.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-9b16bfd12bf476b8c4a981e85375934c6f77786f.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-9b16bfd12bf476b8c4a981e85375934c6f77786f.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-9b16bfd12bf476b8c4a981e85375934c6f77786f.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-9b16bfd12bf476b8c4a981e85375934c6f77786f.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-9b16bfd12bf476b8c4a981e85375934c6f77786f.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-9b16bfd12bf476b8c4a981e85375934c6f77786f.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-9b16bfd12bf476b8c4a981e85375934c6f77786f.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ LTP: openposix test suite [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ tuned: tune-processes-through-perf [12]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
