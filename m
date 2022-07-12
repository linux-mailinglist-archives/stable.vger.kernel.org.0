Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1057106C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 04:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiGLCm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 22:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiGLCm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 22:42:58 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419938CCA2
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:42:57 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p128so6696838iof.1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T94rycEEpzCTLdijNGDU/1/vTkBERG1dIYmo5YFldzk=;
        b=Lg3zMsXYJLVfw6aE6rs4lFmoOZtNHSVg7vOmfQAcqGrKzgms3pZglOozZUyLBbKcv/
         HfH2Lj6ms9FFMe1PBp31qS/LzB68SnNzTOT550CAEi/oC8/Tprt8VEzyC4fqzdGEQQiE
         lUkc/4clTopjNkxTS+Y0bxAPR4i9BxGhT+KU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T94rycEEpzCTLdijNGDU/1/vTkBERG1dIYmo5YFldzk=;
        b=7FHRiVrX1IlidWk9PhtYtTufp3LU7fiG4DJA76P8lJJThWeCyMjTIO1kXxLkET6IFg
         ANsP/BB2jGlHLGQ2XIcRUEUQwLbZGVGAi0QS1cA5HAlgReC123Ld7s05s1lTeeUEji5s
         x8ciVrZtkHoNBMkH85AbLQXcynW6e6EL1O9h7e/aPjVoF6mBQRhH86cLYod2ga/2TTeH
         vf3GYQA7j2cTyewGDuNx26pE/gbxHhA3VCNEfsgO9xKwFTDWCsJQi424SVuC2SaS+AFs
         CQUGdValGVrJj38TIcT06tEkv3HmwOvm3+becvvAeZZbXJmcUArykNYXPpVsHCOcmXaI
         U0DQ==
X-Gm-Message-State: AJIora9SLW0SAUpaRTy9TctdiV1GddIQnRfPZgbv49UUXyoabgt9+QqP
        m4LMmCtdFkpCIZbGqk55Y1Vv4g==
X-Google-Smtp-Source: AGRyM1uwdsE8CncNrCrvgNY98CPK+ZWbVNM7oUrxMoEVD2tvWTcycGEcRVwvufPmZrlNdnoDjDhv0Q==
X-Received: by 2002:a6b:c30c:0:b0:67b:963a:c6ef with SMTP id t12-20020a6bc30c000000b0067b963ac6efmr3814621iof.137.1657593776575;
        Mon, 11 Jul 2022 19:42:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f38-20020a05663832a600b0033ec34174a4sm3572223jav.39.2022.07.11.19.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 19:42:56 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/38] 5.4.205-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <486ebcb2-50f9-7e27-551b-1e32c0fc0b56@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 20:42:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 3:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.205 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.205-rc1.gz
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
