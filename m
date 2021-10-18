Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDF4328A9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhJRVAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJRVAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:00:44 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08065C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:58:29 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id m20so17835595iol.4
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 13:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8STVqYr/Jmwq4qCjh/zNbV1P9B2PnMueUOQ6ZjRS32k=;
        b=Z/PfNve/Ggh+wVZeyvH9EtPF8IP1fb60gM0NvyM7JulVZqSPSm0T3WxESzwDSXcKoO
         uaYs1T6gEfZ4e7YwFVLTg0iI3xzknm1iZ42gIGvZMJ6pQ7wmQkxha4Zzx2vQv33hlj1n
         ND6coLKIgN0ErrOcBSAc2Y+h2Goc6/9tJqLDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8STVqYr/Jmwq4qCjh/zNbV1P9B2PnMueUOQ6ZjRS32k=;
        b=DMzi4oA85A/WrkjUvyZAckdYArlKpznltWurFU2Ss2rSeKgPGKMmWdC3n04mueZmR8
         W4wO+z5lze8X7BkvLhMziW/+7EnSw1ODYYlqxhpUg47wp7rAepuDsP/crnQc4RJJ5G62
         6C71tMH/ZifbY22nSc07pwqDoCRKwWFLj4zLXSDSSs3b6fIpQTz+DRalrOQszty1oLMh
         mt2eC+SBjl4hj0jEiNiI3QyDz9ht1pf93fYcLf2/lTVVi/ZsTqRXYX/3q2iyzwhgaGWh
         QJ0lSupuYZ0ccG+WLvdMegMLpAJQ7AZ24GnVp6iYlLiNDj88i2cCLwJb88Em0S8NSZQ9
         eG1A==
X-Gm-Message-State: AOAM5319pEzBhFywmOO55E2bPSPzsATK/WoZ6T3jb7C30vPSoPYnpyXk
        gSw3vVigvTVO5QZKErzIuae+wQ==
X-Google-Smtp-Source: ABdhPJxg2F/dG1IX9FvvVOA1bv46e2hQLcwnhBGqJuOxCll1Pv3Tym7OBOZQZh1Wn4YRsPBHBZFX3w==
X-Received: by 2002:a6b:f816:: with SMTP id o22mr16777204ioh.106.1634590708444;
        Mon, 18 Oct 2021 13:58:28 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a8sm7061783ilh.5.2021.10.18.13.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 13:58:28 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0243cedd-712d-bfaf-7895-6659922703e7@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 14:58:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 7:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
