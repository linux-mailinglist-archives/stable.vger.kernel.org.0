Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1791817
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfHRQ7s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 18 Aug 2019 12:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfHRQ7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 12:59:48 -0400
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7D514E908
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 16:59:47 +0000 (UTC)
Received: by mail-ot1-f71.google.com with SMTP id c25so882383otp.15
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 09:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zBZhqarMZyG7LYHBe8271rwNtI5LxkEgw/iw3eufAqA=;
        b=A9MxGstjq1DBhqn0wNYfoqUsQ0fO7opFAXHQ6io9pPZXdOb0fWciH+S5rV5RaP4ZZn
         emYw117BZHLmyPihcXe89PsyIEjJJbPv/Li54Nf5DwZH6vCmlqDQet1zdmF5as7y9B98
         oZDlwSJ1E59203WLDjVAaFltX3VSYNmR9w34Xo6LR/ce54E/gMEo9iylPahjgDKb5yke
         A4xZcMfwPBQEiBvnXkXlDBGTYsTmAfktJNryJlRV5uHeVFv61XNianCkiJIuFZgcq4gx
         jR3jcDmJGkfK5AKlK4g22eTgbfnJ8VocOkI2ykCHHQW5o/LM8EeF6RhCuLL9f4evg+xF
         coBw==
X-Gm-Message-State: APjAAAWDDgTAW5Svg3RO8IjqfJJk65bWdlfdHtspMlgkeIICtzjZiTqA
        8YIvUHXn127RXKkqCZnslFHU04XNeexBXaTq+/p+uo1le8DNHQPmn8AV7Lrc1/F2tJvANMc0QKe
        E/aylhk6nVjELRVci0dBRAlR/5FVlFpq/
X-Received: by 2002:a9d:7a94:: with SMTP id l20mr15584322otn.66.1566147587268;
        Sun, 18 Aug 2019 09:59:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxWIm9ZFS35OvJWMqoneMm+VqqZJHlwLzWF6gyzRUQsbiLrrjfJiPAVEoJDO20SYnzUYvU5IRJGkZ2ejku5VZs=
X-Received: by 2002:a9d:7a94:: with SMTP id l20mr15584312otn.66.1566147586965;
 Sun, 18 Aug 2019 09:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <cki.BE02F11449.7TX8NQ6BR3@redhat.com>
In-Reply-To: <cki.BE02F11449.7TX8NQ6BR3@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Sun, 18 Aug 2019 18:59:35 +0200
Message-ID: <CAFqZXNs7umUtz7kNaHuDUFvOtAOe=1e7ThPFf-zBKK70JK=0kg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBTdGFibGUgcXVldWU6IHF1ZXVlLTUuMg==?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Milos Malik <mmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 2:00 PM CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: aad39e30fb9e - Linux 5.2.9
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download here:
>
>   https://artifacts.cki-project.org/pipelines/108109
>
>
>
> One or more kernel tests failed:
>
>   ppc64le:
>     ❌ selinux-policy: serge-testsuite

FYI, this is a false negative - the test ran on a machine that had two
network interfaces with the same IPv4 address assigned, which confused
the SCTP test in the testsuite... I'l try to fix this corner case when
I find the time.

