Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4D5305C91
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 14:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhA0NJz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 27 Jan 2021 08:09:55 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:58824 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238157AbhA0NHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 08:07:43 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 095094403E5;
        Wed, 27 Jan 2021 15:06:56 +0200 (IST)
References: <d1d7d548eba25119397de87211de763c54b5d8cd.1611651611.git.baruch@tkos.co.il>
 <20210126180650.xsrycbnwzu4lzl55@pengutronix.de>
User-agent: mu4e 1.4.14; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 5.10-stable] gpio: mvebu: fix pwm .get_state period
 calculation
In-reply-to: <20210126180650.xsrycbnwzu4lzl55@pengutronix.de>
Date:   Wed, 27 Jan 2021 15:06:55 +0200
Message-ID: <87im7iy1e8.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Uwe,

Thanks for your review.

On Tue, Jan 26 2021, Uwe Kleine-König wrote:
> On Tue, Jan 26, 2021 at 11:00:11AM +0200, Baruch Siach wrote:
>> commit e73b0101ae5124bf7cd3fb5d250302ad2f16a416 upstream.
>> 
>> The period is the sum of on and off values. That is, calculate period as
>> 
>>   ($on + $off) / clkrate
>> 
>> instead of
>> 
>>   $off / clkrate - $on / clkrate
>> 
>> that makes no sense.
>> 
>> Reported-by: Russell King <linux@armlinux.org.uk>
>> Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Fixes: 757642f9a584e ("gpio: mvebu: Add limited PWM support")
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Doesn't this need something like:
>
> 	[baruch: Backported to 5.10]
>
> plus a new S-o-B?

I could not find this requirement in the stable-kernel-rules.rst (Option
3) text.

Greg, should I resend the patch with another SoB?

Thanks,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
