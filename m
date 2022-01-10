Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8643B48A070
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 20:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243142AbiAJTvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 14:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239531AbiAJTvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 14:51:04 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F16C06173F;
        Mon, 10 Jan 2022 11:51:04 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id pj2so13631348pjb.2;
        Mon, 10 Jan 2022 11:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7nQwFvWnXEWIg2fQ1lx9zAVox3M6SG5MqAj2k1cYbzc=;
        b=SLIePsHkyQTI7kSGSYbXczT8SLyE+S3bFu6wUYPBktqGnCZNU4DikRQdvp1NrA4TSn
         L/ooJ76caUKQ+bUQKhPuGOXlHB8Vo3GGiyY8wLQq2IMZtgBYu8349qKGD+64RHBWb6oV
         PeVRi1HV+6M3q8BfE8ebN7HDTPCkWMX/SdkC2DX9nKGqRnaYLG1klSRFrDVgAE1H538G
         NyDkxOwCvWorGhhkIIgnq4cKSvFlUL0QB22LWVGmg9ssWxitgM3OlD3D6Ay0ejcFNAn0
         zxpaaajda4BWkDJ2fzxugKjjWTSN6OHajX/ThDhPw9df8HfobtWditKiWXiIOMPvap6E
         2TZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7nQwFvWnXEWIg2fQ1lx9zAVox3M6SG5MqAj2k1cYbzc=;
        b=mH0aYGGgEKjsjoYz2k/0/8F6D5he/wLwI/iFYrS3QgimcgWbSnsSLYIKf05gXDeHKP
         WREu/oPeFoSrDGv3O9AFBV2ZwxuUcdcnMTAfWu4blw3qERrwMP7EQb6X3ugDpG1yw0+T
         UrW6KRNIEQS7OoMdizlUaj2OFo+gJTHCRlmVP77n8pn02XGvSxdwxbqp6gRa88PdsFvE
         INPwB+sdhcfEfPCN8eIQn4PQ+PoEV5ssLBpk0y8i3xeqPZ12iSiKLEIuORaLiFdqm7wE
         x33ZH90U4LfUFMXFp9Zd/QzL3WUmmifcc5gBMw18pSWITCCsu0jTOu3W00bHbDUV67xR
         CAuA==
X-Gm-Message-State: AOAM532w1BWZxIi/qowJD7CpCaF77VLAoN6PAPYr2Q1XQ/Kjr2ByfxJX
        tF2nvvRlfRuMOVHEEc7YzRj/o327oCU=
X-Google-Smtp-Source: ABdhPJxqtke/V21bxwhHLPeKsTlgT2qlrJ7w8RcHGbgvl5OZ88CpuTFpajH3dimOKTwce2eCdw+Y8g==
X-Received: by 2002:a17:90a:a105:: with SMTP id s5mr1359942pjp.170.1641844263258;
        Mon, 10 Jan 2022 11:51:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g16sm7900493pfv.159.2022.01.10.11.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 11:51:02 -0800 (PST)
Subject: Re: [PATCH 5.10 00/43] 5.10.91-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220110071817.337619922@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <23b2e45d-b642-a5df-2b68-f4f11cb1b4f9@gmail.com>
Date:   Mon, 10 Jan 2022 11:50:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/9/22 11:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.91 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
