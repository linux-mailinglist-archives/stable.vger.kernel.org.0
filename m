Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA834A59AA
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbiBAKLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbiBAKLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:11:21 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C09C061741;
        Tue,  1 Feb 2022 02:11:20 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e16so14866927pgn.4;
        Tue, 01 Feb 2022 02:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EeCGqchabid+tzNehu+gh8uWq74e73DOoeCLshRGCQ0=;
        b=eKnzLgMBp3Jc4lfq4nN/f75TAgXc4lEA/XK6S1sQFE5Z6sxVAgnHACn/aCAzGJKAyq
         V6aV0yA8HVb5+BJxjjEtHaPkNGCTs+orjCzR2JCyGu9qzup5oRY/yvOqF/6Fo/DYVGPa
         f1O4IVZJ0+N0RW706ycJvPs11CHO/RH/eWZ7IVx8rCGhiTPlWsIoE5wACuQ0olAUim0H
         5sE7pU+lROWkFK35JUGijDy3bJt3xZxye0m2G++0Aa4DoZNKIYe7NJ/E3llaP/WQQXKq
         etnAH1wUq6bZEWcZJNzUgfsdPjEvt4ycQnAe0/x+VEdZCNg0q1POhnhUZQIE8fyhhsHU
         KLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EeCGqchabid+tzNehu+gh8uWq74e73DOoeCLshRGCQ0=;
        b=d9aCVlaL9rWQ/jQOCVZ1KWC+0cnN1VIAqYNxDIvPbPWcRHcZ28RzxtFfvAo51DpBeL
         oQfEVczGRgK4Ke11lkKUegUlEnsE7x5FGQptbH/6u5RYmEWt/0s4aDgHJG9G7stP/RfA
         dt6I5wQ5VAZ3u3C2AWSpQaA5Yfu9FscNCdSJYUQ4GKe9qHm2EzflC6iDtBo6+Gi3JqGQ
         mNkmL+nqB7IqjUMkpkv3ceR1eVzeNn82f3O2VWJHDfJM0X1+vxYb8iVpyxlxlXCpqQ51
         T6ar3VXMXVFzVEFvdYvISh+AzsMi/726OixTF8nUZrLn5cRsW/j6LG2MqRN3zha4oBp9
         P2yQ==
X-Gm-Message-State: AOAM5309/wEBW4HjD8LS7Sl78xMIeOEs0sj1+gW5+VhUpptxFkeBqbUr
        gqW9gBCtB4Do2/PQitqHFM/+V+gUqa31Zg==
X-Google-Smtp-Source: ABdhPJxApawFaUtQX1h6ndtNx2nbAxu9roPtoIE4itBHYn+1S5XxdtzvmVQlvaqBCjUR+pMpwyfMKg==
X-Received: by 2002:aa7:9530:: with SMTP id c16mr24063514pfp.54.1643710280166;
        Tue, 01 Feb 2022 02:11:20 -0800 (PST)
Received: from [192.168.43.80] (subs32-116-206-28-8.three.co.id. [116.206.28.8])
        by smtp.gmail.com with ESMTPSA id pf4sm2566424pjb.35.2022.02.01.02.11.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 02:11:19 -0800 (PST)
Message-ID: <c5e811f5-7d29-9663-2162-e2b0171a9c89@gmail.com>
Date:   Tue, 1 Feb 2022 17:11:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20220131105233.561926043@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/01/22 17.54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully compiled and booted on my system (x86_64 localmodconfig).
Also successfully cross-compiled for arm64 (bcm2711_defconfig taken from
raspberry pi kernel sources) and ppc64 (gamecube_defconfig).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
