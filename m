Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13AD48F0C9
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 21:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244216AbiANUPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 15:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244215AbiANUPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 15:15:32 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EF1C061574;
        Fri, 14 Jan 2022 12:15:31 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b3so4937739plc.7;
        Fri, 14 Jan 2022 12:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QpNkYZt56QNcYEoztkMnbQvXnJ4JBQEU46p1qrhWTBs=;
        b=Dvwc2PTkQkLJUIaAGR6RnMt/WqcHsEj66qnzELUzaDnBx9E0cVaLex14LNVamvK4YP
         /xvK7+OdQcOTa4EvaWPINuvJvkXop8Hk5V4sxEzPnVCSF5LXN16y0qSwUHEdelTOpJAm
         3TH0jjErkGW9ikcgdm3xnFMQ17198iArOO63dYAWYbSZ711eutpJi59Mama2KQUksejH
         xTU2BFPMEBeLTOXvITssoYA0zXQcgCwXltZrq/iVVWbYeq6t/ZRsEbPBjrmW5F9Ampn6
         33yrIwhufw8hQVCGRAbSIgF4HyYo3BcyHPc5TRITEUzm7gkAzscHCgMRTXCUTS+lIhNH
         dfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QpNkYZt56QNcYEoztkMnbQvXnJ4JBQEU46p1qrhWTBs=;
        b=hiv7fxPnXxaL3zTFBcQgSMssAENpppnsXqvTMUioHfdxvF08HZsVKwCTM3B0SUJx88
         Sepx2pu6pkfY9dgagX7jX0ra4ZtUi9wbzAEgrrfnLrFyuVq573APOUTvrTjSXofn7yfU
         /L9WfGj+x0xegslBW0mVy9trBwslVPe0ak3rRRGm25jGm59Tyot3XL4nxo65wYKqS1XX
         RCTM+RHKBkn/G9Wm3dteAG0nkQAdmSRBnjtUbsDLbXjVIDmFjx1uMhQUW5BkIyS7jAU/
         //kutsIjW7dtYWYtmLN7jk+AmJwGDrNHRbc/zeZ4HlKjM8OwtRHPbvEk3K3DeA/8eGQV
         3EjA==
X-Gm-Message-State: AOAM532RohopkVfTWcpCnsRz5r6eFGxoMyFqe5ofTDPHr3nYta8jVtsd
        kKoEffIk0UAuXwPQZrXUo1A4vRS8mnk=
X-Google-Smtp-Source: ABdhPJwrxfyrZ8Fpgk/RVLpP+GcTskHLfLPpMwMofteN9diKsCfMTHNoOrtCJttBUcOfAEFHpjoyIw==
X-Received: by 2002:a17:902:6544:b0:149:8222:4b62 with SMTP id d4-20020a170902654400b0014982224b62mr11135353pln.114.1642191330688;
        Fri, 14 Jan 2022 12:15:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k9sm5304259pgr.47.2022.01.14.12.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 12:15:30 -0800 (PST)
Subject: Re: [PATCH 5.4 00/18] 5.4.172-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220114081541.465841464@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3891dda4-c32e-2c60-7dab-7024a7611e9c@gmail.com>
Date:   Fri, 14 Jan 2022 12:15:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.172 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.172-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
