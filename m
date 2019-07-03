Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0329E5EF97
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 01:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfGCXWx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 3 Jul 2019 19:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbfGCXWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 19:22:53 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 999F1308A963
        for <stable@vger.kernel.org>; Wed,  3 Jul 2019 23:22:52 +0000 (UTC)
Received: from [172.54.129.25] (cpt-1023.paas.prod.upshift.rdu2.redhat.com [10.0.19.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E28E818BB4;
        Wed,  3 Jul 2019 23:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 4.19.58-rc1-c0b2467.cki
 (stable)
Message-ID: <cki.1A73B385E5.OJX437QK5O@redhat.com>
X-Gitlab-Pipeline-ID: 17833
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 03 Jul 2019 23:22:52 +0000 (UTC)
Date:   Wed, 3 Jul 2019 19:22:53 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: c0b2467c02bd - Linux 4.19.58-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK


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
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-c0b2467c02bdbd6d49d9165e4097bbb83da01c35.tar.gz


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

