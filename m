Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52580327A99
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhCAJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:20:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233751AbhCAJUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614590324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lc/q/AVTz9XnDkkE5xsYnad++0DlZa8f8rgPqQIGNxI=;
        b=JP/9sFxwph//b93hYIuLGyCDi2fi7WAdmHAo6w8BWzxRXKit05F3QlnjDo5KjKC15BtWmB
        QnXsjpRf7u1zWklKG6fqhrArbV1D+epJcV+wtcnn61c1yUZNr3wvL4iLFbz+cQnmxJ3sGt
        le05ZiElSjZlbBUANw4svE3VkoHTZzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-L-9w2CKON5CaCFm3jjBhew-1; Mon, 01 Mar 2021 04:18:41 -0500
X-MC-Unique: L-9w2CKON5CaCFm3jjBhew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E91E85B665
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 09:18:40 +0000 (UTC)
Received: from [172.21.14.74] (unknown [10.0.115.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01D286F7E4;
        Mon,  1 Mar 2021 09:18:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.11.2 (stable-queue)
Date:   Mon, 01 Mar 2021 09:18:35 -0000
CC:     David Arcari <darcari@redhat.com>
Message-ID: <cki.B543568BFC.BZQS7GN6YF@redhat.com>
X-Gitlab-Pipeline-ID: 624659
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/624659
X-DataWarehouse-Revision-IID: None
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: 0b9b5f9d794f - ALSA: pcm: Don't call sync_stop if it hasn=
't been stopped

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefi=
x=3Ddatawarehouse-public/2021/02/28/624659

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
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    s390x:
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg



Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 ACPI table test
       =E2=9C=85 ACPI enabled test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory: fork_mem
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - transport
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: update pci ids test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Firmware test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking firewall: basic ne=
tfilter test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test

  ppc64le:
    Host 1:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory: fork_mem
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: update pci ids test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking firewall: basic ne=
tfilter test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test

  s390x:
    Host 1:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - transport
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking firewall: basic ne=
tfilter test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test

  x86_64:
    Host 1:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9D=8C CPU: Frequency Driver Test
       =F0=9F=9A=A7 =E2=9C=85 CPU: Idle Test
       =F0=9F=9A=A7 =E2=9C=85 xfstests - ext4
       =F0=9F=9A=A7 =E2=9C=85 xfstests - xfs
       =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - nfsv4.2
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - cifsv3.11
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sa=
nity test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fi=
o test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue schedul=
er test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_mo=
dule test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng

  Test sources: https://gitlab.com/cki-project/kernel-tests
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to e=
xisting tests!

Aborted tests
-------------
Tests that didn't complete running successfully are marked with =E2=9A=A1=E2=
=9A=A1=E2=9A=A1.
If this was caused by an infrastructure issue, we try to mark that
explicitly in the report.

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. Suc=
h tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or a=
re
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running yet are marked with =E2=8F=B1.

