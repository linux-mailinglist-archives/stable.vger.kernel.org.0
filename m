Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE07D4A52E8
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 00:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiAaXKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 18:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbiAaXKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 18:10:41 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483FCC061714;
        Mon, 31 Jan 2022 15:10:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id r59so15379978pjg.4;
        Mon, 31 Jan 2022 15:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+AFas4eyf4Zh1v28tTIizNCM2qF5or23R3vjZUoqzZQ=;
        b=evzdLdFD/ApdmyNvtQPbdj9gdJQ423guwarOCwdGmve7PIWO3SHZYNQNKUSvq8hRhK
         e50DjvPCFtuFmyu9w5RQfgNr4/iRZ/0QetgfwXIcCP4ZHkM+H4gQkERwyBcMWeb1LXHz
         rXS+ciByR0KD0OCaX01I5fk6NCde6Rfj3xZkPL3eNPw+M9BszqznrnYA+nwHy5hqcLLZ
         DmPilPk0lbilDtEoT1uKDEEbn9zBtzMuPdigSpyedTfwh4EbNw36Efe2s2d9tztiSE6C
         WKIBZdtddQ3vm63UZR2aHkhfWlZIsQDDjIn801WM0xfonxN3St9EC313E0sc7x6AS9y6
         qr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+AFas4eyf4Zh1v28tTIizNCM2qF5or23R3vjZUoqzZQ=;
        b=xZY2G8KJPByyosd1+3+H3mdkgfWxhWuD08ig+Pzr7hUOpGCeymX5D5nwbBBHLWsTtT
         YQioRlv3osuRbhm8mQtttD/ru/CyVUPuFPoNg7waEK5zwEzKzYgWi6KPVOYUA5T3ueaO
         utWTzthyN/3re47m2OUxCvA05Hjl+BCYfe1BJ1kEdPfLJ5Ckq057AKVxm6SttY0EHKGl
         3ZhVSDR9puSX4ig7c2L6xPMTd3pvBId9xLHKFzZmIVvB24A2g3mLQbvagR9oc6b2Hu0u
         HbSyr3kwuRJenAIVqESknlSOHULRezQZYXJ+0TGmlbU/rnn2yL9FRk1TGY+W7rc/TUCi
         i7SA==
X-Gm-Message-State: AOAM530k2inDOypQDbxAUX+KX2IzfVGFOesr40s4ej8wO0HR81P7UMh3
        y1Ev0aWzXOXS+YTfB8l4VkM=
X-Google-Smtp-Source: ABdhPJwbFGJPeXdAdKqumuziuUyNyiMh0kFFaWHsssSAB79/mwwz54MKY/qVfdssnY8SEzltmVGNwg==
X-Received: by 2002:a17:902:a512:: with SMTP id s18mr22793343plq.51.1643670640717;
        Mon, 31 Jan 2022 15:10:40 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u18sm19887799pfk.14.2022.01.31.15.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:10:40 -0800 (PST)
Message-ID: <99993fab-226e-190f-5b4a-54f2b978d4fd@gmail.com>
Date:   Mon, 31 Jan 2022 15:10:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220131105233.561926043@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/31/2022 2:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
