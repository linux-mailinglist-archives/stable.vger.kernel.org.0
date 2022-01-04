Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D4A484794
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiADSNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiADSNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:13:22 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A13EC061761;
        Tue,  4 Jan 2022 10:13:22 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id l16so15537419plg.10;
        Tue, 04 Jan 2022 10:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=whL2S6rtPh6h7+qTsELuJiawBHscqEuY+9HepRLG3ro=;
        b=J69BO8D3+itfdYxlnhU2cVYjR8Mjov4Kax7HdFttPq11Q5457whwEh3V36edYlyJLD
         wjq88InBMbfx/ZE3GdDptmvUxDykq208A83Coi5kjp9kdNtPW5LGL6evixzT9a8uTkiX
         FwqeiCe5uiKZyVJmNtbTnAT+HP5zBUVhe+YQF/Jh6HbenrJ8qr2TOZXlDVaSx3/DJsuZ
         c4Tb9xc/NbvdRLabmrJS1Y7TW0fCBuFGr50Itv4g0UFpMEE598OISPwvQsA/QMcE39Wg
         IbHPp8uPq4E4KYO0/a+3lTUrPmEuScNBUuMn8yXGyiNMfh9eGN7kHK3V1ESZZJ8tgQwg
         nOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=whL2S6rtPh6h7+qTsELuJiawBHscqEuY+9HepRLG3ro=;
        b=m3V8NzIYSptof8jV42cGehlYADLD3BXCqQNaapmQvDPEYF/birEVRGyYMeABCp01tt
         B0feqR4hjTjAbZXkMygWqBtWW8Fy6GBPj3mjWMgT0t6E9OvT0USMNA8qnQwOcoLvFEms
         Rw6B/4iSQ4oyaGh7EJ+o4uQeyrwMSWz0Y94z6nVrt5RTfRUStE2ZiaK5V9RqSY/QtKyf
         zk13YAuISuQE/mGscQInXr8Oy2Ns8dLn1M4RsmNN5JLGkCjajfmjYzFGOoiVL15UFO4P
         i2aX4gsFYmZ+p+pvPwCRXyTVyi7qtNgu73P3uQYYn9Yk6aCuut917y5L5MePOiCUH4Jn
         2K+w==
X-Gm-Message-State: AOAM531LQK7aWeWXwKw4oFKVHk9C1jN/N/BDQphhHklKun+cYqxjiVrH
        DbGyUKVo9BbL/xafz2BvkuuPrVHxJq8=
X-Google-Smtp-Source: ABdhPJwyKf/xA3MxG+pfuAsBBecp2eAcDGCQ6fCYZLK3gH5Au/yoFL901uUQuihPvnJUhi2fR/Po9g==
X-Received: by 2002:a17:903:28f:b0:149:43db:f3cf with SMTP id j15-20020a170903028f00b0014943dbf3cfmr51356351plr.104.1641320001383;
        Tue, 04 Jan 2022 10:13:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c9sm38509740pfc.61.2022.01.04.10.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 10:13:20 -0800 (PST)
Subject: Re: [PATCH 5.4 00/36] 5.4.170-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220104073839.317902293@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3146d623-b7fd-de2c-6845-87f59c06b6ed@gmail.com>
Date:   Tue, 4 Jan 2022 10:13:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104073839.317902293@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/22 11:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.170-rc2.gz
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
