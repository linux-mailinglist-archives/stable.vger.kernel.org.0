Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3919A5AC9B8
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 07:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiIEFUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 01:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIEFUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 01:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A11315725;
        Sun,  4 Sep 2022 22:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A8BC61038;
        Mon,  5 Sep 2022 05:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288C6C433C1;
        Mon,  5 Sep 2022 05:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662355213;
        bh=c+oj/U1H7P7LFQ7isbBun23VwDvi6hU70nER07Jn+Po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tGTSzpz1fIqE8G1rRbaAkcplbKDM4o/89OHgRCXt0IR5osMeS2XSGsIeB32Gh+jOV
         Dg34dlWwEztYikwOCo2/Mky+JuRMv9efwCKZ/kb5O/U/Wxc2pBcKQ2a8zaaYXzvNqc
         nTcKbWG1x1sBM/4ghcPjnftZ20EZSwxhOrFIeZI8=
Date:   Mon, 5 Sep 2022 07:20:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Varsha Teratipally <teratipally@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Rafael Aquini <aquini@redhat.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Request to cherry-pick 20401d1058f3f841f35a594ac2fc1293710e55b9
 to v5.10 and v5.4
Message-ID: <YxWHChQpxs9LrCpl@kroah.com>
References: <20220902135912.816188-1-teratipally@google.com>
 <YxIS4jWE03E5pZjS@kroah.com>
 <b94f08a6-a2e2-c719-37ac-7c412fe1b519@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b94f08a6-a2e2-c719-37ac-7c412fe1b519@colorfullife.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 04, 2022 at 07:38:30PM +0200, Manfred Spraul wrote:
> Hi,
> 
> On 9/2/22 16:27, Greg Kroah-Hartman wrote:
> > On Fri, Sep 02, 2022 at 01:59:11PM +0000, Varsha Teratipally wrote:
> > > Hi all,
> > > 
> > > Commit 20401d1058f3f841f35a594ac2fc1293710e55b9("ipc: replace costly
> > > bailout check in sysvipc_find_ipc()" fixes a high cve and optimizes the
> > > costly loop by adding a checkpoint, which I think might be a good
> > > candidate for the stable branches
> > What do you mean by "high cve"?
> > 
> > And that feels like it's an artificial benchmark fixup, what real
> > workload benefits from this change?
> 
> Standard ipcs end up parsing /proc/sysvipc/*, thus there are real users
> where the performance of /proc/sysvsem/* matters.

What real users are that?  What workload needs that becides monitoring
tools?

> 
> But:
> 
> The performance of the function was bad since 2007, i.e. why is is now
> urgent? I do not see a bug that must be fixed.


Me either.

thanks,

greg k-h
