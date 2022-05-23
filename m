Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE0531EF0
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 00:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiEWW5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiEWW5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 18:57:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DC01DA49
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:56:52 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p74so13171281iod.8
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X1SWmkeGkSUF/9KeZ0zt+F6Uh6DFUnKj5kOBRkoubZo=;
        b=aEWsiwxQaH6b/ILJ7R2zhGPqyc4MnMEqmJJlOhRIZhBYE5033B4ouGg3H1vWyC5PdM
         iSX31tixi2e/WlaBOVoW2HLx0g62WKEca7BGVo+OVX+0qRGDQ5jmwcNlqNlD6oYXRF8T
         nPoH8auC0ewhmzo39H5Kpzza3zG2fUzUF+s0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X1SWmkeGkSUF/9KeZ0zt+F6Uh6DFUnKj5kOBRkoubZo=;
        b=fYcRLC0VK9Mic9+v3Xc1PeB2lxU67xArtR2+uCO9piequoXFObziWmZ7ZFLMCb2CjV
         DvnUAeex2tOaHua8gTkvDK9s9/+du9MZf0tKtxdAlSYz8l7ocouGuQOyJZJE0JCUaqX6
         JOjymel1M/nDg1U6vRwHbw6P3Jj1ZZzIDHvdMsqaEuFPUUn23b/MHD62v46unfGapWAX
         NAEpqmVsaiVTZizexb5CJxcxthuYiL3Pq+yg18o/ZgBkOGAR4T+KRfCWiKhfN6SWV4ol
         GBJxlnSEB7EA/bKi0PeWxkHns5Pn/coEoWKUS4ji/7Mv3h++cSy51nVkxNeDgfxXR0Gg
         Msig==
X-Gm-Message-State: AOAM533itLdSmJG/8Sm4+ajS6PjmCWnwrzZHclFjMdYYRQiPMq4ukknI
        43wrdWs+yn8KUc6w5+1u3099MlZm0/fYNA==
X-Google-Smtp-Source: ABdhPJxxQN+Avt65SledOIhzbV8PnzdnQ39akjFQrfj6NyunJJDOyzaVDfyxC/6JvYVz2rpFxcCMaA==
X-Received: by 2002:a05:6638:1182:b0:32e:5c70:c89c with SMTP id f2-20020a056638118200b0032e5c70c89cmr12309820jas.45.1653346610839;
        Mon, 23 May 2022 15:56:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s15-20020a056e0210cf00b002d1639e7187sm3533592ilj.50.2022.05.23.15.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 15:56:50 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/97] 5.10.118-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6191920e-30e6-d5c6-460d-1e1b0a0c405d@linuxfoundation.org>
Date:   Mon, 23 May 2022 16:56:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 11:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.118 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
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
