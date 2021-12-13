Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327154735D1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242841AbhLMUYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbhLMUYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:24:37 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC1DC06173F
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:24:37 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id t19so24749485oij.1
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yBOA4BhFTehhtKBvHghdU0WkM865m8wFFvz5TFkMyVM=;
        b=E/5qAtTBteEZDyavBDa0gtsF2m0B9WGtHey8KDZP8NEz6iS1URUM4lyhrRX2oPpKrm
         etAJYfJ/8swEOFSVXamvYENTi3OKmCppiOrJDHiGLJ/z3njh5lJQN0DUPOQX3OOmm9Va
         bito70TKvFcPIs1LPYzS9ttvqU1x8poz9uD3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yBOA4BhFTehhtKBvHghdU0WkM865m8wFFvz5TFkMyVM=;
        b=j46VNsJDEApJXzUP2CYi2qcv8g3ampeTSte97QGc0X5E+RrY+VfmS5n8jbi0tl+aEW
         p3IxY9J3fVZ3Qj4OLtuSouxoGVc4oBSFIuQ4DcpWNxDx6OzaBDQchjgYTBhkwAdZhZvN
         PjbakOSZp20rxPFclV4JJ//vqPITyRIlp/4ES1ID1EyvsOiaYl9eZ3US7IITWVr+CjmJ
         fvAPBoXL860/8H++ql3wGxV7bvaQrEj2gam++O9xYkGUsacT5CaV95bkClLf8QYjsPSJ
         oX1drajAWwpdXXCEXbixArJ7iuv0tjZ3ELJnivgio3HlQuZsv4GkTvq4H4UQyfgapi44
         TGbw==
X-Gm-Message-State: AOAM533FoEVxujmBh+OPFhzpt3GxztSEImhsJjlm03BnJNyQpYQHWQn0
        gKkHiPXyZXPWNrYukROUUlABnA==
X-Google-Smtp-Source: ABdhPJzmA2VivFPjg4fSmn/3Q+eM3bwvBA04XOOZMn8aO6wzJ/DjpYjp8gTx3pg2fDMEm3aIsAxa3Q==
X-Received: by 2002:a05:6808:1509:: with SMTP id u9mr30937702oiw.13.1639427076687;
        Mon, 13 Dec 2021 12:24:36 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t14sm2376404otr.23.2021.12.13.12.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:24:36 -0800 (PST)
Subject: Re: [PATCH 5.15 000/171] 5.15.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <53db7b0a-36a4-62e1-5541-8502d60505a3@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 13:24:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 2:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
