Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B569B3A42F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfFIHkH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 9 Jun 2019 03:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbfFIHkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 03:40:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3CDD63084288
        for <stable@vger.kernel.org>; Sun,  9 Jun 2019 07:40:06 +0000 (UTC)
Received: from [172.54.141.148] (cpt-large-cpu-05.paas.prod.upshift.rdu2.redhat.com [10.0.18.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EBB019C58;
        Sun,  9 Jun 2019 07:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.44444DF651.1ENGWPVISJ@redhat.com>
X-Gitlab-Pipeline-ID: 11852
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11852?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sun, 09 Jun 2019 07:40:06 +0000 (UTC)
Date:   Sun, 9 Jun 2019 03:40:06 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: bb7b450e61a1 - Linux 4.19.49

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
  Commit: bb7b450e61a1 - Linux 4.19.49


We then merged the patchset with `git am`:


Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-bb7b450e61a1dbe2bfbe998a1afeda654c6a67e9.tar.gz


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

