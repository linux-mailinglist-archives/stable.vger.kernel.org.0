Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF7169A9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfEGR4g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 May 2019 13:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfEGR4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:56:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12F64307D95F;
        Tue,  7 May 2019 17:56:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07539600D4;
        Tue,  7 May 2019 17:56:35 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E82A418089CA;
        Tue,  7 May 2019 17:56:34 +0000 (UTC)
Date:   Tue, 7 May 2019 13:56:34 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <870847532.18462136.1557251794376.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190507170150.GA1468@kroah.com>
References: <cki.8007596684.1FGCVHW930@redhat.com> <20190507170150.GA1468@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9C=85_PASS:_Stable_queue:_queue-5.0?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.205.155, 10.4.195.12]
Thread-Topic: =?utf-8?B?4pyFIFBBU1M6?= Stable queue: queue-5.0
Thread-Index: hm67ak3FTs1sb6ptSraC29PExGEcSg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 07 May 2019 17:56:35 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "CKI Project" <cki-project@redhat.com>
> Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Tuesday, May 7, 2019 7:01:50 PM
> Subject: Re: ✅ PASS: Stable queue: queue-5.0
> 
> On Tue, May 07, 2019 at 11:21:07AM -0400, CKI Project wrote:
> >   x86_64:
> >      ✅ Boot test [0]
> >      ✅ LTP lite [2]
> >      ✅ Loopdev Sanity [3]
> >      ✅ AMTU (Abstract Machine Test Utility) [4]
> >      ✅ Ethernet drivers sanity [5]
> >      ✅ httpd: mod_ssl smoke sanity [6]
> >      ✅ iotop: sanity [7]
> >      ✅ tuned: tune-processes-through-perf [8]
> >      ✅ Usex - version 1.9-29 [9]
> >      ✅ lvm thinp sanity [10]
> >      ✅ Boot test [0]
> >      ✅ xfstests: xfs [1]
> >      🚧 ✅ audit: audit testsuite test [12]
> >      🚧 ✅ stress: stress-ng [13]
> >      🚧 ✅ selinux-policy: serge-testsuite [11]
> 
> Just a question, what is the number in the [] above?
> 
> The number of tests run?  And if so:
>       ✅ Boot test [0]
> is listed twice, with no tests run?  Doesn't booting count? :)
> 
> Also, "LTP lite", isn't that a lot more than just 2 tests that are part
> of that?  Any chance you can add more LTP tests, much like Linaro has?
> I think their list of LTP tests they are running is somewhere.
> 
> >   Test source:
> >     [0]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
> >     [1]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
> >     [2]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
> >     [3]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
> >     [4]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
> >     [5]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
> >     [6]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
> >     [7]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
> >     [8]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
> >     [9]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
> >     [10]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
> >     [11]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
> >     [12]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
> >     [13]:
> >     https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
> 
> Ah crap, it's a footnote, nevermind on most of what I wrote above :)
> 
> But why is booting happening twice?
> 

Hi,

in some cases we are running multiple recipes in a single test job, to
get out the results faster. Each recipe is started by a "boot test" since
that's responsible for installing and booting the kernel being tested. The
report joins all recipes for given architecture, hence that one test is
shown there multiple times. I agree that we should make this more clear
and separate the report parts per recipes but we didn't have time for it
yet, sorry. I notified people about the problem and we'll prioritize :)

> And I see you are running xfstests, which is great, but does it really
> all "pass"?  What type of filesystem image are you running it on.
> 

Here you can find the list of subtests that's being run [0] and a list of
excluded ones from them [1]. This is just a reduced test set as some of the
tests were triggering fake failures or taking too long to run as a part of
CI. The lists may change in the future of course.

We set up two separate xfs partitions for the testing. The machine should
have at least 50G of space available for this.


Hope this explains everything and sorry for the recipe confusion. Let us
know if you have anything else!


Veronika
CKI Project


[0] https://github.com/CKI-project/tests-beaker/blob/master/filesystems/xfs/xfstests/RUNTESTS
[1] https://github.com/CKI-project/tests-beaker/blob/master/filesystems/xfs/xfstests/known_issues

> thanks,
> 
> greg k-h
> 
> 
