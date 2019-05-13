Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E541B7A1
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 16:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfEMOB1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 13 May 2019 10:01:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbfEMOB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 10:01:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECC003082E24
        for <stable@vger.kernel.org>; Mon, 13 May 2019 14:01:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF2635D722
        for <stable@vger.kernel.org>; Mon, 13 May 2019 14:01:26 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D3B8D18089CA;
        Mon, 13 May 2019 14:01:26 +0000 (UTC)
Date:   Mon, 13 May 2019 10:01:26 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Message-ID: <26765947.19325359.1557756086279.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.02CC569AE1.DRJSZO3WAQ@redhat.com>
References: <cki.02CC569AE1.DRJSZO3WAQ@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8E_FAIL:_Stable_queue:_queue-4.19?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.205.191, 10.4.195.4]
Thread-Topic: =?utf-8?B?4p2OIEZBSUw6?= Stable queue: queue-4.19
Thread-Index: aCa9zLIQkFPGH4XmFL9NfhOBVXaceA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 13 May 2019 14:01:26 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Cc: "Jakub Krysl" <jkrysl@redhat.com>
> Sent: Monday, May 13, 2019 3:22:19 PM
> Subject: ❎ FAIL: Stable queue: queue-4.19
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 9c2556f428cf - Linux 4.19.42
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
>   s390x:
>     ❎ lvm thinp sanity
> 

Hi,

please ignore this failure -- we discussed this with the test developer and 
he confirmed this is a setup problem and not kernel failure.

The test was not happy with insufficient disk space on the machine (required
for proper execution). We'll fix the problem and let you know in case another
run happens on a tiny machine before we manage to fix it.


Thanks and sorry for the noise,
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
>   Commit: 9c2556f428cf - Linux 4.19.42
> 
> We then merged the patchset with `git am`:
> 
>   bfq-update-internal-depth-state-when-queue-depth-cha.patch
>   platform-x86-sony-laptop-fix-unintentional-fall-through.patch
>   platform-x86-thinkpad_acpi-disable-bluetooth-for-some-machines.patch
>   platform-x86-dell-laptop-fix-rfkill-functionality.patch
>   hwmon-pwm-fan-disable-pwm-if-fetching-cooling-data-fails.patch
>   kernfs-fix-barrier-usage-in-__kernfs_new_node.patch
>   virt-vbox-sanity-check-parameter-types-for-hgcm-calls-coming-from-userspace.patch
>   usb-serial-fix-unthrottle-races.patch
> 
> Compile testing
> ---------------
> 
> We compiled the kernel for 4 architectures:
> 
>   aarch64:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-83cd03102ebf13d864a6d357cc4708ffb12d63d2.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-83cd03102ebf13d864a6d357cc4708ffb12d63d2.tar.gz
> 
>   ppc64le:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-83cd03102ebf13d864a6d357cc4708ffb12d63d2.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-83cd03102ebf13d864a6d357cc4708ffb12d63d2.tar.gz
> 
>   s390x:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-83cd03102ebf13d864a6d357cc4708ffb12d63d2.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-83cd03102ebf13d864a6d357cc4708ffb12d63d2.tar.gz
> 
>   x86_64:
>     build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
>     configuration:
>     https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-83cd03102ebf13d864a6d357cc4708ffb12d63d2.config
>     kernel build:
>     https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-83cd03102ebf13d864a6d357cc4708ffb12d63d2.tar.gz
> 
> 
> Hardware testing
> ----------------
> 
> We booted each kernel and ran the following tests:
> 
>   aarch64:
>      ✅ Boot test [0]
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ httpd: mod_ssl smoke sanity [4]
>      ✅ iotop: sanity [5]
>      ✅ tuned: tune-processes-through-perf [6]
>      ✅ lvm thinp sanity [7]
>      🚧 ✅ selinux-policy: serge-testsuite [8]
>      🚧 ✅ audit: audit testsuite test [9]
>      🚧 ✅ stress: stress-ng [10]
> 
>   ppc64le:
>      ✅ Boot test [0]
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ httpd: mod_ssl smoke sanity [4]
>      ✅ iotop: sanity [5]
>      ✅ tuned: tune-processes-through-perf [6]
>      ✅ lvm thinp sanity [7]
>      🚧 ✅ selinux-policy: serge-testsuite [8]
>      🚧 ✅ audit: audit testsuite test [9]
>      🚧 ✅ stress: stress-ng [10]
> 
>   s390x:
>      ✅ Boot test [0]
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ httpd: mod_ssl smoke sanity [4]
>      ✅ iotop: sanity [5]
>      ✅ tuned: tune-processes-through-perf [6]
>      ❎ lvm thinp sanity [7]
>      🚧 ✅ selinux-policy: serge-testsuite [8]
>      🚧 ✅ audit: audit testsuite test [9]
>      🚧 ✅ stress: stress-ng [10]
> 
>   x86_64:
>      ✅ Boot test [0]
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ httpd: mod_ssl smoke sanity [4]
>      ✅ iotop: sanity [5]
>      ✅ tuned: tune-processes-through-perf [6]
>      ✅ lvm thinp sanity [7]
>      🚧 ✅ selinux-policy: serge-testsuite [8]
>      🚧 ✅ audit: audit testsuite test [9]
>      🚧 ✅ stress: stress-ng [10]
> 
>   Test source:
>     [0]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>     [1]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
>     [2]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>     [3]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>     [4]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>     [5]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>     [6]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>     [7]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
>     [8]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
>     [9]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>     [10]:
>     https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
> 
> Waived tests (marked with 🚧)
> -----------------------------
> This test run included waived tests. Such tests are executed but their
> results
> are not taken into account. Tests are waived when their results are not
> reliable enough, e.g. when they're just introduced or are being fixed.
> 
