Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538EB462B68
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 05:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhK3EFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 23:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhK3EFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 23:05:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0684C061574;
        Mon, 29 Nov 2021 20:02:26 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z6so19184158pfe.7;
        Mon, 29 Nov 2021 20:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XDz3CQmSMiLKDzSymUH+t6Wlm7vN+dS9L0nfhOjXorU=;
        b=PB9ElOxyBQKZ8fV0jKuoRybB3YGXESG1fn7tWuGlLAJ9sRdC86nkSKHqct03xImd2u
         ttekvR7f0Psq+wsvbW91GJC1WTKb1ou2vbQDTrtWPKV11BxrWLG5ujKtF9LFC2ScQZPY
         LJJIEW7Qp3VOw9NDxHI6F9tkGyqyVtWhsRfiM1Kz+q2VlGaJOOnDfLwzSzSXEMlyeT/U
         74mjdjKAf06zWverxiypW/q+9nnsn28K7bHKMByAsDyCJqM2MChmQ9nvQ9CcKZNk73o2
         omDoqZ21/IJ9d2ym96EpJ3ZLp8SUNe6jMzP3IPsWCdfgAP+xQPyO64XK6EHT/yvqZ6z/
         3wLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XDz3CQmSMiLKDzSymUH+t6Wlm7vN+dS9L0nfhOjXorU=;
        b=E2EbcpoYe55WdT9Rm/KCrditI2jnsa1rypeHWsxY65B8J9atPOui1TeFvSlBFpAErU
         qnrNqo10C0+zvtJmjbT2xOW9vU0Lrqb7bkFjhNvGv9tILd7WaffQFsdSsDZsW2h4XYr2
         47clrFs2jXK1UGfU9/NF9+AoHlpz8KWiB7mZL2KzEZBgqtiMUmiP/amrUJK2YGLYSEFd
         7pK8phtreuN87lg5ivg7gj+6zoD9mW2abtuPbsXj4nTt8zgQmqrsxiNBFNnv7MxcymAy
         vOCO3lR58a1SdzZMnYSiGTdhmGXxHZfPqUV/NxKNKB4DX2HKOzKWy/5HKuCavBt6NHkC
         CaRg==
X-Gm-Message-State: AOAM530brGJsa34YNZhASR9W8oe2n3PQXahjOFDV57x1row/nxfmImDw
        kmJARK5GAepqapFlxgulz2bbL+XrXUjXDA==
X-Google-Smtp-Source: ABdhPJyIaHjfaAg+LgvpTDN6yPVyreuFIAeLMrf3Hfg0AcXXpkGpuGpg7JfOM8U9g6FexRS5uAsU3w==
X-Received: by 2002:a63:ee53:: with SMTP id n19mr24980913pgk.593.1638244946441;
        Mon, 29 Nov 2021 20:02:26 -0800 (PST)
Received: from [10.230.1.174] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id c6sm20756050pfv.54.2021.11.29.20.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 20:02:26 -0800 (PST)
Message-ID: <c8f705a0-8d35-ffcb-791a-c137cd923428@gmail.com>
Date:   Mon, 29 Nov 2021 20:02:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 5.10 000/121] 5.10.83-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211129181711.642046348@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/29/2021 10:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.83-rc1.gz
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
