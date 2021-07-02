Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19DB3BA01E
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 13:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhGBL72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 07:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhGBL72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 07:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1666961422;
        Fri,  2 Jul 2021 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625227016;
        bh=V76FDQFzhFGz1WAZt1hX4+78RHjyg2wI0NDbhJQWcu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G77ZBx1DB07MMgUYHL6uqYdJjLWTBEXcbC0qfwwcZuNt8PjmxcAMsRaWdmPTLQDt7
         TvNTWDw4FgqeeoPYaTRXkbZJ0JFj11SC8jjddOa/FkkCnZDQaxsaMQiG46cJJuCjCM
         quq9RqIoxLgWXCZ59zCk4xNqN5vJeB7le/4lpQyYV5+UibGoNGXsKz50JakEPhMgoe
         PGdOOIEcXC7K7lDNFTKuhrMGnuMKchsiyzvxFzD/y8/fW6NlUthAikPDy2aqTAWJ2s
         v3JlDGXImTbx7l+8Td1BPzZXOGD1fPJezIIXKN5tnvXYw+f/K3rV+cDqf0pfmXOgts
         laAmy4gi+QCMA==
Date:   Fri, 2 Jul 2021 07:56:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Shi <alexs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-ID: <YN7/B8q2uuHr6TfZ@sashalap>
References: <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
 <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
 <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com>
 <YNm93fkIPrqMwHzd@kroah.com>
 <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com>
 <YNqTCV7DmYGZiZ7N@sashalap>
 <YNq4yJls+PKsULh0@kroah.com>
 <265a4571-7eb6-e2e6-7cf9-6ef825cd3152@google.com>
 <8ca517a0-421f-5aa0-26f7-f4c09f50ca2b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8ca517a0-421f-5aa0-26f7-f4c09f50ca2b@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 01, 2021 at 12:47:48PM -0700, Hugh Dickins wrote:
>On Mon, 28 Jun 2021, Hugh Dickins wrote:
>> On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:
>> > On Mon, Jun 28, 2021 at 11:27:05PM -0400, Sasha Levin wrote:
>> > > On Mon, Jun 28, 2021 at 10:12:57AM -0700, Hugh Dickins wrote:
>> > > > On Mon, 28 Jun 2021, Greg Kroah-Hartman wrote:
>> > > > > So could you just send a mbox of patches (or tarball), for the 4.19,
>> > > > > 4.14, and 4.9 trees?  That would make it much easier to ensure I got
>> > > > > them all correct.
>> > > >
>> > > > At risk of irritating you, sorry, I am resisting: the more data I send
>> > > > you, the more likely I am to mess it up in some stupid way.  Please ask
>> > > > again and I shall, but I think your success with 5.12, 5.10, 5.4 just
>> > > > means that you were right to take a break before 4.19, 4.14, 4.4.
>> > >
>> > > I've tried following the instructions for 4.19, and that worked fine on
>> > > my end too.
>> > >
>> > > If no one objects, I can pick up 4.9-4.19 after the current set of
>> > > kernels is released.
>> >
>> > No objection from me, thanks!
>> >
>> > greg k-h
>>
>> Sure, Sasha, whenever suits you: thanks to you both.
>
>I've now checked today's queue/4.19, queue/4.14, queue/4.9:
>exactly as intended, thanks.

Thanks for confirming Hugh!

-- 
Thanks,
Sasha
