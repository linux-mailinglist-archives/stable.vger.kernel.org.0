Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743D64E7EB7
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 04:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiCZDI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 23:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiCZDIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 23:08:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E4A517E7;
        Fri, 25 Mar 2022 20:07:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w4so10084767ply.13;
        Fri, 25 Mar 2022 20:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aQD77EAhWmHnhQ7qBdvXeGAWFiKMptB4SjE+6Tyawbo=;
        b=iGulKvJEbbiu9x/fXiI1QEjAtCqO4uNBzmf/YlNg49GtpKfOA/Mj1qD+mrezdCQETw
         dixQi8asx5SQHJCwtmPTAlzp+iEgEyrdVqs8yIXaaWJmO8Cq6qbqS/bzijUe2uhmj9XC
         9kX6sfi+iYOkbWqnL5SNx/l3wYC+7EyGiu+Nbx7J0HZnGgMFL3G4GIZ8XoegGCJNn+My
         p9oTwdavrQMj51fT/M9Ywx0A8oWhIEPamRhCIf+i+IAc7bk2/1vRL+ldBFY9iAFNgZQL
         lf7zhIV7okqWxYyghYrZApPl3eaYp5EigZ86c0uUt5hOWhHKQDnrtycjOqyqptkHy4hh
         hNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aQD77EAhWmHnhQ7qBdvXeGAWFiKMptB4SjE+6Tyawbo=;
        b=7q197VWu7FAoQX70pITtuWHKF5IcJoxi/tJ7CGqTWei4heGIpv34V2zEPDV3VOCIWO
         1C3HCJzBQmxfRLIlCZlfYOGHElRJoPhQiR82XU8vmKFauuHTGk7Iwk4OZ9rqTAO8wVaz
         jxQ3IKfn/z5HbR4hVEnpa/7d8iCiMLgz+eXnlKI9jZdUipu1UsHJOsQgGKxUq4pBHJoX
         VPgd9NsVWpDdXXkgmmIVMZU3TmS1qj+PEZWTuMk3idbcZyrrb8vRhUrdXN88m5eF03+F
         nt4cv+UzRkUnAfjHzkKakhyB/J/VTyxN0Ls/W/kRJg1w9ANI0t1DUjhimwr/ojxPm6+d
         yC1w==
X-Gm-Message-State: AOAM531MOt1ot1Kmf3SSOZZ5ARVFHlBOPoTP3vDjGRBm/BJhvJ/8Tjd5
        oSiQvTTVvCL6b87bXcHmEn0=
X-Google-Smtp-Source: ABdhPJxFmlmZUtTmr3T9d5Ncza/znnlsWGimEhMly1TKRN+pWidVREt6he4FOovFnRgMQXow07BElA==
X-Received: by 2002:a17:90a:af86:b0:1c7:db8e:8589 with SMTP id w6-20020a17090aaf8600b001c7db8e8589mr9263301pjq.94.1648264039351;
        Fri, 25 Mar 2022 20:07:19 -0700 (PDT)
Received: from [192.168.1.100] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm8438988pfv.199.2022.03.25.20.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 20:07:18 -0700 (PDT)
Message-ID: <d748d89c-455d-b24e-52c3-6980b1702364@gmail.com>
Date:   Fri, 25 Mar 2022 20:07:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150420.245733653@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
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



On 3/25/2022 8:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.1 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
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
