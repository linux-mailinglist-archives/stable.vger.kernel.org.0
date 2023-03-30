Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307786CF7EC
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 02:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjC3AIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 20:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjC3AIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 20:08:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D21A40DD;
        Wed, 29 Mar 2023 17:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF8FB8235B;
        Thu, 30 Mar 2023 00:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DDBC433EF;
        Thu, 30 Mar 2023 00:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680134882;
        bh=oMup++znG1q/IAg4uDioPx9rd7Wt/Is8RxF3vtr80xE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4Uy1Cs3vzyebEQBR/PRfFLwpdtaagHBsqsBeZg6iP9hexHBLPHXas5RlhQmbzj//
         i+YmeCHkU5WyVk6+V/Bvh0hxA+C20Irv5WaLLwv2V0DrkRtW4hHT5mJkZlviv4Zvrg
         v+Rc8MWHAxxIqMlHtIifhBR6y0Z7nzzh55yZGvZ24uMOP3agBL/M/LKkBK6jp21YEa
         I+Y/AJ0/nvrnNy8KXRlsKGodbvpKoOwf2esh9oz2o+Vdy+V3CACxbkpMAeD66u2stQ
         A4pwp+ZPBhA2K22UaYiyZOqJe3AhvvEv4JpEwfTXEtI+8uiTrTFrlHrZKyCQtvsGRJ
         E0HRCu1S8FP2A==
Date:   Thu, 30 Mar 2023 00:08:01 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZCTS4Yc44DN+cqcX@gmail.com>
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
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Feb 27, 2023 at 07:52:39PM -0500, Sasha Levin wrote:
> > Sasha, 7 days is too short.  People have to be allowed to take holiday.
> 
> That's true, and I don't have strong objections to making it longer. How
> often did it happen though? We don't end up getting too many replies
> past the 7 day window.
> 
> I'll bump it to 14 days for a few months and see if it changes anything.

I see that for recent AUTOSEL patches you're still using 7 days.  In fact, it
seems you may have even decreased it further to 5 days:

    Sent Mar 14: https://lore.kernel.org/stable/20230314124435.471553-2-sashal@kernel.org
    Commited Mar 19: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=69aaf98f41593b95c012d91b3e5adeb8360b4b8d

Any update on your plan to increase it to 14 days?

I hope you can understand why I have to ask you --- you are the only person who
can change your own policy.

Thanks,

- Eric
