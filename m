Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030E7E6E2C
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 09:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbfJ1I0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 04:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731531AbfJ1I0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 04:26:36 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA23F208C0;
        Mon, 28 Oct 2019 08:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572251195;
        bh=/zOYDaZGiopTZgTpceQwJQD3qmpu3CAKGprzMHWhy00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m50Z+PQ+JVvnbDuL2/Gt0dV6MQbNizdMxAgjDwhEjlI5HMbt6z1vEGGbJa02zh3yA
         8rM80voVmUnRa7uVDku84najyQbrOq6WSFWJ7k+UiYupM2ehW3kGYMEoQ+rZpsh44a
         zi8g5a1GDfE8kP90dr33E1aH7xmWqvMDaVQF4yfI=
Date:   Mon, 28 Oct 2019 04:26:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, zeba.hrvoje@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for
 sockets" failed to apply to 5.3-stable tree
Message-ID: <20191028082632.GI1560@sasha-vm>
References: <1572191635100175@kroah.com>
 <da7d616b-a7e1-5cf5-5b38-75ecf8843ccb@kernel.dk>
 <20191027200020.GB2587661@kroah.com>
 <b9a4a9f8-2588-b13e-b010-916895d7a8dc@kernel.dk>
 <20191027202633.GA2608793@kroah.com>
 <25f998ae-e6d4-9e62-3b3d-996cd92e80cb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <25f998ae-e6d4-9e62-3b3d-996cd92e80cb@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 02:39:06PM -0600, Jens Axboe wrote:
>On 10/27/19 2:26 PM, Greg KH wrote:
>> On Sun, Oct 27, 2019 at 02:22:06PM -0600, Jens Axboe wrote:
>>> On 10/27/19 2:00 PM, Greg KH wrote:
>>>> On Sun, Oct 27, 2019 at 12:58:14PM -0600, Jens Axboe wrote:
>>>>> On 10/27/19 9:53 AM, gregkh@linuxfoundation.org wrote:
>>>>>>
>>>>>> The patch below does not apply to the 5.3-stable tree.
>>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>>> tree, then please email the backport, including the original git commit
>>>>>> id to <stable@vger.kernel.org>.
>>>>>
>>>>> I can fix this up, but I probably need to see Sasha's queue first for
>>>>> the io_uring patches. I need to base it against that.
>>>>
>>>> Ok, wait for the next 5.3.y release in a few days and send stuff off of
>>>> that if you can.
>>>
>>> Is there no "current" or similar tree to work of off? Would be a shame
>>> to miss the next one, especially since the newer fixes are already in.
>>
>> I'm about to push out the -rcs right now.  You can base off of that and
>> send me the patch and I'll add it, or just wait a few days, either is
>> fine.
>
>Sounds good, thanks Greg.

I'll queue up a backport for this. The conflict is due to not having the
io_queue_sqe()/__io_queue_sqe() split introduced by 4fe2c963154c3
("io_uring: add support for link with drain").

-- 
Thanks,
Sasha