>
>
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
>
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
>
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
>
> Merge testing
> -------------
>
> We cloned this repository and checked out the following commit:
>
>   Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: aad39e30fb9e - Linux 5.2.9
>
>
> We grabbed the 6876cde84f1c commit of the stable queue repository.
>
> We then merged the patchset with `git am`:
>
>   keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
>   sh-kernel-hw_breakpoint-fix-missing-break-in-switch-statement.patch
>   seq_file-fix-problem-when-seeking-mid-record.patch
>   mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
>   mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch
>   mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch
>   mm-z3fold.c-fix-z3fold_destroy_pool-ordering.patch
>   mm-z3fold.c-fix-z3fold_destroy_pool-race-condition.patch
>   mm-memcontrol.c-fix-use-after-free-in-mem_cgroup_iter.patch
>   mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch
>   mm-vmscan-do-not-special-case-slab-reclaim-when-watermarks-are-boosted.patch
>   cpufreq-schedutil-don-t-skip-freq-update-when-limits-change.patch
>   drm-amdgpu-fix-gfx9-soft-recovery.patch
>   drm-nouveau-only-recalculate-pbn-vcpi-on-mode-connector-changes.patch
>   xtensa-add-missing-isync-to-the-cpu_reset-tlb-code.patch
>   arm64-ftrace-ensure-module-ftrace-trampoline-is-coherent-with-i-side.patch
>   alsa-hda-realtek-add-quirk-for-hp-envy-x360.patch
>   alsa-usb-audio-fix-a-stack-buffer-overflow-bug-in-check_input_term.patch
>   alsa-usb-audio-fix-an-oob-bug-in-parse_audio_mixer_unit.patch
>   alsa-hda-apply-workaround-for-another-amd-chip-1022-1487.patch
>   alsa-hda-fix-a-memory-leak-bug.patch
>   alsa-hda-add-a-generic-reboot_notify.patch
>   alsa-hda-let-all-conexant-codec-enter-d3-when-rebooting.patch
>
> Compile testing
> ---------------
>
> We compiled the kernel for 3 architectures:
>
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
>
>
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>
>   aarch64:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [1]
>          ✅ Podman system integration test (as user) [1]
>          ✅ LTP lite [2]
>          ✅ Loopdev Sanity [3]
>          ✅ jvm test suite [4]
>          ✅ AMTU (Abstract Machine Test Utility) [5]
>          ✅ LTP: openposix test suite [6]
>          ✅ audit: audit testsuite test [7]
>          ✅ httpd: mod_ssl smoke sanity [8]
>          ✅ iotop: sanity [9]
>          ✅ tuned: tune-processes-through-perf [10]
>          ✅ Usex - version 1.9-29 [11]
>
>       Host 2:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [12]
>          ✅ selinux-policy: serge-testsuite [13]
>
>
>   ppc64le:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [12]
>          ❌ selinux-policy: serge-testsuite [13]
>
>       Host 2:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [1]
>          ✅ Podman system integration test (as user) [1]
>          ✅ LTP lite [2]
>          ✅ Loopdev Sanity [3]
>          ✅ jvm test suite [4]
>          ✅ AMTU (Abstract Machine Test Utility) [5]
>          ✅ LTP: openposix test suite [6]
>          ✅ audit: audit testsuite test [7]
>          ✅ httpd: mod_ssl smoke sanity [8]
>          ✅ iotop: sanity [9]
>          ✅ tuned: tune-processes-through-perf [10]
>          ✅ Usex - version 1.9-29 [11]
>
>
>   x86_64:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [1]
>          ✅ Podman system integration test (as user) [1]
>          ✅ LTP lite [2]
>          ✅ Loopdev Sanity [3]
>          ✅ jvm test suite [4]
>          ✅ AMTU (Abstract Machine Test Utility) [5]
>          ✅ LTP: openposix test suite [6]
>          ✅ audit: audit testsuite test [7]
>          ✅ httpd: mod_ssl smoke sanity [8]
>          ✅ iotop: sanity [9]
>          ✅ tuned: tune-processes-through-perf [10]
>          ✅ pciutils: sanity smoke test [14]
>          ✅ Usex - version 1.9-29 [11]
>          ✅ stress: stress-ng [15]
>
>       Host 2:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [12]
>          ✅ selinux-policy: serge-testsuite [13]
>
>
>   Test source:
>     Pull requests are welcome for new tests or improvements to existing tests!
>     [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>     [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
>     [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
>     [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>     [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
>     [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>     [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
>     [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>     [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>     [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>     [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>     [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
>     [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
>     [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
>     [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
>     [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
>
> Waived tests
> ------------
> If the test run included waived tests, they are marked with . Such tests are
> executed but their results are not taken into account. Tests are waived when
> their results are not reliable enough, e.g. when they're just introduced or are
> being fixed.



-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
