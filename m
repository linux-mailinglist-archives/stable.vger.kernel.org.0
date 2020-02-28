Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006E9173FB9
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 19:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgB1Sgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 13:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1Sgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 13:36:45 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79CC524677;
        Fri, 28 Feb 2020 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582915004;
        bh=Zoi4OOCj5PUao03jw4sbw2xHe0PvXnrfJef5UgQ6+ro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZuRNCPAcqVWapY9nzOqoJd0r76VqKIspN4RPY9Fe5hLP2Q0f+epZ3czPZG699zymd
         c66bsDTjyKKhxJNDzw5cGcvTei8IuuoabIlVPoLn/6j+HlX3G8E+2iM7XeAp/uZAdq
         VsKh8NdLt+/v9yy/yIfzvSve7ZGWStanPJGOJjfg=
Date:   Fri, 28 Feb 2020 13:36:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        gregkh@linuxfoundation.org, lirongqing@baidu.com,
        stable@vger.kernel.org, vikram.pandita@ti.com
Subject: Re: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in
 advance" failed to apply to 4.14-stable tree
Message-ID: <20200228183643.GB21491@sasha-vm>
References: <158271336456142@kroah.com>
 <20200226233949.GC22178@sasha-vm>
 <20200227095908.GC1224808@smile.fi.intel.com>
 <87r1yf2j57.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87r1yf2j57.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 09:47:16AM +0100, Kurt Kanzenbach wrote:
>Hi,
>
>On Thu Feb 27 2020, Andy Shevchenko wrote:
>> On Wed, Feb 26, 2020 at 06:39:49PM -0500, Sasha Levin wrote:
>>> On Wed, Feb 26, 2020 at 11:36:04AM +0100, gregkh@linuxfoundation.org wrote:
>>
>> ...
>>
>>> > Since this change we don't need to have custom solutions in 8250_aspeed_vuart
>>> > and 8250_of drivers, thus, drop them.
>>> >
>>> > Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
>>> > Reported-by: Li RongQing <lirongqing@baidu.com>
>>> > Cc: Kurt Kanzenbach <kurt@linutronix.de>
>>> > Cc: Vikram Pandita <vikram.pandita@ti.com>
>>> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>> > Cc: stable <stable@vger.kernel.org>
>>> > Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
>>> > Link: https://lore.kernel.org/r/20200211135559.85960-1-andriy.shevchenko@linux.intel.com
>>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> For 4.14, I've worked around these missing commits:
>>>
>>> 5909c0bf9c7a ("serial/aspeed-vuart: Implement quick throttle mechanism")
>>> 989983ea849d ("serial/aspeed-vuart: Implement rx throttling")
>>> 54e53b2e8081 ("tty: serial: 8250: pass IRQ shared flag to UART ports")
>>
>> Thanks!
>>
>>> And queued up a backport. Older kernels are a bit trickier than that.
>
>Thanks for backporting. Why is it trickier?
>
>>
>> Since it's quite old bug and not many reports so far I guess we are not in
>> hurry to fix that old kernels.
>
>It would be quite nice to have that in v4.9 as well. My original patch
>was made against that tree and tested.

Hm, yes, looking at it now it doesn't look too tricky, I'm not sure what
happened a few days ago :)

If you want to send me a backport I'll be happy to queue it up.

-- 
Thanks,
Sasha
