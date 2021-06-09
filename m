Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063E03A1CE4
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFISm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhFISm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:42:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6EBC061574;
        Wed,  9 Jun 2021 11:40:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so2001412pjz.3;
        Wed, 09 Jun 2021 11:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8P2fuv+khTDAahTh67Og7TQDkP0/CickgU++c5fP4pg=;
        b=o6Zg3TuZWAi/EQDxTIbObiqNxlvXi8bB89hgYFM7Hd/AsemTaBWjCIGEDRutZGTLXa
         bFSspXbPij9KcUgv4do/U6RKScvAMPiN63r1REDAaeJFcHDgGfYzfV9/HkHIoGaOD0W9
         j6K5B5FHACLNN+59o3j2Od5Ar+d25J+jeNRP3O+kebxqrJ628SPdHfXaZxYaMK0NNGii
         9cRk3xzM0cdhSlC/7Xx5VvC7h+p0f4d9pSq7/3qR0oBWSZ+gegG6XIaonIh9LrPMK46Q
         6u/HB7NLf9ZMmseLpbBg3h5mgBYCMWvBfg00o60/D7Ay0RHlmMo16qYa7LmrQ4VKNSd3
         InIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8P2fuv+khTDAahTh67Og7TQDkP0/CickgU++c5fP4pg=;
        b=i+Hm9CThtF9Ct79l7DeKfvojtjTD2RbnlDHBYlkiy14eD3OmzDJeD9TfFXUj5hPQAt
         fW6H8v6Dj48BSIRRVLKDdi7FpLPs/MnW9gECAIHtrydyDn+FzlMa21pg8u21n5kW0JbI
         LJU6BFgTY7QoCl3vQAOMRhGwDKfmPBgTgjDGkbY2ZZQ06GdtonEt6ZHcfincfyT2XzIJ
         JlbtIUHWg9EbVOeVCiqtscyG52Wl/dOYWTTqs/6xqJfPHtVdVIEsSyCiO60LsBcPYqwT
         0FFaKu3KBlrgPMVVJo7ZyDQgPFcikBAHhHhf32elgzV+IJ4Fpz3rSV8P5R1e1p+Ii/kv
         22bQ==
X-Gm-Message-State: AOAM530D9erVh03FKfViJ2OI6c+NAw5owsAq1+618TflMDi66HTywCVt
        C9Z0WiPgaAoi6kUoc6CgIkRtZjacEk5bGA==
X-Google-Smtp-Source: ABdhPJxXlLTo/Vzsgw1q748se9WYoj2EV4RNrKyoZ6dEE4DGRnYmGPgeHhJXSWSPTROgUZIZHexi0A==
X-Received: by 2002:a17:90b:354:: with SMTP id fh20mr929299pjb.67.1623264051504;
        Wed, 09 Jun 2021 11:40:51 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id l128sm474199pgl.18.2021.06.09.11.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 11:40:50 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/78] 5.4.125-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210608175935.254388043@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <335bf005-465e-5d94-86af-4f366b834b03@gmail.com>
Date:   Wed, 9 Jun 2021 11:40:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/8/2021 11:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.125 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.125-rc1.gz
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
