Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6126B60CD
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 22:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjCKVCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 16:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCKVCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 16:02:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6C96C192;
        Sat, 11 Mar 2023 13:02:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 085EEB80B35;
        Sat, 11 Mar 2023 21:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2626C433EF;
        Sat, 11 Mar 2023 21:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678568536;
        bh=di7PeN7dVzc3H1ZpzrwXCWo9dYf0lLJhjDGUvasloIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGnwpag42rTIf877VTg+uqGIvTTEc8kri2J7d63ewagqvKwDq6RUoQSrj4jngpf1V
         1az+BKaOuDly/RrgIsbehQOtp++Akp0wt1UnxXnWAsu3CaTNVANmB1pSHjDFlrgGcr
         DbwprYW3uiH2V3N+7K4EaX1hBrvUT817/MMCy2dt2e0HDMbXS5Nkcij/+rpMIHms2P
         vKHwnfXpEmgOD74BQNZPLvV1yizhy7Algdkm27lXgPntpvZaurqwtwM+9uW4GTP+1P
         MRHYkFk8KbSEx3ix+caaaGKmkF7HHB+hNg+a8FLT1fyHG27Xbe0SzxXgQ05CVcr7x4
         X9CSQo87aEoLA==
Date:   Sat, 11 Mar 2023 16:02:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzsV5qkfxu3nxjv@sashalap>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzh7l8qWtkeh/KK@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZAzh7l8qWtkeh/KK@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 12:17:50PM -0800, Eric Biggers wrote:
>On Sat, Mar 11, 2023 at 01:26:57PM -0500, Sasha Levin wrote:
>> I'm getting a bunch of suggestions and complaints that I'm not implementing
>> those suggestions fast enough on my spare time.
>
>BTW, the "I don't have enough time" argument is also a little frustrating
>because you are currently insisting on doing AUTOSEL at all, at the current
>sensitivity that picks up way too many commits.  I can certainly imagine that
>that uses a lot of your time!  But, many contributors are telling you that
>AUTOSEL is actually *worse than nothing* currently.
>
>So to some extent this is a self-inflicted problem.  You are *choosing* to spend
>your precious time running in-place with something that is not working well,
>instead of putting AUTOSEL on pause or turning down the sensitivity to free up
>time while improvements to the process are worked on.
>
>(And yes, I know there are many stable patches besides AUTOSEL, and it's a lot
>of work, and I'm grateful for what you do.  I am *just* talking about AUTOSEL
>here.  And yes, I agree that AUTOSEL is needed in principle, so there's no need
>to re-hash the arguments for why it exists.  It just needs some improvements.)

Just to make sure I'm sending the right message: I'd *love* to improve
it, but I need help. I'm not pushing back on your ideas, I'm asking for
help with their implementation.

Maybe I'm putting words in Greg's mouth, but I think we both would
ideally want to standardize around a single set of tools and scripts,
it's just the case that both of us started with different set of
problems we were trying to solve, and so our tooling evolved
independently.

-- 
Thanks,
Sasha
