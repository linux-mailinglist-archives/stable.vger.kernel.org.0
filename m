Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43116C0613
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 15:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfI0NNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 09:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfI0NNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 09:13:34 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71EB5207FF;
        Fri, 27 Sep 2019 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569590013;
        bh=MK+P96GC5HKYWnKCTtPCrYuMwfryz+prcsSeIhZismY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+YdHOKGgukkPM1gweEclJhKJHpamlvqRq4g7wTdwJLZuW9Rpa1Yh8cyVT3Ko7DQu
         FOUrtAYLOPsCoJfCuJLcfuvSboOAYW0hn6M1vZDkvnQBAjkPwHQoM8cknfEaLMlBH8
         jiHeLIkXrutywttsjSpyYy62cBOfMgHOLVyW2Eao=
Date:   Fri, 27 Sep 2019 09:13:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dave Chiluk <chiluk+linux@indeed.com>
Cc:     Greg KH <greg@kroah.com>, Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, stable@vger.kernel.org
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage
 with high throttling by removing expiration of cpu-local slices
Message-ID: <20190927131332.GO8171@sasha-vm>
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com>
 <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 27, 2019 at 01:12:40AM -0500, Dave Chiluk wrote:
>On Wed, Sep 25, 2019 at 1:44 AM Greg KH <greg@kroah.com> wrote:
>>
>> On Wed, Sep 25, 2019 at 12:53:48AM -0500, Dave Chiluk wrote:
>> > Commit de53fd7aedb1 ("sched/fair: Fix low cpu usage with high
>> > throttling by removing expiration of cpu-local slices") fixes a major
>> > performance issue for containerized clouds such as Kubernetes.
>> >
>> > Commit de53fd7aedb1 Fixes commit : 512ac999d275 ("sched/fair: Fix
>> > bandwidth timer clock drift condition").
>> >
>> > This should be applied to all stable kernels that applied commit
>> > 512ac999d275, and should probably be applied to all others as well.
>>
>> As this commit isn't in a released kernel just yet, we should wait to
>> see what happens when it hits people's machines, right?
>
>I think waiting till 5.4 is released would be irresponsible on this
>one.  512ac999 was recently pushed back into many of the distro

The "released kernel" statement means 5.4-rc1 rather than 5.4, which is
just a few days away.

--
Thanks,
Sasha
