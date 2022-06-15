Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7A54BFC1
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiFOCnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244510AbiFOCnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:43:49 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B9C2A265
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:43:47 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 19so11308405iou.12
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a4xEgF667OU1S/0Miou3ZRcOP0SbSoLC2HeU8wy1b1I=;
        b=idZoNZqS3vX6BTgt+xNkFBAzTAzf/mk7ipBD4tdeBhBbUAn0uxEokx1SbifG8bYEVB
         1jAP5ReYorIbTXDmRy3MYccG/NhnGMxiXfGMoa/9XUNYDqAtH9flWHHNDqOFk2FyDqpp
         9xSHedP4E332id0iLct9u+J/sMftj1iuWghp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a4xEgF667OU1S/0Miou3ZRcOP0SbSoLC2HeU8wy1b1I=;
        b=Ey/zzMBicuqh67m7eiPqo/FitLW+1J5l1B3i2IKDV2/GqkUY+FLPzsWpSDIoAFJWk6
         T1KRMOoTX+Ev2cmdTJ4tePSkhkUa68iAx0UMRiuzsLibPOjOiX8kjR+VZvnePZnSa5Rs
         GCJJlq3+9elzOolj6zMDT6dSQI/UmFVfdmqztqJeFyE0lQQNg1uB4L6fDSD65xSUCvxw
         4hBgj+kQK4r2+GC8c4WjrCGgSdvw6xAp9ofDmLHNFw6o3D5pnB66O85LDRimUEvWG6J1
         dOCWsPdRtSmfhgM+qSLUjzRxYDTABEJ0Tjg/hPBbFpUkzkpI1/n7UQqH0Z/algEB1S8x
         2ADA==
X-Gm-Message-State: AJIora9v4xKBjm9T6QY/d0pBYEbDNwtnpM/THSl2+mEelX9Sj9EjD1/q
        8aYoEzeRMfMajbdCCRsfdK1wzA==
X-Google-Smtp-Source: AGRyM1smwfK39XSpbnyg9+TRrPgYjzVSPS4rbpbw+iQzlgxIAVDXuJzULTtyUkUzPwk1/7hYEH1ASw==
X-Received: by 2002:a05:6638:19c3:b0:335:be36:36ba with SMTP id bi3-20020a05663819c300b00335be3636bamr1015750jab.28.1655261026796;
        Tue, 14 Jun 2022 19:43:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id bw8-20020a056638460800b00331a9a96764sm5581182jab.85.2022.06.14.19.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 19:43:46 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220614183721.656018793@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5c276795-bd0f-a2bb-05ec-85468275acc9@linuxfoundation.org>
Date:   Tue, 14 Jun 2022 20:43:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 12:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.199 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
