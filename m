Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E130E59EE66
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiHWVqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiHWVqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:46:06 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8685A887
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 14:46:05 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o184so17546298oif.13
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 14:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=LewCaPyJI9P19qoX2T8Kq55PTU9SlmcYgInl9k2Dz6A=;
        b=FGaYaFonhdWRVSSWqOPCtTAEYXefho6W1zMIlqnYW/u4WvAU9QqXe/LPDw6q/MTaag
         tyqJ+IKQKx9gWxqL+kRDrQZ/FCNJc7A/7tB+IIlrLkXPCEhAwJZWsaO7uCE6g9vupHKs
         hPN/vD9Xyniq0n3xfn1lhgpvxbc2eRzorx1tA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=LewCaPyJI9P19qoX2T8Kq55PTU9SlmcYgInl9k2Dz6A=;
        b=UUlmRKG4JFSw7EmCqLq15T1kAZTdzUTWA9w4CLHC4tTmf392chEmmUF0+tMX5hw20f
         XAa1Is5S2jzXpXJbNtFTMbBeJfFfoIluEjtwuZyggHanhV9updsuBc31YX5YwkktXqyl
         RYp3EayLeTyWyB19O5Cmg4Hx4Om6zwfY0aelR9y5cU/E8tF0PCw8IUDW0t/oA8ipIWo1
         TAbkS8Gv/uKJwQ/D1OUQk7XeQXAifkeATZFcbTsLNEwI2dMOooY+Tc/Lh7uxExxGkmUH
         8FkqnZduGMRoJ7WAQ8fQO1JP57dsiaU8Ic/5+Qxko2arCUlzV7uNOuo5ydtHSw5hGuJK
         3+ng==
X-Gm-Message-State: ACgBeo0qvBb3Tz9Xrz8+aJb1PPN0VineuqZn/N61kUyeulBmqL13QbPZ
        udw/AXRqfoHbIKXpYNxa2cyjpg==
X-Google-Smtp-Source: AA6agR4g/YuLrYSyqg8DTPckNgcDMaPWiVU+upi7EOPWjX5lrVS7EDCX114PWkjhfSW3Vv9lF/gQIw==
X-Received: by 2002:a05:6808:1b20:b0:343:678c:451b with SMTP id bx32-20020a0568081b2000b00343678c451bmr2112495oib.171.1661291164766;
        Tue, 23 Aug 2022 14:46:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f36-20020a056871072400b0011382da43aesm4184347oap.16.2022.08.23.14.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 14:46:04 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/244] 5.15.63-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c663d37d-2005-7be5-fecf-ca71d640981f@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 15:46:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/22 2:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.63 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.63-rc1.gz
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
