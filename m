Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9306B5F79
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCKSCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCKSCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:02:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ACE5254;
        Sat, 11 Mar 2023 10:02:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so13088089pjh.0;
        Sat, 11 Mar 2023 10:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678557720;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1bxy9bnmht1Cs7JlNBr4fR2hgK514V0hWSGqsJ0L5t4=;
        b=JbE3AzYdCifydggRTjulwDbsvbH3/w96xmxAD1CCEJZ6tu3C06ZNBpDUH+eiUklaod
         hQgtPeSmdqlwsJA0hroreEs0M8RQ32F0Nf+Qzoio24nAo5JBNZaNKWOF5zl69LvfEOJv
         GYt7XPWCjxpjflA0RlF74bRknJLdA9FRRzvxzE9dtVS5uzgJ019VDk164/xKPPceHKsV
         dIgr0ILIqn0lLGRb3P1EXbgibBkXhJVmopUesCqX2JBidNq+PkVeQlo0RPmgJYMVzTu2
         iiUEhLtXG/8aKAsiWZj1rIKsTx1iZKtq+eV67yftWwIBsX12MlaJBXWhaKuwL6bBjEpa
         qsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678557720;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1bxy9bnmht1Cs7JlNBr4fR2hgK514V0hWSGqsJ0L5t4=;
        b=xmnrcOPs3mzGqPwClGkh/aVfNMNtnSCzTsIIZpflVVu1iCbQqXK4B5Hqb8STxphjGn
         mdUMYOqxh33ZoKV2kmxanoi6I4e7TI8IOAWY+UU6LE+MJXCfKgOLtQhqaG1HtdVirT37
         TaLVJGBLEFrN/oGTnWR/RyWdymegSUrJH9RkE0wVOj1yyII70MEh2U0bYh7S1cKojcbv
         0WabJ7ik19PJ90OF4Ub0gGa30bYsi4u33iO1LWHZ0PrQSxWSLReZDJYWziiXfv2ToH2R
         VDXrLZupPoCNcgnheIuQ2hdRt6p990yF1NGSOW6lC59yi7rYTxaWAc31l30ywN4Gc5BG
         LYDA==
X-Gm-Message-State: AO0yUKXL6VD3LgcLWYDHsLulqudvintwD/aGzPFeIqW/cy0jQ6y0iyyU
        xBhUBB5+jsLBcb76IbCu7CcMipWULOQ=
X-Google-Smtp-Source: AK7set8NxbQ5BWxIrpaAm26ziszbasqjblusXpQSGjAcFYyC2XEDNu1+5UsSWuDJdItEDFx8o3Gvpg==
X-Received: by 2002:a17:903:11c9:b0:19e:e39b:6da2 with SMTP id q9-20020a17090311c900b0019ee39b6da2mr16506254plh.29.1678557719624;
        Sat, 11 Mar 2023 10:01:59 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l7-20020a170902f68700b0019cb6222691sm1823922plg.133.2023.03.11.10.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:01:58 -0800 (PST)
Message-ID: <2a2b4eb7-051e-acba-fe1a-a7e0cd0de285@gmail.com>
Date:   Sat, 11 Mar 2023 10:01:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230310133706.811226272@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
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

On 3/10/23 05:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.100-rc1.gz
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

