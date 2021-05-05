Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED53748B7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEETbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhEETbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:31:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94397C061574;
        Wed,  5 May 2021 12:30:11 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s22so2496043pgk.6;
        Wed, 05 May 2021 12:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/VTuav0gZ9g0qKLnYH8JOYFnvCq8yu80F5GqmwjTqCI=;
        b=BF/eqITIcCdc1O79R+M7NqoLA5cjFmi+JeIa4M5Y48HwpBBcmcVzcp7dvDvycpeQp1
         QihiZMEas4w9qrlHImYHZDqHE6pigEsiXN6YVA5oZK59loPjvkIPPvcjo9OnmFsIIspB
         spww8jqa4KgwboxwVUo4Ck9EXIOUeXclcdLUvmdlaNCSl8+B+k/C5kcRR3wO1eH+M2WW
         7xamqZxyavxNmVFbdJQ1jQOE89Tl8hPZV7L+FLljdV9r7yi6bUtjN90lHT9RxdTMtyYj
         oTNS7wkk5bIEuUu9LrKhr5aNMh9lu5vBaEpCZD+BOEPZPNjW+OsK1vzA2WWjicq+5Bs7
         wFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/VTuav0gZ9g0qKLnYH8JOYFnvCq8yu80F5GqmwjTqCI=;
        b=gg4hnpWJ16kHORy7r2YZyd+Astp/KISAtfbNgJK314K5R1l8Ty/EfLPUzmGRjHPblw
         cTcIOvb0FIaEuACpPuMwZ5v9s8SNmEympI1E1jIuWQi4VXRCR/VkoKz0eupOuUJ0/Nk5
         Ir5JQdIVYYOIO6Dr/6InEht+mUOE31vsCj3yUK2RC0fSDYk7x2F91hI2tNrbWCsq+q+T
         CWdZSR+Qx5uN0Alc+z77SiZW01SljsEY8HnrFhjiazobVAfflPEaKI0lMFy8CgD1iNyQ
         9qM4f7+DLfUdT/2F0rjal364qYvadKzxWbHRVfoyXhWusueDI23Wahu6OHdXN7gnQHXo
         Cbfg==
X-Gm-Message-State: AOAM530MNwKS43cAgIZdVtxKRTTO0SALbil8EjH6fyXX2sqI3mPxhepP
        ARaiyj3B+3QOv/ce4upj7/wEFomIqOs=
X-Google-Smtp-Source: ABdhPJxa5Ow0Ptr+TFgTgNKTh5JbxRY1ChHQZv4Czje24+8YJ6h9az9RsjknX0ch11bZ8Ce7LQgLsg==
X-Received: by 2002:a63:d218:: with SMTP id a24mr442754pgg.345.1620243010617;
        Wed, 05 May 2021 12:30:10 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g15sm35606pfv.127.2021.05.05.12.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 12:30:10 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210505112326.195493232@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c86b72ca-9f03-0bed-0096-d8fc97f62807@gmail.com>
Date:   Wed, 5 May 2021 12:30:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 5:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
