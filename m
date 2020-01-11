Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FED138379
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 21:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbgAKUJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 15:09:08 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42727 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731045AbgAKUJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 15:09:07 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so2835377pfz.9;
        Sat, 11 Jan 2020 12:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wk18T4+rpZl8nR0ilzJ0XuyNcWqQpKsC9psMIMKwahw=;
        b=bvMyDRkgHeE0IP2M6Cb7pVNb0PIDFKi/X3GH8aiacqdXoZGQ+wSmWUh7VFvPDR/eB2
         MShbCmt0cjBw0Wt0aBfvj5LlY/e1ynus/ZidQWxWtFxELwnUM63zaaw1NT549vMV81zh
         JQfm2NdQp8fffj22vVlgV3Q0UJ+o3PEV6qhvU1+h/3BN/ytXDy1+hfQ7dmwc4RV2iGbR
         ohWp+IgFOqgqzbnTWxqAWkuxgLEac0wDMvaM+IzJU+f78gRoENDZlCOeUtSWsP707Efi
         gM/TxuOHo6a4H8ifbUJivPgwM9a/msuLuwDaEv4jrOB6OlOJ3xJYrrnZNU39uGJzOU1L
         BAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wk18T4+rpZl8nR0ilzJ0XuyNcWqQpKsC9psMIMKwahw=;
        b=YGA7l+yrOjhuwEwmUnRU38tlarsay0o/I0Ho7KgVexmVRavrWANh0dFkiubP3jlmeC
         Pn6MgDe0nMVTOTlDHlxND/pHDNGGM7Fs1o5wNieYzaYwmXtvYsi8fG4DN5o+eUWt+sJG
         oae+47bDyMDVSbQ1ox1diDJMxheggwqjW/lEVndBXS6GFb1tD+82VcRntqqMJpAAB7JZ
         OCvs7mjuWFtBvQdNPmASb20olyXTdexp8f9Kn4MoXLtKD3Y+Nss5ZslXpjB+d0j8QjB0
         bmE0t4J/AC99loaS2xj8nmC9g1VaMTT/Qcrji04wv+MmDrNP3NckCh9Oc3/0i0Q6Tj8M
         PAxQ==
X-Gm-Message-State: APjAAAWYai814P6loub/YtFUxHXT9xpPwmtqzvta9ijF37CcfpRy5bCD
        uZWhaav/YCyrgdFelhO1P5u+PDCB
X-Google-Smtp-Source: APXvYqx8hGIdiTuPmg6kYRpoeZEdGolClTAJo7GIxOR7t0erRze87CbnBqf8fyP0sz85F7Occ+s8Tg==
X-Received: by 2002:a63:4d1b:: with SMTP id a27mr12430008pgb.352.1578773346559;
        Sat, 11 Jan 2020 12:09:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j17sm7769342pfa.28.2020.01.11.12.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 12:09:05 -0800 (PST)
Subject: Re: [PATCH 4.9 00/91] 4.9.209-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094844.748507863@linuxfoundation.org>
 <0668a7b6-502b-719b-a2eb-59519de7bf3e@roeck-us.net>
 <20200111175114.GA403776@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8f9def49-8985-e7ca-417b-a4069fc6e8a3@roeck-us.net>
Date:   Sat, 11 Jan 2020 12:09:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111175114.GA403776@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 9:51 AM, Greg Kroah-Hartman wrote:
> On Sat, Jan 11, 2020 at 07:44:31AM -0800, Guenter Roeck wrote:
>> On 1/11/20 1:48 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.209 release.
>>> There are 91 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 172 pass: 169 fail: 3
>> Failed builds:
>> 	arm:allmodconfig
>> 	arm:u8500_defconfig
>> 	arm64:allmodconfig
>> Qemu test results:
>> 	total: 358 pass: 358 fail: 0
>>
>> drivers/hwtracing/coresight/coresight-tmc-etf.c: In function 'tmc_alloc_etf_buffer':
>> drivers/hwtracing/coresight/coresight-tmc-etf.c:295:10: error: 'event' undeclared
> 
> Ugh, I thought I dropped those earlier, but they came back through
> Sasha's autosel.  There's another build error with another coresight
> patch in there too, looks rare enough that your scripts didn't catch it
> :)
> 
> I'll go push out a -rc2 now with the offending patches dropped.
> 

For v4.9.208-90-g0dd28c11952d:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 358 pass: 358 fail: 0

Guenter
