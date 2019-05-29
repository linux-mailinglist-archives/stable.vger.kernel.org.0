Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF502E4DB
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfE2S4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfE2S4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:56:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF71240BE;
        Wed, 29 May 2019 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559156196;
        bh=DWacRiwjMj5a6VpNoYOYqOsALp1g7SzVyS/YpGPvbME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ov+kFAm9SPsGT2YMMpFvTCZEDkJpzWpOlHKmDUPvzdWyfFa2wdjrgin1I6IjcVSrr
         QJCS6fkWrInglVv78IHvzeidm/q/4O4Dz35Goyga/FeetKZSoe3JgkfXqzq0EBzoEX
         AMiELAo1aNmIOd0XE10waOoXu4dcGGyyLXNFJnmA=
Date:   Wed, 29 May 2019 14:56:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 077/375] USB: serial: fix initial-termios
 handling
Message-ID: <20190529185634.GI12898@sasha-vm>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-77-sashal@kernel.org>
 <20190523052600.GA15348@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190523052600.GA15348@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 07:26:00AM +0200, Johan Hovold wrote:
>Hi Sasha,
>
>On Wed, May 22, 2019 at 03:16:17PM -0400, Sasha Levin wrote:
>> From: Johan Hovold <johan@kernel.org>
>>
>> [ Upstream commit 579bebe5dd522580019e7b10b07daaf500f9fb1e ]
>>
>> The USB-serial driver init_termios callback is used to override the
>> default initial terminal settings provided by USB-serial core.
>>
>> After a bug was fixed in the original implementation introduced by
>> commit fe1ae7fdd2ee ("tty: USB serial termios bits"), the init_termios
>> callback was no longer called just once on first use as intended but
>> rather on every (first) open.
>>
>> This specifically meant that the terminal settings saved on (final)
>> close were ignored when reopening a port for drivers overriding the
>> initial settings.
>>
>> Also update the outdated function header referring to the creation of
>> termios objects.
>>
>> Fixes: 7e29bb4b779f ("usb-serial: fix termios initialization logic")
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>The stable tag was left out on purpose as this is essentially a new
>feature, and definitely a behavioural change which should not be
>backported.
>
>Please drop from your autosel queues.

Dropped!

>Also, may I ask you again not to include usb-serial (and drivers/gnss)
>in your autosel processing.

Of course, I've added it to my list.

--
Thanks,
Sasha
