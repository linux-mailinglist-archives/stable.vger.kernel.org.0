Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A5E3D6B1A
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhGZXzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 19:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbhGZXzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 19:55:20 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DEAC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:35:48 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id q6so13131015oiw.7
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N4sHPqFO+0UnuIajq1CrRbZYg945sBNoYL5FHc1bius=;
        b=AhccOk5/4mvoSZgyOGBI5bdwH+y1ro8E2e18YJMCZjZmbFN5QlIN0+GJ/m2VLrqtx6
         7xEF7zi+FfvNM/voLxApxNfMNwcb7CPrOyXFppTybm+yBXmhqNI3LaHD3F0BsfqsvwHv
         8B9kYmUkWN5sxrEQvdWzBqjif2tupvtoFbT88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N4sHPqFO+0UnuIajq1CrRbZYg945sBNoYL5FHc1bius=;
        b=J+Y+wcrW8SsyFf2HMZIxEC2p/H/E8vd+7lynkE1Vy7kInAZOFKziPftVZbHun1kXdb
         /Ph3pWoqaVN9+WbEi2gPUbos0Pjx4S4Gw9VckkWPOLzZie5rRi5q9l4uuzmiRi13taag
         25DTYM+0xxVm/Ot5rljKrILx/GB0oNeeqhK4rexfyUrkdD9AuFM7ASxnBCEHBRREuYW7
         1ZoMSFv94KPt5xks1D+ZaqSzoSWz6F82pR7E9pNqE9wAxVdgqBFb3v+vdASv8siwpm1t
         jpkHviFIwrxre9VASGCluBKSjjhmUoaBWgxOy1ZZsWUhoVk0iFbC1TkanmjPiWMPDDoE
         QZDA==
X-Gm-Message-State: AOAM531Je1os87tKd3DIMGFrveYUBEVIm6Dgqm3vxziYXD/8FyA0+MMT
        GsC2eKaWIwcT4/I4dYK6W7U6sQ==
X-Google-Smtp-Source: ABdhPJwfNJs9v1D+e6mx51sqjGc6w94Xc7N1ihTD5nwba3hk0SJTSo64D7NSveJkdO7KYgLINVYH7A==
X-Received: by 2002:aca:5f8b:: with SMTP id t133mr1126873oib.15.1627346147529;
        Mon, 26 Jul 2021 17:35:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c26sm265077otu.38.2021.07.26.17.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 17:35:47 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/108] 5.4.136-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bace032a-c6e4-ab5f-0d38-c2a1bd48b037@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 18:35:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 9:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.136 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

