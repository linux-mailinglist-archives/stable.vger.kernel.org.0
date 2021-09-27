Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48687419DCB
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 20:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhI0SHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235815AbhI0SHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 14:07:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56326C061604;
        Mon, 27 Sep 2021 11:05:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so416244pjb.1;
        Mon, 27 Sep 2021 11:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aCe9cQlxizWPqPrStonYM1I4buyo4DZsOUx0n5WkBks=;
        b=fcug6hPK6mHISnLsphdASOBK/A/VVxD/648c8Rvcg7D9LzDUSgF1JXxcSD5INXC1PR
         INF/i2BByIpHOOLO2AqVFq6RXXmi9FlvhxffwwdQ5kjn+E4uXEoWbdiRRHveNX12qv34
         6CtrNmjWYSoc2kl5kWBiVhwkJyY4ZEzbeGTFy1QJ2mETV1LKaH7mAU3EgZC4Mq1HFd3d
         d/+fEhsaJ7TOqhfVs5s+mmBSJtzSOLt+1T+fGd4cD0gKFwRyUgSV7T4tKRYVcWE+o7ik
         Mj01GFKWO9GO8k6K0JDd6bSh0ps2Rfgz4luHqWUloDWD1q3PD9y7kpYofyxDJo/wMr98
         fclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aCe9cQlxizWPqPrStonYM1I4buyo4DZsOUx0n5WkBks=;
        b=00EKBqTBygIM9QbEh9MWc5Tk3EQWgEHnEiQiOI2gdN41YF5bWesJm5cP7D2toFzFsD
         pN0krEmP2h8qGr9FOD0+ERUAN7W7eUqAacfXgMJBgXjMfID8vEPO/GnuGHobld8MIph/
         pa63/f7LRumKycgunGBPwT9XxKiznVjL7zDsZsJ9MOJod7U+dDn0BgkIqST2VaHienDH
         piedCC4g1MS8rrOiZoUY2LlHPlbRakAPatLE2esjD5aYClTnsevndf+6kcUF60T/AYbK
         /f+0Rlcu8TXPvG5MgZWT7cQZPP/HBmW7DkTyvUshx2BXgozxqj9yMGt1qloh0uu3xtYg
         Xu3A==
X-Gm-Message-State: AOAM531ZSzQIz+aTCS75esZLHfVDIUORTTCJY0+kjDlxxRVbADYVC9ba
        If/7zSgxwMpczMzYenxResJ/QZCnOQU=
X-Google-Smtp-Source: ABdhPJz6qkuWYSYWCS6+mOypEwBn+e6YltqMTa5m7Eoaa/osaM1VZAas0JNhRAM5V3h1Ym0aeYL92g==
X-Received: by 2002:a17:902:ac96:b0:13d:f848:cbbe with SMTP id h22-20020a170902ac9600b0013df848cbbemr1149227plr.9.1632765921445;
        Mon, 27 Sep 2021 11:05:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i69sm18493369pgc.7.2021.09.27.11.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 11:05:21 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/103] 5.10.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210927170225.702078779@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ee06c7cb-d730-3e49-ce46-b803fa91651a@gmail.com>
Date:   Mon, 27 Sep 2021 11:05:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/21 10:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc1.gz
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
