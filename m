Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3770E5AF37A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIFSWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiIFSWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:22:23 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B53D9924E;
        Tue,  6 Sep 2022 11:22:17 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id f4so8815881qkl.7;
        Tue, 06 Sep 2022 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=E1NlKhPcTppapk+TbWvy3gTqdKIUo8UhCROLtlX6AHI=;
        b=QVKN5CMEfjFjfkOoF47o9tCYKCV08aulBvXINyobF1P6+bdV26lrrSLYEmiaAQRStw
         8jLCV1bJv1F5AmbZHrt5daDnuS5RqatMcJkwU7mLrgOCiRxnOueVAVSIhJtxuheLPUzE
         iEQCm1sJ8OQpwGPJHEdT0mzKkLgorBZBs1OGvIvVuemqpHu0Xg6L+a7NLc94YhjCgzsN
         IWsVhTgyxrh2dRNLyt8knEAFTWIkoZZ3P42A8P1MLzvz6uyfEGvRw6s7qXpuLINtnG5v
         kad2vTXCcjICIgaqkjZ9xBeNGLdBJyV7JRn2ZKzWnvV/V1cMDrxFuAloKmJ2eHL75tRp
         1XKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=E1NlKhPcTppapk+TbWvy3gTqdKIUo8UhCROLtlX6AHI=;
        b=tOYdTQTGhdOSNH4cU5kUXHTpmkctC4Z7ncLnQ1ptDYyWAkWLGOEDc7sk6fE3bFhi/h
         4PJBiinnf8aVw+qL6H0AyPCnvXiEMz1IJo9GTUh6FtVPbBSlDSUidslq1cjmHToGsYSp
         3wsRs6fsfJq3EL4dSMP9EF5a3Ogm/nhFssoSlDnDlRL922TU+rLSY29PWAUlLjhjRuxd
         IJt3DAx0cjXw+1gQyqfjeSpCN1vY1uoAhZqnzEmRIKisbdhBZySFdoO1B4vd+oJmJx+l
         3JwfHIfWIYjJg79c79E28hZF1TBFJ4uoNXxVMkc/hZayXX2Tis2e7Irl4OQIYuArNGZ5
         kqdg==
X-Gm-Message-State: ACgBeo3Z3xRfCOh9CCEfqJKtUVPjdT8qVxwGfiDB/w46T5qU5/Rrhkqp
        FnGDLprLx/qVEutr9g5Y72Q=
X-Google-Smtp-Source: AA6agR56BmFVHMgkoHIIdrwlpaXpQY6kRDydskO/zKSDHhdGmD8Y0UHbcnI3jaDe/LNuKWZedSb/Sw==
X-Received: by 2002:ae9:ed89:0:b0:6bb:9968:de30 with SMTP id c131-20020ae9ed89000000b006bb9968de30mr36463899qkg.774.1662488536126;
        Tue, 06 Sep 2022 11:22:16 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h26-20020ac846da000000b003450358fe82sm9942823qto.76.2022.09.06.11.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 11:22:15 -0700 (PDT)
Message-ID: <1ff2180a-fd92-f795-9327-2f3f51d44915@gmail.com>
Date:   Tue, 6 Sep 2022 11:22:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.10 00/80] 5.10.142-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220906132816.936069583@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2022 6:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.142 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.142-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
