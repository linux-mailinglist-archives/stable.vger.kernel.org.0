Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6E105D34
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUXkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:40:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29085 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725956AbfKUXkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 18:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574379638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ra+t36Qu0jTiomf3bm7D0ispZbPiOgsDroSKD3K+G6c=;
        b=VnzkOzpdmLmvvATl7+lQX2sPosCNpC6I4KfvA6G+QwFZROyMOhfMKWaMtgC2BWteLWcslG
        co15HV08NzOwFz8OTcxfmc3w51rZkE1KxnJDglXPIzZ3BU8AU0Pv06zO4y51S9sW2HgNFF
        jH5SjIXQZex3qHEoXUuHZwtW0xrN8sA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Z2x3IaEtPOO6IXTVWNpEyQ-1; Thu, 21 Nov 2019 18:40:36 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18380184CAA0
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 23:40:36 +0000 (UTC)
Received: from [172.54.73.15] (cpt-1028.paas.prod.upshift.rdu2.redhat.com [10.0.19.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7201D26FC4;
        Thu, 21 Nov 2019 23:40:33 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Date:   Thu, 21 Nov 2019 23:40:33 -0000
Message-ID: <cki.408D752337.SYZLEFS0XM@redhat.com>
X-Gitlab-Pipeline-ID: 300278
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/300278
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Z2x3IaEtPOO6IXTVWNpEyQ-1
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
            Commit: 5d6121095143 - Linux 5.3.12

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/300278

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
  Commit: 5d6121095143 - Linux 5.3.12


We grabbed the 7db072fa6a88 commit of the stable queue repository.

We then merged the patchset with `git am`:

  net-cdc_ncm-signedness-bug-in-cdc_ncm_set_dgram_size.patch
  block-bfq-deschedule-empty-bfq_queues-not-referred-by-any-process.patch
  mm-memory_hotplug-don-t-access-uninitialized-memmaps-in-shrink_pgdat_span=
.patch
  mm-memory_hotplug-fix-updating-the-node-span.patch
  arm64-uaccess-ensure-pan-is-re-enabled-after-unhandled-uaccess-fault.patc=
h
  fbdev-ditch-fb_edid_add_monspecs.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    s390x:
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

  s390x:

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

