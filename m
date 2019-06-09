Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892FB3A498
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfFIKCy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 9 Jun 2019 06:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfFIKCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 06:02:54 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C64478762E
        for <stable@vger.kernel.org>; Sun,  9 Jun 2019 10:02:53 +0000 (UTC)
Received: from [172.54.141.148] (cpt-large-cpu-05.paas.prod.upshift.rdu2.redhat.com [10.0.18.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6830F100194A;
        Sun,  9 Jun 2019 10:02:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.EB25654166.KWK4MJU8I1@redhat.com>
X-Gitlab-Pipeline-ID: 11856
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11856?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Sun, 09 Jun 2019 10:02:53 +0000 (UTC)
Date:   Sun, 9 Jun 2019 06:02:54 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 937cc0cc22a2 - Linux 5.1.8

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
  Commit: 937cc0cc22a2 - Linux 5.1.8


We then merged the patchset with `git am`:

  ethtool-fix-potential-userspace-buffer-overflow.patch
  fix-memory-leak-in-sctp_process_init.patch
  ipv4-not-do-cache-for-local-delivery-if-bc_forwarding-is-enabled.patch
  ipv6-fix-the-check-before-getting-the-cookie-in-rt6_get_cookie.patch
  net-ethernet-ti-cpsw_ethtool-fix-ethtool-ring-param-set.patch
  net-mvpp2-use-strscpy-to-handle-stat-strings.patch
  net-rds-fix-memory-leak-in-rds_ib_flush_mr_pool.patch
  net-sfp-read-eeprom-in-maximum-16-byte-increments.patch
  packet-unconditionally-free-po-rollover.patch
  pktgen-do-not-sleep-with-the-thread-lock-held.patch
  revert-fib_rules-return-0-directly-if-an-exactly-same-rule-exists-when-nlm_f_excl-not-supplied.patch
  udp-only-choose-unbound-udp-socket-for-multicast-when-not-in-a-vrf.patch
  ipv6-use-read_once-for-inet-hdrincl-as-in-ipv4.patch
  ipv6-fix-efault-on-sendto-with-icmpv6-and-hdrincl.patch
  net-aquantia-fix-wol-configuration-not-applied-sometimes.patch
  neighbor-reset-gc_entries-counter-if-new-entry-is-released-before-insert.patch
  neighbor-call-__ipv4_neigh_lookup_noref-in-neigh_xmit.patch
  cls_matchall-avoid-panic-when-receiving-a-packet-before-filter-set.patch
  ipmr_base-do-not-reset-index-in-mr_table_dump.patch
  net-mlx4_en-ethtool-remove-unsupported-sfp-eeprom-high-pages-query.patch
  net-tls-replace-the-sleeping-lock-around-rx-resync-with-a-bit-lock.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-45601abfd4383769d9dffcb215d09e934434ccc7.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-45601abfd4383769d9dffcb215d09e934434ccc7.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-45601abfd4383769d9dffcb215d09e934434ccc7.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-45601abfd4383769d9dffcb215d09e934434ccc7.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-45601abfd4383769d9dffcb215d09e934434ccc7.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-45601abfd4383769d9dffcb215d09e934434ccc7.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-45601abfd4383769d9dffcb215d09e934434ccc7.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-45601abfd4383769d9dffcb215d09e934434ccc7.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking sctp-auth: sockopts test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]
       🚧 ✅ Networking UDP: socket [13]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking sctp-auth: sockopts test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]
       🚧 ✅ Networking UDP: socket [13]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking sctp-auth: sockopts test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]
       🚧 ✅ Networking UDP: socket [13]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       🚧 ✅ Networking socket: fuzz [9]
       🚧 ✅ Networking sctp-auth: sockopts test [10]
       🚧 ✅ Networking route: pmtu [11]
       🚧 ✅ Networking route_func: local [12]
       🚧 ✅ Networking route_func: forward [12]
       🚧 ✅ Networking UDP: socket [13]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
