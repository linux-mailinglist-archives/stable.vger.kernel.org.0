Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0A338F598
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 00:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhEXW1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 18:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXW1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 18:27:43 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D82C061574;
        Mon, 24 May 2021 15:26:14 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v14so18434231pgi.6;
        Mon, 24 May 2021 15:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ijS1JpXOi8B1tolKqPZrvvt1/JkfWjMSymM0Q5F0R8c=;
        b=Qegzn4yqS/fQUFLkKGhcioforqeT32y+1BKod51WPT5LgjFz4g06DgPeJWzXzLk64i
         RoXjJVTM/i5u8LF9Tip3wcEQtbXW4xgEq7J0ci0dUNiQEQIuucEprHWAq04TPIlhZIlz
         3l9kjIZTvTb/5O1r1bu4ryYdHDXZfGLpZ3XIbfeYAwJyt5BiW9OKIorjhFOOxefjDzhV
         CxOlFPt3HQ7/QyS/D9wLA1Gn129IDzouwojK1NblyprXj02B3BpTKykfnfr0qOnQWj33
         e3GO5HWBYbSHbWnBCrWpW+QCAOHbw4/zftdDPPOmBOAaB8dApp8AZP0oiIMVPvajNwOE
         k2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijS1JpXOi8B1tolKqPZrvvt1/JkfWjMSymM0Q5F0R8c=;
        b=l+CRnODwjmbP9kSVjXvcsehd0vHjBwDCyhN9k2ttAXoKERO7k3WRHmwBA8z6uVSv1y
         cZmt9ggSLA6L02MHpFSMw8OkDI0yoM+1v++f3MhwraT2xwy6X9tINGVVGEue4/V24jya
         PcDK8h9hGtQhlp1r+iOcTiohB1tznvqaMS2h0qVDFFBryW5dvPnKwLHe3UYxt2jem1Wp
         6YfuJ5BzEXul2wdTDzH9svA7VGGRhDY339O2LhCaa8+YDgqIpynf+fxxLgMnn2hEwRGL
         xvmEKYhdqQA7Jdgql61u+/4afmRl1n+jZ0K3gzU7WPYbSItm8iztGEMDx3aNXDV9RtkD
         wxWw==
X-Gm-Message-State: AOAM532XzbCjylzCYKhxcKtaLJaCBiZxH+iWTfmlg9hEmj/1B0g8SN0t
        62s4Nqz5I2uLu+dwQsL7/zUuzv7rJ/g=
X-Google-Smtp-Source: ABdhPJyjfddw6SKLM5ZJeIUiaUk8q7jWg8oViyHvtwlZ4QlOxcGvAeWCUVjpXtbxwr6ohZ22htjhcQ==
X-Received: by 2002:a63:490:: with SMTP id 138mr15749310pge.99.1621895173368;
        Mon, 24 May 2021 15:26:13 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g72sm11765403pfb.33.2021.05.24.15.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 15:26:12 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/36] 4.9.270-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210524152324.158146731@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21b398d6-4cf9-1f99-fd14-0207a5cdcfdc@gmail.com>
Date:   Mon, 24 May 2021 15:26:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 8:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.270 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
