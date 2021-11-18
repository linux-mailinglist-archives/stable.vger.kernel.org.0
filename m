Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D0D456286
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhKRSlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 13:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbhKRSlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 13:41:01 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE89C061574;
        Thu, 18 Nov 2021 10:38:00 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r23so6153493pgu.13;
        Thu, 18 Nov 2021 10:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u/4kSTrGc6s0vkEXts+k6V2+iObH758xpZNsQ3V2YGw=;
        b=NhQl042oKslxVio5jb4d91oGqvFSEO1uT5e40Pp7NF676KJu56u9QoSvClSBwarsvl
         FnoxLqwX2B7jpTUGpMng28Dod0XVmf5bkvEQGn2tXDbuvmluUx8xS6IXjWp9zJjxMxwz
         rJ4YLDfqp23R7DjeWa/dzhekuc8UNgze/aac+gbMtmOKScnJtJy7ULYODd6k9LDTS/ln
         cNcldt+buPju5cZ97wYZqvKFE2UUJGsKiGQjSH52iDgq1uFjNiPLrPMbwH+SJyWmYvcU
         QV1LPSq0m8pnTEcjsNNLtedYCiPHCXmzYlL5iXDHUK2qq+CYJx8s7g/nSmJA/uRABd1K
         ZtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u/4kSTrGc6s0vkEXts+k6V2+iObH758xpZNsQ3V2YGw=;
        b=v4ezjBJnm3nldRAMHuj4Q0r67+CZQrPrM0YmajbQJL8MUGejg1sYhnFw+eVJoEh2gK
         z5Qupi9yOEoQ+NOTXEGjrjYDMGNEflgj9aYafvSxnhvw/r5N/vntKoS8uOSLnMElnFIl
         O1x7SVYh34CTNW4WCsCnaNWvZU2FdFhRJJMf++d2ghx2gkCPqNL3ZCe58g9+fyS0iVsr
         luWSRAshFJEVzez0EG2zix3+myrRV9c202Qq9zXcZiTbnxAUl3I+idxYZ7INBNhzw+QL
         2tcFFiAeHvXDRYI+6i5zM7BB0IywHOzMuCN+vI4AFJmFTFrADI3G6POq2SMwL7viKgjk
         Eu5w==
X-Gm-Message-State: AOAM531pjq8HWyJGIPELD2cNR7y7VmxrfM4wzy4rAN1bFPkjHHNn0dPZ
        cdxRy3W/fb1ZFsCqG2sA4T+P6U7McLQ=
X-Google-Smtp-Source: ABdhPJwV03P4pLU0HaHTq/hgnzZHm6NEFOl15dwuWwxS2yCvdbQ4RSqr2c44BH7KQOYZ7lJbMCBy5w==
X-Received: by 2002:a63:2c51:: with SMTP id s78mr12796454pgs.312.1637260680099;
        Thu, 18 Nov 2021 10:38:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k8sm258431pgj.94.2021.11.18.10.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 10:37:59 -0800 (PST)
Subject: Re: [PATCH 5.15 000/920] 5.15.3-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211118081919.507743013@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <520f9662-85e0-0804-b41f-4a15a9ca0759@gmail.com>
Date:   Thu, 18 Nov 2021 10:37:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/18/21 12:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc4.gz
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
