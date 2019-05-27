Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE72B831
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfE0PPQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 May 2019 11:15:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbfE0PPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 11:15:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 426633B554
        for <stable@vger.kernel.org>; Mon, 27 May 2019 15:15:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3355A1001E9A
        for <stable@vger.kernel.org>; Mon, 27 May 2019 15:15:15 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 23E2018433A0;
        Mon, 27 May 2019 15:15:15 +0000 (UTC)
Date:   Mon, 27 May 2019 11:15:15 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Jeff Bastian <jbastian@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <2121614321.22097475.1558970115077.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.B161FA3ED6.QK4BD0NMSJ@redhat.com>
References: <cki.B161FA3ED6.QK4BD0NMSJ@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8E_FAIL:_Stable_queue:_queue-4.19?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.205.210, 10.4.195.25]
Thread-Topic: =?utf-8?B?4p2OIEZBSUw6?= Stable queue: queue-4.19
Thread-Index: rOSJPPhMCoDRE36opzZwELPs2lP2QA==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 27 May 2019 15:15:15 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Monday, May 27, 2019 4:59:46 PM
> Subject: ❎ FAIL: Stable queue: queue-4.19
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 8b2fc0058255 - Linux 4.19.46
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> 
> One or more kernel tests failed:
> 

It didn't fail. stress-ng got into oom situation on aarch64 and we don't seem
to be reporting this kind of warning properly, since the summary says fail but
the actual test list reports everything passed. Sorry.

Jeff, can you take a look whether this is a test issue that needs to be worked
around or if the test caught something? The machine has 16G RAM and 224 cores
so maybe something doesn't scale properly?


Thanks,
Veronika

> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this
> message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more
> effective.
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
>   Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: 8b2fc0058255 - Linux 4.19.46
> 
> 
> We then merged the patchset with `git am`:
> 
>   x86-hide-the-int3_emulate_call-jmp-functions-from-uml.patch
>   ext4-do-not-delete-unlinked-inode-from-orphan-list-on-failed-truncate.patch
>   ext4-wait-for-outstanding-dio-during-truncate-in-nojournal-mode.patch
> 
> Compile testing
> ---------------
> 
> We compiled the kernel for 4 architectures:
> 
>   aarch64:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-d33319c71d2e4a6c16e392a4301d425521d7b9cd.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-d33319c71d2e4a6c16e392a4301d425521d7b9cd.tar.gz
> 
>   ppc64le:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-d33319c71d2e4a6c16e392a4301d425521d7b9cd.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-d33319c71d2e4a6c16e392a4301d425521d7b9cd.tar.gz
> 
>   s390x:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-d33319c71d2e4a6c16e392a4301d425521d7b9cd.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-d33319c71d2e4a6c16e392a4301d425521d7b9cd.tar.gz
> 
>   x86_64:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-d33319c71d2e4a6c16e392a4301d425521d7b9cd.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-d33319c71d2e4a6c16e392a4301d425521d7b9cd.tar.gz
> 
> 
> Hardware testing
> ----------------
> 
> We booted each kernel and ran the following tests:
> 
>   aarch64:
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ audit: audit testsuite test [4]
>      ✅ httpd: mod_ssl smoke sanity [5]
>      ✅ iotop: sanity [6]
>      ✅ tuned: tune-processes-through-perf [7]
>      ✅ stress: stress-ng [8]
>      ✅ Boot test [0]
>      ✅ xfstests: ext4 [9]
>      ✅ selinux-policy: serge-testsuite [10]
> 
>   ppc64le:
>      ✅ Boot test [0]
>      ✅ xfstests: ext4 [9]
>      ✅ selinux-policy: serge-testsuite [10]
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ audit: audit testsuite test [4]
>      ✅ httpd: mod_ssl smoke sanity [5]
>      ✅ iotop: sanity [6]
>      ✅ tuned: tune-processes-through-perf [7]
>      ✅ stress: stress-ng [8]
> 
>   s390x:
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ audit: audit testsuite test [4]
>      ✅ httpd: mod_ssl smoke sanity [5]
>      ✅ iotop: sanity [6]
>      ✅ tuned: tune-processes-through-perf [7]
>      ✅ stress: stress-ng [8]
>      ✅ Boot test [0]
>      ✅ selinux-policy: serge-testsuite [10]
> 
>   x86_64:
>      ✅ Boot test [0]
>      ✅ xfstests: ext4 [9]
>      ✅ selinux-policy: serge-testsuite [10]
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ audit: audit testsuite test [4]
>      ✅ httpd: mod_ssl smoke sanity [5]
>      ✅ iotop: sanity [6]
>      ✅ tuned: tune-processes-through-perf [7]
>      ✅ stress: stress-ng [8]
> 
>   Test source:
>     💚 Pull requests are welcome for new tests or improvements to existing
>     tests!
>     [0]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>     [1]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
>     [2]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>     [3]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>     [4]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>     [5]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>     [6]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>     [7]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>     [8]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
>     [9]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
>     [10]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
> 
> 
> 
