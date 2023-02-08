Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4276D68E59B
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 02:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBHBwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 20:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBHBwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 20:52:14 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCFD24489;
        Tue,  7 Feb 2023 17:52:13 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id be8so17659052plb.7;
        Tue, 07 Feb 2023 17:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aPilZBrvyzgqjsmqEP8Qm1Zad9diYGZYlfH9HP2RVME=;
        b=MQKhOHJts6z//UPEl+WhIfzfwHlZU1MQJynwBlxINA6DXfbAYZsUyjQyKjMrhJsudh
         P82X4M9ssJAOFwHETUUn8pyMebXnTTRrR3bG1qV60hNilJaHNdcPq4MSiURbedW3jEz/
         eVhqmQYFwC+gOf8lMs5HtsGqpF4VOIJG6ScjHfwd2gzAT/9PS7mHHCd/sFIsKe+mQe1W
         J4kQ5c6LAI4wwCEDr9p6pX7ZbIQ/HbyCD1LKOTHy/spJKT0QQwANX47Wbd9mbuHpzNkq
         /o7yxEY1yTO1v1O/RbY9T0Ly3vM2Oi631BVaLK6aRJkPdkmkHc894AHlx0b9iqtlQO2E
         VBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aPilZBrvyzgqjsmqEP8Qm1Zad9diYGZYlfH9HP2RVME=;
        b=zZWbQFv4fiLyVr6cvyBwQD5YHf3irXOuhzz1SNq1O0zq3dLm/13tGP9fsI0B7S348+
         RZ6LWwNxNcDe98OOThP8zVvUWA2UgAQhuY4n2WkbcajGj3Ugt5VioRPOUw0VpD4NMwu4
         LEvMLKWydyma922kK8JCCYGEgQeZCUkMdSuiH1MlN78X9P8nbRLiZ9nxE8URMr3UHFi+
         gv85kCz9nERnScfKeY7/wUx3iv8AmCxBTefCrQe9XZ7Y9pbs5iG/npQwkrMceFlVrf9Q
         RW4I36aUMusY4RfL20pMei0Q8bH54YNccI5EHrvcV+Il7Tm+JupW3sxMRkyfcj/DAdUb
         2wdQ==
X-Gm-Message-State: AO0yUKUy+CaQF/0OE7/wZet/STRugUpQfr8uYrvTzlQgZKGQj+MVh2RA
        t0c7eJbGv0hKt/PiKYRdyFU=
X-Google-Smtp-Source: AK7set+9+THITSv0u/2MrM0c5aqwptCz230WHuS/r54mf5+W8GrlqVJOGl/cdgs1q5bio5YyJqu08g==
X-Received: by 2002:a17:902:f392:b0:199:48fc:3dcb with SMTP id f18-20020a170902f39200b0019948fc3dcbmr183954ple.68.1675821133051;
        Tue, 07 Feb 2023 17:52:13 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b00172b87d9770sm9641676plh.81.2023.02.07.17.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 17:52:12 -0800 (PST)
Message-ID: <a8b73e1a-8909-b316-48f9-b83fff322fc7@gmail.com>
Date:   Tue, 7 Feb 2023 17:52:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230207125634.292109991@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/7/2023 4:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
