Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2068017E06
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 18:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfEHQWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 12:22:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfEHQWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 12:22:47 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD006300B915;
        Wed,  8 May 2019 16:22:46 +0000 (UTC)
Received: from redhat.com (dhcp-17-8.bos.redhat.com [10.18.17.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24A7B5F7E5;
        Wed,  8 May 2019 16:22:44 +0000 (UTC)
Date:   Wed, 8 May 2019 12:22:42 -0400
From:   Don Zickus <dzickus@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <20190508162242.tbhuuwd6wrm66ppb@redhat.com>
References: <cki.8007596684.1FGCVHW930@redhat.com>
 <20190507170150.GA1468@kroah.com>
 <870847532.18462136.1557251794376.JavaMail.zimbra@redhat.com>
 <20190508092439.GB2361@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508092439.GB2361@kroah.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 08 May 2019 16:22:46 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 11:24:39AM +0200, Greg KH wrote:
> > Hi,
> > 
> > in some cases we are running multiple recipes in a single test job, to
> > get out the results faster. Each recipe is started by a "boot test" since
> > that's responsible for installing and booting the kernel being tested. The
> > report joins all recipes for given architecture, hence that one test is
> > shown there multiple times. I agree that we should make this more clear
> > and separate the report parts per recipes but we didn't have time for it
> > yet, sorry. I notified people about the problem and we'll prioritize :)
> > 
> > > And I see you are running xfstests, which is great, but does it really
> > > all "pass"?  What type of filesystem image are you running it on.
> > > 
> > 
> > Here you can find the list of subtests that's being run [0] and a list of
> > excluded ones from them [1]. This is just a reduced test set as some of the
> > tests were triggering fake failures or taking too long to run as a part of
> > CI. The lists may change in the future of course.
> > 
> > We set up two separate xfs partitions for the testing. The machine should
> > have at least 50G of space available for this.
> > 
> > 
> > Hope this explains everything and sorry for the recipe confusion. Let us
> > know if you have anything else!
> 
> Thanks a lot for the information.  It's good to see that someone is
> finally running xfstests on the stable trees, that's much appreciated.

Hi Greg,

Thanks for the feedback.  If you have some other suggested tests, we might
be able to add them to our test harness.  We do have some bandwidth for
extra testing.  Thanks!

Cheers,
Don
