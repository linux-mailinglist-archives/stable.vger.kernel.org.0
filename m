Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3685DB7E4A
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 17:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfISPgB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 19 Sep 2019 11:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbfISPgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 11:36:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99EE410DCC97
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 15:36:00 +0000 (UTC)
Received: from [172.54.124.190] (cpt-1056.paas.prod.upshift.rdu2.redhat.com [10.0.19.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DB875C548;
        Thu, 19 Sep 2019 15:35:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.1EA547EC86.LKB7TXQ17N@redhat.com>
X-Gitlab-Pipeline-ID: 174379
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/174379
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 19 Sep 2019 15:36:00 +0000 (UTC)
Date:   Thu, 19 Sep 2019 11:36:01 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 1e2ba4a74fa7 - Linux 5.2.16

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/174379

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
  Commit: 1e2ba4a74fa7 - Linux 5.2.16


We grabbed the 767b360836da commit of the stable queue repository.

We then merged the patchset with `git am`:

  net-hns3-adjust-hns3_uninit_phy-s-location-in-the-hns3_client_uninit.patch

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
         ✅ selinux-policy: serge-testsuite [1]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [2]
         ✅ Podman system integration test (as user) [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ audit: audit testsuite test [7]
         ✅ httpd: mod_ssl smoke sanity [8]
         ✅ iotop: sanity [9]
         ✅ tuned: tune-processes-through-perf [10]
         ✅ stress: stress-ng [11]
         🚧 ✅ LTP lite [12]

  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [2]
         ✅ Podman system integration test (as user) [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ audit: audit testsuite test [7]
         ✅ httpd: mod_ssl smoke sanity [8]
         ✅ iotop: sanity [9]
         ✅ tuned: tune-processes-through-perf [10]
         🚧 ✅ LTP lite [12]

  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [2]
         ✅ Podman system integration test (as user) [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ audit: audit testsuite test [7]
         ✅ httpd: mod_ssl smoke sanity [8]
         ✅ iotop: sanity [9]
         ✅ tuned: tune-processes-through-perf [10]
         ✅ pciutils: sanity smoke test [13]
         ✅ stress: stress-ng [11]
         🚧 ✅ LTP lite [12]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
