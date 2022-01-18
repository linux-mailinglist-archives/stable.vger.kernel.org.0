Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC292492E0D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348512AbiARTAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244633AbiARTAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 14:00:24 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0179C061574;
        Tue, 18 Jan 2022 11:00:24 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o3so205615pjs.1;
        Tue, 18 Jan 2022 11:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1NOpw0fI8U5gcc/EomJX+JqGfcu3g1OIM9vbuYlYt8=;
        b=ZVdIWILcRsqy8cnISN+Qq613MzLO1RDiaGL6xZKgkk/JisQFG5CfM5WW2oqx0J0HXX
         kJ909PNVT5JgD4dNbcNqCFIb5KEaPdfsxDMvXid+55A2uSNS/mxd0aPG918QqHMntUeF
         Ja6XedKujQfYkU5gbhnpmTlvuXARUwYUnbTxAV0LRdyWJ7X3xB5kz0CBjhTqU+aqMl4X
         KQu96C6dvsRK40pXAsi64xYRKoPXdtNAAxGKg2gcjEFl2xKeBU2AKqHv7Mu+WzXnZ29e
         tw99rFPQi87t4Ep4D8XQvL2jGXmKN3WTnmMhy3/IcQ5/bAlOY3eD6ScGm1fzbDWhFnMO
         wHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1NOpw0fI8U5gcc/EomJX+JqGfcu3g1OIM9vbuYlYt8=;
        b=14dV4xjbRchWWqO2Pf4R5gWi8Fwwdfi0842JDRkr1wgXHVi/c/NV+jrmGPiR90kVV1
         ZERmAE5R55S9Ju6TeZJk2V/uQvyPMeURuNQmwJxFmvsiDYf5Vxt/+nfKVgY4lbanfFTO
         B1gEtHuDYkF1NAxbnCMpYghw3eiWqHJCpHcVF/ubpVTt/917QUI/bFbly7vwnGZk0bWU
         1C/mC2B03YdXRJ8tQTmJEzM1qRRHKX+YamHa4xLLQqd62BjlbHyocaJIpoObERiffMXx
         XNt30Qsuz+wt2zmtHBdJ7Yul+DP3p4pd/0I4E2dA2+TTg4MKCIPZcF4czKi1CIYLCKGP
         Vidg==
X-Gm-Message-State: AOAM530Rw8QPjo1wPsTY+FpgNkVrFVMEb9az229mQ6wCZ41iQjpqn1xv
        nsljMELKkVk9JN5liWNdu0XWZ8ZJ/50=
X-Google-Smtp-Source: ABdhPJxY5UXvD8fHcgz7NBBuLSAJDf2jf/Okr9oHb0aAK2oT9WyHzDQMK6RATuhBmWZEWer6PMnYCg==
X-Received: by 2002:a17:90a:5996:: with SMTP id l22mr13625713pji.27.1642532423796;
        Tue, 18 Jan 2022 11:00:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id om7sm3667813pjb.47.2022.01.18.11.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:00:23 -0800 (PST)
Subject: Re: [PATCH 5.4 00/15] 5.4.173-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220118160450.062004175@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2c284cb6-d273-504c-bcb2-dfea00e6b3c6@gmail.com>
Date:   Tue, 18 Jan 2022 11:00:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.173 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
