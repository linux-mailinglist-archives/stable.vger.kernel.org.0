Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0A92791F8
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 22:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgIYUVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 16:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgIYUTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 16:19:18 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA59DC0610E0
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 13:02:45 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id s66so3478626otb.2
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 13:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kvuWgO+mOrlW1HLdWsiSGg/G55nMQXrfQicWrn8GsKM=;
        b=Id5NqFIhBYN3shKOyHPF6EmbW8IuWdYIQd9l34Ru7GpPRdY2aBS/+lw28ChELEnYVl
         5JxBEY2m7EozhGSNLlQPGtEicTMao48ZrfQa0R+h6/5Nkw8PpFb1RAR62B5r9bx9nBLX
         uRJ4Jpfm/Q9abpQYt+OzQlWf1xR/SyGtFBVY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kvuWgO+mOrlW1HLdWsiSGg/G55nMQXrfQicWrn8GsKM=;
        b=ZRyUlL2h+qeKyEm7wrT0tQoF6iGsZ3HrlDmGMb9KTm+7gUMBhn5tIgDEivvs6CS28a
         fjRopyfXrD/paYRLwME4VRmABp+4fDSwTL102fD7vvL1RAyxf5/VfOewMrZBN6aMGftR
         nDAMeXG43djQ4Pc7RppxG2hCz6lZtmgzs2AxuujJOXVTOqhLuFpUlS+5fPpAfWVtW7ua
         A6JS3AppSrxp53RdyxSN4H1zrko15GXj2+hp57jqptG1ieBoEIOXvo/iB6n5JThowYzk
         tXL+UBZM8FRq8k9VexHCOH6Q3TD7jMJ1lAfgN2OuYzLdRWKx+o3rFHHBxNaQuXdgno0R
         bWdQ==
X-Gm-Message-State: AOAM533HdW2OwL3NTqnz1UamGjihdLijxMwA+4TLTH3Hx/xbGDgIczqs
        VRq4+3JD7VYIA31GM98kOpArPg==
X-Google-Smtp-Source: ABdhPJxteMx/uCqXsJGsO/zeUrCIuslnZ799ur0gxBh/TxtFNgaoukL9bhstY0Qul4U4gDQ8mZggIA==
X-Received: by 2002:a9d:764c:: with SMTP id o12mr1350396otl.159.1601064165164;
        Fri, 25 Sep 2020 13:02:45 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u2sm815420oig.48.2020.09.25.13.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:02:44 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/37] 4.19.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <57b9139c-b286-c19a-11b9-c304dc203420@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 14:02:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/20 6:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.148 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.148-rc1.gz
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
