Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2429E34D620
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 19:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhC2Rge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 13:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhC2Rga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 13:36:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232BAC061574;
        Mon, 29 Mar 2021 10:36:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x126so10289242pfc.13;
        Mon, 29 Mar 2021 10:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QfZ/Hia5QBGJqzHVZRJyZZBATTTYnoRfwWMula6zKWQ=;
        b=aVFFavUMYR+NuvlxFrkJSMemJtISbGs2ueW00Dr39UqatxXxCDiEwnkOVmzi86ViCr
         XJ2Y4p1smLhKvi55SVOtnFh7kc92JNij9yKCXhBBtdcuMG2umMTLpcDw0mfy+UiQRENm
         ImuOSil6cORgmyuaLUwYSjvl0Id0OTtg2h7Vpg/8jJInblyVeiCscpKDjhOzAm9zpCQ6
         9FegqewsfPRRPLR6GNY1sQYco4yhNuLY0Mvay5EMOJOCywoQxrYSOS9Exc8gg2teglHh
         /bHp4wuJ1+LvKdK4Z8tODS4duEdRya/4atEUAwZMprVadvXUyIJhjhDuONZ2/ls7fLDR
         l/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QfZ/Hia5QBGJqzHVZRJyZZBATTTYnoRfwWMula6zKWQ=;
        b=rZLPA6Ft4jxvNfZrOUTJjbqH2HsXVvH2zKYHzIH2ibn/vLW44LKXNXjwy4lnZ/xxjL
         qQ0nTDhj5TVCHWShmS6EDfYSEIvPgpAGhv+MvCs4tcv3WTcLVj+49Ipix1VQAH1BUFB6
         aDwyKsZGJt9VMuAf3ZfD64U2Fd5ClbTcw3q48VkAr8Qb/OUn6Hu8XixvvxmHBJVFZLjc
         oeSYFZs/IfxIi8lPZz2z1RYxM9ScN6Fb2k27UosTe/BYjOjLbbunX61sjlypQshq/sLX
         TLlyTtVbKE3ZRcdiY3c7rsPQpCaQKdSvbfZz0ZGYuziwQOfVtoaxM7PAeR+ytErNdkob
         M9sg==
X-Gm-Message-State: AOAM533I9Re4l34waRgWj2GpmRqAq/AKVRf4iQnndLk1XCDYHEaS0FoH
        wGrYTKu3C/SugSpTHics/oZNFAwKc5w=
X-Google-Smtp-Source: ABdhPJy6bGrzJEVxU4mffUvaCOYg96QDOhVU+F7myQ2K6ipkmlpmcGvK3x6iTpYGYOOJskW4lEtfxg==
X-Received: by 2002:a63:3e4b:: with SMTP id l72mr3854579pga.203.1617039387103;
        Mon, 29 Mar 2021 10:36:27 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h137sm17064010pfe.151.2021.03.29.10.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 10:36:26 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/111] 5.4.109-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210329075615.186199980@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6c5982af-b647-70bd-ae80-4e7476e0a7e8@gmail.com>
Date:   Mon, 29 Mar 2021 10:36:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 12:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.109 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.109-rc1.gz
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
