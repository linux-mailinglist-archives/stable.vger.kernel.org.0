Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B522E595B75
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiHPMMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbiHPMLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:11:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D670543E2;
        Tue, 16 Aug 2022 05:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37CA56123A;
        Tue, 16 Aug 2022 12:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319EFC433D6;
        Tue, 16 Aug 2022 12:04:45 +0000 (UTC)
Date:   Tue, 16 Aug 2022 08:04:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
Message-ID: <20220816080452.400d1adc@gandalf.local.home>
In-Reply-To: <YvsocKly+n9S4CsB@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
        <YvruPKI4dCyrXCp5@home.goodmis.org>
        <YvsocKly+n9S4CsB@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,BIGNUM_EMAILS_MANY,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022 07:17:36 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > I sent 3 patches to the linux-trace-devel list almost 4 hours ago, and they
> > still haven't shown up. I was going to point people to it tonight but it's now
> > going to have to wait till tomorrow.  
> 
> Email is async, sometimes it takes longer than others to recieve
> messages.

The delays always happen when you do these patch bombs. In fact, that's
how I knew you sent them just now. My patches finally arrived, just under 8
hours since I sent them!

> 
> My "patch bombs" get sent out slow to the mail servers, there is work to
> fix up vger and move it over to the LF-managed infrastructure, perhaps
> work with the vger admins to help that effort out?

I'm not sure what I can do to help out. I'm not a very good email admin.
(I'm struggling to fix my wife's email now).

> 
> > I really do not think LKML needs to see all 1157 patches that are being
> > backported. There's other places to send them that will not be as disruptive.  
> 
> And where would that be?

You already Cc stable@vger.kernel.org. Does lore track that?

My point is, LKML has what, 10,000 subscribers? Maybe only 5000? Even at
5000, probably at most 50 subscribers look at the stable patches (and I'm
being optimistic). That means, these 3000 emails go to 4950 people that
will never look at them. That's 14,850,000 emails that are wasting disk
space, CPU cycles and electricity. Think of the environment :-)

> 
> Getting the patches out for review is good, and necessary.  Patches
> should never be considered "noise" as it is what we are doing here.  If
> we have infrastructure issues handling these messages, we should work to
> resolve them as really, 3000 emails should not be a lot to manage,
> unless you are being throttled by your email provider?

I'm not saying that they should not be sent out. I'm asking, do they need
to be sent out to the list with the most subscribers? You already
(rightfully) Cc the maintainers of the patches. Since they already go to
the stable list, and if lore archives them, then you could just send a link
to LKML to the lore patch set. Then people could still review them.

Do those that review these patches really just read LKML to do so?

Or is this the spam approach of sending out to 1000x more than you need to,
just so that you get a few more eyes?

And the issue I have with this, is that it affects *all* mailing list on
vger not just LKML. I don't read LKML anymore, but I do read the smaller
lists. And blocking emails for 8 hours to these lists does have an effect on
productivity.

-- Steve
