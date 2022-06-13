Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207EA54A18C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 23:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352050AbiFMVdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 17:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351480AbiFMVdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 17:33:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EB9194;
        Mon, 13 Jun 2022 14:32:53 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d129so6699618pgc.9;
        Mon, 13 Jun 2022 14:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CBtSauLktxLVvSEL2mBpsBRk1lFC8gjkcyC/888fCDU=;
        b=H79J4ThsYQGQ3z8K872V40HVNbF+EpxnBUTN12AuedJBUwG/VDjn9uaJ7lNupQmppI
         g+Qp/KHJxIjP77eOlTKo5wEoV6IXRPE6v4p+Mw7lkNqi71NCwILTX4uTYv2QEuJYvNJu
         JPuAubC49ljc3F+6bhhNQPwY8VdIrkR9ZE7E0HprronvpSkDz3eS7zMEeOgjDtPO7R9m
         XauxUgYXXCxczypBIOdNpm7LW5Ewuihq9ixmOt0dShPopHGpx9AAWf1QnXgaVs2pUo7f
         nXx/Nkg7U8ARifnm8KMzrYUNW9rA5f9TTwxhv3dtPAm4giPn/0qXyVsK8cX1S4mDoTrN
         UoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CBtSauLktxLVvSEL2mBpsBRk1lFC8gjkcyC/888fCDU=;
        b=PWRHOzRZybpUtMwW2heTUprqAdnxWFT5J19hAQxrIhrB8ESXzuiF+HrImApKHUEg/g
         Q7PxrLIUsHlww2j9Up/GfhgDnSKdu267kDNw5zPAcA0ALNZzqzh24N6frUGw9aD/KwzW
         Xh94ikQLoOeb/46DQHvCFMiNRI+hGExWo/kUGqu/bgH3q1IZGwmtEvkjx5hbi1Ja6b3c
         4XIEEIG/rNYMvBWtL2MzKfqm0LCa5722bk09aUMZojFCmpjoajmCY1uAzPZueSjv/Em/
         Jwh2SPL6D2Ajdx7axXkvg40TmMiBO1sCsKLT1DpnToIeHVaAYH5R/xLeHi1FNfekKWqa
         0VgA==
X-Gm-Message-State: AOAM5323zpjHtfVVZwQNPMQf4AqVUUegEe7XL6wBaa9ErLRPAAi5bCpZ
        G2wMjRiVI8XtNZZD/N4EswU=
X-Google-Smtp-Source: ABdhPJyhyyMjcE3H/Qxj59CC/EyEXFIeVjPHT91IY8isZ3CSl2bPqjUXUwyosKd2wEq51mXemNCjEA==
X-Received: by 2002:a63:4654:0:b0:405:e571:90b with SMTP id v20-20020a634654000000b00405e571090bmr1463646pgk.120.1655155972993;
        Mon, 13 Jun 2022 14:32:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g6-20020a056a00078600b0051ba2c0ff24sm6029648pfu.144.2022.06.13.14.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 14:32:52 -0700 (PDT)
Message-ID: <866cee25-0215-eed9-bd7b-baeb66dae061@gmail.com>
Date:   Mon, 13 Jun 2022 14:32:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613181529.324450680@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
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

On 6/13/22 11:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
