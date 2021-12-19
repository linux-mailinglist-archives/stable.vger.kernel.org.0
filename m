Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECB2479E7F
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 01:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhLSAB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 19:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhLSAB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 19:01:28 -0500
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C25C061574;
        Sat, 18 Dec 2021 16:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds202112; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BG4C7QRJ227T6gfSl2abCwK4zoPig3VkuYG7jnALxtc=; b=Y8vT0fnAiuLrYuud4qfOSXHtFH
        Ua6IMVr9r6PsY/s2UgB6w66vP047yII1DLc8NWW+5pIjLOpJpxpQcefNqpsP4m1VS5NrAcHMAvvNk
        T7lcB5CJnao4ms7aJlJ+c3OZ0ooM6WaapNgA/JywiXf1LoLcfgTrHvg8cDRn49EikHQU0x8hbD+pm
        2+96AmpREzmdb4FXgYtbRVbxFAyBQjy8oulDP15KUFPeccJheJv8y9XqZhqyfrvuzPJepVIqOS7tY
        t1kYMZcyO6htrVTyzSBcSURXIqhGP6rnfIyl0Xrs6hfaIW1j9aZ1QQzrfMCmwS9Sqko86UqMCsOI7
        Eha7QUbQ==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:59007 helo=[192.168.10.61])
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <noralf@tronnes.org>)
        id 1myjdl-0000sb-2S; Sun, 19 Dec 2021 01:01:25 +0100
Message-ID: <1e95e757-a0e3-a1e9-8430-3accc25d0f84@tronnes.org>
Date:   Sun, 19 Dec 2021 01:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] gpio: dln2: Fix interrupts when replugging the device
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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

Ping, has this been forgotten? Can't see it in -next.

Noralf.
