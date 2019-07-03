Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AE45E2B3
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 13:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCLQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 07:16:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfGCLQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 07:16:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 642045946B
        for <stable@vger.kernel.org>; Wed,  3 Jul 2019 11:16:58 +0000 (UTC)
Received: from [172.54.129.25] (cpt-1023.paas.prod.upshift.rdu2.redhat.com [10.0.19.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA0AD196BC;
        Wed,  3 Jul 2019 11:16:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.1
Message-ID: <cki.3BCD9A354F.JWPY9HGRUT@redhat.com>
X-Gitlab-Pipeline-ID: 17464
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 03 Jul 2019 11:16:58 +0000 (UTC)
Date:   Wed, 3 Jul 2019 07:16:58 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 8584aaf1c326 - Linux 5.1.16

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: FAILED




When we attempted to merge the patchset, we received an error:

  error: patch failed: arch/arm64/Makefile:51
  error: arch/arm64/Makefile: patch does not apply
  hint: Use 'git am --show-current-patch' to see the failed patch
  Applying: arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS
  Patch failed at 0001 arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS

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
  Commit: 8584aaf1c326 - Linux 5.1.16


We grabbed the d0f506ba82ea commit of the stable queue repository.

We then merged the patchset with `git am`:

  arm64-don-t-unconditionally-add-wno-psabi-to-kbuild_cflags.patch
