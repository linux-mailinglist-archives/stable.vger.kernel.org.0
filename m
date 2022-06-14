Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA95054BD95
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiFNWX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 18:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242406AbiFNWX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 18:23:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72A34D607;
        Tue, 14 Jun 2022 15:23:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d5so6287555plo.12;
        Tue, 14 Jun 2022 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HeXZ13GHuZAsU9fsNJvqXv4g/jBPWfplGywa/jhxuTI=;
        b=o2ue+YzgKM4bUAY8JOZNrYh823YWVTilZM0rpjm6ClgI1+sWhL6cadfwb0XwY67FiM
         PFHGU/FugpYrrZdXZd7oigrgqm+kDXpbCD4UA/h1O+Hb2Ql96xIXX3mP5hEguoIbAnbg
         DK1oLnnyrYrHQH4+VvufqQayCC8+4LgZploYTGE3MlIMqISQzjiPcvMzfI1As/RQzpyc
         aBTQdNNTFBvzBadduo5wjWvO2ePnGmlFvLlN6kMSWPMaE8o8qO65rgvsAdtj7ky3BSYv
         4313a68XGAO0IDEwJL7teD6KXpLahjDaDeyOKE0cFWQ0kHvaWAAa9EPurz5VH/r9Ly1b
         CN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HeXZ13GHuZAsU9fsNJvqXv4g/jBPWfplGywa/jhxuTI=;
        b=eUqbLju//qceYS7oflNMND6N9RU9jH9VWPzeeKpEUB/50zfbbw3/zCiXSUEeVGJKKT
         jz2LYWyLE/iTgNU6puKqSYImYmwu01Q8p+W8JHjVN3nP38LyheiEGS9FZKeyunUQVykT
         Bfzt4t/xXIYGmDaFySP0Cf0YO3Qq15P42A0KRhiutZPOgVwSGP+x42Fr+ijFEVyNMPdE
         iP98ig7fdHIujopyi0SKSiDryUa0L3bRE+HuubmctOS8kmMYy30IqmVCia5yZZS9Oos+
         K5P0gRegeTLe79cyY9Nr2vgQ13fDodrFfB8LojR48xQnBOSwkMOJVfu8NpPTKxOX2tPv
         56Qw==
X-Gm-Message-State: AJIora8hWx3JELHoZm6jYuuThczICBOK1VJ7alJi6HpZukaPG8W86ux5
        CcZ1OQU85kiH7UT61BB0tJe5SWrb6NA=
X-Google-Smtp-Source: ABdhPJyfpbXPRxfN+lPKFOZGceKmNmcnrOD5rKJ2WS8Qbxq9ZREYOf3jx4fUQ+AOQrZBsHdKwqTbSA==
X-Received: by 2002:a17:903:1248:b0:168:d2ba:ee71 with SMTP id u8-20020a170903124800b00168d2baee71mr6592785plh.150.1655245437074;
        Tue, 14 Jun 2022 15:23:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c137-20020a63358f000000b00408c56d3379sm145585pga.74.2022.06.14.15.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:23:56 -0700 (PDT)
Message-ID: <50336991-c4ae-8edc-8ce7-929d0f48062d@gmail.com>
Date:   Tue, 14 Jun 2022 15:23:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183720.861582392@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 11:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
