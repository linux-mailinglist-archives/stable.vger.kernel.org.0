Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC1D26B641
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgIPABM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgIPAAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 20:00:52 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FC9C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 17:00:50 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id i16so602233oii.12
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 17:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BJqVo86vzJ1PWut4G+FLZC5D6BwHJucJI+OgVSPz+n8=;
        b=FAr//4UonfQsmfEC2v/UpP8Dt/VfQ1hFY5h8oGOUKOopPi4sTeaG5gYrT/R7uczGug
         iO6xwbku9VpvAaKm8bcmHd0slpZ3Dx5Hk3xk3ui4tD6+0EG2eVTVwFw2rFPn0RT9JZ52
         KHisykccb5An+UpErD6Kq9nGIQ6kgjyNN6Wwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJqVo86vzJ1PWut4G+FLZC5D6BwHJucJI+OgVSPz+n8=;
        b=T8+5yr5IBxTP+TWZ5XmV0Lu3mSqp9LUSnNHd51jlowwOp+MXiX6lTKyTIstz2DVur5
         ohdMv+7fiXWR+q4MDJPiiLrCPKR+uxA3d3gByplNCpWGaawm24fMCgOOdg/W4PBMnVZ0
         JcxCijuDTImJnZkrldttI0sV6PEVG8BIJCuZgC/RI91ONW9rL5hKWIxXAW7VKrxahskU
         4i7LAa9kVA5VjUkI8vsQ08fAjCytlcUXWYsAsU3Q/GjWMnFx4fMGw1Lyu96Up3QLa+OX
         wC7uQiTml4TjpWKxQjskoLcWlUGuTot9Y9LdwjK8rqNtDg5jc2NETO59zUWXL21NfSPR
         AI1g==
X-Gm-Message-State: AOAM531zn7pPgesD3eRBjG4p/4rzCdTQ0Bwlw1ndjWVjPcpR1gtycOwM
        93p6RAZgdQIRMkFrZtHggnnhVA==
X-Google-Smtp-Source: ABdhPJwUh3GdFjq/8RezOjhS2HuAIuOi6isRR2Rf7CcbhAPPlnNCOXxpD42xoGd/PE+cay7aawfxcg==
X-Received: by 2002:aca:d07:: with SMTP id 7mr1374570oin.65.1600214449972;
        Tue, 15 Sep 2020 17:00:49 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 189sm7705150oid.40.2020.09.15.17.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 17:00:49 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/78] 4.19.146-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dfb1b41a-494a-5f5b-a7d2-5096d8d5492b@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 18:00:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/15/20 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.146 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.146-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
