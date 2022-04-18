Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3743A505ECC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 22:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbiDRUEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 16:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiDRUEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 16:04:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BAA2DD7A;
        Mon, 18 Apr 2022 13:01:45 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bg9so20750819pgb.9;
        Mon, 18 Apr 2022 13:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0+kZsE73VgEeBbqhD1myF7KMCvhPaJ3w14vUYyxTE3o=;
        b=pKx+g1rYuVcoJk+5fXHi6io0yaJIjSrEVSUFfLzU4UtUy/zQKXRYMC6Pwge7RGQby/
         PsmGr5+2owyPTFUXI11E/CZF3ycB5ZNU5dQ6dS8+Xy+Y2g2jh8j6qgcjfeTZaakkpQTR
         tedw1Q8Y2gNuzq1gnBRHOjizNdZ2QPqiVAWvS3Jg6HayKe1k9VLEf+Boqj8AIc4wNsXf
         KIysQeI9olR98IYuQ/R3yJ73/AY8ARL1maoPkuz3LJc2jY4kYrOxq9l8E1rrShlBEOyn
         JAlTYO73dpp2Z1m54/BUN/+x4yqMFdmuDLl2DSscbt0wNraKELse5pGyzAvpvwNCMhKZ
         /sAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0+kZsE73VgEeBbqhD1myF7KMCvhPaJ3w14vUYyxTE3o=;
        b=r9/y7Kux8niuXlPYtDzZ1BNcqpac3vozXaWmG+5ul0YYImKnUNQSlEfyOJxW5WzgYw
         ZJXEGwsqqI23cXPSXrobFJTDhiIauZ/a+2L7W2QfrYbIT7AXO+n+JhQObzaylo4x6rKv
         /yGQuJclLqJK8dwdbKgX5ZClOr/PHRhKV2bpIv+3iveEqyKrq9/6UUuRFOTFT3GhjOY/
         MPCRIGzeBKMpULShb/5Wp/KJG63MmsBFwhnUhPGvctUsoECtQRNvMNIKrGEcMXhTOY9u
         HknZV5nMMW4N76B9uttm8sFQObXV2U2J+2W7UKNXYRCurMxHdG2q0eqq6ikJMv5Yzo0l
         R0fg==
X-Gm-Message-State: AOAM532ikUujuVX1pm/TltpMPTUeNd5ebM1JjUmWaKJ7R/gyNSZP3l1a
        NeyI+oYQxPCvW1xBIy3cdvc=
X-Google-Smtp-Source: ABdhPJwRf1e/B77RcLxn/QGADVvVfQW9IGD65PInAFuGXBHvYSa4VAH8zyTubbVOrYTX2Q+shOqtXw==
X-Received: by 2002:a65:5acd:0:b0:399:24bc:bbfd with SMTP id d13-20020a655acd000000b0039924bcbbfdmr11488417pgt.323.1650312105301;
        Mon, 18 Apr 2022 13:01:45 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w60-20020a17090a6bc200b001cbc1a6963asm14038059pjj.29.2022.04.18.13.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 13:01:44 -0700 (PDT)
Message-ID: <70453a26-ef94-bff5-8bb9-3c17af52dcf7@gmail.com>
Date:   Mon, 18 Apr 2022 13:01:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.10 000/105] 5.10.112-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220418121145.140991388@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2022 5:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.112 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.112-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
