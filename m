Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3192F42E3C0
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJNVrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 17:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhJNVrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 17:47:22 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C0FC061570;
        Thu, 14 Oct 2021 14:45:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id g5so5083615plg.1;
        Thu, 14 Oct 2021 14:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xdlCzRVGHNjMDjsq6GAUYJ13METgldQ7JXDaHJewMGo=;
        b=W1GkHzUC7f5FNwZmpe1RoiAG0TYF+axhJKbNQrtjt5R2hhNf0sgg+Hrgd/CMjvd1zZ
         Ca56mbCuXR2Pe7P2oiJOKzaG4OWIPAYP6bkMgp4YS5oeUyCWCdk514fG9bCJPaHSXe2v
         70uO+ggY97OS4j7sWja6YnM7MS1+lB0sqosP5MCXPDszODjrDiG9VFXVguA1F/CdyQdK
         AQAMMKhnqteCOzsmmdhAgw7OsaB8hpxRp8A3qpcDrSOZvM27cBTb8D1ehWVAtWDY3TO1
         pqQeNqkCYscZ8Zvuo+F5WFcCWuXIfiujPT24oP6dXO8kWi8YPqKHK1FLamNR9APjxjzq
         bJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdlCzRVGHNjMDjsq6GAUYJ13METgldQ7JXDaHJewMGo=;
        b=rQ/zRNRCM8mikWEd6BWLv8fDI0SInp7hrT64wldUNy6DFIr+EeRaX8xLmQrccR9UVz
         3jBWO8MGFbe6Ef4ycF5tGBES5x8rIQy5e8puov9Ea1x0t/kvtrHyONfY6BNU913cPopF
         fot54HGj+uizf6BygBwZ8j74JeKwZbhlW83KxAuZjlf524smFYl80pNlgHpXbh0v0d6F
         kP/suXJDJVRrDFzIu/EUXpio6p6WncTiK/3eIpS7fza2CKbfTMAnGhlKMLXhl/Rtss/D
         uMwJY+n03kgy4szArwuN9L4vk5NWc8UCfNeaFqNuCReYpfTMSd3ZZAkei6sp+9Yu2rHn
         mhdg==
X-Gm-Message-State: AOAM530Qsk3NCnOsR4akSH3DgFtAvTyNv/0LKpHXVSD5nF+wRjvAPQcD
        RV6N9iXW7HOZ2DgdwUbxN95rVbC1kwc=
X-Google-Smtp-Source: ABdhPJyJq2qIrMVJjceK74DB9F/ZF78nxkEqqJMVcsTzKxJpvB5DMF/49My3CMrF7JQypQLx/tubVQ==
X-Received: by 2002:a17:90b:4c86:: with SMTP id my6mr8988799pjb.203.1634247909275;
        Thu, 14 Oct 2021 14:45:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c15sm3340165pfo.178.2021.10.14.14.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 14:45:08 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.154-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211014145207.314256898@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ef0c35b-1dee-4bdc-db4b-c2375f1ea30d@gmail.com>
Date:   Thu, 14 Oct 2021 14:45:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.154 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.154-rc1.gz
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
