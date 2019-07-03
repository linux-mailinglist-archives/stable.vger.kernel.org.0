Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B0F5E35D
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfGCMBR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 3 Jul 2019 08:01:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfGCMBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:01:17 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8104C8762E;
        Wed,  3 Jul 2019 12:01:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 757DF842C9;
        Wed,  3 Jul 2019 12:01:17 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 64FE8E163;
        Wed,  3 Jul 2019 12:01:17 +0000 (UTC)
Date:   Wed, 3 Jul 2019 08:01:16 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <1989107726.28546762.1562155276612.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190703112520.GA20712@kroah.com>
References: <cki.3BCD9A354F.JWPY9HGRUT@redhat.com> <20190703112520.GA20712@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Stable_queue:_queue-5.1?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.205.46, 10.4.195.12]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Stable queue: queue-5.1
Thread-Index: J/jJZrT9SSsuZZ6QKC34ntsHKwcm8w==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 03 Jul 2019 12:01:17 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "CKI Project" <cki-project@redhat.com>
> Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Wednesday, July 3, 2019 1:25:20 PM
> Subject: Re: ❌ FAIL: Stable queue: queue-5.1
> 
> On Wed, Jul 03, 2019 at 07:16:58AM -0400, CKI Project wrote:
> > Hello,
> > 
> > We ran automated tests on a patchset that was proposed for merging into
> > this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: 8584aaf1c326 - Linux 5.1.16
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: FAILED
> 
> Guys, this is getting annoying, this is your test systems, the queue is
> empty :)
> 

Hi,

this is not an empty queue problem (that should be fixed now). We triggered
the testing right after the 5.1.16 was released to test the present queue
with it. We have added the commit hash of the queue to the merge details in
the report to verify this is indeed the case.

The base commit for the stable kernel is 8584aaf1c326
The commit of the stable queue is d0f506ba82

This queue was removed a minute later (obviously with the release) after the
baseline change was pushed but we caught this combo as we try to trigger
testing after every change to any of those repos. So the patches from the
queue really didn't apply.


I currently see two ways (or their combination) around this:
1) The queue changes need to be pushed first
2) We detect how long ago the baseline was pushed and if it's less than
   let's say 5mins we abort the pipeline to give you enough time to do the
   changes to the repo

Maybe you also have a different idea that would work better? We try to
keep up with your quick changes to really test everything and in this case
ended up being too fast.


Thanks for the feedback and working with us so we can figure out a workflow
that works the best for you,

Veronika


> thanks,
> 
> greg k-h
> 
> 
