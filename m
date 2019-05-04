Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC011386A
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 11:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfEDJ1Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 4 May 2019 05:27:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfEDJ1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 05:27:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D8FE3082A27
        for <stable@vger.kernel.org>; Sat,  4 May 2019 09:27:15 +0000 (UTC)
Received: from [172.54.27.0] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1559310AFF65;
        Sat,  4 May 2019 09:27:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.AC4D86E4B9.EV4NZ22DHS@redhat.com>
X-Gitlab-Pipeline-ID: 9342
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9342
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sat, 04 May 2019 09:27:15 +0000 (UTC)
Date:   Sat, 4 May 2019 05:27:16 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 6006d5b02522 - Linux 5.0.12

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
  Commit: 6006d5b02522 - Linux 5.0.12

We then merged the patchset with `git am`:

  ipv4-ip_do_fragment-preserve-skb_iif-during-fragmentation.patch
  ipv6-a-few-fixes-on-dereferencing-rt-from.patch
  ipv6-fix-races-in-ip6_dst_destroy.patch
  ipv6-flowlabel-wait-rcu-grace-period-before-put_pid.patch
  ipv6-invert-flowlabel-sharing-check-in-process-and-user-mode.patch
  l2ip-fix-possible-use-after-free.patch
  l2tp-use-rcu_dereference_sk_user_data-in-l2tp_udp_encap_recv.patch
  net-dsa-bcm_sf2-fix-buffer-overflow-doing-set_rxnfc.patch
  net-phy-marvell-fix-buffer-overrun-with-stats-counters.patch
  net-tls-avoid-null-pointer-deref-on-nskb-sk-in-fallback.patch
  rxrpc-fix-net-namespace-cleanup.patch
  sctp-avoid-running-the-sctp-state-machine-recursively.patch
  selftests-fib_rule_tests-print-the-result-and-return-1-if-any-tests-failed.patch
  packet-validate-msg_namelen-in-send-directly.patch
  packet-in-recvmsg-msg_name-return-at-least-sizeof-sockaddr_ll.patch
  selftests-fib_rule_tests-fix-icmp-proto-with-ipv6.patch
  tcp-add-sanity-tests-in-tcp_add_backlog.patch
  udp-fix-gro-reception-in-case-of-length-mismatch.patch
  udp-fix-gro-packet-of-death.patch
  bnxt_en-improve-multicast-address-setup-logic.patch
  bnxt_en-free-short-fw-command-hwrm-memory-in-error-path-in-bnxt_init_one.patch
  bnxt_en-fix-possible-crash-in-bnxt_hwrm_ring_free-under-error-conditions.patch
  bnxt_en-pass-correct-extended-tx-port-statistics-size-to-firmware.patch
  bnxt_en-fix-statistics-context-reservation-logic.patch
  bnxt_en-fix-uninitialized-variable-usage-in-bnxt_rx_pkt.patch
  net-tls-don-t-copy-negative-amounts-of-data-in-reencrypt.patch
  net-tls-fix-copy-to-fragments-in-reencrypt.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-394f1f661add0000d7b3f2b86398082a7e51e50c.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-394f1f661add0000d7b3f2b86398082a7e51e50c.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-394f1f661add0000d7b3f2b86398082a7e51e50c.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-394f1f661add0000d7b3f2b86398082a7e51e50c.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-394f1f661add0000d7b3f2b86398082a7e51e50c.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-394f1f661add0000d7b3f2b86398082a7e51e50c.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-394f1f661add0000d7b3f2b86398082a7e51e50c.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-394f1f661add0000d7b3f2b86398082a7e51e50c.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ Networking route: pmtu [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  ppc64le:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ Networking route: pmtu [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Boot test [0]
     🚧 ✅ Networking route: pmtu [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Boot test [0]
     🚧 ✅ Networking route: pmtu [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ stress: stress-ng [10]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
