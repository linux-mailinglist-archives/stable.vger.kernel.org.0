Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD8A1F565B
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgFJN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbgFJN7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 09:59:40 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B04AC03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:59:40 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id b18so1780956oti.1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cO10j57No0BaEyb9YSQv7ypFi+s1a2RxN3tcT3QgZWI=;
        b=MjKh9E1ka7ye4LxJWRV3NqhfehHWPDxlwuvxv4sY2ufC/iG+JGdWhKzB/DRjr3F9Fp
         EiGp9TPFtBivX4GgmFP5yCvhuGuF2Irkq/UEohgqBqyBh3FdX8fn/NrZ7ApVHMosX56o
         BYKOj5S/3aeXjlEwCDitWVPFYyHGW9tWAFTHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cO10j57No0BaEyb9YSQv7ypFi+s1a2RxN3tcT3QgZWI=;
        b=WEWz8FmtEokoJ9/H5Lxf+vGca59XT+Lha6xNsHVXhdCRdUyVidu2P5YaDTz/oQzT1a
         6bfCTJs4vYWSmWTm7IlrOB7UJQBq0bYbXpb4UngQx46thjy4+LyZ9Kr8Z+VObCru1QMT
         0qxqPKdEwtUKQsu1SYv59LebJu0tLpfqZecQIzZh6tKbi+woKFe+jCXmv7sJqJ6uFUKw
         LrgRi2M9SqcDN+zH8V7uU62xPBVsvY1e9nDW+5VIVSlg9IAFUdxEhBw/0kcBTMNxiXki
         Pq9hX+Q3buzpbFF156rlLWdVv7bS+f6f0txkfV+SbAZAW0OHT9nEGsZNZqKaXVc2ebhX
         4WUQ==
X-Gm-Message-State: AOAM533QKCbhTIVxBSPXvemQ87mto/VEiqNHfXaBmKrpdD5jHt2sL4Tv
        jeDn8mLMkD0NJEQCpxQ06SNgDg==
X-Google-Smtp-Source: ABdhPJzf+YXQpMcXtYNdqQnAUdcSOPlqPUi+y5rAXH+kUMnPwYic9TBvFuTVFbkRZgVGTTsEgD0WqA==
X-Received: by 2002:a9d:186:: with SMTP id e6mr2755394ote.33.1591797579638;
        Wed, 10 Jun 2020 06:59:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z6sm15425oth.26.2020.06.10.06.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 06:59:38 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/34] 5.4.46-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200609174052.628006868@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <241bc3fd-7bcd-1ccb-f825-f0b5acd6bb45@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 07:59:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 11:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.46 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:40:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

