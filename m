Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808613F7EB6
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 00:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhHYWiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 18:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhHYWiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 18:38:52 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF715C0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:38:05 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id h133so1570666oib.7
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eFwz6uvNiRmoxFvPJ8s1uB72uaqZs1fV+ahpvxpZMEo=;
        b=F4WdfhKH2h3IpBPItyiLV8/le1ec9P0HE3SBK73jK10+JzOm0EioTad+yhSfoLcELQ
         9wlRLWTMdn7oy7X0LHzja7AieFEH5Ud8aGaZjAy6shgQ0X3hDui979gn3Y9+e6Hx31/9
         EjG7pgjv4Y1uk1l2toK71W2kcMIs0srmOd6UM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eFwz6uvNiRmoxFvPJ8s1uB72uaqZs1fV+ahpvxpZMEo=;
        b=H9wOXnVXSBnuBEhR1d8onKvL+x6e/yzScUfmbAW04uaj6ikDRnvr7wbAm2eDdvjrKA
         KSS1J11QrOd5AlQ7PqlnA2IQYJVW/qO75KPtPd9joGuSr8m7cKs+ZcmKCGE0MQ7/LiV1
         BT17ZBSUyjgBY29alJmRX01MbN3kZQstPxpyGiqskX+4uzKYJdBpEj7xR2EhRJg3HHyl
         PQYiqvW1iZmbfxY51/kfn8JBCWcjzQ+i028id3c0HypCMH3NKsKwhBRX6N+nt209xxKP
         tRMrfjEVo6bM1VVm+KNNCeU9S1GQWdeuScCDn9yNsGpIawgk67yY1CL4/PqaM3TJTvUm
         2gUQ==
X-Gm-Message-State: AOAM531YQ8ngq8kCSz25oidWeSrxQmNEd0nJG0YqQfZnlp4D49KK/gHx
        WueNb9h6YEy8De9VdTl5br07Zg==
X-Google-Smtp-Source: ABdhPJxzak1Xs3tvw0CUCD2aprjthIWOKKub5U8gzkgrEiw1dy/skjjzGk8xHhVa6VdgRnhae4IhKg==
X-Received: by 2002:a05:6808:1889:: with SMTP id bi9mr8794769oib.139.1629931085203;
        Wed, 25 Aug 2021 15:38:05 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w1sm235002ott.21.2021.08.25.15.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 15:38:04 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/31] 4.4.282-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824170743.710957-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5643c91c-9c13-94b8-9349-77546a510ff2@linuxfoundation.org>
Date:   Wed, 25 Aug 2021 16:38:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/21 11:07 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.282 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:07:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.4.y&id2=v4.4.281
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 


Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
