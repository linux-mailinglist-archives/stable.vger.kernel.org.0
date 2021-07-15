Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424273CAF4D
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 00:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhGOWpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 18:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhGOWpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 18:45:16 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960EDC06175F;
        Thu, 15 Jul 2021 15:42:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gp5-20020a17090adf05b0290175c085e7a5so478290pjb.0;
        Thu, 15 Jul 2021 15:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BVw7rlbdXsx2expzS3jO3rYzvYP2WBigJE1GsKn9KwE=;
        b=b9UEeZqGzOBksShhEPzCyQ2Fc0et/7zj7p3ocT5jCbppaORm/qyo2RdGhF7YcnbZIZ
         F34BYOxqh6ikBeOBJOljNoCcC2pYC+yZ41IzvXTPOz/KNFIpZ0oKwlPBwZIoldryUSCa
         ccxOUTwJgVu0Rpcs+inu+1cCwf6jsPc+4J9zC4m0TrSPc39vkQSRWgyrsHlkOso49+Mj
         schCNds35ZY94KG8PfrEbZVKDZEhCvCmQW63R0zdekInPMOP4OJxXFYm9nO9YYFDGuJY
         UsUM7xIUouvr/dfEWWsurz63zdTkAAAf3BmUqC8bTLyh2O/f7rKAG8/kNR+2x/FxwjXw
         acKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BVw7rlbdXsx2expzS3jO3rYzvYP2WBigJE1GsKn9KwE=;
        b=M3wcmHSeZ0u+DCISxwd/tZa29WgCkXMNyTuDDyvH/iuWxLbTVTk1XI0N1m+WvHJu7Y
         BkecfynBkKz90a/gZZMS6Ulx67Se4ssx+QbJhhhR+hIkWDrUae/b5zDHhLgzT+qgInip
         XMhKHpsd1c81p/7ua7LzYXHCuYjkTMbpbvWkcgxg5uF/LyS295MaeeDSxOAA25jeOMR8
         Y6W/u/T/cJ5/xfTRvKtFsZ3fZ+B7UYuoW+R5RcJ1XJWUcEfAJCK41AEnQ0JaeNgaYo5h
         PXUt1NYBIl2hipJyia36PNO/NLCZk0cNbM/7MVTxCWd7aF1Gv8pCscHnUjP8OTgz1IGM
         zmIQ==
X-Gm-Message-State: AOAM5316yq4UkP/2Yqracg7LpD6iu/5IWtAzvS9vguXbrzHIqXdgNIPS
        2wlWsoCl8Fw+3xr5kStRoSGtiZ0D1ySUjg==
X-Google-Smtp-Source: ABdhPJzszR91tpSpUt65aYswOXLeynPqcjp5jJfZirvB0pXJbppuX9YO3T7ZbXW1MXdp1Zpp0leZHw==
X-Received: by 2002:a17:902:d50a:b029:12b:59a9:9586 with SMTP id b10-20020a170902d50ab029012b59a99586mr3071517plg.62.1626388941547;
        Thu, 15 Jul 2021 15:42:21 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w186sm7921536pfw.106.2021.07.15.15.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 15:42:21 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/266] 5.13.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210715182613.933608881@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <698aae7d-daa1-da76-2693-5a3488f5b493@gmail.com>
Date:   Thu, 15 Jul 2021 15:42:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
