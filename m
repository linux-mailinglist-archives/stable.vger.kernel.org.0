Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2696950CA39
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 14:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiDWMzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 08:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiDWMzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 08:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0E261
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 05:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B449AB80C85
        for <stable@vger.kernel.org>; Sat, 23 Apr 2022 12:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2508EC385A0;
        Sat, 23 Apr 2022 12:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650718370;
        bh=zFo7gTyP5sFQ6CDgnuqvV0AkEbjIPBb54vONJvnSyjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZvdOg0FoToi0V8IqJT8Y7n7lp1xVEhirzutmFZm9WkgMm+YbYgiAuiyhtwNn/ywVM
         Uq5QEpoAlDqbRpBBy2AoGuSJR50XEVVoop952/LA8zMtFzx5+9K84Vshnm6bpeLjl8
         03JQbUYb2ZZvvbrYCkQcXxIRO1Qg3L7a7tr9nIIs=
Date:   Sat, 23 Apr 2022 14:52:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     kuni1840@gmail.com, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: Request to cherry-pick c89dffc70b34 to 4.14, 4.19, and 5.4.
Message-ID: <YmP2nTtDY9tepP5P@kroah.com>
References: <YmPcYGUsZef6OQX0@kroah.com>
 <20220423122354.56795-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423122354.56795-1-kuniyu@amazon.co.jp>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 23, 2022 at 09:23:54PM +0900, Kuniyuki Iwashima wrote:
> From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Sat, 23 Apr 2022 13:00:48 +0200
> > On Sat, Apr 23, 2022 at 10:58:19AM +0200, Greg Kroah-Hartman wrote:
> > > On Sat, Apr 23, 2022 at 10:07:06AM +0900, Kuniyuki Iwashima wrote:
> > > > Hi maintainers,
> > > > 
> > > > Upstream commit 01770a166165 ("tcp: fix race condition when creating child
> > > > sockets from syncookies") is planned to be backported to 4.14, 4.19 and
> > > > 5.4:
> > > > 
> > > >   https://marc.info/?l=linux-stable-commits&m=165063781908608&w=3
> > > >   https://marc.info/?l=linux-stable-commits&m=165063781708604&w=3
> > > >   https://marc.info/?l=linux-stable-commits&m=165063781708603&w=3
> > > > 
> > > > Another commit c89dffc70b34 ("tcp: Fix potential use-after-free due to
> > > > double kfree()") has a Fixes tag for it, so please backport this also.
> > > 
> > > Ick, that commit does not apply cleanly.  The people who wanted
> > > 01770a166165 should also provide a working version of this fix as well.
> > 
> > Oh nevermind, I didn't have my queue up to date.  It worked just fine,
> > sorry for the noise.
> 
> Thanks for queuing up!
> 
> Next time I'll send a mail with a backportable-patch, not just commit id :)

commit id is fine for when I don't do stupid things :)

This is easier than having a backported patch as that way I don't have
to confirm semi-manually that it matches what is in Linus's tree.  So
all is good, keep doing it this way for stuff that applies cleanly.

thanks again,

greg k-h
