Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1568CB36F2
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 11:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731764AbfIPJQx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 Sep 2019 05:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfIPJQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 05:16:53 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA12DA26674
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 09:16:52 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 260A619C78;
        Mon, 16 Sep 2019 09:16:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.15-rc2-4a69042.cki
 (stable)
Message-ID: <cki.0A944FE00E.XEG1QUXDF7@redhat.com>
X-Gitlab-Pipeline-ID: 166408
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/166408
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Mon, 16 Sep 2019 09:16:52 +0000 (UTC)
Date:   Mon, 16 Sep 2019 05:16:53 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 4a69042627aa - Linux 5.2.15-rc2

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/166408

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
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ⚡⚡⚡ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ Memory function: memfd_create [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ Networking sctp-auth: sockopts test [9]
         ✅ Networking: igmp conformance test [10]
         ✅ Networking TCP: keepalive test [11]
         ✅ Networking UDP: socket [12]
         ✅ Networking tunnel: gre basic [13]
         ✅ Networking tunnel: vxlan basic [14]
         ✅ audit: audit testsuite test [15]
         ✅ httpd: mod_ssl smoke sanity [16]
         ✅ iotop: sanity [17]
         ✅ tuned: tune-processes-through-perf [18]
         ✅ Usex - version 1.9-29 [19]
         ✅ storage: SCSI VPD [20]
         ✅ stress: stress-ng [21]
         🚧 ✅ LTP lite [22]
         🚧 ✅ CIFS Connectathon [23]
         🚧 ✅ Memory function: kaslr [24]
         🚧 ✅ Networking bridge: sanity [25]
         🚧 ✅ Networking MACsec: sanity [26]
         🚧 ✅ Networking route: pmtu [27]
         🚧 ✅ Networking tunnel: geneve basic test [28]
         🚧 ✅ Networking vnic: ipvlan/basic [29]
         🚧 ✅ ALSA PCM loopback test [30]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [31]
         🚧 ✅ trace: ftrace/tracer [32]
         🚧 ✅ Networking route_func: local [33]
         🚧 ✅ Networking route_func: forward [33]
         🚧 ✅ Networking ipsec: basic netns transport [34]
         🚧 ✅ Networking ipsec: basic netns tunnel [34]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [35]
         ✅ xfstests: xfs [35]
         ✅ selinux-policy: serge-testsuite [36]
         ✅ lvm thinp sanity [37]
         ✅ storage: software RAID testing [38]
         🚧 ✅ Storage blktests [39]

  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [35]
         ✅ xfstests: xfs [35]
         ✅ selinux-policy: serge-testsuite [36]
         ✅ lvm thinp sanity [37]
         ✅ storage: software RAID testing [38]
         🚧 ❌ Storage blktests [39]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ⚡⚡⚡ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ Memory function: memfd_create [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ Networking sctp-auth: sockopts test [9]
         ✅ Networking TCP: keepalive test [11]
         ✅ Networking UDP: socket [12]
         ✅ Networking tunnel: gre basic [13]
         ✅ Networking tunnel: vxlan basic [14]
         ✅ audit: audit testsuite test [15]
         ✅ httpd: mod_ssl smoke sanity [16]
         ✅ iotop: sanity [17]
         ✅ tuned: tune-processes-through-perf [18]
         ✅ Usex - version 1.9-29 [19]
         🚧 ⚡⚡⚡ LTP lite [22]
         🚧 ✅ CIFS Connectathon [23]
         🚧 ✅ Memory function: kaslr [24]
         🚧 ✅ Networking bridge: sanity [25]
         🚧 ✅ Networking MACsec: sanity [26]
         🚧 ✅ Networking route: pmtu [27]
         🚧 ✅ Networking tunnel: geneve basic test [28]
         🚧 ✅ Networking ipsec: basic netns tunnel [34]
         🚧 ✅ Networking vnic: ipvlan/basic [29]
         🚧 ✅ ALSA PCM loopback test [30]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [31]
         🚧 ✅ trace: ftrace/tracer [32]
         🚧 ✅ Networking route_func: local [33]
         🚧 ✅ Networking route_func: forward [33]

  s390x:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ⚡⚡⚡ Boot test [0]
         ⚡⚡⚡ Podman system integration test (as root) [1]
         ⚡⚡⚡ Podman system integration test (as user) [1]
         ⚡⚡⚡ Loopdev Sanity [2]
         ⚡⚡⚡ jvm test suite [3]
         ⚡⚡⚡ Memory function: memfd_create [4]
         ⚡⚡⚡ LTP: openposix test suite [6]
         ⚡⚡⚡ Ethernet drivers sanity [7]
         ⚡⚡⚡ Networking sctp-auth: sockopts test [9]
         ⚡⚡⚡ Networking TCP: keepalive test [11]
         ⚡⚡⚡ Networking UDP: socket [12]
         ⚡⚡⚡ Networking tunnel: gre basic [13]
         ⚡⚡⚡ Networking tunnel: vxlan basic [14]
         ⚡⚡⚡ audit: audit testsuite test [15]
         ⚡⚡⚡ httpd: mod_ssl smoke sanity [16]
         ⚡⚡⚡ iotop: sanity [17]
         ⚡⚡⚡ tuned: tune-processes-through-perf [18]
         ⚡⚡⚡ Usex - version 1.9-29 [19]
         ⚡⚡⚡ stress: stress-ng [21]
         🚧 ⚡⚡⚡ LTP lite [22]
         🚧 ⚡⚡⚡ CIFS Connectathon [23]
         🚧 ⚡⚡⚡ Memory function: kaslr [24]
         🚧 ⚡⚡⚡ Networking bridge: sanity [25]
         🚧 ⚡⚡⚡ Networking MACsec: sanity [26]
         🚧 ⚡⚡⚡ Networking route: pmtu [27]
         🚧 ⚡⚡⚡ Networking tunnel: geneve basic test [28]
         🚧 ⚡⚡⚡ Networking vnic: ipvlan/basic [29]
         🚧 ⚡⚡⚡ ALSA PCM loopback test [30]
         🚧 ⚡⚡⚡ ALSA Control (mixer) Userspace Element test [31]
         🚧 ⚡⚡⚡ trace: ftrace/tracer [32]
         🚧 ⚡⚡⚡ Networking route_func: local [33]
         🚧 ⚡⚡⚡ Networking route_func: forward [33]
         🚧 ⚡⚡⚡ Networking ipsec: basic netns transport [34]
         🚧 ⚡⚡⚡ Networking ipsec: basic netns tunnel [34]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ⚡⚡⚡ Boot test [0]
         ⚡⚡⚡ selinux-policy: serge-testsuite [36]
         🚧 ⚡⚡⚡ Storage blktests [39]

  x86_64:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ xfstests: ext4 [35]
         ✅ xfstests: xfs [35]
         ✅ selinux-policy: serge-testsuite [36]
         ✅ lvm thinp sanity [37]
         ✅ storage: software RAID testing [38]
         🚧 ✅ Storage blktests [39]
         🚧 ⚡⚡⚡ IOMMU boot test [40]

      Host 2:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - mpt3sas driver [41]

      Host 3:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ⚡⚡⚡ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ Memory function: memfd_create [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ Networking sctp-auth: sockopts test [9]
         ✅ Networking: igmp conformance test [10]
         ✅ Networking TCP: keepalive test [11]
         ✅ Networking UDP: socket [12]
         ✅ Networking tunnel: gre basic [13]
         ✅ Networking tunnel: vxlan basic [14]
         ✅ audit: audit testsuite test [15]
         ✅ httpd: mod_ssl smoke sanity [16]
         ✅ iotop: sanity [17]
         ✅ tuned: tune-processes-through-perf [18]
         ✅ pciutils: sanity smoke test [42]
         ✅ Usex - version 1.9-29 [19]
         ✅ storage: SCSI VPD [20]
         ✅ stress: stress-ng [21]
         🚧 ✅ LTP lite [22]
         🚧 ✅ CIFS Connectathon [23]
         🚧 ❌ Memory function: kaslr [24]
         🚧 ✅ Networking bridge: sanity [25]
         🚧 ✅ Networking MACsec: sanity [26]
         🚧 ✅ Networking route: pmtu [27]
         🚧 ✅ Networking tunnel: geneve basic test [28]
         🚧 ✅ Networking vnic: ipvlan/basic [29]
         🚧 ✅ ALSA PCM loopback test [30]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [31]
         🚧 ✅ trace: ftrace/tracer [32]
         🚧 ✅ Networking route_func: local [33]
         🚧 ✅ Networking route_func: forward [33]
         🚧 ✅ Networking ipsec: basic netns transport [34]
         🚧 ✅ Networking ipsec: basic netns tunnel [34]

      Host 4:
         ✅ Boot test [0]
         ✅ Storage SAN device stress - megaraid_sas [41]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/cifs/connectathon
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/bridge/sanity_check
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/macsec/sanity_check
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/vnic/ipvlan/basic
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/sound/aloop
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/sound/user-ctl-elem
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [35]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [36]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [37]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [38]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [39]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [40]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [41]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress
    [42]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
