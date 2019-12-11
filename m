Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FEE11A686
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 10:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfLKJNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 04:13:11 -0500
Received: from first.geanix.com ([116.203.34.67]:46082 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbfLKJNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 04:13:11 -0500
Received: from [192.168.100.11] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 66492449;
        Wed, 11 Dec 2019 09:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576055561; bh=YxISBxVYxSRK+XP0WAd8zfV2chhV6asFXIr1+s+IZL8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=A9NdXoTg5wWJzYYcrajVz//tTfiRe52uB5nOdYxB5S0Vv+WbmIFdwA0X+epDZA0rY
         LnH+mGcC0NN6AW7Hl4a7Z74M+gYqJjSCNQxQbqi6kVvV+gedgOiybDVcFhPUlaFVVW
         jncZaIGBIc1x+f+nSBtYCXeiVoJEkSiLM3pq8l8pXBAmltoh411BM34b/6GZDJWpW6
         dMLu9bj9X5cYcKu4MGvjq7zxtg7nG323qX6Fub0uazM025O8w9F3Q0qNdSpPo44gyf
         H5mOlVC292vqGoJDNlnoH3Yv3cPlsHHk1pS/V9ACHFYv6kYL/m5xqQRA1oeT6pWGZD
         wrFccN4eBd1nw==
Subject: Re: [PATCH v3 1/2] can: m_can: tcan4x5x: put the device out of
 standby before register access
To:     Marc Kleine-Budde <mkl@pengutronix.de>, dmurphy@ti.com,
        linux-can@vger.kernel.org
Cc:     martin@geanix.com, stable@vger.kernel.org
References: <20191211064208.84656-1-sean@geanix.com>
 <8b1682ad-c291-252e-c768-63a7a4801aff@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <bc0014ec-7302-97f4-5d71-8d029b0fb1fb@geanix.com>
Date:   Wed, 11 Dec 2019 10:13:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8b1682ad-c291-252e-c768-63a7a4801aff@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/12/2019 09.42, Marc Kleine-Budde wrote:
> On 12/11/19 7:42 AM, Sean Nyekjaer wrote:
>> The m_can tries to detect if Non ISO Operation is available while in standby,
>> this function results in the following error:
>>
>> tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
>> tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
>> tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.
>>
>> When the tcan device comes out of reset it comes out in standby mode.
>> The m_can driver tries to access the control register but fails due to
>> the device is in standby mode.
>> So this patch will put the tcan device in normal mode before the m_can
>> driver does the initialization.
>>
>> Fixes: a229abeed7f7 ("can: tcan4x5x: Turn on the power before parsing the config")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> 
> Applied both to linux-can.
> 

Oh, the commit id for "can: tcan4x5x: Turn on the power before parsing 
the config" have changed, since this morning :)

The new commit is 0d38aa7d1090

Thanks
/Sean
