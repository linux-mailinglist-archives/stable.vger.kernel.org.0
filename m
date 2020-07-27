Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554522FDB8
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 01:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgG0X3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 19:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgG0X33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 19:29:29 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B70208E4;
        Mon, 27 Jul 2020 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892569;
        bh=2RNa96Lx3KsNfqNDjq9god52tZ1VPKcA7xclquJSil4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uE0PAjHgPjzoetbsN/6so4DPgozOnmyKNvHU8W2xZw6FpPzgAAQTixICEsmfB9X0z
         hT+Q5UWXeUeetlHHpvTj1A9d2BBPGqq5Yr41q+ubCL8d4VERacmJcX0x7TL1JyzQ4m
         yit/0ZEtGmME0foyMvstdUdNlbtlw0cKb/mR7tkU=
Date:   Mon, 27 Jul 2020 19:29:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "dbasehore ." <dbasehore@chromium.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 54/86] Input: elan_i2c - only increment wakeup count
 on touch
Message-ID: <20200727232928.GK406581@sasha-vm>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134917.124943291@linuxfoundation.org>
 <20200727212933.pkt6kgescdz7akht@duo.ucw.cz>
 <20200727220112.GV1665100@dtor-ws>
 <CAGAzgsrTBm0UWM5QwxzePRrpz2xOUsJ4cuyj28q=ik++OQ-dkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGAzgsrTBm0UWM5QwxzePRrpz2xOUsJ4cuyj28q=ik++OQ-dkw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 03:18:06PM -0700, dbasehore . wrote:
>On Mon, Jul 27, 2020 at 3:01 PM Dmitry Torokhov
><dmitry.torokhov@gmail.com> wrote:
>>
>> On Mon, Jul 27, 2020 at 11:29:33PM +0200, Pavel Machek wrote:
>> > Hi!
>> >
>> > > From: Derek Basehore <dbasehore@chromium.org>
>> > >
>> > > [ Upstream commit 966334dfc472bdfa67bed864842943b19755d192 ]
>> > >
>> > > This moves the wakeup increment for elan devices to the touch report.
>> > > This prevents the drivers from incorrectly reporting a wakeup when the
>> > > resume callback resets then device, which causes an interrupt to
>> > > occur.
>> >
>> > Contrary to the changelog, this does not move anything... unlike
>> > mainline, it simply adds two pm_wakeup_events.
>> >
>> > It may still be correct, but maybe someone wants to double-check?
>>
>> Good catch, I believe the backport is busted.
>
>I don't believe it will break anything, but the backport isn't needed
>in 4.19 since "Input: elan_i2c - increment wakeup count if wake
>source" wasn't merged into 4.19. It's probably best to drop the
>backport.

Hm, I wonder how this happened. It was just a cherry pick in this case
:/

Either way, I've dropped it from 4.19, thanks!

-- 
Thanks,
Sasha
