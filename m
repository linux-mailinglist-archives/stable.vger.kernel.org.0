Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACFA68AA72
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 15:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjBDN77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 08:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjBDN7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 08:59:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA56A75;
        Sat,  4 Feb 2023 05:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B2260C58;
        Sat,  4 Feb 2023 13:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C78C433D2;
        Sat,  4 Feb 2023 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675519189;
        bh=Fhavk2AQ6Or0LmISVKTZDzP/lj4mydikIpRbCIbVl3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K43VplUf1hWGz9SKH7Vwgzg7I7Q3Shv4eEMkVhuhiMTfOrSZ0YK3bSEZF6RmUo++k
         zGQ+uGECtprCx/AhLZIv7vxd/9c78p6+CIXWbNAktoH3a5/A0u/axvSpg0PppFY2m9
         989HhDoREMm5mpUUSU8KkS8nhVlnnhBnxRZu2wDQ=
Date:   Sat, 4 Feb 2023 14:59:46 +0100
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
Message-ID: <Y95k0h8XetGmcSP1@kroah.com>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
 <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net>
 <Y91YWzopMMGF1Lgh@sol.localdomain>
 <Y91bjnIuQRvVqpO7@sol.localdomain>
 <705ab151-da1e-30e1-c232-c9860717267d@roeck-us.net>
 <Y91lXYN7zF8d/fek@sol.localdomain>
 <Y94QTVUg2H68XnQ2@kroah.com>
 <Y95iSDo7Qa+HoWSg@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y95iSDo7Qa+HoWSg@sashalap>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 04, 2023 at 08:48:56AM -0500, Sasha Levin wrote:
> On Sat, Feb 04, 2023 at 08:59:09AM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Feb 03, 2023 at 11:49:49AM -0800, Eric Biggers wrote:
> > > On Fri, Feb 03, 2023 at 11:28:46AM -0800, Guenter Roeck wrote:
> > > > On 2/3/23 11:07, Eric Biggers wrote:
> > > > > On Fri, Feb 03, 2023 at 10:54:21AM -0800, Eric Biggers wrote:
> > > > > > On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
> > > > > > > On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> > > > > > > > > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > > > This is the start of the stable review cycle for the 5.4.231 release.
> > > > > > > > > > There are 134 patches in this series, all will be posted as a response
> > > > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > > > let me know.
> > > > > > > > > >
> > > > > > > > > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > > > > > > > > Anything received after that time might be too late.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Building ia64:defconfig ... failed
> > > > > > > > > --------------
> > > > > > > > > Error log:
> > > > > > > > > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > > > > > > > > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> > > > > > > > > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> > > > > > > > >
> > > > > > > > > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
> > > > > > > >
> > > > > > > > Yup, it does!
> > > > > > > >
> > > > > > > > Eric, any help with this?
> > > > > > > >
> > > > > > >
> > > > > > > Adding "#include <linux/sched/task.h>" to the affected file would probably
> > > > > > > be the easy fix. I did a quick check, and it works.
> > > > > > >
> > > > > > > Note that the same problem is seen in v4.14.y and v4.19.y. Later
> > > > > > > kernels don't have the problem.
> > > > > > >
> > > > > >
> > > > > > This problem arises because <linux/mm.h> transitively includes
> > > > > > <linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.
> > > > > >
> > > > > > Greg, any preference for how to handle this situation?
> > > > > >
> > > > > > Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
> > > > > > are no more affected .c files in the other arch directories) and call it a day?
> > > > > >
> > > > > > Or should we backport the transitive inclusion (i.e., the #include added by
> > > > > > commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
> > > > > > <linux/kernel.h> so that it's next to do_exit()?
> > > > >
> > > > > One question: do *all* the arches actually get built as part of the testing for
> > > > > each stable release?  If so, we can just add the #include to the .c files that
> > > > > need it.  If not, then it would be safer to take one of the other approaches.
> > > > >
> > > >
> > > > Yes, I do build all architectures for each stable release.
> > > >
> > > > FWIW, I only noticed that one build failure due to this problem.
> > > 
> > > Okay, great.  In that case, Greg or Sasha, can you fold the needed #include into
> > > arch/ia64/kernel/mca_drv.c in exit-add-and-use-make_task_dead.patch on 4.14,
> > > 4.19, and 5.4?  Or should I just send the whole series again for each?
> > 
> > I'll fold it in later today when I get a chance, no need to resubmit the
> > whole thing, thanks!
> 
> Greg, I did it for the 5.4 backport. If I do it for 4.19 and 4.14 it's
> going to add a bunch of fuzz into those, lmk if you want me to push
> those too or whether you'll fix it up.

I just fixed up those 2 trees, and I don't understand what you mean by
"a bunch of fuzz".  Can you look at my changes to verify I got it right?

thanks,

greg k-h
