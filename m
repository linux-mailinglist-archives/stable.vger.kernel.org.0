Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4896F31A544
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 20:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhBLTWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 14:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhBLTWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 14:22:10 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCA6C061574;
        Fri, 12 Feb 2021 11:21:30 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c11so107615pfp.10;
        Fri, 12 Feb 2021 11:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LzOrSUACTBWXgiiphHWyW3zClpiObYApqSiQB8b2HH0=;
        b=LGmmZzxCZJ1BlAlRfxXye9nkMvQyJ8gGabULyyaGvtV/tbmzFXH9RExpX7SscVKPx9
         P2BG1UP5Osnq4LxETCiQso+i0OzRJ+BHN3oyT1sjTmOOx+2s6AB39ebdPBv4Oc23nMgt
         gQmpZWPM5HMWBjxpfEWi/UjJ4w1AEtXSpj/kGt2Gfs3zURU8zQHtBDxvqIOi5nI5GRBv
         AYlzomExlQi6NaUklH4ODEOXrvDXsJRFeDQ/GSW6DDYNSSN3SE9BoyxhRR6c7gqmDvfq
         ZtgpJi034gAyVkHPD+4wqjHBe8l3Wy/iSGjjXEmqgLGHJIBX6X+w/qez/70oIREU76MW
         g73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LzOrSUACTBWXgiiphHWyW3zClpiObYApqSiQB8b2HH0=;
        b=YCS8LYoidkpsdHNu6Mq03/lGQnzm4rNeDEhI4QRK8XMylAVLy6Twu/kpWJMlpQacyk
         rqx2tKgAg9XiugjYdZ3ZqKNEiIThZm8avGpd0siSxF3lCYe7YZRnbhkZY5sS4PPoyw8z
         /ApWvl5mxsNvMcwYgDN23EEaeqd+Qpnl9GuH9UeVcGXh4OIpedOXs+mzM2sgD9BmGaQq
         r0U2eynFRUycx0U8Qx9JyBFGwbbPYTQQ4IT1ZdoR77U18hoFakISc9XOCd+7AUjSaGiB
         k7kNYTXxhcWYWh6PV1tG5V/E1zbH8UhpSojg/p8IGUEl1cvAY4NvzfFikea4aO+b9kkT
         ZApg==
X-Gm-Message-State: AOAM531YG7TB11Y/PdO+/NWZC/tb4Lyzvf9V/n+OuVxD9hWkG1AR1W7v
        hxSTgsgzE5hlH4vBfCRfjPWQw81xPjk=
X-Google-Smtp-Source: ABdhPJxAOV3LvgmZNr5odUtFxI6F0SfZ60gMuiru6bE8fJuwdvKtpgFwGdlopjzeXpz0KurxX0kuPg==
X-Received: by 2002:a63:4e53:: with SMTP id o19mr4517923pgl.428.1613157689211;
        Fri, 12 Feb 2021 11:21:29 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k31sm9665384pgi.5.2021.02.12.11.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 11:21:28 -0800 (PST)
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210211150152.885701259@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6d521b40-3b84-decf-a137-daf4299af2ef@gmail.com>
Date:   Fri, 12 Feb 2021 11:21:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/11/2021 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.16 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

On ARCH_BRCMSTB, 32-bit and 64-bit ARM, thanks!
-- 
Florian
