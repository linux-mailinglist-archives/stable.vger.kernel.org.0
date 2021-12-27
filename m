Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C89480352
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 19:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhL0ScK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 13:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhL0ScK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 13:32:10 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06BDC06173E;
        Mon, 27 Dec 2021 10:32:09 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id s1so9050071vks.9;
        Mon, 27 Dec 2021 10:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=Zfd2u9+Q6dgG6+KxtdEU6T223CizBwI0DLDNizDBQX8=;
        b=M7LXKyDqwOgxKSDORbt4onigteltD0RE6XkzxxbnxijoMJ+cxz6m8Amf2RRsAC2DXM
         um0hqrqEExeyJZNFtWTKO2DR+uXVGlq3Ud0f9YynNXD9aM73ZxkU4hK/OSzbnqzH8H67
         oLdTyUGICrupGb2pD/HGjyeQAb7x4QD7iC94Y7zQ4kS6KgTLYz0lSaIP4BNeBbcRf2aT
         f9QKoTeFMOzctlVfm+3uxhBftni/SoHxBVBSw1HOvfsOG913Qf342tPGnIreSXEMbADJ
         d7a6iLbf465cHIhun7lp3F7foPapIRC0BoDZVN1Zmgp0D3blc5AmAhoks8Oqslxn2uI4
         oWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=Zfd2u9+Q6dgG6+KxtdEU6T223CizBwI0DLDNizDBQX8=;
        b=t62IJOrYT+APsny7Z1DqHDmUBX6MZNzhRxGG/ZuRI8PD2olJzePJhRRdQw8w5twbmD
         F6gliLFZVxpr+xZLer9nIeX4/g5YcE5L5m7C2iAMN/o6G7wJZSkBIWBwtAZdhD+h52Ek
         1u2ub8Re9+oHXwFM0KDNeDz2Q0+I08KNy496tftMgz8CgBxz2sc8onoCJvvueIkJ8gs8
         aYJ8Z9iRBdzaT2hRQx4MjSoSLDu6nTn4QGfy8cIRvumwH8XS6iVgas8iYXhySTI69P/Q
         1k+pW5uY4IbU1QdTfoDweReHo7RUA+1UxJYdJmxahfR+53vQ3KG1IGkWoH29FfGEDIYC
         bq9w==
X-Gm-Message-State: AOAM532u6oLIe0N0qh//ngAkxrVdxqKQuivOf9BQI7nfz1UNry4Ekr5x
        AK8xpgYz/UuXyJfoxd6R4Os=
X-Google-Smtp-Source: ABdhPJxoCvAIAgG4HjkyMI5OQ4jjetWfNv97arxS+oF4bsfU3ElVmh9inSB76Lv+eZ7e8Txz4omWXA==
X-Received: by 2002:a1f:1fc9:: with SMTP id f192mr5342195vkf.33.1640629928873;
        Mon, 27 Dec 2021 10:32:08 -0800 (PST)
Received: from [10.230.29.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m25sm3175739vsl.34.2021.12.27.10.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 10:32:08 -0800 (PST)
Message-ID: <58fa5e31-9e66-f1e0-d61e-591dd1148edf@gmail.com>
Date:   Mon, 27 Dec 2021 10:32:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/128] 5.15.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211227151331.502501367@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/27/2021 7:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.12 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.12-rc1.gz
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

