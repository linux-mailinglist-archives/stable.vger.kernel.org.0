Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40506C6868
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 13:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjCWMdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 08:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCWMda (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 08:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEBE166D5;
        Thu, 23 Mar 2023 05:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08500B820D6;
        Thu, 23 Mar 2023 12:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CFCC433D2;
        Thu, 23 Mar 2023 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679574803;
        bh=RJwJp5xZFYfJKUAvwGN5h+/3qwUdgbzR7CNNlpc1JdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HMTNzu3NRWbEap2Tu2DYFWaMQWxGqPZ9ZciMA7Uw108C0K6jyXhNVM35Qk8lLMdT8
         DUZLsUj3Ds2olQg1NT+9TFjJtuoQ0Pz9o4jiDR0xtwLqT3ppjumNZsXG1E79aLO+vI
         KQ07F79KS7ow68q57g1VTFvUlvvm3qyPZmnTvDIYCqVYzv0r4CVbFleAqZzLw/i+TP
         +lIAQTXxswEdzMyDO7tFhdePnYSsboj4QfVxS4i9WGNpEmofw1Ruw99Blj2wQtm2cV
         F12+wzPyjn3A4xlVZ02o7YuDqitpyfD8KTYkQV+GrfCyaHGRVcTS4ttWqBCt5SAhj1
         RzWUuQDfGOTNw==
Date:   Thu, 23 Mar 2023 08:33:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ryan Roberts <ryan.roberts@arm.com>,
        Yury Norov <yury.norov@gmail.com>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH AUTOSEL 4.19 5/9] sched_getaffinity: don't assume
 'cpumask_size()' is fully initialized
Message-ID: <ZBxHEhPRze3eUCfk@sashalap>
References: <20230322200309.1997651-1-sashal@kernel.org>
 <20230322200309.1997651-5-sashal@kernel.org>
 <CAHk-=whZ8r85GhA=n8=NJCXOnpJ5KNqitV2FK2YnK73+Z7tzUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=whZ8r85GhA=n8=NJCXOnpJ5KNqitV2FK2YnK73+Z7tzUg@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 02:08:54PM -0700, Linus Torvalds wrote:
>On Wed, Mar 22, 2023 at 1:09 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> The getaffinity() system call uses 'cpumask_size()' to decide how big
>> the CPU mask is - so far so good.  It is indeed the allocation size of a
>> cpumask. [...]
>
>Same comment as about commit 8ca09d5fa354 - this is a fine cleanup /
>fix and might be worth backporting just for that, but it didn't really
>turn into an actual visible bug until commit 596ff4a09b89.

Ack, I'll keep it in anyway. Thanks!

-- 
Thanks,
Sasha
