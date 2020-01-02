Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEED912E86E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 17:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgABQJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 11:09:35 -0500
Received: from first.geanix.com ([116.203.34.67]:51890 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgABQJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 11:09:35 -0500
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 04A04753;
        Thu,  2 Jan 2020 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1577981363; bh=m8fuwRp3fKASi2WchSnLIZHMD40mpj8Tf45qZtKc6hE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Han7x36upLq/kkyUcQI7VxVCG70bcnnWwFdxxiuc6jEWYhmjIHkY3rBG8Srsqqgxd
         ug+uzbdcGULpvfJOh8mP0wOQ8UURnvwyLFM87/fd/t1QtHPe6IHL5WxplCifIZ9zIg
         4Jbwb9K1Ya/TtgBLHfXtGkvwxOPUAjZhnyAjtm1KMI0PJ7HTh/6W6xoFgn3ePOTwSR
         WbLHT2ksj0SNkrqFg3dsNXb15cVnAwZJUjmbMyKR+bfsawVLmfDjtGFTnCk3HPic5A
         QYglAF7xAtBzJOtoOVI29l36G37NUQ6M5pkdj+39J07XuO7C0YJc6HqrInzYMkV+dt
         /HwJSKlAi/4DQ==
Subject: Re: [PATCH v2 1/2] can: m_can: tcan4x5x: put the device out of
 standby before register access
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     dmurphy@ti.com, martin@geanix.com, stable@vger.kernel.org
References: <20191209192440.998659-1-sean@geanix.com>
 <d58b9d08-dbd8-b73e-dae1-286c1a3ce8f2@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <973df29f-c930-c6b2-17c4-3e3b468f3bf0@geanix.com>
Date:   Thu, 2 Jan 2020 17:09:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <d58b9d08-dbd8-b73e-dae1-286c1a3ce8f2@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,URIBL_BLOCKED autolearn=disabled version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on ea2d15de10a4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 02/01/2020 16.46, Marc Kleine-Budde wrote:
> On 12/9/19 8:24 PM, Sean Nyekjaer wrote:
>> The m_can tries to detect of niso (canfd) is available while in standby,
>> this function results in the following error:
>>
>> tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
>> tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
>> tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.
> 
> Can you add the missing error handling to m_can_config_endisable(), and
> handle this error correctly in all its callers?
> 
> Marc
> 

Hi Marc

Sorry if this was a bit of mess :)
Version 6 of this patch is already applied....
https://www.spinics.net/lists/linux-can/msg03186.html

Do you want me to add more error handling than this?

/Sean
