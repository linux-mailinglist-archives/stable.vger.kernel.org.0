Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EAE5BC0BE
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 02:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiISAAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISAAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 20:00:19 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DC513EA5;
        Sun, 18 Sep 2022 17:00:18 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id j10so16855601qtv.4;
        Sun, 18 Sep 2022 17:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=eZTV+zU2oTiRAq097+BWcDFn03WYIXYwoyBgocEInuo=;
        b=gYsMSf0j+6vFWMRAIwv+hIXHVZJOKkqXyShHjfdCk9/PCcCoc6WO0MICA5AFcfUE8R
         nuNU+FVhvhDZ8EVaCAZKWRR/2IPxzgl7sOPG4bhiSkk4tA7Cy87GvC2Z8kKZYZNSuVr9
         yhQNTu0UXjA6LE4AjT8xq8mvyNJUSwYdhSpxB0eXtVFkW9OOMQIygibaVwFO4nJ8gQRK
         sCjLjHT7Keq6A00oQYjTMFIga/geKe3SJc8rK8G8+Am0MkWYRjSs69r6hPjpBZBG1JWG
         tGHrr+XmQrHpHqXkxNOuYreYLUCSx7QyEEDrODFeLhfzsjOT3t4dyltialC8csBkEO73
         XDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eZTV+zU2oTiRAq097+BWcDFn03WYIXYwoyBgocEInuo=;
        b=T6eDUFi4JVEcWiOt2SwJynVUtFLfgBxJA6vCsZTj/ma7eAFnfsnS14dzTv38+iXa7g
         DhWXjO3726k+IDFo/6cDX9ZF+ncyMV2EzeSdKKhMmja0EepEwXk0LVpronrxt9NsFZbz
         OSn0MqDsIkrT8E5evmtnHt36w5UoFOyw2nrsaAF0Nmj79WWwcUfQqCoj9rCW3chag8QT
         S0DKOGsNKV2ipjW7UUw+c29CXpRTMjo7vhB2CCCeylL+KTJN11WDfpaN911YN5wpp7VX
         YJvx63qN03oBTHXse7lQvJ903+le00EG2zm9r5RHevczKU5V5/V1p4x+5TZDeB3Pu2tR
         SpCg==
X-Gm-Message-State: ACrzQf0TJpjkzJQiBwF6sqU2FDm8VgHaNEznURmJVdqx1jXBduwdrGkU
        X7zp68O053WhES+sq/2CzNQ=
X-Google-Smtp-Source: AMsMyM5SDDGit+x7Zjyrv1fnhH9YSnrtdyBdaJpRaFYH8TY0KOGi6vyya7cybIYeIroIgiXTFyVpaA==
X-Received: by 2002:a05:622a:1014:b0:35c:e8ef:a406 with SMTP id d20-20020a05622a101400b0035ce8efa406mr2443659qte.306.1663545617746;
        Sun, 18 Sep 2022 17:00:17 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bn29-20020a05620a2add00b006bb2cd2f6d1sm10897123qkb.127.2022.09.18.17.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 17:00:17 -0700 (PDT)
Message-ID: <876fe0d9-b3a4-f6c1-d08a-ebad9387d50f@gmail.com>
Date:   Sun, 18 Sep 2022 17:00:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/35] 5.15.69-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220916100446.916515275@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/16/2022 3:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.69 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

