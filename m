Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABD3354602
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbhDER1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbhDER1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:27:49 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5C0C061756;
        Mon,  5 Apr 2021 10:27:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id a6so2673622pls.1;
        Mon, 05 Apr 2021 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EKqbrpSsdQ49mzcIvIerUxoIE8Uaf168h8g6RRMdblU=;
        b=RiSaflatPnBSuEw5lH1MaNrkVDyj8koRQzEf7s2TcpPWviHiGP4oqZT5GraRO6B2gi
         W31Oy59hpwjgcLjzg+zr0nfLoezBTUPNv9m2H4gverzUg4Ld+JF4khV4feYtDtdluJ4F
         dj1pnn/G0yDeggomSj6BJzana+N5X7a/m87OAgj/TsrMxRve6zEiw0k6Gqa7RGa9zZGc
         mTQ0x+y6xikE1wQdSQvH8CKq/A9p71LKn4LOgiOFfGyRUxcm3KwbTPdglhQ+36yGAvPW
         q7q526pk4rsoxoBiup4vTLbKyWUcg5MlK2CeHwpiQGYn2S8ZGM5oo+OmIvOOYzXyqxKy
         tdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EKqbrpSsdQ49mzcIvIerUxoIE8Uaf168h8g6RRMdblU=;
        b=Yz5HqCrUvXf4NFhZq2RWCztJ+bHm8fg/YhH42OmZugwbnm0sW2EJoBSqvFQaFE6sJj
         /gjJbBEWXR7t+HWi78UFSt3JqW+AzLjL3kCZ77DrsmaMEu5yLIJFymASBm/I51FEZ2gU
         A+cqN7XbgmUhOOsBOKsoUIkpNFcyR7PjbAcdO5het2OGtMVNEDqfKrsNu7f1Pw1v+RP2
         IhctKPmjDDMKGuLIodWjIy9HgwNgUra6DXDrFhw4KyZ4Fdbj4rqW+EMB9JpO+/MKrLiy
         IkNG65m3qkEWR4XWgoUZ7Qo73Af072Sl4+SNiiD1OzBPp9Fuc/o6rWpwnNsVSr5FeuY/
         a1Fg==
X-Gm-Message-State: AOAM533NlavM5zuEpyZ9Ya/ZHVdEqh8PX0/aOmQHqJiUr1IYkg8atblh
        JuFgsx8LC78hcx49pjj1U9HM1SPpSfQ=
X-Google-Smtp-Source: ABdhPJxaacG79rTu3h/br4K9ZuGLMcRB4CSKzA7XmMjiew7VjEVmWCoFz5xQXrMNc05PoL7GqAuDUw==
X-Received: by 2002:a17:90a:bc45:: with SMTP id t5mr213372pjv.26.1617643661419;
        Mon, 05 Apr 2021 10:27:41 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n14sm87241pjk.6.2021.04.05.10.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 10:27:40 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210405085018.871387942@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <035dbb88-494f-d6a5-3da3-199968d455ea@gmail.com>
Date:   Mon, 5 Apr 2021 10:27:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/2021 1:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.265 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
