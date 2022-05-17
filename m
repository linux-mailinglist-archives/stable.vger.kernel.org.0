Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5077552A7CB
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 18:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349466AbiEQQWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 12:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243610AbiEQQWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 12:22:30 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23903AA52;
        Tue, 17 May 2022 09:22:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a11so17343915pff.1;
        Tue, 17 May 2022 09:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ucBjucFRLoCm+fSN1r2d7kOJNJ0DcOpGqQ15rcjUeMA=;
        b=GMlCRPNOBl0U8kUWJ+h1cRq1eDkVBFSBSimWnPlTdkJs30NCejY/oi7tflcow5oG0u
         reNC7F+7WXgBWXVWr9W15j4VQ8+KzzzCElWHv+dl+cHNEHQSh9J7RFyJ9qZOQiGR4qso
         51O+CkqfU65E6X1ATXlDNXO/U9epYzKV3Px0ZscdOnQG8FXRWn+Ic7bGxs5turgNr4MF
         Ek/MteFCNDE1fHMytnEJMQqaBhoJpMxOmt9v7Q+HpdW5qBixum1vincbwZG8uzJJmDGR
         wpqr1S1mTXa8NqacHujjnN6f59AJ6BrebaMIWMFDU0eM6tVDWPaacyilVKXuz8rn1816
         o0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ucBjucFRLoCm+fSN1r2d7kOJNJ0DcOpGqQ15rcjUeMA=;
        b=NLvGzwElbRtu24wECUHR1MDpIkcRfDx49E48bg+DSubEan++mLP3IqgXVbVDYEoH1x
         AMpd2935Rz9krQepP54wuk8aTw3YoI/oHuB5Kb2Wm9XR679429y3O9xJheKu7dFkmvQP
         C9Y1m0xKKQzd/A6sjjXybqmg1tt376SnEfr8bjowru2aEBKAdvmKok/XpVysK5rCoRm/
         FhTxFwv67h66Bsc0+s4EvzyDCSbNdta8ShLNJ+GZP5O1z0J3BDkdXf/fcYOatjdGuPCq
         oCbNRQzayX67xOVUsBRWV2G8RcTGogYfqXTfWo/4GU5h4wItafegCIqCWilQE6by8bUv
         Iesw==
X-Gm-Message-State: AOAM53332jG7k4gacLaSu/4f77ptPJJajvUrtlW4efMnHy2xPFOhbwY6
        3DdC2QhoPFTyOwc1lmygYOk=
X-Google-Smtp-Source: ABdhPJw/XLRgnnIeudXfxqzg16Zi1H9cBFvzQnhI/WTy4mArrCc1RgCi1SWskS0L6QO1ZEYfsfGFQw==
X-Received: by 2002:a63:87c7:0:b0:3d8:552d:20d9 with SMTP id i190-20020a6387c7000000b003d8552d20d9mr20029249pge.440.1652804549114;
        Tue, 17 May 2022 09:22:29 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902bf4200b0015f44241a31sm9280091pls.110.2022.05.17.09.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 09:22:28 -0700 (PDT)
Message-ID: <bf29d9d4-4d14-d45c-cd01-509fec795f97@gmail.com>
Date:   Tue, 17 May 2022 09:22:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.15 000/102] 5.15.41-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220516193623.989270214@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/16/2022 12:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
