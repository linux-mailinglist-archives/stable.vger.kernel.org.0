Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387A15E6779
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiIVPqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiIVPp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:45:58 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3037AD98EE;
        Thu, 22 Sep 2022 08:45:47 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id z9so7057441qvn.9;
        Thu, 22 Sep 2022 08:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=npCtthBeHly+tK7/LJyNLYN+91l67LV+vAHpLBuptm0=;
        b=jZh1ryPqTFflrdzw1pVlOBIrpK2YtgyDcB43ieQ0TmlO/RJkKmAW4mfUIhezSS2RDy
         TwYFpZ4ye8A0vjI5RBOzYbeYDUn/Rn1vsVQS3e7t40fi+pFNc82f6YtKOwkLS3wmwqB4
         5m01nTy6773hdEbZTxVNsJdxp7rPE2coKUQMzePp11tSDsJMonmVJ6n5Cqp1wN+jPDNB
         W+IoV6UwwgUIVasEElPwC78kPne4iLtopXSLaRfoLeX7HiasafOvmPQ/HQ/D3nDq3u8j
         MHctb7NFaeBuFIieVHmuRkVmLXR8HkWApn5MU4Cuq2oK83IlHvjvSbCSUk1PHKIhV5sm
         cWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=npCtthBeHly+tK7/LJyNLYN+91l67LV+vAHpLBuptm0=;
        b=em5qdqd7IEO+zcIuO0WMzM0z4ytl1Aqais5LqLwHaJ52A1+9eCu946lXD+C+CTGNF4
         e4Jgc6RVJyQPfvscfizPcpGON2FENZZBXZ2TVieH6YmJELzBiB7Jd4c0ZemtVeF6MKyB
         cZg4A5uzKLI+N12kKtBygLv6FVLGKhbx8C1pspqAyH0fUTeQX99xTiuURjo4jXo5KxJg
         TQKHilMu4Weor6VsMo3CoUXaj3hs1zBNHe5keO3C1/PAxqBo5SR9K5mQdoxBEpGG3j0J
         AFZTFHrlOHmzKESFgQxSK92nXueq6GGq83mhKy23CjRXjpVzQ/IbKPtb/qYnKhkNnD2C
         kxdQ==
X-Gm-Message-State: ACrzQf3ItmxfcrOac94YMHBqI1ZREeJV41lTYMFF2NEBCWPnA07ylALX
        8cUDaR5lEiWyR8Qbg6Sqdy0=
X-Google-Smtp-Source: AMsMyM7ODZpkGJ9MFeGSpV5Uyg7XrOb85sRdI09evkS7bhaTMIIDnMsZXgl8/8MN8Ryu4ETbLYChAw==
X-Received: by 2002:ad4:5e86:0:b0:4aa:b556:6447 with SMTP id jl6-20020ad45e86000000b004aab5566447mr3197935qvb.121.1663861545918;
        Thu, 22 Sep 2022 08:45:45 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bb4-20020a05622a1b0400b0035cf2995ad8sm3493460qtb.51.2022.09.22.08.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:45:45 -0700 (PDT)
Message-ID: <f7b97263-d68f-7368-e723-2db31495402b@gmail.com>
Date:   Thu, 22 Sep 2022 08:45:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220921164741.757857192@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/22 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
