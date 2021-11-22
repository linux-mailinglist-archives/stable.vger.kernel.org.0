Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C84459612
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 21:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhKVUbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 15:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKVUbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 15:31:24 -0500
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85627C061574;
        Mon, 22 Nov 2021 12:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds202012; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1LWRUToSutCwU/dNaPGi2jZ28H0OKIpy+31+76vtFl4=; b=Yyl9hTbDfjrmU10DJlSB364y+r
        FrHixg0NFpFW83ll3gYzQBMj9uFaefxUAdzU2u+sddjQkxsm5lFwk9E0Q+vXtEI61RAcrUWoqPu1Z
        sLAND+QnnNrk4WJ54nB2f2SWAy9CCaLejU4UL8k0eNZSkvJH0xFV8f9to/B2CN+QicPJJUIVk51Td
        X96xlPkGc+tl4Q3OjP9aSMEwLMZPBlBoOvLf1QpXe0Z4JfJUm9xMYyRq3VKXd8/+a+XN/qpineyha
        sNXrRuotjxgIo+ChjqMWKd12Zp6m/b5P0xzbtbrK3JYaVEvR/+ZcxfScm8DjCQm5kmNOhGPnAPi8T
        +xCrVfrg==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:55103 helo=[192.168.10.61])
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <noralf@tronnes.org>)
        id 1mpFvC-0008BZ-8q; Mon, 22 Nov 2021 21:28:14 +0100
Message-ID: <56881c23-8659-04e2-e7c1-264f7ef1b752@tronnes.org>
Date:   Mon, 22 Nov 2021 21:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] gpio: dln2: Fix interrupts when replugging the device
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>,
        Daniel Baluta <daniel.baluta@gmail.com>
References: <20211018112201.25424-1-noralf@tronnes.org>
 <CACRpkdZQSB+McOGK9HZUNAr2p+FX=6ddbY=5-sQ8difh1pEqGg@mail.gmail.com>
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
In-Reply-To: <CACRpkdZQSB+McOGK9HZUNAr2p+FX=6ddbY=5-sQ8difh1pEqGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Den 24.10.2021 23.09, skrev Linus Walleij:
> On Mon, Oct 18, 2021 at 1:23 PM Noralf Trønnes <noralf@tronnes.org> wrote:
> 
>> When replugging the device the following message shows up:
>>
>> gpio gpiochip2: (dln2): detected irqchip that is shared with multiple gpiochips: please fix the driver.
>>
>> This also has the effect that interrupts won't work.
>> The same problem would also show up if multiple devices where plugged in.
>>
>> Fix this by allocating the irq_chip data structure per instance like other
>> drivers do.
>>
>> I don't know when this problem appeared, but it is present in 5.10.
>>
>> Cc: <stable@vger.kernel.org> # 5.10+
>> Cc: Daniel Baluta <daniel.baluta@gmail.com>
>> Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 

Has this been applied, I can't see it in -next?

Noralf.
