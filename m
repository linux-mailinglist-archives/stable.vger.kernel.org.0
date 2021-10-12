Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1ED429ADB
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 03:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhJLBTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 21:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhJLBTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 21:19:15 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F2DC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:17:14 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id w11so16740186ilv.6
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 18:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=22UDNeDQRMRsf4J6KSBgPECViTea6fN+IAAnb/JuSlc=;
        b=SjLODv5Jn/O9FzbTwh1WCfNXMTx0SIj330RMvgLmpATICkOY08usw3MJe2TRwMiee5
         g0ZfL5EOuz/bZ1EHOQxZxz58QBQxqbeEfNWfNkUnSzVEINgotLmh3VbinnfosZFOmr+e
         st0IEwpqZ1RvsGokrdYU2F335rZwayYGmRw30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=22UDNeDQRMRsf4J6KSBgPECViTea6fN+IAAnb/JuSlc=;
        b=wt5aRmpz5Z2/1GaZgLRSmDb9bRh8Kg5+tpdWUmyhI5kBvQ9XPNxI/VhY4VXAKrEWH2
         G2qOKl9eQk4+qWY1jMd8b4SstWLHRvpgVQQvnFy9FCgDODRzrsQEb3A7mAiGro944ekJ
         bN8U+dtBB+NwbxEcy+Ih0pQOoEgnBsS6Tyr6pzON3Nig6LR41HmVzyK2dz88nXJ4u2n8
         HU11km/B9baXwfrIzQtABH43BMER98+P52PQmfrSPVzo06Hx+1OeELjEf5saYczuxhjS
         deMmpDUkxnjZQckjgEpOlw/lWJMA0dLlqzAwv/FBdeLoVpHiaZLX5K5cICzRpUYWeo+G
         zHTA==
X-Gm-Message-State: AOAM530M1CB/Uj4c1Y1eqXrLVGTxFvCRo6CVEqTmlDHWZ5LoT/h3nQ24
        b2Xtt3pLJe2ahNNtbdzj69yGHQ==
X-Google-Smtp-Source: ABdhPJztuTgkv9nhNSbSOJTSmjyAOegunllGZPDp0IWj93zJDJF6pG76UysWYHEQjVpN/zkdSHvNmg==
X-Received: by 2002:a92:c7a1:: with SMTP id f1mr4210756ilk.263.1634001429616;
        Mon, 11 Oct 2021 18:17:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l18sm4596634ilj.12.2021.10.11.18.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 18:17:09 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a4d5ca5a-50f9-bf9c-f39e-6d23bb543fe2@linuxfoundation.org>
Date:   Mon, 11 Oct 2021 19:17:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 7:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
