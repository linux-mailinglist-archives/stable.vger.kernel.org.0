Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA571007CC
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRPAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:00:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbfKRPAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574089250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wxe/flxXe0w/jdvMhmPpCDpgXCGil5Xz9AuUA8D6rlU=;
        b=Ezlj05ETncB6PtSE6D0geXpEJAxQ6iOuotQZ9WuWCLvIjsTcy+TLzBQG9hzNEBxNlYzNgv
        iVj+JH2VQKP128G+aPAn9wpw/+jYMcesJRhDzVZjhMdCVYYTBGkSnZUhFfLrd520uNhCpO
        Xe58fdv75qs59i3aF7RMtC6c4n6+7MI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-yJTgbZGYPRCKzLIVfw2sfg-1; Mon, 18 Nov 2019 10:00:43 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1193B8E5772;
        Mon, 18 Nov 2019 15:00:42 +0000 (UTC)
Received: from [172.54.46.57] (cpt-1015.paas.prod.upshift.rdu2.redhat.com [10.0.19.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 813A35D9CA;
        Mon, 18 Nov 2019 15:00:41 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
Date:   Mon, 18 Nov 2019 15:00:41 -0000
CC:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <cki.042792963E.5VOWULC1Q9@redhat.com>
X-Gitlab-Pipeline-ID: 293063
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/293063
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: yJTgbZGYPRCKzLIVfw2sfg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into thi=
s
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git
            Commit: 116a395b7061 - Linux 5.3.11

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/293063

One or more kernel tests failed:

    aarch64:
     =E2=9D=8C LTP lite

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

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 116a395b7061 - Linux 5.3.11


We grabbed the c4a7b00e0626 commit of the stable queue repository.

We then merged the patchset with `git am`:

  scsi-core-handle-drivers-which-set-sg_tablesize-to-zero.patch
  ax88172a-fix-information-leak-on-short-answers.patch
  devlink-disallow-reload-operation-during-device-cleanup.patch
  ipmr-fix-skb-headroom-in-ipmr_get_route.patch
  mlxsw-core-enable-devlink-reload-only-on-probe.patch
  net-gemini-add-missed-free_netdev.patch
  net-smc-fix-fastopen-for-non-blocking-connect.patch
  net-usb-qmi_wwan-add-support-for-foxconn-t77w968-lte-modules.patch
  slip-fix-memory-leak-in-slip_open-error-path.patch
  tcp-remove-redundant-new-line-from-tcp_event_sk_skb.patch
  dpaa2-eth-free-already-allocated-channels-on-probe-defer.patch
  devlink-add-method-for-time-stamp-on-reporter-s-dump.patch
  net-smc-fix-refcount-non-blocking-connect-part-2.patch

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
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9D=8C LTP lite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng

  ppc64le:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 stress: stress-ng

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

