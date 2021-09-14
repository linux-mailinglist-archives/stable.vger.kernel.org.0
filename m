Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD9240A73F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhINHWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:22:36 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:59298
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235026AbhINHWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 03:22:35 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C06C34019A
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 07:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631604077;
        bh=CTieqUfrN3QD2Y917kpYPbjsuUgn/zzRL0HRoSY4mxA=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=V8DyrMwTlNsppkAUjKLe0Pt14bQP1U4xP2T++pOPHm2BQploQMcSaPZWp4FTSCrFD
         CCf4iyU99bgstDvxyGg+BphVe88WB/hHi5z1gHFmxElvhfqi3c/pDiF6H+6ineWpoT
         r3R+0/lHTCCsR1t/HH+G5ZYVnkPmlpYAUJCOTbdqRO8Hry/mcSt9xiRdtV4oA8YpIJ
         KUD6SoAwxko6TCCTYHrQ/+dEdh78ZGQahdFpahATg+UdgplYbUO15Y8xtJgxC7p9xC
         aV0NJn7lbcvb3iaeEJNb5gnNx+lsJRbzxxc9bAln4AFYx9aTylsHi08Rn2C8ecV+Ig
         Ybc+iG2n0TQCw==
Received: by mail-wm1-f71.google.com with SMTP id x125-20020a1c3183000000b002e73f079eefso377701wmx.0
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 00:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CTieqUfrN3QD2Y917kpYPbjsuUgn/zzRL0HRoSY4mxA=;
        b=fHNl/qpH62Q7ZBbOFsaAdaaPGJRTk5npJUdfbTXEhDui7BZVKNBPlk/f4UInftHhCi
         72ryjRGX+7IxWj3zVJx7AF4ecbg2Pg7TXXjoHd9OvWnB3BzaXofwXFF/BMQrM29IOG7k
         BLfcxljpsmshngZfEWG9rTNQKA5wYKjy0BqWbuVuoUmLiOx+glOaxtIp2mjx83nUyEYc
         9MnZ9i4myqDg62Ra04zxGAYGU0jnj/dN0oZjAazXAoy2I1hajBiBS8Q8SSIfJly2HyDF
         WXhEHJmqMNbN9xZqF2ETVPHPSGfXeNGYpN0fiH1fu5/MBXk/ZB/XibI+zBhHnOvVOD2K
         5LPw==
X-Gm-Message-State: AOAM530NvueyjFJmP78QXGMHOwluF2aKFvnCPo+xzOB963bLPnAGCgPM
        zusOigwRZ4aSpxpBNPQUhcjUn+MQkIN2qMZIYbSPRLhtpQlFvJ7ivn0fGOxu4AnmvgZ4FKvAkE6
        8N/FUgcpFZZNTBJNAlAytwSD1GfA6R7j06Q==
X-Received: by 2002:a05:6000:1569:: with SMTP id 9mr17026235wrz.343.1631604077421;
        Tue, 14 Sep 2021 00:21:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6q9GIV+dbbGpUDkzy+9zvc6SY1/R/bzqrROtBxibMIPF3kczBjGgM2zPWhPd5LxWs/YX10w==
X-Received: by 2002:a05:6000:1569:: with SMTP id 9mr17026215wrz.343.1631604077251;
        Tue, 14 Sep 2021 00:21:17 -0700 (PDT)
Received: from [192.168.3.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id v17sm9346322wrr.69.2021.09.14.00.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 00:21:16 -0700 (PDT)
Subject: Re: [PATCH 1/2] power: supply: max17042_battery: Clear status bits in
 interrupt handler
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        stable@vger.kernel.org, kernel@puri.sm
References: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm>
 <0123524d-b767-5b5b-8b14-60d8cea3c429@canonical.com>
 <5702731.UytLkSCjyO@pliszka>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <6affbb35-7b79-db6e-a346-e74d2ba2e886@canonical.com>
Date:   Tue, 14 Sep 2021 09:21:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5702731.UytLkSCjyO@pliszka>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/09/2021 20:32, Sebastian Krzyszkowiak wrote:
> On poniedziałek, 13 września 2021 15:02:34 CEST Krzysztof Kozlowski wrote:
>> On 12/09/2021 22:54, Sebastian Krzyszkowiak wrote:
>>> The gauge requires us to clear the status bits manually for some alerts
>>> to be properly dismissed. Previously the IRQ was configured to react only
>>> on falling edge, which wasn't technically correct (the ALRT line is active
>>> low), but it had a happy side-effect of preventing interrupt storms
>>> on uncleared alerts from happening.
>>>
>>> Fixes: 7fbf6b731bca ("power: supply: max17042: Do not enforce (incorrect)
>>> interrupt trigger type") Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
>>> ---
>>>
>>>  drivers/power/supply/max17042_battery.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/power/supply/max17042_battery.c
>>> b/drivers/power/supply/max17042_battery.c index
>>> 8dffae76b6a3..c53980c8432a 100644
>>> --- a/drivers/power/supply/max17042_battery.c
>>> +++ b/drivers/power/supply/max17042_battery.c
>>> @@ -876,6 +876,9 @@ static irqreturn_t max17042_thread_handler(int id,
>>> void *dev)> 
>>>  		max17042_set_soc_threshold(chip, 1);
>>>  	
>>>  	}
>>>
>>> +	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
>>> +			  0xFFFF & ~(STATUS_POR_BIT | 
> STATUS_BST_BIT));
>>> +
>>
>> Are you sure that this was the reason of interrupt storm? Not incorrect
>> SoC value (read from register for ModelGauge m3 while not configuring
>> fuel gauge model).
> 
> Yes, I am sure. I have observed this on a fully configured max17055 with 
> ModelGauge m5. It also makes sense to me based on what I read in the code and 
> datasheets.
> 
> There were two kinds of storms - the short ones happening on each SOC change 
> caused by SOC threshold alerts set by max17042_set_soc_threshold which 
> eventually got cleared by reconfiguring the thresholds; and a huge one 
> happening when SOC got down to 0% that did not get away until the battery got 
> charged to at least 1% at which point the thresholds got reconfigured again 
> (which is how I noticed the underflow fixed by the second patch).

OK, undestood.

> 
> Besides, I also have patches for configuring m5 gauge via DT that I'll send 
> once I clean them up.

That's cool! Happy to see such work.

> 
>> You should only clear bits which you are awaken for... Have in mind that
>> in DT-configuration the fuel gauge is most likely broken by missing
>> configuration. With alert enabled, several other config fields should be
>> cleared.
> 
> I have checked all the bits in the Status register and aside of Bst, POR and 
> bunch of "don't-care" bits they're all alert indicators that we either handle 
> explicitly in the interrupt handler (Smn/Smx) or implicitly via 
> power_supply_changed (Imn/Imx, Vmn/Vmx, Tmn/Tmx, dSOCi, Bi/Br). The driver 
> unconditionally enables alerts for SOC thresholds and all the rest stays 
> effectively disabled at POR; however, a bootloader or firmware may configure it 
> differently, which may be wanted for things like resuming from suspend when a 
> bad condition happens. Therefore we need to clear all the bits anyway and I'm 
> not sure whether iterating through them in a "if set then clear" loop gains us 
> anything aside of additional lines of code.

Seems reasonable, you're right. Could you mention this expolanation in
commit msg or comment in the code?


Best regards,
Krzysztof
