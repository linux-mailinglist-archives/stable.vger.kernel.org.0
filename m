Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856D148480E
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiADSsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiADSsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:48:08 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E5DC061784;
        Tue,  4 Jan 2022 10:48:08 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id mj19so32034711pjb.3;
        Tue, 04 Jan 2022 10:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vSK8/28CP9KIkcXPEPV3gMsZVBQeibcySwPx2JeGPls=;
        b=E0sXlatkL37VBQBKT3QzkmzhW5+i008O11NLBGLxpHMZha/utBTR2qul0n481ba/5b
         bIdjlN0ufSYhsZr2yLx7Pudp0IYh+hZ4co7YezE6aDiyPLW+fnUuA3EXugxqe7oFIXPL
         V8UWPk4DCmYPOsC5hgRWezVsZ9HicxnDHY595MT8ZFKS4BwCpjOsO1FFHrHLkptjI5UN
         cy0iw1E641r/QwFZ/fFZa2sD7yp+Ijq0x8HGFbPZemGNHk1MN0V8gI754vkU0v9kkbeJ
         05kWOvssgaGu2vs/hSu6mrxI7z07QVXt8GksmCiGn6HH6OnISKdsJPrLTXGScNCUjqMH
         y6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vSK8/28CP9KIkcXPEPV3gMsZVBQeibcySwPx2JeGPls=;
        b=7U//Whb8FybS/ep44YrJmFSgKiTGqtdA5x/Zw7OntK2vwGfWWu4udO3M+88FYSeJP9
         K1CtzFjQiEvW0o8SqmcozixQ1fmiE+kW8Gw33P2XB90i+EcxehjzGjYRIi32XNwNUlsd
         AzWCMO5nH7L8gXxr5IKGxQ1OUawc1B1dFAA32vavsbqsGcp1tc620SyXGmwX2tHovSOS
         7ainLD799peDU3E+pvq9OIiUpuzHLBouRbgM7YylAveF+6J6xPWQCTwpw+9Za/tOYh/f
         FB4EFGqFI1Ba7W8Y1ewyUhMdJaG86GBINlqlFdm/HA8IyopDZfXSLSvmg8U++LDLm5+/
         SaTg==
X-Gm-Message-State: AOAM532ZP2CDIDcWKdLrUFxti3IjpiQObhHxx8WEc539JHazYFjJGw0x
        ujIoslYMdi48svcTwSKuje6oyxrj8t4=
X-Google-Smtp-Source: ABdhPJyZR7WN4U4OsO5dG3tpd/KD1LauKNOzYCveoA3OCZ+QpzD3ZssZnedqZXLg2DwjxcXlvoIpRQ==
X-Received: by 2002:a17:90a:d510:: with SMTP id t16mr61981126pju.84.1641322087413;
        Tue, 04 Jan 2022 10:48:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l11sm9290932pfu.115.2022.01.04.10.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 10:48:06 -0800 (PST)
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220104073845.629257314@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02f94e92-e621-2ebe-7a55-b91460706069@gmail.com>
Date:   Tue, 4 Jan 2022 10:48:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/22 11:41 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
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
