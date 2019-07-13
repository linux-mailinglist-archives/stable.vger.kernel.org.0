Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A916E67A3A
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGMNRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 09:17:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35023 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfGMNRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 09:17:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so5759457pgl.2;
        Sat, 13 Jul 2019 06:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CW90fCbZ/nThnMYxrh09PMSuih7U5TFwDcD0corZhW4=;
        b=SxwFSNKtcdCJRzh8ZlyCU8dNqUL/e5hQ0rkvg/HRa7rugMaaLP58/f770K+TL1mQSj
         AwpuoDQn6MoB9LqeCjQdXtTrsMNO2znsfluvyd3eErqnf3wUsV8Z9Cs9aMFWTlKum+Dc
         hUYfTRV9JZtyAGIS/rRVewR9QFvf8xpeada8LnnPAbZ6FrurX0eI9vNJYu9Kbbd/ixrY
         NI0DembArWo7csBzH+/87Je5F+Bz60VaKoYw5I0Ki9x2BMhIg4ntJM1q04cENBdOf8F/
         V8YnGkBCJFPUukDurlsVcvXBp5OXzx8fqg92CLky49xM+AurDNlenRiMCCsD66bShtYy
         Zqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CW90fCbZ/nThnMYxrh09PMSuih7U5TFwDcD0corZhW4=;
        b=NC49Elsas5sSGR37lc68IsVpWc/63cy60bd+36atGVnwyiQfCEgKzgluM5F2h+gDYh
         CFNhMuKQ3Oa7ruqm038n0v2+Dxdp57TWc+i0TjtTfvN5rAzJf7Oeum7HUuSs/ee1M5jq
         IenoKnNN+cQSRvJivPRBdwP++HTmYBLGlog8zkPdNQP4UrnSEmlS88wQKN4Pol4Xs5xp
         HbBFYq8V8xscRIC4DnDexx7gs0pszeRaYPTJm4djyik9/veKsmPmNyD1BAoPJzmFUdMm
         2bZskMcBFGfCxPDiCdpTa8eJnE3mpNdGWVTjnLjWfdnX3PrSkBTo2FeKpWt/ixNHrdnR
         ROzA==
X-Gm-Message-State: APjAAAVWjxVPle2lCFAPaMZIdg51QPwRmszUDt+Ifo5D9DPSEJcdwYC2
        Rk24qtCv0044ZNxurKSSKhw+dlrb
X-Google-Smtp-Source: APXvYqxVOO38nSrFEivs7+SOHK7Hbnr+EIGWTW6odmHCeSRUxn7o5k671L2wfW2IynGXKLuXkVlL6w==
X-Received: by 2002:a63:4e60:: with SMTP id o32mr17173954pgl.68.1563023820318;
        Sat, 13 Jul 2019 06:17:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f12sm10989384pgo.85.2019.07.13.06.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 06:16:59 -0700 (PDT)
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        j-keerthy@ti.com
References: <20190712121628.731888964@linuxfoundation.org>
 <4dae64c8-046e-3647-52d6-43362e986d21@nvidia.com>
 <20190712153035.GC13940@kroah.com> <20190712202141.GA18698@roeck-us.net>
 <20190713082233.GA28657@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9871ef1a-ea5d-e9cb-2eff-a0a1a93ad44f@roeck-us.net>
Date:   Sat, 13 Jul 2019 06:16:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190713082233.GA28657@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/13/19 1:22 AM, Greg Kroah-Hartman wrote:
> On Fri, Jul 12, 2019 at 01:21:41PM -0700, Guenter Roeck wrote:
>> On Fri, Jul 12, 2019 at 05:30:35PM +0200, Greg Kroah-Hartman wrote:
>>> On Fri, Jul 12, 2019 at 02:26:57PM +0100, Jon Hunter wrote:
>>>> Hi Greg,
>>>>
>>>> On 12/07/2019 13:17, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.1.18 release.
>>>>> There are 138 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
>>>>> or in the git tree and branch at:
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>> -------------
>>>>> Pseudo-Shortlog of commits:
>>>>
>>> Both are now dropped, thanks.  I'll push out a -rc2 with that changed.
>>>
>>
>> Can you push that update into the git repository ?
>> v5.1.17-137-gde182b90f76d still has the problem.
> 
> Odd, I thought I did this.  Pushed out again just to be sure.
> 
Problem is still seen in -rc2.

>> Also:
>>
>> Building powerpc:ppc6xx_defconfig ... failed
>>
>> drivers/crypto/talitos.c: In function ‘get_request_hdr’:
>> include/linux/kernel.h:979:51: error:
>> 	dereferencing pointer to incomplete type ‘struct talitos_edesc’
>>
>> Seen with both v4.19.58-92-gd66f8e7 and v5.1.17-137-gde182b90f76d.
>>
>> This problem is caused by "crypto: talitos - fix hash on SEC1.", which will
>> need a proper backport - struct talitos_edesc is declared later in the
>> source file.
> 
> Ick, let me go drop this one after breakfast...
> 

Turns out this affects all three branches (v4.19. v5.1, and v5.2).

Guenter
