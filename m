Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63E830FFB
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 16:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfEaOR7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 31 May 2019 10:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfEaOR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 10:17:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE2A937EEF
        for <stable@vger.kernel.org>; Fri, 31 May 2019 14:17:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3CDA4EE0C
        for <stable@vger.kernel.org>; Fri, 31 May 2019 14:17:58 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA17218363C0;
        Fri, 31 May 2019 14:17:58 +0000 (UTC)
Date:   Fri, 31 May 2019 10:17:58 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <438701674.22873619.1559312278037.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.048BF4514F.WLA8C664MK@redhat.com>
References: <cki.048BF4514F.WLA8C664MK@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8E_FAIL:_Stable_queue:_queue-4.19?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.204.184, 10.4.195.10]
Thread-Topic: =?utf-8?B?4p2OIEZBSUw6?= Stable queue: queue-4.19
Thread-Index: hdcwf+jeV14hBV1v5KS7u+vOu7Toxw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 31 May 2019 14:17:58 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Friday, May 31, 2019 3:50:36 PM
> Subject: ❎ FAIL: Stable queue: queue-4.19
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 0df021b2e841 - Linux 4.19.47
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED
> 
> 
> 
> When we attempted to merge the patchset, we received an error:
> 
>   Patch is empty.
> 

The testing was triggered right before the release was made so we grabbed
the patch list from the series file. The actual patch application was
executed after the release so the files obviously didn't exist anymore,
leading to this error.

I'll add some handling for this situation, sorry.
Veronika


> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this
> message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more
> effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 
> Merge testing
> -------------
> 
> We cloned this repository and checked out the following commit:
> 
>   Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: 0df021b2e841 - Linux 4.19.47
> 
> 
> We then merged the patchset with `git am`:
> 
> 
