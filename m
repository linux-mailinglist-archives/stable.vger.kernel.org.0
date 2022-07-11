Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81585709B0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 20:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiGKSFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 14:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiGKSFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 14:05:38 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C45622BCC;
        Mon, 11 Jul 2022 11:05:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j3so5421613pfb.6;
        Mon, 11 Jul 2022 11:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=noypuOLW3PplBBEk7+nMQAUOT3MQa4wqzB0Ga1JwZPU=;
        b=BXjXC1xk4z30GEgjJ8MqI5zPXHqqA1ApN3zqkaxFyRA5dSWsXzWy2fJS67gc95qMnl
         Jvs337sXY0k/yX4EccJrvuhfO3KFUuJ5lGLGw0PC0JZAwoRm9suBV66OgEUAL/L+Nbv/
         1vQ+AOvkya7AFpiquHGfsSRdXy85V0NDC4g5zvzIJ/wVVMC7qbXjBDGfg2oAmqTSLRjg
         Jhd4PVxuTqIsoj0Hscyg1xEgzwg5h8J6ZBkiaqKCiLWxYrSNABSYN1BUsiui37iGLDsc
         HTaiYPAJ6TJfZJ9Kq4bhTrSPzoOWDRHoQvDcNOcDchW9tsx7mWdSi8P2CaUf5CX9xia4
         NP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=noypuOLW3PplBBEk7+nMQAUOT3MQa4wqzB0Ga1JwZPU=;
        b=hzNZ9VX+oBl5VwOvfIXoB29Xt+dz1v/FD1JHJRK6+16AWJdB0BmxJIUZsCdD2MuJs1
         cXvr6Ujb5cgVIGyzirYKMrO0YDgKt+MFDba3cZlU2AiC+71PGCiTe70ZquYUzWRarhDi
         dOpsQPUt48n5vCWSReQwVp2E9iJY61UurQqxWbZKYGm+FiL0icfLA3aS/BKbdVQvkIB+
         E6TwMfk0aSagBQf/dxqemjjoTu9A4FzjG+fze/aN84q98TTgB8EckPrWLq0yET50KRMQ
         VRjgoEdL1vUOZYZa8bhl6pzpjynhzCMG8+XmScMPn+nqNrIuMoguZO1rV649vh2OhUC1
         23Dg==
X-Gm-Message-State: AJIora/KNT0cx7SWPx++Z+888tXFLGo9/mmeeWYpBW+dTDdeUhgQnqF2
        nIZ/7npWO8OUEZUioNwhzbY=
X-Google-Smtp-Source: AGRyM1tueiVhwMNIikVnPkF+PdEbw+JE8QuqVAXHwPdv6SENQCUpZ9OLsoIjKq6wdaJ7rPFBcnk7bw==
X-Received: by 2002:a63:1921:0:b0:412:407f:f012 with SMTP id z33-20020a631921000000b00412407ff012mr16494448pgl.125.1657562734887;
        Mon, 11 Jul 2022 11:05:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m15-20020a17090a4d8f00b001eff3957020sm6760101pjh.36.2022.07.11.11.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:05:34 -0700 (PDT)
Message-ID: <25c40576-53f5-c43d-6a11-ebad8b6f7bfc@gmail.com>
Date:   Mon, 11 Jul 2022 11:05:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 00/38] 5.4.205-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220711090538.722676354@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 02:06, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
