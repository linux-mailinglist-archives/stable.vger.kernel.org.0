Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A7634BB7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 01:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiKWAhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 19:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiKWAhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 19:37:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050AE2A2;
        Tue, 22 Nov 2022 16:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8364360F04;
        Wed, 23 Nov 2022 00:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59EBC433C1;
        Wed, 23 Nov 2022 00:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669163845;
        bh=h8VLtxpdKZfZ+vNL+gi0UzSZjgOR3emL+GnWw7h0MNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tqydbc2v5LWr3g5elM2/wja0lH7lpMnvyhhtrGLHRLgfq7ZxwDIRpI5lqwUHezLXL
         vsef7v/PzitcEW8/rmYpTTwpEH04I4bhFq+AyIqtgZ+L8QCSng5Z/BKz2CFmSsRUn8
         SzaY6KkC28THl5mB7rcEodjM7pDOtZVjBzuydBqCdWVebe7L81Hrpitm7Gvy+e0TQ6
         z58ooYKlRu1N4PbEt5yatX9yl6jOoIOVjcMTpppvYmv+rAr+d/fA7U3e9KAP8Z/94Q
         zgEFodxvyL3GI8yGez24rCgDFLAlWK1sPbBTyPp3AheI+ej6Vfkg5DsuWj+IwtBDwW
         QebfbsAMEmQMA==
Date:   Tue, 22 Nov 2022 19:37:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Patch "l2tp: Serialize access to sk_user_data with
 sk_callback_lock" has been added to the 6.0-stable tree
Message-ID: <Y31rP+RyIaye5UrC@sashalap>
References: <20221122151904.89804-1-sashal@kernel.org>
 <87wn7mlxxe.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87wn7mlxxe.fsf@cloudflare.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 22, 2022 at 06:06:12PM +0100, Jakub Sitnicki wrote:
>Hi Sasha,
>
>On Tue, Nov 22, 2022 at 10:19 AM -05, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     l2tp: Serialize access to sk_user_data with sk_callback_lock
>>
>> to the 6.0-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      l2tp-serialize-access-to-sk_user_data-with-sk_callba.patch
>> and it can be found in the queue-6.0 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>"Just when I thought I was out, they pull me back in!"
>
>Greg assured me yesterday that this was dropped from stable queues:
>
>https://lore.kernel.org/stable/Y3thooxAN2Are7Ai@kroah.com/

Ah yes, sorry about that, I'll throw it out.

-- 
Thanks,
Sasha
