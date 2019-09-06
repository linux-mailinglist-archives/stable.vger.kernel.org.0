Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89680ABC27
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 17:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394689AbfIFPUj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 6 Sep 2019 11:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfIFPUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 11:20:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD63F75752
        for <stable@vger.kernel.org>; Fri,  6 Sep 2019 15:20:38 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE6F75C231;
        Fri,  6 Sep 2019 15:20:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.F3A9C5552A.BUSNPBQ012@redhat.com>
X-Gitlab-Pipeline-ID: 147783
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/147783
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 06 Sep 2019 15:20:38 +0000 (UTC)
Date:   Fri, 6 Sep 2019 11:20:39 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 140839fe4e71 - Linux 5.2.12

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/147783

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
  Commit: 140839fe4e71 - Linux 5.2.12


We grabbed the 086f4245e484 commit of the stable queue repository.

We then merged the patchset with `git am`:

  revert-input-elantech-enable-smbus-on-new-2018-systems.patch

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
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ jvm test suite [2]
         ✅ AMTU (Abstract Machine Test Utility) [3]
         ✅ LTP: openposix test suite [4]
         ✅ audit: audit testsuite test [5]
         ✅ httpd: mod_ssl smoke sanity [6]
         ✅ iotop: sanity [7]
         ✅ tuned: tune-processes-through-perf [8]
         ✅ stress: stress-ng [9]
         🚧 ✅ LTP lite [10]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [11]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [11]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ jvm test suite [2]
         ✅ AMTU (Abstract Machine Test Utility) [3]
         ✅ LTP: openposix test suite [4]
         ✅ audit: audit testsuite test [5]
         ✅ httpd: mod_ssl smoke sanity [6]
         ✅ iotop: sanity [7]
         ✅ tuned: tune-processes-through-perf [8]
         🚧 ✅ LTP lite [10]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [11]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ jvm test suite [2]
         ✅ AMTU (Abstract Machine Test Utility) [3]
         ✅ LTP: openposix test suite [4]
         ✅ audit: audit testsuite test [5]
         ✅ httpd: mod_ssl smoke sanity [6]
         ✅ iotop: sanity [7]
         ✅ tuned: tune-processes-through-perf [8]
         ✅ pciutils: sanity smoke test [12]
         ✅ stress: stress-ng [9]
         🚧 ✅ LTP lite [10]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
