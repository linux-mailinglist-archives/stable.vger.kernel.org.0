Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F2F68AB0B
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 17:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjBDQIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 11:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDQIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 11:08:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B01883E0;
        Sat,  4 Feb 2023 08:08:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B045B80AE2;
        Sat,  4 Feb 2023 16:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623C0C433D2;
        Sat,  4 Feb 2023 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675526917;
        bh=RZp/If+1OL8vdGYL7EKkxSgfAujYOM+AMDfm7cxGyxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PCQiRDiiKfAPE3ImtS4aeZK2jrsDshczX7wBhqwf0LOdiFVjMPmZdxbYLOb6ZC4r9
         C1v7tYvmmdajfvtipNCnYq1VcZvGYAP6ZV7DySTKCmuLi/eZetp/AlePbGM0A8Y9iz
         UKgF/R8F4x97iHrJv+Mm3Iqk9lQ6fCyoK8b0KmC7Eq/M1isNSPINzYVTfevZz4I5b+
         bH+DtJ4S9oiX1FOTjie/jpLvvhx0yYYxqEic4m6lIcWQNiad4KIhrrZqMcIYAx3w3q
         AT53eYFIvw6BLA1SKGzJSBt3o7IzrL9c1h11zMWn9K134hg98Rfy2vIXc6RmKq58VT
         O80aildBGAWlw==
Date:   Sat, 4 Feb 2023 11:08:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <Y96DBADEhFbBN0+I@sashalap>
References: <20230203155619.GA3176223@roeck-us.net>
 <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net>
 <Y91YWzopMMGF1Lgh@sol.localdomain>
 <Y91bjnIuQRvVqpO7@sol.localdomain>
 <705ab151-da1e-30e1-c232-c9860717267d@roeck-us.net>
 <Y91lXYN7zF8d/fek@sol.localdomain>
 <Y94QTVUg2H68XnQ2@kroah.com>
 <Y95iSDo7Qa+HoWSg@sashalap>
 <Y95k0h8XetGmcSP1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y95k0h8XetGmcSP1@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 04, 2023 at 02:59:46PM +0100, Greg Kroah-Hartman wrote:
>On Sat, Feb 04, 2023 at 08:48:56AM -0500, Sasha Levin wrote:
>> On Sat, Feb 04, 2023 at 08:59:09AM +0100, Greg Kroah-Hartman wrote:
>> > On Fri, Feb 03, 2023 at 11:49:49AM -0800, Eric Biggers wrote:
>> > > On Fri, Feb 03, 2023 at 11:28:46AM -0800, Guenter Roeck wrote:
>> > > > On 2/3/23 11:07, Eric Biggers wrote:
>> > > > > On Fri, Feb 03, 2023 at 10:54:21AM -0800, Eric Biggers wrote:
>> > > > > > On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
>> > > > > > > On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
>> > > > > > > > On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
>> > > > > > > > > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
>> > > > > > > > > > This is the start of the stable review cycle for the 5.4.231 release.
>> > > > > > > > > > There are 134 patches in this series, all will be posted as a response
>> > > > > > > > > > to this one.  If anyone has any issues with these being applied, please
>> > > > > > > > > > let me know.
>> > > > > > > > > >
>> > > > > > > > > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>> > > > > > > > > > Anything received after that time might be too late.
>> > > > > > > > > >
>> > > > > > > > >
>> > > > > > > > > Building ia64:defconfig ... failed
>> > > > > > > > > --------------
>> > > > > > > > > Error log:
>> > > > > > > > > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
>> > > > > > > > > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
>> > > > > > > > > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
>> > > > > > > > >
>> > > > > > > > > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
>> > > > > > > >
>> > > > > > > > Yup, it does!
>> > > > > > > >
>> > > > > > > > Eric, any help with this?
>> > > > > > > >
>> > > > > > >
>> > > > > > > Adding "#include <linux/sched/task.h>" to the affected file would probably
>> > > > > > > be the easy fix. I did a quick check, and it works.
>> > > > > > >
>> > > > > > > Note that the same problem is seen in v4.14.y and v4.19.y. Later
>> > > > > > > kernels don't have the problem.
>> > > > > > >
>> > > > > >
>> > > > > > This problem arises because <linux/mm.h> transitively includes
>> > > > > > <linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.
>> > > > > >
>> > > > > > Greg, any preference for how to handle this situation?
>> > > > > >
>> > > > > > Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
>> > > > > > are no more affected .c files in the other arch directories) and call it a day?
>> > > > > >
>> > > > > > Or should we backport the transitive inclusion (i.e., the #include added by
>> > > > > > commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
>> > > > > > <linux/kernel.h> so that it's next to do_exit()?
>> > > > >
>> > > > > One question: do *all* the arches actually get built as part of the testing for
>> > > > > each stable release?  If so, we can just add the #include to the .c files that
>> > > > > need it.  If not, then it would be safer to take one of the other approaches.
>> > > > >
>> > > >
>> > > > Yes, I do build all architectures for each stable release.
>> > > >
>> > > > FWIW, I only noticed that one build failure due to this problem.
>> > >
>> > > Okay, great.  In that case, Greg or Sasha, can you fold the needed #include into
>> > > arch/ia64/kernel/mca_drv.c in exit-add-and-use-make_task_dead.patch on 4.14,
>> > > 4.19, and 5.4?  Or should I just send the whole series again for each?
>> >
>> > I'll fold it in later today when I get a chance, no need to resubmit the
>> > whole thing, thanks!
>>
>> Greg, I did it for the 5.4 backport. If I do it for 4.19 and 4.14 it's
>> going to add a bunch of fuzz into those, lmk if you want me to push
>> those too or whether you'll fix it up.
>
>I just fixed up those 2 trees, and I don't understand what you mean by
>"a bunch of fuzz".  Can you look at my changes to verify I got it right?

Your changes look right.

We're likely using different tools to format a patch - you can see
differences in things like indentation of the diffstat, which headers
are kept in the patch, and so on...

If I were to regenerate patches you have previously queued up, we'd see
a somewhat big diff because of that.

-- 
Thanks,
Sasha
