Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D5E68AB2C
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 17:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBDQX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 11:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjBDQXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 11:23:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8EA20062;
        Sat,  4 Feb 2023 08:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17771B80B21;
        Sat,  4 Feb 2023 16:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385BDC4339B;
        Sat,  4 Feb 2023 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675527797;
        bh=IFQHzkK3hjBlnB9Ffcx/Fid6aLV7Fr94Uu3CRb/nrGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KkIOVEf2YTsVghmsoLmtzCFHl6SPYnRMn9ZOl3xNWSufTZ0KJQXj2BltMfsf/2lvE
         qIQgK+5fuzRgjr0nZPWhIq5FCZmY7pAQB4ztrzg9aBf3iAoPhk/swm2C6+FokiOO0O
         Q51id47fJrepXwG/DD+wzcdNiojdU51uX00Z0WGc=
Date:   Sat, 4 Feb 2023 17:23:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <Y96GcqPb0ctSq68G@kroah.com>
References: <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net>
 <Y91YWzopMMGF1Lgh@sol.localdomain>
 <Y91bjnIuQRvVqpO7@sol.localdomain>
 <705ab151-da1e-30e1-c232-c9860717267d@roeck-us.net>
 <Y91lXYN7zF8d/fek@sol.localdomain>
 <Y94QTVUg2H68XnQ2@kroah.com>
 <Y95iSDo7Qa+HoWSg@sashalap>
 <Y95k0h8XetGmcSP1@kroah.com>
 <Y96DBADEhFbBN0+I@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y96DBADEhFbBN0+I@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 04, 2023 at 11:08:36AM -0500, Sasha Levin wrote:
> On Sat, Feb 04, 2023 at 02:59:46PM +0100, Greg Kroah-Hartman wrote:
> > On Sat, Feb 04, 2023 at 08:48:56AM -0500, Sasha Levin wrote:
> > > On Sat, Feb 04, 2023 at 08:59:09AM +0100, Greg Kroah-Hartman wrote:
> > > > On Fri, Feb 03, 2023 at 11:49:49AM -0800, Eric Biggers wrote:
> > > > > On Fri, Feb 03, 2023 at 11:28:46AM -0800, Guenter Roeck wrote:
> > > > > > On 2/3/23 11:07, Eric Biggers wrote:
> > > > > > > On Fri, Feb 03, 2023 at 10:54:21AM -0800, Eric Biggers wrote:
> > > > > > > > On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
> > > > > > > > > On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > > > On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> > > > > > > > > > > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > > > > > This is the start of the stable review cycle for the 5.4.231 release.
> > > > > > > > > > > > There are 134 patches in this series, all will be posted as a response
> > > > > > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > > > > > let me know.
> > > > > > > > > > > >
> > > > > > > > > > > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > > > > > > > > > > Anything received after that time might be too late.
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Building ia64:defconfig ... failed
> > > > > > > > > > > --------------
> > > > > > > > > > > Error log:
> > > > > > > > > > > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > > > > > > > > > > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> > > > > > > > > > > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> > > > > > > > > > >
> > > > > > > > > > > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
> > > > > > > > > >
> > > > > > > > > > Yup, it does!
> > > > > > > > > >
> > > > > > > > > > Eric, any help with this?
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Adding "#include <linux/sched/task.h>" to the affected file would probably
> > > > > > > > > be the easy fix. I did a quick check, and it works.
> > > > > > > > >
> > > > > > > > > Note that the same problem is seen in v4.14.y and v4.19.y. Later
> > > > > > > > > kernels don't have the problem.
> > > > > > > > >
> > > > > > > >
> > > > > > > > This problem arises because <linux/mm.h> transitively includes
> > > > > > > > <linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.
> > > > > > > >
> > > > > > > > Greg, any preference for how to handle this situation?
> > > > > > > >
> > > > > > > > Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
> > > > > > > > are no more affected .c files in the other arch directories) and call it a day?
> > > > > > > >
> > > > > > > > Or should we backport the transitive inclusion (i.e., the #include added by
> > > > > > > > commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
> > > > > > > > <linux/kernel.h> so that it's next to do_exit()?
> > > > > > >
> > > > > > > One question: do *all* the arches actually get built as part of the testing for
> > > > > > > each stable release?  If so, we can just add the #include to the .c files that
> > > > > > > need it.  If not, then it would be safer to take one of the other approaches.
> > > > > > >
> > > > > >
> > > > > > Yes, I do build all architectures for each stable release.
> > > > > >
> > > > > > FWIW, I only noticed that one build failure due to this problem.
> > > > >
> > > > > Okay, great.  In that case, Greg or Sasha, can you fold the needed #include into
> > > > > arch/ia64/kernel/mca_drv.c in exit-add-and-use-make_task_dead.patch on 4.14,
> > > > > 4.19, and 5.4?  Or should I just send the whole series again for each?
> > > >
> > > > I'll fold it in later today when I get a chance, no need to resubmit the
> > > > whole thing, thanks!
> > > 
> > > Greg, I did it for the 5.4 backport. If I do it for 4.19 and 4.14 it's
> > > going to add a bunch of fuzz into those, lmk if you want me to push
> > > those too or whether you'll fix it up.
> > 
> > I just fixed up those 2 trees, and I don't understand what you mean by
> > "a bunch of fuzz".  Can you look at my changes to verify I got it right?
> 
> Your changes look right.
> 
> We're likely using different tools to format a patch - you can see
> differences in things like indentation of the diffstat, which headers
> are kept in the patch, and so on...

Yeah, I'm using quilt, you're using git, different whitespace in places.

thanks for verifying the change was correct.

greg k-h
