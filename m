Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89AF3C958
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfFKKt7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Jun 2019 06:49:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbfFKKt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 06:49:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD70C3082E0F
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 10:49:58 +0000 (UTC)
Received: from [172.54.141.148] (cpt-large-cpu-05.paas.prod.upshift.rdu2.redhat.com [10.0.18.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FA8D19C70;
        Tue, 11 Jun 2019 10:49:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.3E83E3F98B.J46RGUNHI5@redhat.com>
X-Gitlab-Pipeline-ID: 12008
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12008?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 11 Jun 2019 10:49:58 +0000 (UTC)
Date:   Tue, 11 Jun 2019 06:49:59 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 768292d05361 - Linux 4.19.50

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK


We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 768292d05361 - Linux 4.19.50


We then merged the patchset with `git am`:


Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-768292d053619b2725b846ed2bf556bf40f43de2.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-768292d053619b2725b846ed2bf556bf40f43de2.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-768292d053619b2725b846ed2bf556bf40f43de2.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-768292d053619b2725b846ed2bf556bf40f43de2.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-768292d053619b2725b846ed2bf556bf40f43de2.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-768292d053619b2725b846ed2bf556bf40f43de2.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-768292d053619b2725b846ed2bf556bf40f43de2.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-768292d053619b2725b846ed2bf556bf40f43de2.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  ppc64le:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  s390x:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!

