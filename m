Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F77476684
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 00:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhLOX3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 18:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhLOX3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 18:29:01 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6044C061574;
        Wed, 15 Dec 2021 15:29:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id oa5-20020a17090b1bc500b001b0f8a5e6b7so5284592pjb.0;
        Wed, 15 Dec 2021 15:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E4wVk/8PnPqNVeA1jtbfr4FbsH6nhrVH1h47TXbeIA0=;
        b=X4SEDsohygw1ziEqM7xi5pIWmkP57EOslZwwCPsxIwI/lzMYHmk9Lsn5uoUGuL5Qke
         IVLjX9XJ2El26rm5E+I+anviys0BobXrI+H1fbQxPK68t9ycQyQIXSf9WdoGjN+puPcY
         aDAO4eesO2kmGujDDGSXHbNRNHBpU96o57neD8ypM0fb4xxiqXsTFhYIIfeg7gK5wFKS
         BuEsehCILp/lfvqtkIWGf8IFBrruoKIQbNbZP2dAJQF2dgOq8lTCLFLTQ1ktzNTgAM1T
         7pBmDD8wbOW89IWCoeuZ6eo60RV+Fcl6UnTBV0f+EDfN/kDaEMxdR7T1aHgnnQ9GuqXi
         pViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E4wVk/8PnPqNVeA1jtbfr4FbsH6nhrVH1h47TXbeIA0=;
        b=f2/LPTt+ug5QU3AkkzsagmfGGPZiFx8UwR6kqkKgZKwijh4iuSztFCDCO57HcpGblm
         xZasNbAHpZEMTH36PE6GM3kKG3e9cXoR1gCVGgm4xK1RW3KnVbNrlO0/XkigPY44c6Dr
         /uRcrxyb2HJeSaMQdx9u3GwIKOJju196g0ZMOkDN13Wbf7t532F2FXUZdpVO8DJvjAt7
         pOkSt22i4LmIqYf7pgt6WgmqbXMNpvJTCcd2e7JmbktoJnxbwfoVy6YlICoiw8SGveZB
         yczq2TAUSkPYG2+mUIXhdjgJ7odylN1GYf7c0qVJBPdn3Z/Nhm2AN9d/CRIdrtyieAtY
         /tnw==
X-Gm-Message-State: AOAM531Df5Cd34T2K3GBgvQOJa+nyQKFsdnKx9SMwkfUK39tbxAK9ETq
        XaPiXn9cLmgIMj/CRQqHDYiv7ml+Nc8=
X-Google-Smtp-Source: ABdhPJwn+O42igxjl6ZqArXi566YyjFmg00iJEJXZVlKqEAJieIV7beU/Vtj90Bjqwb6oaEFNo8AhA==
X-Received: by 2002:a17:902:7007:b0:143:c6e8:4117 with SMTP id y7-20020a170902700700b00143c6e84117mr13393597plk.55.1639610940116;
        Wed, 15 Dec 2021 15:29:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p43sm3330592pfw.4.2021.12.15.15.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 15:28:59 -0800 (PST)
Subject: Re: [PATCH 5.10 00/33] 5.10.86-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211215172024.787958154@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <07c6c97b-7b33-4c3f-7c05-173833b30318@gmail.com>
Date:   Wed, 15 Dec 2021 15:28:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.86-rc1.gz
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
