Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5336A50AF
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 02:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjB1B0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 20:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjB1B0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 20:26:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAA623C46;
        Mon, 27 Feb 2023 17:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3FC860EFC;
        Tue, 28 Feb 2023 01:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A22C433EF;
        Tue, 28 Feb 2023 01:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677547559;
        bh=0Pe7KSJN82PEApgbDu8WD+gbSjamTMir1pZN3Uhc2OI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pVA3xdWLvU+MvDpwDpBZoIe+APPP1ID980TpPlmD8FNn/TD4okNnbu/tVtpDBW2Fp
         BP/vFCkzNawaFOa4lOz2rhyy+v9BmxnZUA+XfORtSjulDxRMkDwoBTRq3HyfccqaRZ
         M5tiwI+I3azc8QeibhZU+gBXMpjw7gMeKsZOsD+CfSlOtitA3kTPJVkn6XLUaOJvtM
         Q0Fhs6W8m53D7dvV6D2v4/BufJJl1qesQKcsc+0EgcckKi5b7cFG7PMldMPSBK2D5H
         YC1WS+XSb2SLTzu1HL4eyTRfJuGWqSvF38CCMpAuu1ucAkcWwu79uGYlhAo2+OoUEW
         CLgcAqAEOC7Mw==
Date:   Tue, 28 Feb 2023 01:25:57 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/1YJWs355TimFz1@gmail.com>
References: <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/01z4EJNfioId1d@casper.infradead.org>
 <Y/1QV9mQ31wbqFnp@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/1QV9mQ31wbqFnp@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 07:52:39PM -0500, Sasha Levin wrote:
> > > > Nothing has changed, but that doesn't mean that your process is actually
> > > > working.  7 days might be appropriate for something that looks like a security
> > > > fix, but not for a random commit with no indications it is fixing anything.
> > > 
> > > How do we know if this is working or not though? How do you quantify the
> > > amount of useful commits?
> > 
> > Sasha, 7 days is too short.  People have to be allowed to take holiday.
> 
> That's true, and I don't have strong objections to making it longer. How
> often did it happen though? We don't end up getting too many replies
> past the 7 day window.
> 
> I'll bump it to 14 days for a few months and see if it changes anything.

It's not just for the review time, but also for the longer soak time in
mainline.

Of course, for that to work properly you have to actually take advantage of it,
for example by re-checking for fixes when actually applying the patch, not just
when sending the initial AUTOSEL email.  Which I hope you're doing already, but
who knows.

- Eric
