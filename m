Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB53A5E6
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbfFINWW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 9 Jun 2019 09:22:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfFINWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 09:22:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83B72308218D
        for <stable@vger.kernel.org>; Sun,  9 Jun 2019 13:22:21 +0000 (UTC)
Received: from [172.54.141.148] (cpt-large-cpu-05.paas.prod.upshift.rdu2.redhat.com [10.0.18.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E4DB60852;
        Sun,  9 Jun 2019 13:22:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.1FF446FEBB.RZL20EIFWK@redhat.com>
X-Gitlab-Pipeline-ID: 11860
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11860?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sun, 09 Jun 2019 13:22:21 +0000 (UTC)
Date:   Sun, 9 Jun 2019 09:22:22 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: bb7b450e61a1 - Linux 4.19.49

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
  Commit: bb7b450e61a1 - Linux 4.19.49


We then merged the patchset with `git am`:

  cls_matchall-avoid-panic-when-receiving-a-packet-before-filter-set.patch
  ethtool-fix-potential-userspace-buffer-overflow.patch
  fix-memory-leak-in-sctp_process_init.patch
  ipv4-not-do-cache-for-local-delivery-if-bc_forwarding-is-enabled.patch
  ipv6-fix-the-check-before-getting-the-cookie-in-rt6_get_cookie.patch
  neighbor-call-__ipv4_neigh_lookup_noref-in-neigh_xmit.patch
  net-ethernet-ti-cpsw_ethtool-fix-ethtool-ring-param-set.patch
  net-mlx4_en-ethtool-remove-unsupported-sfp-eeprom-high-pages-query.patch
  net-mvpp2-use-strscpy-to-handle-stat-strings.patch
  net-rds-fix-memory-leak-in-rds_ib_flush_mr_pool.patch
  net-sfp-read-eeprom-in-maximum-16-byte-increments.patch
  net-tls-replace-the-sleeping-lock-around-rx-resync-with-a-bit-lock.patch
  packet-unconditionally-free-po-rollover.patch
  pktgen-do-not-sleep-with-the-thread-lock-held.patch
  revert-fib_rules-return-0-directly-if-an-exactly-same-rule-exists-when-nlm_f_excl-not-supplied.patch
  ipv6-use-read_once-for-inet-hdrincl-as-in-ipv4.patch
  ipv6-fix-efault-on-sendto-with-icmpv6-and-hdrincl.patch
  mtd-spinand-macronix-fix-ecc-status-read.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-ba528be0c70bbced9b18bd497de6a53997363ee7.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-ba528be0c70bbced9b18bd497de6a53997363ee7.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-ba528be0c70bbced9b18bd497de6a53997363ee7.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-ba528be0c70bbced9b18bd497de6a53997363ee7.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-ba528be0c70bbced9b18bd497de6a53997363ee7.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-ba528be0c70bbced9b18bd497de6a53997363ee7.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-ba528be0c70bbced9b18bd497de6a53997363ee7.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-ba528be0c70bbced9b18bd497de6a53997363ee7.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking sctp-auth: sockopts test [9]
       🚧 ✅ Networking route: pmtu [10]
       🚧 ✅ Networking route_func: local [11]
       🚧 ✅ Networking route_func: forward [11]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [12]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking sctp-auth: sockopts test [9]
       🚧 ✅ Networking route: pmtu [10]
       🚧 ✅ Networking route_func: local [11]
       🚧 ✅ Networking route_func: forward [11]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [12]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [12]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking sctp-auth: sockopts test [9]
       🚧 ✅ Networking route: pmtu [10]
       🚧 ✅ Networking route_func: local [11]
       🚧 ✅ Networking route_func: forward [11]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [12]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking sctp-auth: sockopts test [9]
       🚧 ✅ Networking route: pmtu [10]
       🚧 ✅ Networking route_func: local [11]
       🚧 ✅ Networking route_func: forward [11]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
