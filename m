Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDF0E092
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 12:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfD2Kcd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Apr 2019 06:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfD2Kcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 06:32:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20BC3821D9
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 10:32:32 +0000 (UTC)
Received: from [172.54.57.253] (cpt-0007.paas.prod.upshift.rdu2.redhat.com [10.0.18.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC5CA10013D9;
        Mon, 29 Apr 2019 10:32:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.EA3B14DE7F.HBF9A1TDJU@redhat.com>
X-Gitlab-Pipeline-ID: 8851
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/8851
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 29 Apr 2019 10:32:32 +0000 (UTC)
Date:   Mon, 29 Apr 2019 06:32:32 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d3da1f09fff2 - Linux 5.0.10

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
  Commit: d3da1f09fff2 - Linux 5.0.10

We then merged the patchset with `git am`:

  
  
  
  
  
  
  
  
  
  
  

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-85484a7e05f914687dd4c37399a534bb862cfb4a.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-85484a7e05f914687dd4c37399a534bb862cfb4a.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-85484a7e05f914687dd4c37399a534bb862cfb4a.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-85484a7e05f914687dd4c37399a534bb862cfb4a.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-85484a7e05f914687dd4c37399a534bb862cfb4a.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-85484a7e05f914687dd4c37399a534bb862cfb4a.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-85484a7e05f914687dd4c37399a534bb862cfb4a.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-85484a7e05f914687dd4c37399a534bb862cfb4a.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ lvm thinp sanity [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ lvm thinp sanity [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ selinux-policy: serge-testsuite [11]
     🚧 ✅ stress: stress-ng [10]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ lvm thinp sanity [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ lvm thinp sanity [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ selinux-policy: serge-testsuite [11]
     🚧 ✅ stress: stress-ng [10]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
