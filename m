Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8D657A6EC
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiGSTHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 15:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiGSTHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 15:07:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8174F45048;
        Tue, 19 Jul 2022 12:07:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f65so14312971pgc.12;
        Tue, 19 Jul 2022 12:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gH0BuCq6HoPHC1pgL5wqDtOmN+mBvEBTY1SpqMIIaSA=;
        b=TrxuMUNXFyYg7FnaWymyPObOFpQWc6fcYOspgozLql8SuqgPCDjWga4ZB07zFHQBKD
         1A9WpQF02SN0Dl7CGlN6dm7jg/96arw6K7WIENh7G6cbsB5Du83eowtgtpWoIWEqLOAn
         vIyniH8BnynKG1ivLwl2uBU8wf+3gMRbsLx5N8jOPuQ0H8MDUKdWQg+AozUf0WUTkvE7
         8pdResZU5iXYYMRiXv4Ou99eN//cAW5Q6tCJug2Fom+hSY3xcFbK+q23fmrtBP1EPDgN
         blmCDRwnFtqDAwJqGD7HiryPgckJeAiuOTmb4rLDz3MA2EJ94lOybyMmQkumMatLKMQe
         Vd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gH0BuCq6HoPHC1pgL5wqDtOmN+mBvEBTY1SpqMIIaSA=;
        b=uNSE3rEsgymjROArps92ksc8SQv8e6iQlCvQSnRozYz4FdeN8TjFoZZxy1Uda53h8b
         5KhkT9wCTEJDZ66M6c2vglXpwzaFfuIxk/sfG63xqSDfPwAWdNz1IcALNp7B+MXJ/05s
         AFXRwOTlUAjiSNc+KhxEbbYCvMcDyvEz+22Tma/8TNNNCFzcIlJhncfXJAR9ALNlHJWE
         4qs7esK60Hgu5Gb5E+LDCBaUWr+FvalplF8fY0zq764m4L+VifXjyO3THGZOR8sYqxhl
         XVTEA2/AaCt8cZVY9AIeQJk3qMe+iuuqKoYLryrhaq6brvgSxxStI+ZAcWSa+cvsu3qg
         FmBw==
X-Gm-Message-State: AJIora9rQ0/o674QndHZDDTAA1K/5okoYiREew0XVUJvpBUuhIjQKYva
        +vhmIlCNdhKXp1qtWyyipVE=
X-Google-Smtp-Source: AGRyM1vb3qjtI7WqBQv/fwc/DJdnlJreaQay2HLgSd0IgBdVVvbtIy9lr+g3haspM4owafe9Fj9UrA==
X-Received: by 2002:a65:4645:0:b0:419:9286:4c63 with SMTP id k5-20020a654645000000b0041992864c63mr29187166pgr.582.1658257661861;
        Tue, 19 Jul 2022 12:07:41 -0700 (PDT)
Received: from [192.168.1.106] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u23-20020a1709026e1700b0016d01c133e1sm2394971plk.248.2022.07.19.12.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 12:07:41 -0700 (PDT)
Message-ID: <9df8cc41-bf0d-7aab-1a05-7d9632de9e0b@gmail.com>
Date:   Tue, 19 Jul 2022 12:07:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220719114656.750574879@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/19/2022 4:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and built tested 
with BMIPS_GENERIC (bmips_stb_defconfig):

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
