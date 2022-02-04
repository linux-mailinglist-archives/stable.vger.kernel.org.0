Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571EE4A9D7C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354942AbiBDRNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbiBDRNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:13:18 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C309DC061714;
        Fri,  4 Feb 2022 09:13:18 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so13683544pju.2;
        Fri, 04 Feb 2022 09:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FrGD7DV1bQB7CURCoe3X9HrWEd0aORUWWP1IBOvPLN0=;
        b=dsqlbeDRpF0iwakhqKyGxWF2q0ul4tkUq782BeerniBulZGpdg96H3NRm5srajo5Jv
         P07g9npCDY91/EkIOQP7C8D+WHEAPZNLkepGVpZ8gBSXCyUIVtKbMueI9NRITIGONBTY
         /xcG4YPW5MmZGSTN4qLyd6yO3u5nfghgM/qZ8iQnQFC4pnTyYAEjr0vqWXRQfnHWB0iZ
         FxYIY7pxjLhoOnOrKf+IjnEOjHUhQqf5v7dt07FW3GyE0Xmdp6+Oy1MliWZM7AysqJPF
         5VG9lSmntobS6zLppIfDPcVlP8j7dNFZx12TbhjDXLxEdUrlvxIR6KdrmrneSHEhMeo0
         Clbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FrGD7DV1bQB7CURCoe3X9HrWEd0aORUWWP1IBOvPLN0=;
        b=aSJWsxefUTOGoud0z67glsK3QTegZowkS56BX3yxLGFO1IsAr40lcFbXLVb4KG7T9I
         ZYFTwsueLCnmbSj048L0uNORhj9ZrvKxcwQ6lPAjRD1IDNhVdxj3SpXivVgX8QraA/5G
         FEFl4B4fjS+dWENonsKaC6uLkZzcxpdAtEhJwWMWsjZPP2QzobhPY9Vfrb7EWeUFTmuN
         STTXVJaumvLP0fXRc00lN43u4rp7k90mkE0JycqVqFe/eOssdsg5zLTUn2WdQV8YR16h
         W5/B7c9BtuAiSsUfqN3Scj+PHH8Tf6mBzgI/PF3kCVQ8dcDMrrQTAyhmQLztcfSZJMkG
         CvGw==
X-Gm-Message-State: AOAM533HnnJS96Xup9L23/yRsfrrne/w4r5uYETdAAT1hP8iNWL6wvMw
        vR0q9UBlvyHz8Z1YxMNvIms=
X-Google-Smtp-Source: ABdhPJxZMLdv9ihGVBu1mWoFpuEw8yQEa845QlRfu47bQjLEXDvEC5UfAnTICFMefej+p3yehYbrdw==
X-Received: by 2002:a17:90a:5204:: with SMTP id v4mr4243927pjh.47.1643994798062;
        Fri, 04 Feb 2022 09:13:18 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j6sm3329011pfu.18.2022.02.04.09.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:13:17 -0800 (PST)
Message-ID: <5f720d97-83d0-9918-1cc9-b86a6bde39cd@gmail.com>
Date:   Fri, 4 Feb 2022 09:13:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220204091912.329106021@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/4/2022 1:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
