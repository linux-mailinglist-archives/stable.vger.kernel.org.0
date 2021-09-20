Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56307412CF0
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242464AbhIUCs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346993AbhIUCZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:25:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95080C1E2269;
        Mon, 20 Sep 2021 12:00:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so146155pji.4;
        Mon, 20 Sep 2021 12:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWqo4o25WJcX6VLB9kZ3eunxoV27J+URstmd+miGkGE=;
        b=dskCyiCJJkWRNCQmLFng+qJV7sqv5sIolcsDlHMdpAjnltxIreMF7BoiCDwGRAkBA+
         3VlLHTFU6seQYZtfaTlTc/TbkZMiD1rlZfMUqv5dEs3RGE14G6uZ0BH9FOpo3LZfbFCe
         kFI7UGA3sjOL1az38Ik1uw0y6RuQSWtb1srx6FT/MJ9kFC1+q0SQRcVf17tgKV1EDW0P
         hEwFwLpQZpb3pza4WfxPAAhSTcmaQ5cL9L5KJy9W2DCgt7bkEKV2dwXmuvU/vuZB6Ive
         SyTea+OKongBqkjf29bZTiyib0ERXeGQlBFYROIT4hoeKItqqeIXNAMZCxbWTB9AfiGQ
         3sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZWqo4o25WJcX6VLB9kZ3eunxoV27J+URstmd+miGkGE=;
        b=vMNHT+dMOlsGtBQPe6BBzXr5MhPazZ23gtD2iUeLa+WdsIGp56i5iZxOwFjyLAQLrQ
         1JwflUbwfDNnvk00NT65+FqPYut1wkEicgwtFc15coq5jLKIIMg7fo+A4qpcm2xjosdG
         2VWbp1IJwoCsH5LGu1raGvCjp1bneeK7Zud2qW25UPel+5fkBzwTCy8i/p3+32fH1Ffe
         vNHOr4Pk9iE6rEGUiDwdvJ2Ey4HLmnuQ030xX9hFFpde5dU/dXnZaqJfPgPw3lmLF3dk
         Cr3GxrExRuIBmmMkbalNsT1ID2PqD/LatSbmEIduLASlDKgyG3UqBXSBTT/gDm2i518p
         mwGg==
X-Gm-Message-State: AOAM531XM6mfndwiVdayGg3pjilzYHcV/z8InrzXE9bZtTtLx3Ipn5i+
        MLBi0MK4F8cqnkfddYkFCNncwYLTqt4=
X-Google-Smtp-Source: ABdhPJwAbTudI4WORc4tK0sVOLS51Bi66U0tPufeUQmaMUdiIhWsHWnOgaWir8BiDWPqZITAj10rNw==
X-Received: by 2002:a17:90a:9317:: with SMTP id p23mr564534pjo.151.1632164447669;
        Mon, 20 Sep 2021 12:00:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q3sm106706pfg.49.2021.09.20.12.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 12:00:47 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163915.757887582@linuxfoundation.org>
 <87001227-a271-e9bb-38bc-059279caaf3b@gmail.com>
Message-ID: <513b55c6-0f1f-4a84-65b7-fd05e99c0bcb@gmail.com>
Date:   Mon, 20 Sep 2021 12:00:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87001227-a271-e9bb-38bc-059279caaf3b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 11:39 AM, Florian Fainelli wrote:
> On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.68 release.
>> There are 122 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 

Sorry taking that back, the merge did not really happen so I was not
testing 5.10.68 but 5.10.67, see my other comment about one of the
patches causing a regression, thanks!
-- 
Florian
