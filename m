Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF55A5F60
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 04:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfICCir convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Sep 2019 22:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfICCiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 22:38:46 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3EB87308427C
        for <stable@vger.kernel.org>; Tue,  3 Sep 2019 02:38:46 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82C8E5C221;
        Tue,  3 Sep 2019 02:38:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.2.11-c3915fe.cki
 (stable)
CC:     Xiong Zhou <xzhou@redhat.com>
Message-ID: <cki.EDBAAD9BB8.PJ4CXK5IUR@redhat.com>
X-Gitlab-Pipeline-ID: 140026
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/140026
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 03 Sep 2019 02:38:46 +0000 (UTC)
Date:   Mon, 2 Sep 2019 22:38:46 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: c3915fe1bf12 - Linux 5.2.11

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/140026



One or more kernel tests failed:

  aarch64:
    ❌ Boot test

  ppc64le:
    ❌ xfstests: xfs

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

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
         ❌ Boot test [0]
         ⚡⚡⚡ xfstests: ext4 [1]
         ⚡⚡⚡ xfstests: xfs [1]
         ⚡⚡⚡ selinux-policy: serge-testsuite [2]
         ⚡⚡⚡ lvm thinp sanity [3]
         ⚡⚡⚡ storage: software RAID testing [4]
         🚧 ⚡⚡⚡ Storage blktests [5]
         🚧 ⚡⚡⚡ IOMMU boot test [6]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [7]
         ✅ Podman system integration test (as user) [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ Memory function: memfd_create [10]
         ✅ AMTU (Abstract Machine Test Utility) [11]
         ✅ LTP: openposix test suite [12]
         ✅ Ethernet drivers sanity [13]
         ✅ Networking socket: fuzz [14]
         ✅ Networking sctp-auth: sockopts test [15]
         ✅ Networking: igmp conformance test [16]
         ✅ Networking TCP: keepalive test [17]
         ✅ Networking UDP: socket [18]
         ✅ Networking tunnel: gre basic [19]
         ✅ Networking tunnel: vxlan basic [20]
         ✅ audit: audit testsuite test [21]
         ✅ httpd: mod_ssl smoke sanity [22]
         ✅ iotop: sanity [23]
         ✅ tuned: tune-processes-through-perf [24]
         ✅ Usex - version 1.9-29 [25]
         ✅ storage: SCSI VPD [26]
         ✅ stress: stress-ng [27]
         🚧 ✅ LTP lite [28]
         🚧 ✅ CIFS Connectathon [29]
         🚧 ✅ Memory function: kaslr [30]
         🚧 ✅ Networking bridge: sanity [31]
         🚧 ✅ Networking route: pmtu [32]
         🚧 ✅ Networking route_func: local [33]
         🚧 ✅ Networking route_func: forward [33]
         🚧 ✅ Networking tunnel: geneve basic test [34]
         🚧 ✅ Networking ipsec: basic netns transport [35]
         🚧 ✅ Networking ipsec: basic netns tunnel [35]
         🚧 ✅ Networking vnic: ipvlan/basic [36]
         🚧 ✅ trace: ftrace/tracer [37]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ❌ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [7]
         ✅ Podman system integration test (as user) [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ Memory function: memfd_create [10]
         ✅ AMTU (Abstract Machine Test Utility) [11]
         ✅ LTP: openposix test suite [12]
         ✅ Ethernet drivers sanity [13]
         ✅ Networking socket: fuzz [14]
         ✅ Networking sctp-auth: sockopts test [15]
         ✅ Networking TCP: keepalive test [17]
         ✅ Networking UDP: socket [18]
         ✅ Networking tunnel: gre basic [19]
         ✅ Networking tunnel: vxlan basic [20]
         ✅ audit: audit testsuite test [21]
         ✅ httpd: mod_ssl smoke sanity [22]
         ✅ iotop: sanity [23]
         ✅ tuned: tune-processes-through-perf [24]
         ✅ Usex - version 1.9-29 [25]
         🚧 ✅ LTP lite [28]
         🚧 ✅ CIFS Connectathon [29]
         🚧 ✅ Memory function: kaslr [30]
         🚧 ✅ Networking bridge: sanity [31]
         🚧 ✅ Networking route: pmtu [32]
         🚧 ✅ Networking route_func: local [33]
         🚧 ✅ Networking route_func: forward [33]
         🚧 ✅ Networking tunnel: geneve basic test [34]
         🚧 ✅ Networking ipsec: basic netns tunnel [35]
         🚧 ✅ Networking vnic: ipvlan/basic [36]
         🚧 ✅ trace: ftrace/tracer [37]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]
         🚧 ✅ IOMMU boot test [6]

      Host 2:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - mpt3sas driver [38]

      Host 3:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - megaraid_sas [38]

      Host 4:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [7]
         ✅ Podman system integration test (as user) [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ Memory function: memfd_create [10]
         ✅ AMTU (Abstract Machine Test Utility) [11]
         ✅ LTP: openposix test suite [12]
         ✅ Ethernet drivers sanity [13]
         ✅ Networking socket: fuzz [14]
         ✅ Networking sctp-auth: sockopts test [15]
         ✅ Networking: igmp conformance test [16]
         ✅ Networking TCP: keepalive test [17]
         ✅ Networking UDP: socket [18]
         ✅ Networking tunnel: gre basic [19]
         ✅ Networking tunnel: vxlan basic [20]
         ✅ audit: audit testsuite test [21]
         ✅ httpd: mod_ssl smoke sanity [22]
         ✅ iotop: sanity [23]
         ✅ tuned: tune-processes-through-perf [24]
         ✅ pciutils: sanity smoke test [39]
         ✅ Usex - version 1.9-29 [25]
         ✅ storage: SCSI VPD [26]
         ✅ stress: stress-ng [27]
         🚧 ✅ LTP lite [28]
         🚧 ✅ CIFS Connectathon [29]
         🚧 ✅ Memory function: kaslr [30]
         🚧 ✅ Networking bridge: sanity [31]
         🚧 ✅ Networking route: pmtu [32]
         🚧 ✅ Networking route_func: local [33]
         🚧 ✅ Networking route_func: forward [33]
         🚧 ✅ Networking tunnel: geneve basic test [34]
         🚧 ✅ Networking ipsec: basic netns transport [35]
         🚧 ✅ Networking ipsec: basic netns tunnel [35]
         🚧 ✅ Networking vnic: ipvlan/basic [36]
         🚧 ✅ trace: ftrace/tracer [37]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/cifs/connectathon
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/bridge/sanity_check
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [35]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [36]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/vnic/ipvlan/basic
    [37]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [38]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress
    [39]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
