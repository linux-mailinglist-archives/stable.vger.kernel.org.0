Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644A93DAF74
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 00:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhG2Wtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 18:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhG2Wti (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 18:49:38 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318C2C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:49:34 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id o2-20020a9d22020000b0290462f0ab0800so7484976ota.11
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m4QLGxadq1aF9ze44IvsZ7ypWAHaFI/cSHt14ZhTQGA=;
        b=hs8lssGdhuWuwX5iFZ02FPdSj9RHOLesvmnAdT1k0jHtSjqGQhygBvVMLNNZXRp+wb
         wbLlyGVTDr1AfHa83Wuf4DyN9MOuDO0dfkab+CTATkR983s3knDxGI/tHCfsTLWwGM6Q
         nhqedDzLrLp9i/EshdS4zHvOxC7N8Lg4x7mfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m4QLGxadq1aF9ze44IvsZ7ypWAHaFI/cSHt14ZhTQGA=;
        b=Qvz30VUDByqozK3OOFwFkf3tFonyzmVgjVqPJF9+RxGni/Q8tw5vXcN4DSa5zFP+29
         5KGO93wXIZx+LW6qpGC79/tjjphqTjU8mB4e+s3+eeb5WN8DFSSCVDYHEiTFzRI/xhgx
         rhIRtEEyvf+F4QNG0+4kpDCvNHM3dZEo7/9DmCfqhqvaF7r1/zWsETax0eNjeaPBKJou
         Liz6pPTzA+csXCTdtQCHB2/MVpuI/NswYbCg6eMSn6CApSkGsnYDxK2Q7//z2ZGadnuS
         nDHPUFhVhITMRk5a0Lqy4veaaoN/ZyNFy6D+UiNOH0UETuwm1XEM3nA5KZTxqMfjg+iJ
         1f+A==
X-Gm-Message-State: AOAM531Xm3jApVOnW2BcyHwYZ25eQUODaDmEnmGtNFSBEYeH1TsP4704
        0Jz6J1QArojSnWveH6YlRaRldBjMYLPFWg==
X-Google-Smtp-Source: ABdhPJxufXXDfhR5UwT9/d9tY9+03c6eK/GzVwZLjDuIVz+92WbBjFLR1aSdc4y6zs2ly/uF7YKfPA==
X-Received: by 2002:a05:6830:1e96:: with SMTP id n22mr4953756otr.11.1627598973583;
        Thu, 29 Jul 2021 15:49:33 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r6sm750930otv.0.2021.07.29.15.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 15:49:33 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/22] 5.13.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a2cd7185-f87b-82ef-d321-4a951878546e@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 16:49:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.7 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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


