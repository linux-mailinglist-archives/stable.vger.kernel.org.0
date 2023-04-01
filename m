Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2311E6D2D93
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 04:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjDACFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 22:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjDACFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 22:05:52 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41AEFA;
        Fri, 31 Mar 2023 19:05:51 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id r16so17983448oij.5;
        Fri, 31 Mar 2023 19:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680314751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ftkFRlydY5j9a8m5plIM/f4/vr6ozLid81af03S9j0o=;
        b=DR8REL8hzbCG1CFq0ozyUcgzrYkWCTOft8KUrNDGWOy1zpXJsDl7isUXf3q2fA8AdF
         ZLiF0MAgAeVkEacAO9xYO+QgDN59PQA99gfEYAI7hpYqplYwrNUr6AGNeQAoGJmmp+rB
         z0MnDQMAIc+7PDyALkNr0C3p82XJqI/yYJIB8q3XrPtMjzVVrjqXBswGMBUZ7+YuE472
         TIdtHXs9G4eMe3LOGwiqk0DM0iS91qFcwPUG00lb5sVn0oqNhQR0JB7wFLND4DmU8cbu
         IMM9EpwzYb2GM857AH/upY8DIMxmcYqNnWANEpQI9iR1eEvd049VxHLC8vw8mT1/+1wD
         ozqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680314751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ftkFRlydY5j9a8m5plIM/f4/vr6ozLid81af03S9j0o=;
        b=KTzKDvnOiV84KgPtXae1GMYsUw3r7DlyeOir/oMjqrNOSFQBMMNqaRrtQKqj01p8re
         KTXRXX1HzEYDSHE7wvhWNO6hVr8Qt0VFJCpMZ0T8dV6xtKT+FxibzNBtUepvzXpuQNtx
         /YhIueR/YpB3IGvFNcqSxlx1v0fOSTUJ+mYCl6c4bhJ8KmVWl9AsaJRr/ZAIkJuUFZxE
         zD/H4M2DJAggkiAuX3oV6RrEDgsAPU7TYZTO3D+NeqX2M7GoR6r0JClGuU19i9B0kf5g
         7wjvOq7Gkxxvhor3YB7f0RP0DC8ix0rO64txkjxkE04fh3gHwEVRiYjhVcf2nOqy4kCw
         ugOw==
X-Gm-Message-State: AO0yUKUKRAIAKbH/Oqrt/CcZ0adPEu0zAaOA52dV9lBCrk1r4kvKslRu
        Gub6mN8+U1/flHlmFgI0hAX3i6gKJJ0=
X-Google-Smtp-Source: AK7set+7Qk16TsLMKrHNg/hT4yagB1I0GcCD4zhUKtXGOZkYXqKNEhoxTo60nQSgnQG9/O6O+6QuqA==
X-Received: by 2002:a05:6808:5ca:b0:386:9dc5:2cc0 with SMTP id d10-20020a05680805ca00b003869dc52cc0mr12226101oij.25.1680314751260;
        Fri, 31 Mar 2023 19:05:51 -0700 (PDT)
Received: from [192.168.0.116] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id h38-20020a4a9429000000b0051a6cb524b6sm1525190ooi.2.2023.03.31.19.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 19:05:51 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <4a76b5fe-c3d6-de44-c627-3f48fafdd905@lwfinger.net>
Date:   Fri, 31 Mar 2023 21:05:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/2] RTW88 USB bug fixes
Content-Language: en-US
To:     "Alex G." <mr.nuke.me@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Hans Ulli Kroll <linux@ulli-kroll.de>, Pkshih <pkshih@realtek.com>,
        Tim K <tpkuester@gmail.com>, Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        stable@vger.kernel.org
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
 <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/23 15:34, Alex G. wrote:
> On 3/31/23 07:10, Sascha Hauer wrote:
>> This series fixes two bugs in the RTW88 USB driver I was reported from
>> several people and that I also encountered myself.
>>
>> The first one resulted in "timed out to flush queue 3" messages from the
>> driver and sometimes a complete stall of the TX queues.
>>
>> The second one is specific to the RTW8821CU chipset. Here 2GHz networks
>> were hardly seen and impossible to connect to. This goes down to
>> misinterpreting the rfe_option field in the efuse.
> 
> I applied both these patches, tested an 8821CU, and the news are good:
> 
> The number of kernel warnings and adapter hangs has gone down considerably.
> 
> The signal levels on 2.4GHz bands have improved noticeably. There is the 
> occasional station coming in 30dB lower than on nearby adapters. I wasn't able 
> to find a pattern here.
> 
> I can now run these adapters in IBSS and 802.11s modes on the 2.4 GHz band. That 
> was not possible before.
> 
> I am impressed with the improvements in these patches. For the series:
> 
> Tested-by: Alexandru gagniuc <mr.nuke.me@gmail.com>
>>
>> Sascha Hauer (2):
>>    wifi: rtw88: usb: fix priority queue to endpoint mapping
>>    wifi: rtw88: rtw8821c: Fix rfe_option field width
>>
>>   drivers/net/wireless/realtek/rtw88/rtw8821c.c |  3 +- >>   drivers/net/wireless/realtek/rtw88/usb.c      | 70 +++++++++++++------
>>   2 files changed, 48 insertions(+), 25 deletions(-)

I can confirm that these changes cleared up my problems with the "timed out to 
flush queue" warnings that caused a problem before with my rtw8822bu.

Tested-by: Larry Finger <Larry,Finger@lwfinger.net>

Thanks,

Larry


