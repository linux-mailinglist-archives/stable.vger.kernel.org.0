Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C63DDA07
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 20:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfJSSRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 14:17:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726052AbfJSSRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 14:17:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571509041;
        h=from:from:reply-to:subject:subject:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QsfnbD9FteOeBvjenKJKOka+SSoQ2dKG9s0Jj7QIva4=;
        b=C3djWc6Boy1DvuPY5rMvg8c7fnI2jjdFvPEu7wJJRlo4wrkiMibTI049HZxtdzhuR+2WWt
        3cSLZ5TYmF12Ib98R0176KrO2baECXi9W4egKrz/6EiAQIKahynZBVXQQi5sAMrbJ1OrSv
        7lmXPvFCcgOgihipy1KsLWNrjddtNBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-8xUwZtHUNC6bz98s79ECDg-1; Sat, 19 Oct 2019 14:17:20 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E6C980183D
        for <stable@vger.kernel.org>; Sat, 19 Oct 2019 18:17:19 +0000 (UTC)
Received: from [172.54.99.2] (cpt-1058.paas.prod.upshift.rdu2.redhat.com [10.0.19.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE8A95D6A7;
        Sat, 19 Oct 2019 18:17:16 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.4.0-rc3-404590a.cki
 (stable-next)
Message-ID: <cki.DE1C3D88E8.J8A9OYHK6Q@redhat.com>
X-Gitlab-Pipeline-ID: 235237
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/235237
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 8xUwZtHUNC6bz98s79ECDg-1
X-Mimecast-Spam-Score: 1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date:   Sat, 19 Oct 2019 14:17:24 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/sashal/li=
nux-stable.git
            Commit: 404590aa1984 - scsi: core: try to get module before rem=
oving device

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/235237

One or more kernel tests failed:

    ppc64le:
      =E2=9D=8C Boot test
      =E2=9D=8C Boot test

    aarch64:
      =E2=9D=8C Boot test
      =E2=9D=8C Boot test

    x86_64:
      =E2=9D=8C Boot test
      =E2=9D=8C Boot test
      =E2=9D=8C Boot test
      =E2=9D=8C Boot test
      =E2=9D=8C Boot test

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this messa=
ge.

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
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as roo=
t)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as use=
r)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP lite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve=
 basic test
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/b=
asic
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: lo=
cal
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: fo=
rward
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic n=
etns transport
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic n=
etns tunnel

      Host 2:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests

  ppc64le:
      Host 1:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as roo=
t)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as use=
r)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP lite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve=
 basic test
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic n=
etns tunnel
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/b=
asic
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: lo=
cal
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: fo=
rward

      Host 2:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests

  x86_64:
      Host 1:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IOMMU boot test
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests

      Host 2:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as roo=
t)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as use=
r)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP lite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve=
 basic test
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/b=
asic
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: lo=
cal
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: fo=
rward
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic n=
etns transport
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic n=
etns tunnel

      Host 3:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage SAN device stress - megaraid_s=
as

      Host 4:
         =E2=9D=8C Boot test
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test

      Host 5:
         =E2=9D=8C Boot test
         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage SAN device stress - mpt3sas dr=
iver

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

