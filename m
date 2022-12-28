Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7B65863C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 20:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiL1TIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 14:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiL1TIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 14:08:39 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DDB14D2B;
        Wed, 28 Dec 2022 11:08:38 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id k137so6487972pfd.8;
        Wed, 28 Dec 2022 11:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LG1TKXfO3Ap1YVLnv1vLNUNgLF1B4SFHf63ToBDBDCg=;
        b=FNNpqbSgPvg8Ci3s8pZ/cj5NIEYbaKeAAwgKGJqFKYZyOm7nviLlkiR27j7/kHiv9/
         MuHJB+cBnFGTq7w139IlWJnRhv8C2KUlnGjFT+vzh/7HKB+W1J+kv544ucAy6VfbLFpu
         W6QtZAcnN0IKj1z01vbj27jp/80bOBXixHgJBJ6pT1WHjrVicdj7AS6l4AIFwdNxFx73
         oH3j6aMBeqic8o4P0PKi4LnxXJfbp198PDGGlSWomBxm6cxK6IBG5ugd47Fq7dv44h01
         ZQ75f7yL6ViuO7uK0KUT7guq5DKDPYI7W8Z/SkMd28MppgKVHYRyS51vPJmKT4IhmdUA
         Wxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LG1TKXfO3Ap1YVLnv1vLNUNgLF1B4SFHf63ToBDBDCg=;
        b=jR2ZBc6u2OSI69wrXetqDpoiRr5J5gT6STOwVyUsRSsocd50TgKLehgG4/bjWZfz+L
         fx1BzhVgG5UcjK+rixhXuO/J0g/Lg155pibgrn6ukZGjDsXEaxvMrKewi1EDF5EjUYcf
         qG8RQSlhfxs+xldyyeiD78h+4MCe39I1hWTTzz440K+4P9qjoKTN6JjAghEPNbLK9p5X
         W4tEZWqCl8iLcRKVFSORQAMy+YP4BZTn3ed7NLmOXTBp0U7yDjYAbNl99UDXGhpDpJKc
         PrnCHDXXxGx3vws70FWcfN6xbV11tX3kaCdDQje7Na7XBWPSdgEzU/b0LgL5UxD6Yl+V
         DXiA==
X-Gm-Message-State: AFqh2koRLJohPS4/GT82iWGiMq0WrQaAnQnat+rCGMyAN3KquZKI2M0D
        cUhfjdeJavZdllt0FEwocCA=
X-Google-Smtp-Source: AMrXdXs3v3zXwsJDPj1hQvHoDsNZ8SJR/+bixjEBkFAtCi2TvZFCePhcLD/CddXDaxSe9zF7eKZ0HQ==
X-Received: by 2002:a05:6a00:1255:b0:576:b8e1:862b with SMTP id u21-20020a056a00125500b00576b8e1862bmr33307714pfi.14.1672254517424;
        Wed, 28 Dec 2022 11:08:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j123-20020a625581000000b00574e84ed847sm10715726pfb.24.2022.12.28.11.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 11:08:36 -0800 (PST)
Message-ID: <e0b14de8-db62-b403-bd23-ee36f99073ae@gmail.com>
Date:   Wed, 28 Dec 2022 11:08:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144256.536395940@linuxfoundation.org>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/28/2022 6:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
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
