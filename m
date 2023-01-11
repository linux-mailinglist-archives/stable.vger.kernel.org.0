Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF5A665071
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 01:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbjAKAkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 19:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjAKAkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 19:40:40 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE21C50143
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:40:38 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id h26so7252837ila.11
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DoXC0RF5LPtMrYzqBEQuK1VB+5yAJ5xRxFUwIGUCwM=;
        b=bkITCjagCoFTLuFMDnm+DcPYqrginswcZ6lEFxoexAXPQuydFtnx8shBNA88+/UDpS
         UYYKspqp8GnV5Vz8m0IXfPUR7a/EKYRw8pMFHifQLdMDiMZD87sER8zgURLojpZsL7r2
         +2OysFC1FKiK08qcrOvg+zJleHCSE7bItc3Zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DoXC0RF5LPtMrYzqBEQuK1VB+5yAJ5xRxFUwIGUCwM=;
        b=27cvD51CKbuz4RpzYDHfhtJOxeTcUq+8JNQo4zsLdfF9G64n7pclV6fG0j7eaZaBhK
         i7zW0nsKAMcw6CfSNB09YBm+iUoglKRaI8BzZ+MwME1HNI9eya/H+/2i+hClxIQrAyUv
         EUMFREBK0rH5PL03iVcy7zn+IcxkirukXrA8D1H7iXp+tNhHGAIXQnfn5HMgPRXJO4Ia
         UETY6ORGHvF23u0t8SgO118nsb/vLgB6U9lmrhA2kvI68IX40r7EQcpwv2cyU3NI81T2
         IuTC1/+zyIFhQIVybySQDBZcIizOHDKhMDGXN1pvrTf4shAoTahlpsVWnPuXgkt4WOin
         mB7w==
X-Gm-Message-State: AFqh2kqdPWJCtXm36E6YCKdXaKqj2wdTVg3mIjSxMRsV6RJQdgaFlXW6
        OQ4ySkRxTrGvoC+pb/sS7FgKaA==
X-Google-Smtp-Source: AMrXdXsSzWtkzpEvHECNk5QilwNBn1vNy4Q2toNogv2oyW3wyfW9GnNn8inX+7DLAuGTmpPsUuFQhg==
X-Received: by 2002:a92:ce03:0:b0:30d:bf1a:b174 with SMTP id b3-20020a92ce03000000b0030dbf1ab174mr230748ilo.1.1673397638021;
        Tue, 10 Jan 2023 16:40:38 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j21-20020a023215000000b003748d3552e1sm4054531jaa.154.2023.01.10.16.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 16:40:37 -0800 (PST)
Message-ID: <5035a51d-2fb3-9044-7b70-1df33af37e5f@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 17:40:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
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
References: <20230110180031.620810905@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/23 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
