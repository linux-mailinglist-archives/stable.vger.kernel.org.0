Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462D1AF586
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 07:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfIKF6F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 11 Sep 2019 01:58:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfIKF6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 01:58:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72C6F30860BF
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 05:58:04 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17A995C21E;
        Wed, 11 Sep 2019 05:58:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.15-rc1-d24ce91.cki
 (stable)
Message-ID: <cki.52D0BEA80D.W5RJBWOX4F@redhat.com>
X-Gitlab-Pipeline-ID: 156141
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/156141
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 11 Sep 2019 05:58:04 +0000 (UTC)
Date:   Wed, 11 Sep 2019 01:58:05 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: d24ce912b21e - Linux 5.2.15-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/156141

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

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ⚡⚡⚡ Loopdev Sanity [7]
         ✅ jvm test suite [8]
         ✅ Memory function: memfd_create [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Ethernet drivers sanity [12]
         ✅ Networking socket: fuzz [13]
         ✅ Networking sctp-auth: sockopts test [14]
         ✅ Networking TCP: keepalive test [15]
         ✅ Networking UDP: socket [16]
         ✅ Networking tunnel: gre basic [17]
         ✅ Networking tunnel: vxlan basic [18]
         ✅ audit: audit testsuite test [19]
         ✅ httpd: mod_ssl smoke sanity [20]
         ✅ iotop: sanity [21]
         ✅ tuned: tune-processes-through-perf [22]
         ✅ Usex - version 1.9-29 [23]
         🚧 ✅ LTP lite [24]
         🚧 ✅ CIFS Connectathon [25]
         🚧 ✅ Memory function: kaslr [26]
         🚧 ✅ Networking bridge: sanity [27]
         🚧 ✅ Networking MACsec: sanity [28]
         🚧 ✅ Networking route: pmtu [29]
         🚧 ✅ Networking tunnel: geneve basic test [30]
         🚧 ✅ Networking ipsec: basic netns tunnel [31]
         🚧 ✅ Networking vnic: ipvlan/basic [32]
         🚧 ✅ ALSA PCM loopback test [33]
         🚧 ✅  ALSA Control (mixer) Userspace Element test [34]
         🚧 ✅ trace: ftrace/tracer [35]
         🚧 ✅ Networking route_func: local [36]
         🚧 ✅ Networking route_func: forward [36]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - mpt3sas driver [37]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]
         🚧 ✅ IOMMU boot test [38]

      Host 3:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - megaraid_sas [37]

      Host 4:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ⚡⚡⚡ Loopdev Sanity [7]
         ✅ jvm test suite [8]
         ✅ Memory function: memfd_create [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Ethernet drivers sanity [12]
         ✅ Networking socket: fuzz [13]
         ✅ Networking sctp-auth: sockopts test [14]
         ✅ Networking: igmp conformance test [39]
         ✅ Networking TCP: keepalive test [15]
         ✅ Networking UDP: socket [16]
         ✅ Networking tunnel: gre basic [17]
         ✅ Networking tunnel: vxlan basic [18]
         ✅ audit: audit testsuite test [19]
         ✅ httpd: mod_ssl smoke sanity [20]
         ✅ iotop: sanity [21]
         ✅ tuned: tune-processes-through-perf [22]
         ✅ pciutils: sanity smoke test [40]
         ✅ Usex - version 1.9-29 [23]
         ✅ storage: SCSI VPD [41]
         ✅ stress: stress-ng [42]
         🚧 ✅ LTP lite [24]
         🚧 ✅ CIFS Connectathon [25]
         🚧 ✅ Memory function: kaslr [26]
         🚧 ✅ Networking bridge: sanity [27]
         🚧 ✅ Networking MACsec: sanity [28]
         🚧 ✅ Networking route: pmtu [29]
         🚧 ✅ Networking tunnel: geneve basic test [30]
         🚧 ✅ Networking vnic: ipvlan/basic [32]
         🚧 ✅ ALSA PCM loopback test [33]
         🚧 ✅  ALSA Control (mixer) Userspace Element test [34]
         🚧 ✅ trace: ftrace/tracer [35]
         🚧 ✅ Networking route_func: local [36]
         🚧 ✅ Networking route_func: forward [36]
         🚧 ✅ Networking ipsec: basic netns transport [31]
         🚧 ✅ Networking ipsec: basic netns tunnel [31]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/cifs/connectathon
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/bridge/sanity_check
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/macsec/sanity_check
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/vnic/ipvlan/basic
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/sound/aloop
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/sound/user-ctl-elem
    [35]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [36]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [37]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress
    [38]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [39]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [40]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [41]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [42]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
