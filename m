Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45C1915E6
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 11:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfHRJ3y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 18 Aug 2019 05:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfHRJ3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 05:29:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C88D8980ED
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 09:29:54 +0000 (UTC)
Received: from [172.54.61.75] (cpt-1031.paas.prod.upshift.rdu2.redhat.com [10.0.19.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 902D0600C6;
        Sun, 18 Aug 2019 09:29:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.9278178582.ALIGSHRNQY@redhat.com>
X-Gitlab-Pipeline-ID: 108137
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/108137
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Sun, 18 Aug 2019 09:29:54 +0000 (UTC)
Date:   Sun, 18 Aug 2019 05:29:54 -0400
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

  https://artifacts.cki-project.org/pipelines/108137

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


We grabbed the dcd73f5722d4 commit of the stable queue repository.

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
  cpufreq-schedutil-don-t-skip-freq-update-when-limits-change.patch
  drm-amdgpu-fix-gfx9-soft-recovery.patch
  drm-nouveau-only-recalculate-pbn-vcpi-on-mode-connector-changes.patch
  xtensa-add-missing-isync-to-the-cpu_reset-tlb-code.patch
  arm64-ftrace-ensure-module-ftrace-trampoline-is-coherent-with-i-side.patch
  alsa-hda-realtek-add-quirk-for-hp-envy-x360.patch
  alsa-usb-audio-fix-a-stack-buffer-overflow-bug-in-check_input_term.patch
  alsa-usb-audio-fix-an-oob-bug-in-parse_audio_mixer_unit.patch
  alsa-hda-apply-workaround-for-another-amd-chip-1022-1487.patch
  alsa-hda-fix-a-memory-leak-bug.patch
  alsa-hda-add-a-generic-reboot_notify.patch
  alsa-hda-let-all-conexant-codec-enter-d3-when-rebooting.patch
  hid-holtek-test-for-sanity-of-intfdata.patch
  hid-hiddev-avoid-opening-a-disconnected-device.patch
  hid-hiddev-do-cleanup-in-failure-of-opening-a-device.patch
  input-kbtab-sanity-check-for-endpoint-type.patch
  input-iforce-add-sanity-checks.patch
  net-usb-pegasus-fix-improper-read-if-get_registers-fail.patch
  bpf-fix-access-to-skb_shared_info-gso_segs.patch
  netfilter-ebtables-also-count-base-chain-policies.patch

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
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Networking socket: fuzz [7]
         ✅ audit: audit testsuite test [8]
         ✅ httpd: mod_ssl smoke sanity [9]
         ✅ iotop: sanity [10]
         ✅ tuned: tune-processes-through-perf [11]
         ✅ Usex - version 1.9-29 [12]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [13]
         ✅ selinux-policy: serge-testsuite [14]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: xfs [13]
         ✅ selinux-policy: serge-testsuite [14]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Networking socket: fuzz [7]
         ✅ audit: audit testsuite test [8]
         ✅ httpd: mod_ssl smoke sanity [9]
         ✅ iotop: sanity [10]
         ✅ tuned: tune-processes-through-perf [11]
         ✅ pciutils: sanity smoke test [15]
         ✅ Usex - version 1.9-29 [12]
         ✅ stress: stress-ng [16]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
