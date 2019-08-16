Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F739030D
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 15:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfHPNbO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 16 Aug 2019 09:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbfHPNbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 09:31:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D86B315C01F
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 13:31:14 +0000 (UTC)
Received: from [172.54.56.124] (cpt-1033.paas.prod.upshift.rdu2.redhat.com [10.0.19.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC2271001B02;
        Fri, 16 Aug 2019 13:31:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.28A7053AE9.AG415YRJ3X@redhat.com>
X-Gitlab-Pipeline-ID: 104462
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/104462
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 16 Aug 2019 13:31:14 +0000 (UTC)
Date:   Fri, 16 Aug 2019 09:31:14 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: aad39e30fb9e - Linux 5.2.9

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/104462

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
  Commit: aad39e30fb9e - Linux 5.2.9


We grabbed the c3aa6e9e5378 commit of the stable queue repository.

We then merged the patchset with `git am`:

  keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
  sh-kernel-hw_breakpoint-fix-missing-break-in-switch-statement.patch
  seq_file-fix-problem-when-seeking-mid-record.patch
  mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
  mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch
  mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch
  mm-z3fold.c-fix-z3fold_destroy_pool-ordering.patch
  mm-z3fold.c-fix-z3fold_destroy_pool-race-condition.patch
  mm-memcontrol.c-fix-use-after-free-in-mem_cgroup_iter.patch
  mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch
  mm-vmscan-do-not-special-case-slab-reclaim-when-watermarks-are-boosted.patch

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
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ✅ LTP lite [4]
         ✅ Loopdev Sanity [5]
         ✅ jvm test suite [6]
         ✅ AMTU (Abstract Machine Test Utility) [7]
         ✅ LTP: openposix test suite [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ✅ LTP lite [4]
         ✅ Loopdev Sanity [5]
         ✅ jvm test suite [6]
         ✅ AMTU (Abstract Machine Test Utility) [7]
         ✅ LTP: openposix test suite [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ✅ LTP lite [4]
         ✅ Loopdev Sanity [5]
         ✅ jvm test suite [6]
         ✅ AMTU (Abstract Machine Test Utility) [7]
         ✅ LTP: openposix test suite [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ pciutils: sanity smoke test [15]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

