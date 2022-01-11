Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C586848AF86
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 15:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241442AbiAKO2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 09:28:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239980AbiAKO2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 09:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641911319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gkMo/BJLbM1k1ZKuC9Po4jrSBdkxFD4Hylqg8mqHQWM=;
        b=Ci4NTu9Udg8EiNiqAogygfuhwh1/SlRg7pp8WI6Ca4CLn0ClDBEexRCSeIg6F0vZdmNRTp
        GX96yCWO3xwnQkHZgqpAj5Cir5qCfXum0JGd6W/zSem9h/IpeR2U8FN2L4/6LPtbjdUECc
        84j07hTpdM6zVR0oduAz8/+B9F+tl/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-eAGobyFqNbGwoifBvGHMeg-1; Tue, 11 Jan 2022 09:28:38 -0500
X-MC-Unique: eAGobyFqNbGwoifBvGHMeg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2499C1083F67
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 14:28:37 +0000 (UTC)
Received: from [172.64.9.26] (unknown [10.30.33.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA03A2B5A5;
        Tue, 11 Jan 2022 14:28:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     stable@vger.kernel.org
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.15.13 (stable-queue,
 7fb4d82f)
Date:   Tue, 11 Jan 2022 14:28:34 -0000
Message-ID: <cki.BM2HWEDFCL68G7V4Z5ZO@redhat.com>
X-Gitlab-Pipeline-ID: 445604228
X-Gitlab-Url: https://gitlab.com
X-Gitlab-Path: =?utf-8?q?/redhat/red-hat-ci-tools/kernel/cki-internal-pipeli?=
 =?utf-8?q?nes/cki-trusted-contributors/pipelines/445604228?=
X-DataWarehouse-Checkout-IID: 28727
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Check out this report and any autotriaged failures in our web dashboard:
    https://datawarehouse.cki-project.org/kcidb/checkouts/28727

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: 7fb4d82fc369 - drm/amd/pm: keep the BACO feature enabled =
for suspend

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK
    Targeted tests: NO

All kernel binaries, config files, and logs are available for download here:

  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefi=
x=3Ddatawarehouse-public/2022/01/11/445604228

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
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg

    s390x:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg



Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (mar=
ked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  ppc64le:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (mar=
ked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  s390x:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (mar=
ked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (mar=
ked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

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
Targeted tests
--------------
Test runs for patches always include a set of base tests, plus some
tests chosen based on the file paths modified by the patch. The latter
are called "targeted tests". If no targeted tests are run, that means
no patch-specific tests are available. Please, consider contributing a
targeted test for related patches to increase test coverage. See
https://docs.engineering.redhat.com/x/_wEZB for more details.

