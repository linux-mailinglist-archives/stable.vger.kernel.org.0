Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E180A6BBF76
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 22:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjCOVvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 17:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjCOVvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 17:51:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FE16BDEE;
        Wed, 15 Mar 2023 14:51:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v21so11461175ple.9;
        Wed, 15 Mar 2023 14:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678917079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=82jEHlqa7+p3T4PXm/DXhIjyHaorZWNXFDK48xpWCGQ=;
        b=DT3wYg0VhCTSvP/5wZxWxEu7rCG72uWIiCBdungFwhg1HkPaWk3sNR7SZzn1jrkDJm
         p/UFmDs9O1R6p+Gu8G2BOJXYjAP5hG56Xq2eOAaoiNJR+xGilUafwGzXeesz8lQNmFwa
         GLGrVFOns6wwy6qZSyRG0zkVPJ0F9jf7lGmHMCEpL8n5BYBpYTyYBZrL2fQg0EIjxE84
         5XAARiB/uIkpEKAda0nrUU3BK0njFbN057PHKca50D1vzoR10+cG6MnlWS9PXUtEs+W5
         yzFXyX4fQ5QSjQTz3bd0XO5aDvs/Y92zjArqm1v1Xfezc2D8hs6tKpC5pWaBvLApKtBq
         oAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678917079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82jEHlqa7+p3T4PXm/DXhIjyHaorZWNXFDK48xpWCGQ=;
        b=l2+u481CkeiQzy8MdakAuqbaTpe+HuV83eeiI7ibd/p61kRenEdE3JIUEIJJ4YZ4Yg
         PK2AaNTN9r+71vV57WefoDkEBB2xEt23jfO7ezgi9gLC/xVxqphd4VhNtLp6ayIW24Rf
         NCZ4bPfSv2vtkMsaOHZdGTEh11DqyESa9a22XO5cIXTTjAr1CFgScMLmymwyjKLsg4u3
         ROQ6oQ/NEtpt6yywBUk3UbOhPXa8WZUjqLyYFdOcn3PeNw5zNmvkLcgl4YITE8AW2IpR
         wMT4d9RhvL9R0iAI+g7LNVrL4tv1rg+PIXDtw6/XNHyVPILFE6eiDU8iMhnxb62ufRit
         yn3w==
X-Gm-Message-State: AO0yUKUmRyooJYrch4vVrMeRMRrGnQclg+F2o1Jm4lAza2wpNSGghA1e
        x47ATI84nFQyTEm2+Eg/JMU=
X-Google-Smtp-Source: AK7set/1xWtTfnSy/FwXUduy/o/hkMEjKmcmH7L6HCvSuh2DpOkhGzUNT3bTzJAYt03aPb9xlF60Aw==
X-Received: by 2002:a17:902:ec82:b0:1a1:9020:f9d5 with SMTP id x2-20020a170902ec8200b001a19020f9d5mr138815plg.64.1678917078893;
        Wed, 15 Mar 2023 14:51:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q11-20020a170902bd8b00b0019fea4bb887sm4064576pls.157.2023.03.15.14.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:51:18 -0700 (PDT)
Message-ID: <cdd94943-fc3b-d211-b818-068888d82198@gmail.com>
Date:   Wed, 15 Mar 2023 14:51:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115740.429574234@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
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

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

