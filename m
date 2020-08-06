Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2018923E24B
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 21:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHFTeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 15:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHFTeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 15:34:12 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16ACBC061575
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 12:34:11 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id v6so26309331ota.13
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 12:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1es26tsdCKsqKmJOB8uF5Bn5UO+epgItEywVRGDwRXA=;
        b=XE4k7WyI2t7M59d27ZYsgFmCscGNqSYs6wi0xjS3Vgo/Z2qEl42HftuaR4p79Fgoga
         L8XJkEdsU1kItTy0CsGsiCLzWIekHyY98ZR2Vw7sTZK7QsaXW1N/gL1Bhu2edkZzFbv0
         liqpuRk9wgjvxS9hJfK6ALEXCaxmTxsEmylwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1es26tsdCKsqKmJOB8uF5Bn5UO+epgItEywVRGDwRXA=;
        b=ki2x1MsdnrPGL1+Pwj8lGmOa6Zul4r448EX+1CjvQKIGq5wB8jCFL7QkhhvrQ4mR0N
         hWwaDXTimWWB03QdXdIDh9+3Db1Z7g4uCu4D2tR/6M1uukueE1GW6Fi0dDJl7q6th/Ws
         5+lWjSrn7l54poLZOO+JmEsq3+khmjryHPKkhzdNIRVAwp52Of2OIwFTdSW/bo04wsfy
         viCKuafNoEAaddvRrQIAR6DCJ7fhomz2D+JTCL47MXC2Lvl6OHBfwx2NPtEhmMGnfhyt
         HoRRnQ8Tv0giVUkVkYvWd8F70VdZe4fWz3V0DMt7CGzeCyU2YScIMxlMsFfRsrmUwnSH
         hHRw==
X-Gm-Message-State: AOAM533Nlreh5RUTmL2YnkZaIJuRtS/k54A9vU8LeTtJa9REYx3w85EE
        Z/8lfVCtQkSz025DSZSCzrIbjw==
X-Google-Smtp-Source: ABdhPJxYxpY0QuM0iIR4HWc0hd1gPoDxDjJmafm9uJSbMujRdlz6vySSTL55Y5mkaZmp4Lh6W2+WvQ==
X-Received: by 2002:a9d:7349:: with SMTP id l9mr9021506otk.341.1596742451094;
        Thu, 06 Aug 2020 12:34:11 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w22sm1341226ooq.37.2020.08.06.12.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:34:10 -0700 (PDT)
Subject: Re: [PATCH 4.14 0/8] 4.14.193-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200805153507.005753845@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <87e43631-71d2-d7f9-7cdc-4f62c1f067c6@linuxfoundation.org>
Date:   Thu, 6 Aug 2020 13:34:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.193 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

