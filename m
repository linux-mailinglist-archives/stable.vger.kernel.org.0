Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF92628C25
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbiKNWdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbiKNWdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:33:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC15F1A3A7;
        Mon, 14 Nov 2022 14:33:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso15168579pjg.5;
        Mon, 14 Nov 2022 14:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ObnPkYP9VPHLOLvmYFnfmYoPmSZxQGJ5X5zELinPx1M=;
        b=YymYRK9EE+gX1+Ek0dWAYwMDdT6L4cpJL9lJQsMZibBYAVVIILjUdgcu3jP1tc0rzn
         C3mxhtEyu+DIRjVV1ZYypjaSBKxQTjmNvFT7ZUqBUh5cFeaIY8lPHXWy14u4MRTJYjeB
         xhnY9E3I++2vkE4sxLGpBdmaa25iYG0yiAuLPz3B+JaElSaBEmlHIr2Vbp1HPX6Kxcfr
         mrX4XxVZB1EaQYpewL5bBDO1APQLiHJfXWVO8jvjRD7+hb2ML1Xt+T6bT0qg5PqxYWwe
         tNBJdFh4XUYFkmoUIBeDFiKCChzTB1hugux3/ZGbdFX1tpAIPUaMIGt/TobM0pURE7fM
         z9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ObnPkYP9VPHLOLvmYFnfmYoPmSZxQGJ5X5zELinPx1M=;
        b=LRrIV5fsXxNLoFV/uK5j6jDSweNLyQQd8r3bKNhdP8sev7TYsTKQR35WMQ+8M8lmsm
         rfUIis/ENnG0c2JWfq/0nCWDPcpajT3XMl2lGmbkW06rZp06pRcKv48BEEFSAeaffvB8
         5778vbW5I+nnsOta5dY+A6T+lMT2mCPZoHvChZXHOzPuzfZv8oqz+0f0fNe1llAlheBR
         a4WbBxAe5fWXLrkLXc4jinM+SDwcOYANWOEeHEx1KcjBVb2Gm8XpDO+5W4kam+p+PwYS
         JPhrgjKugv+mupoAYFRR5Q4isqBdggZE2eLYDFHZ86ksG7GZatcsqN2espewJmmvjlWY
         MDfw==
X-Gm-Message-State: ANoB5plo0SQ6wAs0jwAmoIm1CqAFX6VsEXHv990va6Vigz/AD/pDCG6L
        H5aZnjhoEUxdTID4zEQdDN+vwCFKw2SG4A==
X-Google-Smtp-Source: AA0mqf4n2XQ0bxWpFtbCviTJi+M2vDFbL3p8vni35A3arpiMnRgs/2M/jabQQ4FkpqszwFQIhw3qMA==
X-Received: by 2002:a17:90a:af92:b0:212:e307:b59f with SMTP id w18-20020a17090aaf9200b00212e307b59fmr15887409pjq.208.1668465198236;
        Mon, 14 Nov 2022 14:33:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z25-20020aa79499000000b0056ca3569a66sm7242901pfk.129.2022.11.14.14.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 14:33:17 -0800 (PST)
Message-ID: <b42b369f-827e-5ac5-664e-c70fb4ed82e7@gmail.com>
Date:   Mon, 14 Nov 2022 14:32:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221114124458.806324402@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
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

On 11/14/22 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
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

