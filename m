Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E26848AE2
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 19:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfFQR6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 13:58:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfFQR6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 13:58:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D3A330018FC
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 17:58:11 +0000 (UTC)
Received: from [172.54.67.194] (cpt-large-cpu-02.paas.prod.upshift.rdu2.redhat.com [10.0.18.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 867A27FA2C;
        Mon, 17 Jun 2019 17:58:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-4.19
Message-ID: <cki.638D8E5353.03RZJNNKUW@redhat.com>
X-Gitlab-Pipeline-ID: 12528
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 17 Jun 2019 17:58:11 +0000 (UTC)
Date:   Mon, 17 Jun 2019 13:58:11 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 6500aa436df4 - Linux 4.19.52

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
  Commit: 6500aa436df4 - Linux 4.19.52


We then merged the patchset with `git am`:

  drm-nouveau-add-kconfig-option-to-turn-off-nouveau-legacy-contexts.-v3.patch
