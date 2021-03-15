Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76A33C7A7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 21:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCOUWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 16:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhCOUWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 16:22:22 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B288CC06174A;
        Mon, 15 Mar 2021 13:22:22 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id o16so4160186pgu.3;
        Mon, 15 Mar 2021 13:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FeMO8N8mOrZOYLthvyTTz6z7169kWhSczB4v2641sdc=;
        b=d2xRug54QK11RhuS51cwYWzCyiFKVfFVqkKpn1hGP+w6zlXkDAcdo3R/Fq72dRCrxV
         /e/MCUsTxwh3pDIoH5jUl34/KCvkHYVa5gjuYfwhppdpAQNC7tY9zLrUm16TjAXZKAzH
         5ORp2K7HSVnPBHb1YDnIOHDHKyHv3FykZVXva5Uw0dKRwN8B0NtV0iew22fUFkJ4fVpU
         bUSFzAgb/846ikYCXVS2U0pwDM3DWmYT1kM4BYK9h82hyTP+ADaKlYu8fUT1pOrUduNC
         87+p2cYpzDB2V19Xb7uO1LBD5sSh0IkXpzzNEqFIrJnCXTFEw9LpkObKwndcs4MYCVps
         Qd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FeMO8N8mOrZOYLthvyTTz6z7169kWhSczB4v2641sdc=;
        b=O0SLC9s4uEvH+H4CThMvVYhL8qxrwtYgveaefcEXfn17c8Ec8BZ0WitCtloRnO+oxn
         R7sXnXHSuoa1dSe/aTb1sZCyK7n3PtDeg95p1cwQffDp44Kzzknge/ANbPUZyCKuaarN
         PbDd9sjccx6JrqC0dMznhnR4SL3hOoeQb7xSt66Wh/BO7JVy/k+6EkW0QNmQFgc7UQ/X
         W6Wfkvyvcf8k8b3U4yAcmzUrBKRitZsEOZ9jntlv+UlmSAev6eZYl6xOPwtBZDnVN7La
         GdK7rHhE6DBeiM1JkYl1R+zvCh/+7HQhT/xBOrXnhgYxC9eajfP/QjdSQjb6XWdWY74+
         5sRQ==
X-Gm-Message-State: AOAM530Dlw+Q7EaEwCxesNmLYOrF6QNBeo5k+zUboDsJ72uQOSNJkdIa
        KFnFWrw2GsTVIOujl2YpgTsL8TzB3Mk=
X-Google-Smtp-Source: ABdhPJye9+6KXatviEcgw0cN88pvabSHnuOQB/JhEgRIofvEFdqdOAeVeA+UbNopWBKj/kPzDqJXwQ==
X-Received: by 2002:a63:7cc:: with SMTP id 195mr717255pgh.323.1615839741733;
        Mon, 15 Mar 2021 13:22:21 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id js16sm473935pjb.21.2021.03.15.13.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 13:22:21 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/168] 5.4.106-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210315135550.333963635@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0a57d66b-bb32-2cc7-a418-22ba2383687f@gmail.com>
Date:   Mon, 15 Mar 2021 13:22:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/15/2021 6:53 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.106 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:55:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit ARM and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
