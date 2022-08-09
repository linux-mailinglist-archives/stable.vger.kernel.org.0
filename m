Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBA758E2C2
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 00:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiHIWOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 18:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHIWNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 18:13:54 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831FB10FEA;
        Tue,  9 Aug 2022 15:13:43 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c28so777718qko.9;
        Tue, 09 Aug 2022 15:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=OoSIIGP86FduPSeti5lKZKH5Cp2L8PK56m/1OZAxWMI=;
        b=hJDlzknlpXy0oF13g+XI0QhRk01/uI5U3bSa8Iid443LWBnk4eMmzQ6lMWQIFjgXmP
         DVzQhESbxEDEPRAxls3r/wMDNsyFrhKYTtja2Wh4UnyzOvNqbPpB0AS1F++pgUSNHhIY
         GToFJXqVvo/CdI57XXJTB+UqTpvgNQpaLC7PFTlBISxsW9OpWks8zYEHzC8Na+wtjme3
         XN+uDWAroN5NKV8PC8svOiTTFcE7+jId/rUvl519LmwnfMb7cXbmCS6v1rzoZEQw0z60
         YjrAaU4uFz4S2b1ogKJG0Inn8fl8qvbq6ON45jMbGxDulBJ3PYuTlkByn3+9XKCAk1sl
         A0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=OoSIIGP86FduPSeti5lKZKH5Cp2L8PK56m/1OZAxWMI=;
        b=u2HOloXIggeeAl7DH6k2UjBbvPEc5kz4cINqT9mOBmdsDHisouYQsAEjLmtW+2IA7c
         vYJ2jjpu4EHhUW9E/Ox/6w4f9E+La3oNi7g++yAjb9McXvUOVCfy3NNZIeRVeEzjExcO
         4OqMPc6A9g3NJsQixIfgJ18KcRDfw9zDLPYLyKw5zGlvLh4VZLYJOCdaOofatml0Rr7l
         m0UI1DRB8YlxP0d1+T74rT4eX4hnnmScXQOY2/AokiXUqnMIjZNeDI273PzM15ELBC3y
         tyrjIcUkPEjnR+/EUTTcGz5scOrSRRahMXjd9z6I72PoRm8vD6pd2T3b794gPFmmYAuE
         nPzA==
X-Gm-Message-State: ACgBeo3BTCM8we2n+MzO9cA98T2w/iS86TVp9I6vWJDfwRpTyOiKXPbH
        kfRRLNXAsYq8qdBrTMQPda0=
X-Google-Smtp-Source: AA6agR7pG10RM2AyYeVGBTtOheRihYeXyBHSE2J+23YQSkukQ73K/LruxWSJidlyPp7Fk6B3jQqipg==
X-Received: by 2002:a05:620a:b95:b0:6b9:76a1:d79b with SMTP id k21-20020a05620a0b9500b006b976a1d79bmr4541452qkh.166.1660083222466;
        Tue, 09 Aug 2022 15:13:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i5-20020ac860c5000000b0034305a91aaesm2384533qtm.83.2022.08.09.15.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 15:13:39 -0700 (PDT)
Message-ID: <c7740731-01c4-6528-b5ea-aedf2d927a8f@gmail.com>
Date:   Tue, 9 Aug 2022 15:13:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220809175513.345597655@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 8/9/22 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested 
with BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
