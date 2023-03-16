Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75D86BDA01
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 21:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCPUSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 16:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCPUSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 16:18:01 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B9623671;
        Thu, 16 Mar 2023 13:18:00 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id f1so2042464qvx.13;
        Thu, 16 Mar 2023 13:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678997879;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3hSQqmOPjN3PoBEQpVeufKdChsynQgIj6cJH3e5uFEI=;
        b=UTdvpLFs42Cwb3ydTv3z+AT96WfIYlpo7rWEOhYhRyOAYzJkExAHsunw40mo0AcoEZ
         EBzOBGpgePHFlGELL2r6u5ruhr6QetM2/uzCzPoe+bf115dYK+QT1NGA2MP7G9zMU5P1
         5Lp+Gzr89M//HmJC9xiiNjEEv0RefsAdcvML44kNrYaKKCcNlUxmxPi+7gvMMLe8iCw/
         LdP6U3jcl6F5ASdy5LZ0dZegaI+Fh+wUZFclnLbFF58ld8pU/daIF2gvRi1Ibsgr9KYv
         gbldenQTT26fkCqiDtc6mJ75dcvf3osQIr7krbFSFg2xYTjoSwZqntBTyN3xv3gFRfuj
         C+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678997879;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hSQqmOPjN3PoBEQpVeufKdChsynQgIj6cJH3e5uFEI=;
        b=SNSV/glYxSJOWKYG6oai7w+i4y9JsFoIrBhErNJUwbisNf4E5OvJI/vixXifSDyrZ5
         Re9sXMxTrPHU49CsYBlxAgSjsV6vKs41C1gyfNUcCaZXvUgQ4ro6Q0lcljtCwjQkiqk4
         HS50GKVCIETezqcbDBTcugfyGYputl7Rw/wk+nbBjtvUfckLX9qf86MTRIYtBbyYoVn1
         X203Rmq7stgttMlWLW5gzhKbn3YmRC7UUE9KD2kGA90itftyJoLfCWNvlph/hXO2qL7H
         f9/8VwD7ACr1QPz8IfhFw1+xBZfWyLiQjn1KOgHB0tDlw4GXAOpWNFKjKTMTWvkFV9fa
         4D0g==
X-Gm-Message-State: AO0yUKUqN7/sBwe1QayIcfBZFyA7aIfIDRdXgf5oBSpqIIUYMfZzUbDp
        UPo0/WtrqmHhcVQxWbdg1Lc=
X-Google-Smtp-Source: AK7set+hpP78ijCJqK4lIgvUx76VikcSG1ESncgtMNADZ9uOHoXBbCkjOUd4zy9xUJKN6QTZMlz6DA==
X-Received: by 2002:a05:6214:1c4e:b0:5b9:2e5d:76ea with SMTP id if14-20020a0562141c4e00b005b92e5d76eamr4380121qvb.6.1678997879372;
        Thu, 16 Mar 2023 13:17:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o10-20020a05620a228a00b00745b3e62006sm242069qkh.23.2023.03.16.13.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 13:17:58 -0700 (PDT)
Message-ID: <58bcb53a-1a6a-63c0-bf69-627c3abf483b@gmail.com>
Date:   Thu, 16 Mar 2023 13:17:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083443.733397152@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
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

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

