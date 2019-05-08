Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D2D1751A
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfEHJYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfEHJYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:24:43 -0400
Received: from localhost (unknown [84.241.196.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A50FA20578;
        Wed,  8 May 2019 09:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557307482;
        bh=JPlvReNNSGyOBk61p5a23NIWNFIHc2trBofvTikGKz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LIDr+W32Azm8csCiJWnEyedJnhETxQO5jibAaT1Uf76feiZlo7EylFjFsRcywoARd
         JsZX6ruMRFUYbr2FhpBel1t/uuCP54c91UCHQDVhOSEvSPhDGWymnnprviteXHVl0X
         T73BZlJ5SgsKViIS1t+XcfT3mgVyASLaSEUBYx7k=
Date:   Wed, 8 May 2019 11:24:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190508092439.GB2361@kroah.com>
References: <cki.8007596684.1FGCVHW930@redhat.com>
 <20190507170150.GA1468@kroah.com>
 <870847532.18462136.1557251794376.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <870847532.18462136.1557251794376.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 01:56:34PM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg KH" <gregkh@linuxfoundation.org>
> > To: "CKI Project" <cki-project@redhat.com>
> > Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Tuesday, May 7, 2019 7:01:50 PM
> > Subject: Re: ✅ PASS: Stable queue: queue-5.0
> > 
> > On Tue, May 07, 2019 at 11:21:07AM -0400, CKI Project wrote:
> > >   x86_64:
> > >      ✅ Boot test [0]
> > >      ✅ LTP lite [2]
> > >      ✅ Loopdev Sanity [3]
> > >      ✅ AMTU (Abstract Machine Test Utility) [4]
> > >      ✅ Ethernet drivers sanity [5]
> > >      ✅ httpd: mod_ssl smoke sanity [6]
> > >      ✅ iotop: sanity [7]
> > >      ✅ tuned: tune-processes-through-perf [8]
> > >      ✅ Usex - version 1.9-29 [9]
> > >      ✅ lvm thinp sanity [10]
> > >      ✅ Boot test [0]
> > >      ✅ xfstests: xfs [1]
> > >      🚧 ✅ audit: audit testsuite test [12]
> > >      🚧 ✅ stress: stress-ng [13]
> > >      🚧 ✅ selinux-policy: serge-testsuite [11]
> > 
> > Just a question, what is the number in the [] above?
> > 
> > The number of tests run?  And if so:
> >       ✅ Boot test [0]
> > is listed twice, with no tests run?  Doesn't booting count? :)
> > 
> > Also, "LTP lite", isn't that a lot more than just 2 tests that are part
> > of that?  Any chance you can add more LTP tests, much like Linaro has?
> > I think their list of LTP tests they are running is somewhere.
> > 
> > >   Test source:
> > >     [0]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
> > >     [1]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
> > >     [2]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
> > >     [3]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
> > >     [4]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
> > >     [5]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
> > >     [6]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
> > >     [7]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
> > >     [8]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
> > >     [9]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
> > >     [10]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
> > >     [11]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
> > >     [12]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
> > >     [13]:
> > >     https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
> > 
> > Ah crap, it's a footnote, nevermind on most of what I wrote above :)
> > 
> > But why is booting happening twice?
> > 
> 
> Hi,
> 
> in some cases we are running multiple recipes in a single test job, to
> get out the results faster. Each recipe is started by a "boot test" since
> that's responsible for installing and booting the kernel being tested. The
> report joins all recipes for given architecture, hence that one test is
> shown there multiple times. I agree that we should make this more clear
> and separate the report parts per recipes but we didn't have time for it
> yet, sorry. I notified people about the problem and we'll prioritize :)
> 
> > And I see you are running xfstests, which is great, but does it really
> > all "pass"?  What type of filesystem image are you running it on.
> > 
> 
> Here you can find the list of subtests that's being run [0] and a list of
> excluded ones from them [1]. This is just a reduced test set as some of the
> tests were triggering fake failures or taking too long to run as a part of
> CI. The lists may change in the future of course.
> 
> We set up two separate xfs partitions for the testing. The machine should
> have at least 50G of space available for this.
> 
> 
> Hope this explains everything and sorry for the recipe confusion. Let us
> know if you have anything else!

Thanks a lot for the information.  It's good to see that someone is
finally running xfstests on the stable trees, that's much appreciated.

greg k-h
