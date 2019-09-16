Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3C9B3FC6
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 19:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbfIPRxe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 Sep 2019 13:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388225AbfIPRxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 13:53:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA4AE10F2E81
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 17:53:33 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 312D45D6A3;
        Mon, 16 Sep 2019 17:53:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.A1549FEC70.PUGPO9WRRJ@redhat.com>
X-Gitlab-Pipeline-ID: 168287
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/168287
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 16 Sep 2019 17:53:33 +0000 (UTC)
Date:   Mon, 16 Sep 2019 13:53:34 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 6e282ba6ff6b - Linux 5.2.15

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/168287

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
  Commit: 6e282ba6ff6b - Linux 5.2.15


We grabbed the b3793b83d825 commit of the stable queue repository.

We then merged the patchset with `git am`:

  bridge-mdb-remove-wrong-use-of-nlm_f_multi.patch
  cdc_ether-fix-rndis-support-for-mediatek-based-smartphones.patch
  ipv6-fix-the-link-time-qualifier-of-ping_v6_proc_exit_net.patch
  isdn-capi-check-message-length-in-capi_write.patch
  ixgbe-fix-secpath-usage-for-ipsec-tx-offload.patch
  ixgbevf-fix-secpath-usage-for-ipsec-tx-offload.patch
  net-fix-null-de-reference-of-device-refcount.patch
  net-gso-fix-skb_segment-splat-when-splitting-gso_size-mangled-skb-having-linear-headed-frag_list.patch
  net-phylink-fix-flow-control-resolution.patch
  net-sched-fix-reordering-issues.patch
  sch_hhf-ensure-quantum-and-hhf_non_hh_weight-are-non-zero.patch
  sctp-fix-the-link-time-qualifier-of-sctp_ctrlsock_exit.patch
  sctp-use-transport-pf_retrans-in-sctp_do_8_2_transport_strike.patch
  tcp-fix-tcp_ecn_withdraw_cwr-to-clear-tcp_ecn_queue_cwr.patch
  tipc-add-null-pointer-check-before-calling-kfree_rcu.patch
  tun-fix-use-after-free-when-register-netdev-failed.patch
  net-ipv6-fix-excessive-rtf_addrconf-flag-on-1-128-local-route-and-others.patch
  ipv6-addrconf_f6i_alloc-fix-non-null-pointer-check-to-is_err.patch
  net-fixed_phy-add-forward-declaration-for-struct-gpio_desc.patch
  sctp-fix-the-missing-put_user-when-dumping-transport-thresholds.patch
  net-sock_map-fix-missing-ulp-check-in-sock-hash-case.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    s390x:
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
         ✅ Ethernet drivers sanity [5]
         ✅ Networking socket: fuzz [6]
         ✅ Networking sctp-auth: sockopts test [7]
         ✅ Networking TCP: keepalive test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ stress: stress-ng [13]
         🚧 ✅ LTP lite [14]
         🚧 ✅ Networking bridge: sanity [15]
         🚧 ✅ Networking route: pmtu [16]
         🚧 ✅ Networking route_func: local [17]
         🚧 ✅ Networking route_func: forward [17]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [18]

  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ jvm test suite [2]
         ✅ AMTU (Abstract Machine Test Utility) [3]
         ✅ LTP: openposix test suite [4]
         ✅ Ethernet drivers sanity [5]
         ✅ Networking socket: fuzz [6]
         ✅ Networking sctp-auth: sockopts test [7]
         ✅ Networking TCP: keepalive test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         🚧 ✅ LTP lite [14]
         🚧 ✅ Networking bridge: sanity [15]
         🚧 ✅ Networking route: pmtu [16]
         🚧 ✅ Networking route_func: local [17]
         🚧 ✅ Networking route_func: forward [17]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [18]

  s390x:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ⚡⚡⚡ Boot test [0]
         ⚡⚡⚡ selinux-policy: serge-testsuite [18]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ⚡⚡⚡ Boot test [0]
         ⚡⚡⚡ Podman system integration test (as root) [1]
         ⚡⚡⚡ Podman system integration test (as user) [1]
         ⚡⚡⚡ jvm test suite [2]
         ⚡⚡⚡ LTP: openposix test suite [4]
         ⚡⚡⚡ Ethernet drivers sanity [5]
         ⚡⚡⚡ Networking sctp-auth: sockopts test [7]
         ⚡⚡⚡ Networking TCP: keepalive test [8]
         ⚡⚡⚡ audit: audit testsuite test [9]
         ⚡⚡⚡ httpd: mod_ssl smoke sanity [10]
         ⚡⚡⚡ iotop: sanity [11]
         ⚡⚡⚡ tuned: tune-processes-through-perf [12]
         ⚡⚡⚡ stress: stress-ng [13]
         🚧 ⚡⚡⚡ LTP lite [14]
         🚧 ⚡⚡⚡ Networking bridge: sanity [15]
         🚧 ⚡⚡⚡ Networking route: pmtu [16]
         🚧 ⚡⚡⚡ Networking route_func: local [17]
         🚧 ⚡⚡⚡ Networking route_func: forward [17]

  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ jvm test suite [2]
         ✅ AMTU (Abstract Machine Test Utility) [3]
         ✅ LTP: openposix test suite [4]
         ✅ Ethernet drivers sanity [5]
         ✅ Networking socket: fuzz [6]
         ✅ Networking sctp-auth: sockopts test [7]
         ✅ Networking TCP: keepalive test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ pciutils: sanity smoke test [19]
         ✅ stress: stress-ng [13]
         🚧 ✅ LTP lite [14]
         🚧 ✅ Networking bridge: sanity [15]
         🚧 ✅ Networking route: pmtu [16]
         🚧 ✅ Networking route_func: local [17]
         🚧 ✅ Networking route_func: forward [17]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [18]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/bridge/sanity_check
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
