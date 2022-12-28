Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E7C658653
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 20:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiL1TUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 14:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiL1TUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 14:20:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F0614D22;
        Wed, 28 Dec 2022 11:20:39 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ge16so13404085pjb.5;
        Wed, 28 Dec 2022 11:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tPjEE4IkK/UqjlAXGEr5RHGSebOudNwdgJr4Z1YJtDs=;
        b=BPLoHCGT9oR6K/S0wfK4If03CeIE2KDLqyKX2iD57fGcEVsdDolJ4T6xPijESN1w6F
         Le404VMstLLy8N6RY/50t6rSTDiSxkuSyFwzdRkwZtDqMsWRsKHW078V6+CPkbKHSUrh
         WCOxDpOUvaK8MH00+0FchO5EgtQep2UN/97AU8la8vmb5qvMMCfM3cspIqAHhFIspK1N
         jyLk164cBaq10KwtUDoMXx+iaXLWfbg7UiKIEEt5vklZPgpEGmGbKU4c4wWNuQCdDWJw
         Gx/nkCDicobEl6F7ldu/4alxnCtqJhh/bpaOqxI1+d1EBDRqlChLCcrQ/6OjPJGaWKMU
         w9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPjEE4IkK/UqjlAXGEr5RHGSebOudNwdgJr4Z1YJtDs=;
        b=WXin4GtIPCWMB9Qpsp1GyYK6HgktzFX/9RH+Sg8q/ldbCa+ebDZRL3ImOvfu5/ZyVg
         /4do9JiHXpJtnGjxVZJib5gNN52s/h5Y173/qXTjCTJcZ8td8tNYqMBe+5gLu6h60mib
         jfALM26zoKsVA6V3MZH7kn/lIsaRlyJVUYsOfNIMql0ffM6PGbiv8/X2n8h3BsvAg+xm
         1OZwsxM/Go4BXHCuusiMdAFf2nai7BZjLJEwQhgcbd1s3iur8nNIpVHVfzi3vWHxSfpl
         xJGPK7b81u5934Qmmjg6JRStPsmd+DtdBaz1OmK/5bOZcRj2qDZBhi4i+nOAi3NucLyU
         eKzQ==
X-Gm-Message-State: AFqh2koDKZjYejgRpcgAJWN1cF6efhWsEfXmKI3keKHxONdHK50hqgJW
        X//R4hmV0rt8hkr4Cs7AGtI=
X-Google-Smtp-Source: AMrXdXs73Z915rrEYq+qN4900ZX9X0NvlilJQSCosBGNPXUv6N3aCT5lZ0I/vIASJo1BncDFX3g/rA==
X-Received: by 2002:a05:6a20:3c8f:b0:ad:97cc:e948 with SMTP id b15-20020a056a203c8f00b000ad97cce948mr40352953pzj.45.1672255239202;
        Wed, 28 Dec 2022 11:20:39 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902684400b00189f69c1aa0sm11363584pln.270.2022.12.28.11.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 11:20:38 -0800 (PST)
Message-ID: <c85bf51e-803f-98f4-8d3f-f85daf28e553@gmail.com>
Date:   Wed, 28 Dec 2022 11:20:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144328.162723588@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
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



On 12/28/2022 6:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
