Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D696B634A
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 06:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCLFWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 00:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCLFWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 00:22:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7A63B3F9;
        Sat, 11 Mar 2023 21:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF70B80A26;
        Sun, 12 Mar 2023 05:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D4FC433D2;
        Sun, 12 Mar 2023 05:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678598520;
        bh=bWzonHMaKKd6TZ8k25Z+jxTxX+g/vuQjBJ8jzeUK+NA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LBAaWVlb5rdiMemGPlLN+frtOWZ15ZB2+uN4IOkysg827MnY4jToOrmi4zV4damIp
         C3vPIbBYqagEUviTyZCkY356ArXst/MfraDuK6Mf30v4a4URJUeEve+ygdKgrpydTV
         kmNQk0vLvy7yr8dEigE38SpmDMgOs5v/trEFOs/8V7e3dRKu0kxXYeRMk//sbJ+GTm
         tRT9eRl0hcNcy880kSL4WNtnp6LFTSRT95Zt1E+3Y56AMzUGOJGY67pfo3qQ/BcdbQ
         T55bYZCL+YyEqojKFGly4Dm8sZT7jgs+OvuqP43/v8Dw8XC5e8+Hmz15cSBFmHdbL6
         RlOFxoun3/yRA==
Date:   Sat, 11 Mar 2023 21:21:58 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA1hdkrOKLG697RG@sol.localdomain>
References: <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
 <ZAzqSeus4iqCOf1O@sol.localdomain>
 <ZA1V4MbG6U3wP6q6@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA1V4MbG6U3wP6q6@1wt.eu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 05:32:32AM +0100, Willy Tarreau wrote:
> On Sat, Mar 11, 2023 at 12:53:29PM -0800, Eric Biggers wrote:
> > I'll try to put something together, despite all the pushback I'm getting.
> 
> Thanks.
> 
> > But
> > by necessity it will be totally separate from the current stable scripts, as it
> > seems there is no practical way for me to do it otherwise,
> 
> It's better that way anyway. Adding diversity to the process is important
> if we want to experiment with multiple approaches. What matters is to
> have multiple inputs on list of patches.
> 
> > given that the
> > current stable process is not properly open and lacks proper leadership.
> 
> Please, really please, stop looping on this. I think it was already
> explained quite a few times that the process is mostly human, and that
> it's very difficult to document what has to be done. It's a lot of work
> based on common sense, intuition and experience which helps solving each
> an every individual case. The scripts that help are public, the rest is
> just experience. It's not fair to say that some people do not follow an
> open process while they're using their experience and intuition. They're
> not machines.
> 

I mean, "patches welcome" is a bit pointless when there is nothing to patch, is
it not?  Even Sasha's stable-tools, which he finally gave a link to, does not
include anything related to AUTOSEL.  It seems AUTOSEL is still closed source.

BTW, I already did something similar "off to the side" a few years ago when I
wrote a script to keep track of and prioritize syzbot reports from
https://syzkaller.appspot.com/, and generate per-subsystem reminder emails.

I eventually ended up abandoning that, because doing something off to the side
is not very effective and is hard to keep up with.  The right approach is to
make improvements to the "upstream" process (which was syzbot in that case), not
to bolt something on to the side to try to fix it after the fact.

So I hope people can understand where I'm coming from, with hoping that what the
stable maintainers are doing can just be improved directly, without first
building something from scratch off to the side as that is just not a good way
to do things.  But sure, if that's the only option to get anything nontrivial
changed, I'll try to do it.

- Eric
