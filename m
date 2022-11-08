Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E968621CFD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiKHT1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiKHT1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:27:51 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7962228E;
        Tue,  8 Nov 2022 11:27:50 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id h10so10894284qvq.7;
        Tue, 08 Nov 2022 11:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EF69t9SF3x61lH/czl++mmCOkbNRPl0mdOxYpEl0ZJY=;
        b=i/R/UyK00fjhw0Gd1bgCB8+Wxb7ibJvCxm18utgoIFJt6d6GVhSv68rLdnzfFEHSnE
         Nb7AHIHbmmlfl4WZr5eBaERoXudsUFgt+qOnT3k53Lr4F2gijlVOQmxNskxw9NBLiafX
         DBajWxgwsPFzHwZlKOQUaHgcM2RO/J2RP/qFu5I0Y5yF6NDrlyeAwfid7Ft8Nup2Ca3d
         YTa2fsoNFbbLhvlzNaWJX+EFUBsD/GuDXGF+ZU1U+C0Wp5GQJF7xySKPCHj/LFbs4JiW
         6CrH4XhjdcxzDgnYhMKJo1v2o4dI7YpjeuLnoZHohABlyTa5wkmlWyo6qWetoGycZM4a
         xptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EF69t9SF3x61lH/czl++mmCOkbNRPl0mdOxYpEl0ZJY=;
        b=jenCZ0BRS/8jVXy20qlJidBovky7btYPz03c6ZVWLXs/gc+RXicMCCMGPxO9GCVs2B
         5Kqvayx8Iqb1dL/dz3PAUonGvp76D0FGX5NGBS3BFOtJBD09K81ZwDn0ZKm7+cUTXK47
         vwHqT5fzUoD1K2ww/h6+LM6+L2IEza3h4Dx9QvRW6RTkEkny65/+o6CnJN1nCsAj2YYY
         MXtuhV/yf8vLDkNpSSQ3bEzZCqSKFFFjkp8CPuzSw7/5fMQe3X931dhjDw0N/FdPkQuX
         DRRhGYkpq02q+eo+J/YGhIiXycxQ2MfbTuFhzadEZHdZnQQpm22jpagal58SoXYij87Q
         d5GA==
X-Gm-Message-State: ACrzQf1G+mNVNY2NWOSjdjqpQ25POQTFRNy5fqqnvNbW8Z0crmuOzdgV
        qP++/QzbvSKtJmfzPCPrFHs=
X-Google-Smtp-Source: AMsMyM6BBm6ib7X3NTmbMzqQ4gCyTQwLwGpv9L8fijeutqCGsSZZ6bF7OzYf7J1Ecm+IRsyH/fafZw==
X-Received: by 2002:a05:6214:76d:b0:4bb:e59a:17dc with SMTP id f13-20020a056214076d00b004bbe59a17dcmr47088968qvz.125.1667935669746;
        Tue, 08 Nov 2022 11:27:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u22-20020a05620a431600b006cfc01b4461sm9647505qko.118.2022.11.08.11.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 11:27:49 -0800 (PST)
Message-ID: <682a9f6a-d8d0-8f73-b262-2d38c55bc4be@gmail.com>
Date:   Tue, 8 Nov 2022 11:27:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133340.718216105@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
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



On 11/8/2022 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc1.gz
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

