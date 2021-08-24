Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9774B3F6840
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242828AbhHXRlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242746AbhHXRjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5222360E8B;
        Tue, 24 Aug 2021 17:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629826545;
        bh=3AV+X2lMR3IiIbVsKlwkWxcEDzR8crfLQXzjI47QOE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EkVovaQdtDvhzsTl5yVx1KvwjN23QXC11r1TwwdiQP74uC+J3m8a5981DqhqjAj+v
         BDdeB4kDmoRorCKC1/UpxyE8L51L1m7KtO8YPC2pzzCEEIpACr8Pf8/csJVKcwjP6E
         s2jtFNR8mPrqkd6k2/IqJ1hnaXrtJ9mC4Zu7CBFSDVxDOFy0nGFiqrFJYJYyGBrmZj
         vhKkND0qEMJuvN0SHWAW2bkvcHHJb+Mr+6TuxFhX5XmTtvP05pTRHaaYTV/KIqZB1B
         pw8p1moEhMaxbZMpKWxgYmfqKwBegOOYU4CqDweh34szZKZdqitxwsQaJfi03QGdL1
         ri0y5RK7vt/Ww==
Date:   Tue, 24 Aug 2021 13:35:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Sandeep Patil <sspatil@android.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH 5.13 073/127] pipe: avoid unnecessary EPOLLET wakeups
 under normal loads
Message-ID: <YSUt8NdA+5EPJIyD@sashalap>
References: <20210824165607.709387-1-sashal@kernel.org>
 <20210824165607.709387-74-sashal@kernel.org>
 <CAHk-=wiQhb689WEk__vLy-ET4rL69cjq39pGTmrKam=c_0LYGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wiQhb689WEk__vLy-ET4rL69cjq39pGTmrKam=c_0LYGg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 10:00:33AM -0700, Linus Torvalds wrote:
>On Tue, Aug 24, 2021 at 9:57 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> [ Upstream commit 3b844826b6c6affa80755254da322b017358a2f4 ]
>
>This one has an odd performance regression report associated with it.
>
>Honestly, I don't understand the performance regression, but that's
>likely on me, not on the kernel test robot.
>
>So I'd hold off on applying it for now. It *might* be some odd test
>robot hiccup, but ..

I'll drop it for now.

Ideally we wouldn't take it at all, but I don't think any of us wants to
field "my tests have regressed!" questions for the next 5 years or so.

Thanks!

-- 
Thanks,
Sasha
