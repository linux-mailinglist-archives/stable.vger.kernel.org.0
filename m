Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F517115ADB
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 04:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLGDnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 22:43:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59630 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726388AbfLGDnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 22:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575690194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eoakzL8Rpx3otj1h3/sMmuBjtu2sPMF1eCNcsO3HTzI=;
        b=bRDXi5phtnFfqNL8JTIUB+N7vAJXQkJNPgWRXEG58rF2yqRVBl5JGf8DFYYV63pMhObDnm
        mxp5QLD7UN1fAk8UCdDXtGxwJMuYg8oBUpcv1Iq9gOJDxpJkSOFoJQEUhIN0pFMq68EHVD
        i2MmeIJfrAlXZSEphjcxmfxTGSINW5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-W_QW9uifPLSjtOo7u5DSng-1; Fri, 06 Dec 2019 22:43:12 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B48D51005502
        for <stable@vger.kernel.org>; Sat,  7 Dec 2019 03:43:11 +0000 (UTC)
Received: from [172.54.81.213] (cpt-1035.paas.prod.upshift.rdu2.redhat.com [10.0.19.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ACA219C4F;
        Sat,  7 Dec 2019 03:43:09 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.3.15-7dc12b0.cki
 (stable-queue)
Date:   Sat, 07 Dec 2019 03:43:08 -0000
Message-ID: <cki.B7483CD9E0.WOL9XPRAKT@redhat.com>
X-Gitlab-Pipeline-ID: 326788
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/326788
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: W_QW9uifPLSjtOo7u5DSng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/st=
able-queue.git
            Commit: 7dc12b076eae - serial: ifx6x60: add missed pm_runtime_d=
isable

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/326788

Please reply to this email if you have any questions about the tests that w=
e
ran or if you have any suggestions on how to make future tests more effecti=
ve.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
___________________________________________________________________________=
___

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: ext4
       =E2=9C=85 xfstests: xfs
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 2:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 Memory function: kaslr
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking MACsec: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking sctp-auth: sockopts test
       =E2=9C=85 Networking: igmp conformance test
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns transport
       =E2=9C=85 Networking ipsec: basic netns tunnel
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 stress: stress-ng
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 jvm test suite
       =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
       =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
       =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
       =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 Memory function: kaslr
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking MACsec: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking sctp-auth: sockopts test
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns tunnel
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 jvm test suite
       =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
       =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
       =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
       =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: ext4
       =E2=9C=85 xfstests: xfs
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
       =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: ext4
       =E2=9C=85 xfstests: xfs
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
       =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
       =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 2:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as root)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as user)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns transport
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element t=
est
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/bas=
ic
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common

    Host 3:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage SAN device stress - mpt3sas driv=
er

    Host 4:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage SAN device stress - megaraid_sas

    Host 5:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as root)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as user)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns transport
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element t=
est
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/bas=
ic
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common

  Test sources: https://github.com/CKI-project/tests-beaker
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to=
 existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. S=
uch tests are
executed but their results are not taken into account. Tests are waived whe=
n
their results are not reliable enough, e.g. when they're just introduced or=
 are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with =E2=8F=B1. Reports for non-upstream kernel=
s have
a Beaker recipe linked to next to each host.

