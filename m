Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1D107274
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 13:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfKVMvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 07:51:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51953 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbfKVMvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 07:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574427075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zqn8t/TBvgJerDNrUTJ7nxMF64wppR8yrwvfCwA9/6Q=;
        b=Mtbl0MvzWB9aSjyrYsvOyht3+f4irB0dUXCrtEdFO90WhID67XzSKoA7PBkf6eUXFsIFGt
        s8zn4Jt4rkvICkUmqv6647ijjVNMH8oygKq5TdXcWv5hK9P3jucY9roXX/sbhRSXr4xU87
        2PBbqqBpwmayWRDsDEvoSNDqBjVKe1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-2QvqituqMt-ZzmEZ9GonvQ-1; Fri, 22 Nov 2019 07:51:13 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C6EDB20
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 12:51:12 +0000 (UTC)
Received: from [172.54.73.15] (cpt-1028.paas.prod.upshift.rdu2.redhat.com [10.0.19.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D70906E718;
        Fri, 22 Nov 2019 12:51:09 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.3.13-rc1-6b14caa.cki
 (stable)
Date:   Fri, 22 Nov 2019 12:51:09 -0000
Message-ID: <cki.C2507DF09F.RUKG09QJOE@redhat.com>
X-Gitlab-Pipeline-ID: 301338
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/301338
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 2QvqituqMt-ZzmEZ9GonvQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: 6b14caa1dc57 - Linux 5.3.13-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/301338

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

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  ppc64le:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

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

