Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916BE78052
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 17:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfG1PnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 11:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfG1PnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 11:43:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 223A92075E;
        Sun, 28 Jul 2019 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564328593;
        bh=Dq6QoeL4ezr8ZMXAdrLCOVGLtVrBtn6BM2sBUdeCB9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2kdhgneqNrndEjMHQ3ivzAHCizetTNGmYiQIwcSITKs2WTjP+ILuQ9/pel/OXx6Rt
         OwJnWAX+HFTWIHiVG3tcBp0h1vR+g1TDDlagOmRjDJql7F72S5NrUMMWnxqu9diIj3
         EOYumr0qVw7XimeNyd4sEZ6y56M4/9vX1TamnLls=
Date:   Sun, 28 Jul 2019 11:43:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Cc:     "jic23@kernel.org" <jic23@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.4 17/35] iio: st_accel: fix
 iio_triggered_buffer_{pre,post}enable positions
Message-ID: <20190728154312.GJ8637@sasha-vm>
References: <20190719041423.19322-1-sashal@kernel.org>
 <20190719041423.19322-17-sashal@kernel.org>
 <20190721182256.70ab6692@archlinux>
 <1fcd1ef5f55de84c2b8c58492cd5fac9b8acf7ee.camel@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1fcd1ef5f55de84c2b8c58492cd5fac9b8acf7ee.camel@analog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 06:47:47AM +0000, Ardelean, Alexandru wrote:
>On Sun, 2019-07-21 at 18:23 +0100, Jonathan Cameron wrote:
>> [External]
>>
>> On Fri, 19 Jul 2019 00:14:05 -0400
>> Sasha Levin <sashal@kernel.org> wrote:
>>
>> > From: Alexandru Ardelean <alexandru.ardelean@analog.com>
>> >
>> > [ Upstream commit 05b8bcc96278c9ef927a6f25a98e233e55de42e1 ]
>> >
>> > The iio_triggered_buffer_{predisable,postenable} functions attach/detach
>> > the poll functions.
>> >
>> > For the predisable hook, the disable code should occur before detaching
>> > the poll func, and for the postenable hook, the poll func should be
>> > attached before the enable code.
>> >
>> > Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>> > Acked-by: Denis Ciocca <denis.ciocca@st.com>
>> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> Hi Sasha,
>>
>> This should do any harm, but I deliberately didn't cc stable on
>> this one.
>>
>> Alex, my assumption on this one is that it was fixing a logical
>> ordering problem, but one that had no visible impact.
>> Whilst the pollfunc will be attached too early, the trigger
>> will be disabled for the whole of this function anyway so
>> it shouldn't cause any visible problem.  Is that a correct interpretation?
>
>Yes.
>That is correct.
>
>Maybe I'll change the commit title format so that there is no confusion.
>It's a fix, but not in the sense that something was broken.
>Just something that is the realm of cleaning up.

I'll drop it from the queue, thanks!

--
Thanks,
Sasha
