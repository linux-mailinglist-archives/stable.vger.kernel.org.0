Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6252442288
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhKAVXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhKAVXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:23:40 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F68C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:21:06 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p204so11572640iod.8
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K18TGQ4nH9kGKX37x989CqZVv8jyi5svDJyeXNn9jN8=;
        b=SpD3Ov1+FGbs5q+hUb7QigmZepVKpsOCXl9/w5Sm9Vfn8YZjUjykNv+nsmMlu85rKm
         ZMBM6Dtb+Lv+SRGl+jwg3RiGf5t+S3FLNJZYvVHmL5erN4kLWC6R7VfYqO4NUV2VfqcU
         uOsJmAzI8rbYsLHDQMx1EuI8Io8nKyqfe5X4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K18TGQ4nH9kGKX37x989CqZVv8jyi5svDJyeXNn9jN8=;
        b=fIzgiJy93+gPXQq9Tp/gDBYkk0InbstpLDv8CJjTnwGpbRQnK1YxzdV7ySHNPI6G3d
         ZqTOkgXZ4LFTPWhPw3Jx6TVX53AcX1vqU54tiLfM4UadWnOr292HBbZT+0yrf/yr78yw
         RE6JHTmZdBrKPffujxlpmdnaXWC6fFEeMf6teLXri/zjUITt0+MmPHFm70XTOY6NSehF
         tPZpEItqHl8pWQcZXZdsRDev3CY+cNi//Wp2NNhRLT8p5gCZ/7BCJOFXOI7Ks7Ola2lm
         P5yOT23dpsy73aKB3iIhekfsCnowxs5sc73hJauHG9VS2pwEnQBgyskCML/t8MdxR8SD
         yGSQ==
X-Gm-Message-State: AOAM533xBYhf7UJEHeSUKfQPIwZy5U96lD5MMfz2fBZyu9aJi7AnNWEQ
        z+Trv0lrqxiYaXwS5iCVLyD7LBGMqcHUmw==
X-Google-Smtp-Source: ABdhPJwExIUpZ6WzeGXBMtDCKydyXEZee9zs1WzTEJqrsTSm0bKSNy/FLJK4F8dYejrkzwo33pcKbg==
X-Received: by 2002:a05:6602:59:: with SMTP id z25mr20436431ioz.212.1635801665869;
        Mon, 01 Nov 2021 14:21:05 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i15sm5959364ila.12.2021.11.01.14.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:21:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/77] 5.10.77-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4d67fdfc-86e2-ee86-4444-892bc04b2693@linuxfoundation.org>
Date:   Mon, 1 Nov 2021 15:21:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 3:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.77 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
