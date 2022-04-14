Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF495019B2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiDNRNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 13:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245514AbiDNRMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 13:12:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B32C114D
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:03:17 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id 125so6031839iov.10
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OllXB12xYj2oLW47j16BPRteV5aGbcg+P8qWGLzVFgo=;
        b=Sg9Oj6fVMqHx4wGYatrCXwfVrgDCBdgSBuV8CJJEMxfZS8ADhOx0+9774BF3P5+0AX
         Y8VCnYXOJcbJNV3sIzmP2ZmeMkENdnB0B/S5DbU4fN1Jddewi35fOaiZ/4Vmp721Wefb
         kPLzUcZIjf8pTCrst7E2EVKghHegWxZZQOxOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OllXB12xYj2oLW47j16BPRteV5aGbcg+P8qWGLzVFgo=;
        b=DLkubLaL5W0/r+2mkLX24Dh4MlkgmKt3+n2jCy3QV+KsGO45k0/eJ11oKN4sRjLL56
         A+Lcxvo7fMdpOHyTriWkUqh9HzRtj/DjjrHZx18+yDNr2k0DBWTDX0zZ9+GgrVLSK/WA
         ovxVnDhVsqx5bcUWKSbynfG7EYjzjEeWBHGYlLZ5JnljqBwR0FLrlRM+y+VkfQFU000E
         IhV43l9/bWIAfUa4aqihnL939qHOJRTIKkJu8EfH9bg8cSG2W+iitVxYanBAfbGV6p19
         vNy5lhVkVJAdP3wdKiTumnHgzjQjH5Ee80Pv5wgNB84S5anW1Zcx3N8rRGWCltrbCwoq
         epTA==
X-Gm-Message-State: AOAM531cYnhAlhJEQzVarM2bWzr3aeCaVPAqXPXSdopjzln/v90JBY+V
        lirn6kJQ7EEJNF8EBYeXwZkTag==
X-Google-Smtp-Source: ABdhPJwOfVPfya7xmiCQCpcRTJlx+/Ql+vs159c3+lqXwm1y2ZbNR8soXx4bWU1pNLUROi+wtJweeg==
X-Received: by 2002:a05:6602:c3:b0:64f:d28f:a62c with SMTP id z3-20020a05660200c300b0064fd28fa62cmr926382ioe.212.1649955796950;
        Thu, 14 Apr 2022 10:03:16 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id b12-20020a6be70c000000b00648f61d9652sm1445108ioh.52.2022.04.14.10.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 10:03:16 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fe30f230-f642-ded3-7ca3-f70dffcdd8b9@linuxfoundation.org>
Date:   Thu, 14 Apr 2022 11:03:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/22 7:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.238 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
