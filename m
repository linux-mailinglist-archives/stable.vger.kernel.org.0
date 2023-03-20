Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13A76C2551
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCTXCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCTXCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:02:03 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8421F92B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:02:00 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id o12so6189613iow.6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353319; x=1681945319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ol+B8Rm7LVaQanwklijT53+0nw4R6I7B4CbLiSGN/Pk=;
        b=PR98NuIACi6GbtffTTQ7GRyP4Rm4we7JytqtLL0DNMowMIpj6lwi+zMMLMW357zcV6
         YdebfM1/BAdRQY3RkxPHtNVbJ0GYit4yBNH7E1whw/0NeFAWrn4AEkkLVkT+jZmar9oD
         SSq8qzXDLWndR0TLSaixDGX1C/o57uvdI+4N8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353319; x=1681945319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ol+B8Rm7LVaQanwklijT53+0nw4R6I7B4CbLiSGN/Pk=;
        b=fRqC59Bs40s++zRsXaxYC1fPG5RkbU3k78eHyhJtcvZh/BqB/cLw+zhOuI8OiO1Nea
         vNPeCHqXHYmsQp2CvRTyld4aQPwTYVn4UstjbXZB1l2LGc/4dDZXbtxaCUmiyI331Tky
         qqyy9j1b1Uua7OVYP1HWx7UjnILUHM6qgchEnJ2yrs1ghkT/XvP8D74mvnEcAJ1rDKDm
         kQNyvlmIod1L/XOXpsL5El/XwzqRTyCRTi079poHpdLZEc3XeWgnW7K+b6E6bm/YXCBt
         6ozUhbXlPHQ1IhMYIgk1ZEgs23+0B9Zd2kVIXv+xvFURZBb8Fr91j8CUtWqYcHNs2/CN
         y2xQ==
X-Gm-Message-State: AO0yUKX1XTa9WCCAEkq9nmYg+Zhw/VpaTIlNKDTjq8yq710ZwmXnbXw0
        DJQDvk5Ns3VwqTwMPbIoJObcyg==
X-Google-Smtp-Source: AK7set+J2U/lAYm7gRWd7YMrfKnfYIGgwX40P085kk4oMiavf4S1Ehp5iZ4v8YfjrYKAmn+dfxfwDg==
X-Received: by 2002:a5e:c817:0:b0:752:f9b6:386b with SMTP id y23-20020a5ec817000000b00752f9b6386bmr690135iol.0.1679353319570;
        Mon, 20 Mar 2023 16:01:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g21-20020a05663810f500b00405f36ed05asm3553624jae.55.2023.03.20.16.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:01:59 -0700 (PDT)
Message-ID: <9d8e16ec-4336-f26c-a132-d95cdde2a4a1@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 17:01:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/20/23 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
