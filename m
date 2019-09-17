Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2CFB504E
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfIQO0T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 17 Sep 2019 10:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbfIQO0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 10:26:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0E998980E1
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 14:26:18 +0000 (UTC)
Received: from [172.54.84.214] (cpt-1024.paas.prod.upshift.rdu2.redhat.com [10.0.19.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04D735C226;
        Tue, 17 Sep 2019 14:26:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.16-rc1-08e7f5e.cki
 (stable)
Message-ID: <cki.8A2EA093C3.XJA2C39DW8@redhat.com>
X-Gitlab-Pipeline-ID: 169018
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/169018
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 17 Sep 2019 14:26:18 +0000 (UTC)
Date:   Tue, 17 Sep 2019 10:26:19 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 08e7f5e8f180 - Linux 5.2.16-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/169018

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
         🚧 ✅ ALSA Control (mixer) Userspace Element test [34]
         🚧 ✅ trace: ftrace/tracer [35]
         🚧 ✅ Networking route_func: local [36]
         🚧 ✅ Networking route_func: forward [36]

  s390x:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ⚡⚡⚡ Boot test [0]
         ⚡⚡⚡ Podman system integration test (as root) [6]
         ⚡⚡⚡ Podman system integration test (as user) [6]
         ⚡⚡⚡ Loopdev Sanity [7]
         ⚡⚡⚡ jvm test suite [8]
         ⚡⚡⚡ Memory function: memfd_create [9]
         ⚡⚡⚡ LTP: openposix test suite [11]
         ⚡⚡⚡ Ethernet drivers sanity [12]
         ⚡⚡⚡ Networking sctp-auth: sockopts test [14]
         ⚡⚡⚡ Networking TCP: keepalive test [15]
         ⚡⚡⚡ Networking UDP: socket [16]
         ⚡⚡⚡ Networking tunnel: gre basic [17]
         ⚡⚡⚡ Networking tunnel: vxlan basic [18]
         ⚡⚡⚡ audit: audit testsuite test [19]
         ⚡⚡⚡ httpd: mod_ssl smoke sanity [20]
         ⚡⚡⚡ iotop: sanity [21]
         ⚡⚡⚡ tuned: tune-processes-through-perf [22]
         ⚡⚡⚡ Usex - version 1.9-29 [23]
         ⚡⚡⚡ stress: stress-ng [37]
         🚧 ⚡⚡⚡ LTP lite [24]
         🚧 ⚡⚡⚡ CIFS Connectathon [25]
         🚧 ⚡⚡⚡ Memory function: kaslr [26]
         🚧 ⚡⚡⚡ Networking bridge: sanity [27]
         🚧 ⚡⚡⚡ Networking MACsec: sanity [28]
         🚧 ⚡⚡⚡ Networking route: pmtu [29]
         🚧 ⚡⚡⚡ Networking tunnel: geneve basic test [30]
         🚧 ⚡⚡⚡ Networking vnic: ipvlan/basic [32]
         🚧 ⚡⚡⚡ ALSA PCM loopback test [33]
         🚧 ⚡⚡⚡ ALSA Control (mixer) Userspace Element test [34]
         🚧 ⚡⚡⚡ trace: ftrace/tracer [35]
         🚧 ⚡⚡⚡ Networking route_func: local [36]
         🚧 ⚡⚡⚡ Networking route_func: forward [36]
         🚧 ⚡⚡⚡ Networking ipsec: basic netns transport [31]
         🚧 ⚡⚡⚡ Networking ipsec: basic netns tunnel [31]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ⚡⚡⚡ Boot test [0]
         ⚡⚡⚡ selinux-policy: serge-testsuite [2]
         🚧 ⚡⚡⚡ Storage blktests [5]

  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - mpt3sas driver [38]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]
         🚧 ❌ IOMMU boot test [39]

      Host 3:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - megaraid_sas [38]

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
         ✅ Networking: igmp conformance test [40]
         ✅ Networking TCP: keepalive test [15]
         ✅ Networking UDP: socket [16]
         ✅ Networking tunnel: gre basic [17]
         ✅ Networking tunnel: vxlan basic [18]
         ✅ audit: audit testsuite test [19]
         ✅ httpd: mod_ssl smoke sanity [20]
         ✅ iotop: sanity [21]
         ✅ tuned: tune-processes-through-perf [22]
         ✅ pciutils: sanity smoke test [41]
         ✅ Usex - version 1.9-29 [23]
         ✅ storage: SCSI VPD [42]
         ✅ stress: stress-ng [37]
         🚧 ✅ LTP lite [24]
         🚧 ✅ CIFS Connectathon [25]
         🚧 ✅ Memory function: kaslr [26]
         🚧 ✅ Networking bridge: sanity [27]
         🚧 ✅ Networking MACsec: sanity [28]
         🚧 ✅ Networking route: pmtu [29]
         🚧 ✅ Networking tunnel: geneve basic test [30]
         🚧 ✅ Networking vnic: ipvlan/basic [32]
         🚧 ✅ ALSA PCM loopback test [33]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [34]
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
    [37]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [38]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress
    [39]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [40]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [41]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [42]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
