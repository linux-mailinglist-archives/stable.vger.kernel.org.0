Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC8BD833F
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 00:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbfJOWGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 18:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfJOWGy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 15 Oct 2019 18:06:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2DC420854;
        Tue, 15 Oct 2019 22:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571177213;
        bh=Nr6N5Me8dPzW8jNSAc3t7koMgI57FxDk/XCXBZcyfGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e0sG9NagyPCklacveOQEumzJmstAiVPzAeH4d0BSC0IlZmhvhvxQ4H7k6at0PCg4Z
         j62DNZNpGPUWq5/oDilZpSYHcDxv/aPAv5n/Vc+iCJXHQHHfhZW6CodfB2Ff9npoP2
         AD85u/5SnSVM47fAX/xPwkxatc02SWtacJ8xynIc=
Date:   Tue, 15 Oct 2019 18:06:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     m.felsch@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: light: fix vcnl4000 devicetree
 hooks" failed to apply to 5.3-stable tree
Message-ID: <20191015220652.GR31224@sasha-vm>
References: <1571069502139213@kroah.com>
 <20191015030419.GJ31224@sasha-vm>
 <20191015061809.GA926806@kroah.com>
 <20191015141931.GO31224@sasha-vm>
 <20191015153304.GA1002701@kroah.com>
 <20191015163524.GP31224@sasha-vm>
 <20191015173935.GA1071372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191015173935.GA1071372@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 07:39:35PM +0200, Greg KH wrote:
>On Tue, Oct 15, 2019 at 12:35:24PM -0400, Sasha Levin wrote:
>> On Tue, Oct 15, 2019 at 05:33:04PM +0200, Greg KH wrote:
>> > On Tue, Oct 15, 2019 at 10:19:31AM -0400, Sasha Levin wrote:
>> > > On Tue, Oct 15, 2019 at 08:18:09AM +0200, Greg KH wrote:
>> > > > On Mon, Oct 14, 2019 at 11:04:19PM -0400, Sasha Levin wrote:
>> > > > > On Mon, Oct 14, 2019 at 06:11:42PM +0200, gregkh@linuxfoundation.org wrote:
>> > > > > >
>> > > > > > The patch below does not apply to the 5.3-stable tree.
>> > > > > > If someone wants it applied there, or to any other stable or longterm
>> > > > > > tree, then please email the backport, including the original git commit
>> > > > > > id to <stable@vger.kernel.org>.
>> > > > > >
>> > > > > > thanks,
>> > > > > >
>> > > > > > greg k-h
>> > > > > >
>> > > > > > ------------------ original commit in Linus's tree ------------------
>> > > > > >
>> > > > > > > From 1436a78c63495dd94c8d4f84a76d78d5317d481b Mon Sep 17 00:00:00 2001
>> > > > > > From: Marco Felsch <m.felsch@pengutronix.de>
>> > > > > > Date: Tue, 17 Sep 2019 16:56:36 +0200
>> > > > > > Subject: [PATCH] iio: light: fix vcnl4000 devicetree hooks
>> > > > > >
>> > > > > > Since commit ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
>> > > > > > the of_match_table is supported but the data shouldn't be a string.
>> > > > > > Instead it shall be one of 'enum vcnl4000_device_ids'. Also the matching
>> > > > > > logic for the vcnl4020 was wrong. Since the data retrieve mechanism is
>> > > > > > still based on the i2c_device_id no failures did appeared till now.
>> > > > > >
>> > > > > > Fixes: ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
>> > > > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>> > > > > > Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
>> > > > > > Cc: <Stable@vger.kernel.org>
>> > > > > > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> > > > >
>> > > > > Greg, I'm not sure why you dropped this one?
>> > > > >
>> > > > > I've queued it up for 5.3.
>> > > >
>> > > > It doesn't apply to my 5.3 tree, and now that you added it, it still
>> > > > doesn't apply :(
>> > > >
>> > > > So I'm going to drop it now.  How did this apply on your side?
>> > >
>> > > I... uh... it just applies?
>> > >
>> > > $ git cherry-pick 1436a78c63495dd94c8d4f84a76d78d5317d481b
>> > > [queue-5.3 5f3196259cbe2] iio: light: fix vcnl4000 devicetree hooks
>> > > Author: Marco Felsch <m.felsch@pengutronix.de>
>> > > Date: Tue Sep 17 16:56:36 2019 +0200
>> > > 1 file changed, 5 insertions(+), 5 deletions(-)
>> > >
>> > > what do you see as the conflict? line numbers look mostly the same, so
>> > > as the context.
>> >
>> > It's conflicting with another patch already in the queue, try applying
>> > it now and see what happens :)
>>
>> Apparently git resolves this conflict correctly. After cherry-pick, that
>> commit looks like this:
>>
>> diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
>> index ca0d27b46ea22..16dacea9eadfa 100644
>> --- a/drivers/iio/light/vcnl4000.c
>> +++ b/drivers/iio/light/vcnl4000.c
>> @@ -398,15 +398,15 @@ static int vcnl4000_probe(struct i2c_client *client,
>> static const struct of_device_id vcnl_4000_of_match[] = {
>>        {
>>                .compatible = "vishay,vcnl4000",
>> -               .data = "VCNL4000",
>> +               .data = (void *)VCNL4000,
>>        },
>>        {
>>                .compatible = "vishay,vcnl4010",
>> -               .data = "VCNL4010",
>> +               .data = (void *)VCNL4010,
>>        },
>>        {
>> -               .compatible = "vishay,vcnl4010",
>> -               .data = "VCNL4020",
>> +               .compatible = "vishay,vcnl4020",
>> +               .data = (void *)VCNL4010,
>>        },
>>        {
>>                .compatible = "vishay,vcnl4040",
>> @@ -414,7 +414,7 @@ static const struct of_device_id vcnl_4000_of_match[] = {
>>        },
>>        {
>>                .compatible = "vishay,vcnl4200",
>> -               .data = "VCNL4200",
>> +               .data = (void *)VCNL4200,
>>        },
>>        {},
>> };
>>
>> Unless you have any objections, I'll queue up this version instead.
>
>No objection, please do!  I'm on a plane for the next 8+ hours and have
>limited git access...

It's back in the queue, and I've verified that applying the patch file
with 'patch -p1 [...]' works.

-- 
Thanks,
Sasha
