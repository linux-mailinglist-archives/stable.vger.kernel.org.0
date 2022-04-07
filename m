Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E794F89C0
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 00:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiDGWLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 18:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiDGWKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 18:10:50 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1462BA020;
        Thu,  7 Apr 2022 15:05:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k13so1041015plk.12;
        Thu, 07 Apr 2022 15:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bceXYa5MMVgd2n3rkKZEmGqfAx6kQms6hFJZqA1rIqQ=;
        b=USfo6kjr7wb7xA0G/fR8SCv/nifRz3+eiKTPms+84IeRZodqXI6cd+BjKQMRhO0nso
         is5aLW7pbkV5/SPIwqfEc04QCoNIr/MRREKvG9VyeqIK0nK42qE8KE4UwO5L2MEZ4w7Y
         YM7BQHXzaE9JSWNpBIiR0Lp2YUfRR3iuVF7SUxo5blChyalvqXu0M8ghojn4ZqVAgUCd
         GdXb13yZYtflmt9mY47jpw4+u4sY5V/9xsTgEmMBQd41C+CQwpRHds4pGm+4PS+7TeOi
         kgyzYfUP5g2LHLHath2yP16o0bB5LhjZZ07Cj/xDvnbPnDO+FwT0mhmuVAXqs2FsZvY4
         B67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bceXYa5MMVgd2n3rkKZEmGqfAx6kQms6hFJZqA1rIqQ=;
        b=cWbvyg2S/1Jk+pdBIOBmerYAfWU7qIQonaP8K4EEglX3N4KTDKwtFsUb9QT+evr4SM
         EF9DpVw0/HuMEWajKvy4WAh7Xa41u/voPj6LnXrOBE8dluOxazJpRgCIyElVZ05I+ioM
         O2Fi/9goI2LfnRbxjd7EYtWWkMp/1y7++TyvjIMedF9Ha0BdNHnR7SYJRw43ePlmC59f
         SjzNItQUHZEutXvb73ahEAtW2MDsiU8vcXYFYNxhvYXlo0Ap3DceRPN1VIvcTZT4KpB4
         FCJOcBr1rUfsXi8+yTf+3TJTZyxwaRKmvI6BSvFF1yIppoFqe+toSqQRv5hVaxF2PkMx
         ERaw==
X-Gm-Message-State: AOAM530I45fT2kIb7tP4AMBslnJDtTv/5apNsmWp7hL86bfWVmTJq7r3
        QL/bZK4xIXX6fMXeut8flNs=
X-Google-Smtp-Source: ABdhPJzUXI8qCzzrnPNtm4u6L+v+b/oyIZ0wGRJerpAH1+bhGmsuVpWhAHab9HiTNEKQTsgejCVfgg==
X-Received: by 2002:a17:90b:1806:b0:1c7:852d:e853 with SMTP id lw6-20020a17090b180600b001c7852de853mr18066443pjb.106.1649369116972;
        Thu, 07 Apr 2022 15:05:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pi2-20020a17090b1e4200b001c7b15928e0sm9877648pjb.23.2022.04.07.15.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 15:05:16 -0700 (PDT)
Message-ID: <2e2dd667-5a3c-ffd5-56eb-dd12a24402ec@gmail.com>
Date:   Thu, 7 Apr 2022 15:05:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220407183749.142181327@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220407183749.142181327@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/7/22 11:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Apr 2022 18:35:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
