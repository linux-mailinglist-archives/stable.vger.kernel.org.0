Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9303F9C46E
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 16:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfHYOh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 10:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbfHYOh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 10:37:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 52D443082126
        for <stable@vger.kernel.org>; Sun, 25 Aug 2019 14:37:26 +0000 (UTC)
Received: from [172.54.99.226] (cpt-1058.paas.prod.upshift.rdu2.redhat.com [10.0.19.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED9A5D9D6;
        Sun, 25 Aug 2019 14:37:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.2
Message-ID: <cki.FF1370FEA1.W4XGF3MDGN@redhat.com>
X-Gitlab-Pipeline-ID: 123306
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/123306
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Sun, 25 Aug 2019 14:37:26 +0000 (UTC)
Date:   Sun, 25 Aug 2019 10:37:26 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: f7d5b3dc4792 - Linux 5.2.10

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/123306




When we attempted to merge the patchset, we received an error:

  error: patch failed: security/keys/trusted.c:1228
  error: security/keys/trusted.c: patch does not apply
  hint: Use 'git am --show-current-patch' to see the failed patch
  Applying: KEYS: trusted: allow module init if TPM is inactive or deactivated
  Patch failed at 0001 KEYS: trusted: allow module init if TPM is inactive or deactivated

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

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: f7d5b3dc4792 - Linux 5.2.10


We grabbed the cc88f4442e50 commit of the stable queue repository.

We then merged the patchset with `git am`:

  keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
