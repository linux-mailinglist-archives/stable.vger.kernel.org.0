Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD04C6E8127
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 20:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjDSSVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 14:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjDSSVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 14:21:30 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1DE7A81;
        Wed, 19 Apr 2023 11:21:28 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id a15so602068qvn.2;
        Wed, 19 Apr 2023 11:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681928488; x=1684520488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9JQ4YYXDHsdgydwwSkAz6HZEvZ1oP7JFBvoxDwJAvLY=;
        b=YKVGS+JSlMdc4XLuJlnixrMr1IveWypUVQwZ/1x19W+QvHciP8XMfIfR44MjzwRrXz
         zgHVkC1yIbmwdH9bugckqffWMIIowwshWYY95KMSlRZNFpIQ48Weri2SlRaFlr3LtyZw
         azJO7NTDtHzAFnK9KzB+U3fVHUQp00R8rK8/eN4FSx5tmNcDXuEGF0jHmiPp5nixo42C
         ANOMAA7IS1KQNZO0ktM2KiSBjEyiZvkAcmdevFqT0cPB2PS5etZZtlPG8lCOiumxLKzl
         G1Z4jTK8unTFlGcV+czLYDsnGXjvtQC1SFNIAWquio7CH5IaIXlKagT89nbUt7Yila9W
         Jrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681928488; x=1684520488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JQ4YYXDHsdgydwwSkAz6HZEvZ1oP7JFBvoxDwJAvLY=;
        b=f88/JzBspqHbjvU34hCX8vVixACAOXzZDvDopWxH7thIktJeYjfJ5WrEHpM63jxPxF
         ccEGZV3kybsBsZbIgK7H6rsmDwnsM9dwrEzKeh1WS387qF1PashmsaRWqp1wa9MxMwyw
         KzC6ejqVZg9zXpx3DIz2o//3lDpdFq8soJyE7WJngioLncd/XOwn8UQjPSuHX0cBd6Kx
         UcRn+0w7CcLJ/L7SLYsRBSahiK1rNEyD2cNwLcksSqOclvaqaPOEhZz8gYBAJoMZzorI
         RM24YyJvXidvVO82qfl96Zi0WdS/ef05Wfc0sQeYVUtqQZ9LKV8FFVScrPNFgWtlewk+
         p6mQ==
X-Gm-Message-State: AAQBX9e3L6fPM+hgbdsFXiOKxDGjVJU9ya4QDcoP+YxkvlXfujPR3bR7
        mMxGVv/fb3lkAm3J2xlNGV0=
X-Google-Smtp-Source: AKy350a+dfIVVyli8FYMG1z89l9XMpH9g4QdD4/ZdUFCps1ZR6oAiKCc9JeOXuxK1TT0wvcWhGHZdQ==
X-Received: by 2002:a05:6214:2622:b0:572:6e81:ae89 with SMTP id gv2-20020a056214262200b005726e81ae89mr32408165qvb.40.1681928488047;
        Wed, 19 Apr 2023 11:21:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c11-20020ac8110b000000b003e699f278dasm384193qtj.7.2023.04.19.11.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 11:21:27 -0700 (PDT)
Message-ID: <483c9166-5266-91a5-3cfb-bbca3a0a80f7@gmail.com>
Date:   Wed, 19 Apr 2023 11:21:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419132034.475843587@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/23 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

