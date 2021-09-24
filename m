Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C2417D4B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343677AbhIXVyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245112AbhIXVyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:54:45 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E3DC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:53:11 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id p80so14447339iod.10
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 14:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j3aWjaIPFonu8drIIteSMoX3XKDl/3kctB7jZVViw9E=;
        b=YNvqXOFCWGuz/iLbjCk/707ApbmVvOmJrdRSl5El0t6mUAdJkDs5raaNvQGh9wpSbk
         oaQNzMmLmZLiV9zmyCzlt+D4/hT9poN2+7SuXxyVtm/aIgll7//qolaIkMeT7+QHpv0g
         UgiTXkr9TfCL/RXQURmD5X/jhJfwytj6Wlfnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j3aWjaIPFonu8drIIteSMoX3XKDl/3kctB7jZVViw9E=;
        b=k2vCab2ciXBeUxWmqiEgOj4gtB0/Qr8i18gmePkIW1WFanT2wFbhXohzoycDjXA9lr
         GdehvtZ0TZStGm0HXtIPUe34qBorHOG++oMoPFcCGfPrBWkYGqPZbFVQVmKgHG1UpQ0E
         eHotpwqpS8nl0v2ko59o6eGhFekRsz6qQH52zZJ9Su+aY/ZdyRfO0iPr3wGbsOEytKfY
         M3lkti7SaCQZ4Txk9aPm+DjNqFcTuAFbtwUEk4LwVTqcoV1IONsdlFYq0J/Lnwa0QEFN
         koVvnj+6FM5MecwKD9KlTz8GB2KKmlobf9nRFUSWmbl57G2Y8LTTIL3M8zuNuFxyqXl0
         XsHw==
X-Gm-Message-State: AOAM532iqIkiXGSUCZdsOqt8khemXdEZI11/Pm9hbW6CV+nGnyemTl55
        t9MaxIVwx4b7g/BioAA5Del3Bg==
X-Google-Smtp-Source: ABdhPJy8wpIq3czR3fhaDw667P00I7yb/Vh/uTA1McFUzgqpew3vsVwvPakZuHGn5fmFXI4f/c8EHQ==
X-Received: by 2002:a6b:5d19:: with SMTP id r25mr10929688iob.11.1632520391376;
        Fri, 24 Sep 2021 14:53:11 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o11sm4629729ilq.12.2021.09.24.14.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:53:11 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/50] 5.4.149-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0e3b468b-4810-bf3f-9af7-1863fb42e6ae@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 15:53:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 6:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.149 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

