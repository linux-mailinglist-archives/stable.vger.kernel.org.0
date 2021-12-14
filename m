Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D82D474749
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 17:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhLNQOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 11:14:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhLNQOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 11:14:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639498481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NbV3UT54OSlwfHTBHr8C1CM7BD5wuCaVAFYuZZp+EmY=;
        b=ZLo1l0kUErteZwUIpRi+mcfrzKkEhrFVHjx5BDHZzqWr9SsbQ8y6iOaISBGCZdQopX08J+
        ljdYSTsgIxz0KscRetE9S1S5Mpf8NxBhKN+SelkbCtPEzgoYV/NqzgOpDI9cyeUzpKT/86
        p+vz7DbwzKPCRyzJYSI+Kb2KjGGKblw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-GYIQMCZ3NJ20gUtHJ2r7TA-1; Tue, 14 Dec 2021 11:14:39 -0500
X-MC-Unique: GYIQMCZ3NJ20gUtHJ2r7TA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1154101AFA8
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 16:14:38 +0000 (UTC)
Received: from [172.64.9.13] (unknown [10.30.33.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940ED1059166;
        Tue, 14 Dec 2021 16:14:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.15.8 (stable,
 43e577d7)
Date:   Tue, 14 Dec 2021 16:14:37 -0000
Message-ID: <cki.H8487VZIWEN3NZMT6QFX@redhat.com>
X-Gitlab-Pipeline-ID: 429402796
X-Gitlab-Url: https://gitlab.com
X-Gitlab-Path: =?utf-8?q?/redhat/red-hat-ci-tools/kernel/cki-internal-pipeli?=
 =?utf-8?q?nes/cki-trusted-contributors/pipelines/429402796?=
X-DataWarehouse-Checkout-IID: 26983
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Check out this report and any autotriaged failures in our web dashboard:
    https://datawarehouse.cki-project.org/kcidb/checkouts/26983

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: 43e577d7a2cb - Linux 5.15.8

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK
    Targeted tests: NO

All kernel binaries, config files, and logs are available for download here:

  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefi=
x=3Ddatawarehouse-public/2021/12/14/429402796

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

