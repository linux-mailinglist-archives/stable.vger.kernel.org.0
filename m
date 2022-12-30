Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA74659693
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 10:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiL3JNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 04:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiL3JNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 04:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07618692
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 01:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1432261A6A
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246DFC433EF;
        Fri, 30 Dec 2022 09:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672391610;
        bh=9Ekj92sUMRHtTg8IYszSI09n7I4PuwXjweegdaPvvr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DtqeJhVTypzKq7grO37qbbggLoq8NNvc3rSWOIFerlyUGxHTsAVwFx5Qn4RNdikRY
         tZQMtNZVMze6YgBeEkSaxIkVYEeAgIqVYyWciP43OA8mhKLwlXXeP7Lx5szBDY3H4k
         G0E8KE1ga0kiar9Jm4Ogg6vji6M+ZiMFbQKwvrkc=
Date:   Fri, 30 Dec 2022 10:13:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y66rt1YahFBSyFKF@kroah.com>
References: <20221228144330.180012208@linuxfoundation.org>
 <2bf086f8-aa9d-b576-ba8b-1fcfbc9a4ff1@applied-asynchrony.com>
 <Y6xkpmqxRQwDyLAb@kroah.com>
 <d5534922-0b33-268d-cfad-c175ff4f676e@suse.cz>
 <e8d819e0-10c4-89c0-6b13-d1ceb01da0fc@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8d819e0-10c4-89c0-6b13-d1ceb01da0fc@leemhuis.info>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 29, 2022 at 02:04:53PM +0100, Thorsten Leemhuis wrote:
> On 28.12.22 19:57, Vlastimil Babka wrote:
> > On 12/28/22 16:45, Greg Kroah-Hartman wrote:
> >> On Wed, Dec 28, 2022 at 04:02:57PM +0100, Holger Hoffstätte wrote:
> >>> On 2022-12-28 15:25, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 6.1.2 release.
> >>>> There are 1146 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>
> >>> I know this is already a large set of updates, but it would be great if
> >>> commit 6f12be792fde994ed934168f93c2a0d2a0cf0bc5 ("mm, mremap: fix mremap()
> >>> expanding vma with addr inside vma") could be added as well; it applies and
> >>> works fine on top of 6.1.1.
> >>> This fixes quite a few annoying mmap-related out-of-memory failures.
> >>
> >> It's set up for future releases.  If this was such a big issue for
> >> 6.1-final, why wasn't it sent to Linus before 6.2-rc1?
> > 
> > Thorsten did question its upstreaming speed elsewhere. But it actually
> > is in 6.2-rc1. Andrew sent the PR on 22th and Linus merged on 23th [1].
> > I didn't try to accelerate it to stable as IIRC people already pointed
> > it out and you acknowledged it's on your radar, and it was a tracked
> > regression. Sucks that it didn't make it to 6.1.2.
> 
> Yup. I've been thinking somewhat what I could or should do to ensure
> things work more smoothly when similar situations arise in the future;
> ideally without me stepping on maintainer's toes too much. ;)
> 
> Currently I consider doing the following two things:
> 
> (1) if I notice something that looks like an important regression fix,
> reply with a "how fast do you think this fix should process through the
> ranks" inquiry to the developer. With such information I'd feel way more
> comfortable sending a "Linus, could you maybe pick this up directly"
> after some time in case the maintainer leaves the patch longer in -next.
> 
> (2) once Linus merged the fix, send a quick mail to Greg/the stable team
> asking them to immediately queue it for the next release (in case
> problems show up it can still be de-queued).
> 
> Does that sound sane? Or anyone any better idea?

Sounds sane to me!

thanks,

greg k-h
