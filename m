Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCAEA1CDCA
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 19:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfENRSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 13:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfENRSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 13:18:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C10B43007149
        for <stable@vger.kernel.org>; Tue, 14 May 2019 17:18:15 +0000 (UTC)
Received: from [172.54.252.220] (cpt-0020.paas.prod.upshift.rdu2.redhat.com [10.0.18.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9229D1001E98;
        Tue, 14 May 2019 17:18:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-5.1
Message-ID: <cki.A3A8485C6F.6XI265B8MJ@redhat.com>
X-Gitlab-Pipeline-ID: 10054
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10054?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 14 May 2019 17:18:15 +0000 (UTC)
Date:   Tue, 14 May 2019 13:18:15 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: b724e9356404 - Linux 5.1.1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: FAILED


When we attempted to merge the patchset, we received an error:

  Patch is empty.

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
  Commit: b724e9356404 - Linux 5.1.1

We then merged the patchset with `git am`:

