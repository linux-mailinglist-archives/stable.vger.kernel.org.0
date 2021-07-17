Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085F93CC6D0
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 01:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhGQXeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 19:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhGQXeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 19:34:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB9BC061762;
        Sat, 17 Jul 2021 16:31:13 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id o201so12720182pfd.1;
        Sat, 17 Jul 2021 16:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fxKIUXLbmRN8ueNsQhq3eLN6c3ekGbBfhVweDY7xvjY=;
        b=OTXya9tvVbxwqG9UznvVyJwGzUxWNeneKvmr1IOcWsp8SwM9TsE+izZZFUBL1wfHYy
         sC2w+X1nMAPFfBHB8V+qTJBL3MvgxcgwIKE5Hb7VhXiIIc1KlD7ZmFNAABjW4zQ3Br62
         H2RnHm5l5abh/RxPrRIc3qafhVo5shXaVYPxkbFG2BBKZ9+4k92yX7x/v+lori515bLI
         aYDeo/DJZzmkMiGD+f67AwYeHFJpp5QehK51UBvFxjSAH+5SQ6Nvs5df1UO10oxSxCB9
         TLLFonFCFgdhkXzq4X910jg742J7UIAcSvpehodaC2Ujm29iO1w76KypnUTD+9I8R005
         6wnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fxKIUXLbmRN8ueNsQhq3eLN6c3ekGbBfhVweDY7xvjY=;
        b=TOgTjncScDOrCa3EyLGzpnVuobXLJZp9VFuq4Ffc99rhAJnveLE7wgBpa8YM9MCGCN
         J0wmfrv28M605EpHsAH/+Cm6J7EZkw/xCA9OSaurE9SOytHac/GJccwBN81ikDC++3L8
         gu5itavMzlb2g3VRAL6DBrvM1CgeToazLno9Vbu17x4B29kXbeNB4+Vo8xhcqK3Bm56Z
         DSSJobNPOj7uPCiGAvQQRNyZvdKE48sLibocM2KAcZ/KfuIUHFRHXapcjlUO5VmmwmJh
         +Z2u6MVzOio9GbzpDDMdZwn0/joRXKh6msInE50N4JCL9wobJS1fcnZkzt87BkROxPNE
         EVyw==
X-Gm-Message-State: AOAM530Up8lto8yxSXhtedirKHay/IsOej0hEL72O0tcgwIFFnWNZFlH
        XcCHin8lskGPO54ZoYRLq0VWgs7zgaM=
X-Google-Smtp-Source: ABdhPJwHM9pvcBAPo4YUczQdqjuc5bP+LvvHYV6Uia2+FkAE/q//uJuGg76gZolJaf/A+IOQWQimvA==
X-Received: by 2002:a62:8283:0:b029:336:6e7a:9c73 with SMTP id w125-20020a6282830000b02903366e7a9c73mr9404473pfd.45.1626564672761;
        Sat, 17 Jul 2021 16:31:12 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id m24sm15794494pgv.24.2021.07.17.16.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 16:31:12 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/119] 5.4.133-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210716182029.878765454@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <52aa0a43-3f55-1209-4237-0b66c6dbe094@gmail.com>
Date:   Sat, 17 Jul 2021 16:31:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716182029.878765454@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/16/2021 11:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
