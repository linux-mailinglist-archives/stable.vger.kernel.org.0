Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644194BD7E
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 18:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfFSQFz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 19 Jun 2019 12:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFSQFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 12:05:55 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92ADF81F33
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 16:05:54 +0000 (UTC)
Received: from [172.54.67.194] (cpt-large-cpu-02.paas.prod.upshift.rdu2.redhat.com [10.0.18.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0079E608A7;
        Wed, 19 Jun 2019 16:05:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.93900B3832.W6EVEZZR2P@redhat.com>
X-Gitlab-Pipeline-ID: 12764
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 19 Jun 2019 16:05:54 +0000 (UTC)
Date:   Wed, 19 Jun 2019 12:05:55 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 9f31eb60d7a2 - Linux 4.19.53

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
  Commit: 9f31eb60d7a2 - Linux 4.19.53


We then merged the patchset with `git am`:

  ax25-fix-inconsistent-lock-state-in-ax25_destroy_timer.patch
  be2net-fix-number-of-rx-queues-used-for-flow-hashing.patch
  hv_netvsc-set-probe-mode-to-sync.patch
  ipv6-flowlabel-fl6_sock_lookup-must-use-atomic_inc_not_zero.patch
  lapb-fixed-leak-of-control-blocks.patch
  neigh-fix-use-after-free-read-in-pneigh_get_next.patch
  net-dsa-rtl8366-fix-up-vlan-filtering.patch
  net-openvswitch-do-not-free-vport-if-register_netdevice-is-failed.patch
  net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
  nfc-ensure-presence-of-required-attributes-in-the-deactivate_target-handler.patch
  sctp-free-cookie-before-we-memdup-a-new-one.patch
  sunhv-fix-device-naming-inconsistency-between-sunhv_console-and-sunhv_reg.patch
  tipc-purge-deferredq-list-for-each-grp-member-in-tipc_group_delete.patch
  vsock-virtio-set-sock_done-on-peer-shutdown.patch
  net-mlx5-avoid-reloading-already-removed-devices.patch
  net-mvpp2-prs-fix-parser-range-for-vid-filtering.patch
  net-mvpp2-prs-use-the-correct-helpers-when-removing-all-vid-filters.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-ce226e94fdc2705ca7eef6580ab406bdeff22e0a.tar.gz


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
       🚧 ✅ Networking socket: fuzz [7]
       🚧 ✅ Networking sctp-auth: sockopts test [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ Networking socket: fuzz [7]
       🚧 ✅ Networking sctp-auth: sockopts test [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ Networking socket: fuzz [7]
       🚧 ✅ Networking sctp-auth: sockopts test [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ Ethernet drivers sanity [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ Networking socket: fuzz [7]
       🚧 ✅ Networking sctp-auth: sockopts test [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
