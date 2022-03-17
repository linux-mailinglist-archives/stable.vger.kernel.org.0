Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2B4DD05B
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 22:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiCQVqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 17:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiCQVqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 17:46:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158A470926;
        Thu, 17 Mar 2022 14:45:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so4329705pjb.4;
        Thu, 17 Mar 2022 14:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p5+eZDglu4EKUlxv0zc13FPQknv4EGDEYm8BXQb4bsA=;
        b=BskcsTqsgqPHPDBSmNkr7htimjAHhaloMoml//5Aiy7W3wSE9mq2GAbeCZyKPczpOY
         wuOKOzY0JPACbCBRUt/iTjhgiO0aS+SYbuyAzplPlIv6bd8kJdQ6wq8e7uz7asFbQSCw
         FP/garNOcbV4QOi/X8W1XyOsnV8A1vLuiMm7jwbWo7uhhyfZZUFVcnsjhcLmv2HqbZts
         Ud9VYEsS+KtePh7nJq9MitSIuwyv2gvEB7MSNIUZQL60LtDmP7kxIYNmCAZF653ajV6q
         fGIL9VUEt58vjS+84JghS7o4SQeqOVa/DYpWWS7wUjsdARbc5YGnX3QEUug21KypmEEw
         XcdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p5+eZDglu4EKUlxv0zc13FPQknv4EGDEYm8BXQb4bsA=;
        b=BnS4UZThdm0PUviPUtbORB96wIjiy1pqnh2sReKE4k0lb6coP3/b5k3vN/OD8cjzHT
         tqb3Cq6H6sVyZlSbWKImb1dHujcvgVp72y7YL02LOUNVuFl04UBDHdPj7PUq0XVWyQ1O
         gr/0nCr3ivMKubTZSLdAR8T0FrMChDSRt4SfYnbOEZUEzqLlCgAHpI4U8vNZxYs+1iC5
         LL15g+DRg0+9jyD9PxscKAkO80sWC4Frn64AvqRjwFvMDdtCtCv1WK5q1pB58eGRJhoU
         Q8BHp4+rINhLFX21yx0Z8OdltGwVgL42z8kF//Lg8H+Y1OjkpQBLFvVW6oEh6uVVzdNT
         YjVw==
X-Gm-Message-State: AOAM533pv6TWnv/8jsuYy8TL6+H9giige0MmCqnLEHT+zh+8TwmrHP9N
        D2+DlCAS99HkqpTsDrBR+r4=
X-Google-Smtp-Source: ABdhPJzx10dupLMa89vx32h+/JMVbkplGu+bjEiPayVIz6rV/99dylBOZ00u+LigksleSEv4eA2Jow==
X-Received: by 2002:a17:902:8f83:b0:151:5c71:a6e6 with SMTP id z3-20020a1709028f8300b001515c71a6e6mr6816804plo.126.1647553518560;
        Thu, 17 Mar 2022 14:45:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o17-20020a639a11000000b0038160e4a2f7sm6431633pge.48.2022.03.17.14.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 14:45:17 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/25] 5.15.30-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220317124526.308079100@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b9b208df-853f-2030-1167-0cd473ff5289@gmail.com>
Date:   Thu, 17 Mar 2022 14:45:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.30 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
