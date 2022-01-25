Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C711649AA0A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324003AbiAYDaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346150AbiAYB6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:58:36 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C8FC0617A3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:50:57 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n17so6052776iod.4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/1d1kaM+wY9koZYobUo0XrdU4rdHnsKv0hB2d3Y2iLo=;
        b=ULrPj7FtDkx8HUFfClmDZrlERjdr03KjuRzkVS24IWs5Cslv0HY+ht853cAenMwKLd
         s2HXWoG3LzazlqsZSc3b6UmKiJLDpoNmYqKFDWfXxOhRwy9SwVh/b9mYGmULF5+/G5kr
         7BvPj312ch4JtZmc9kh09e3dl1EQo3qQ64u7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/1d1kaM+wY9koZYobUo0XrdU4rdHnsKv0hB2d3Y2iLo=;
        b=Lb/RFAE1Xhne1EFYs5uUjWpoVwTUUDdJs04f8ln4Ae8dFXPwDaxWT5prexPXF8FhVJ
         9Po2airuEmpS+pIFYscl50m/WRXQ6k3EEo3WvwmxPptnzcO/2CgPhanc3whV388Wsja1
         C2v8v59PM7hwF4R+4eTtl844IwE/n+rr2G8W0M2z1xzLcXSXOu3Am5IIHvPFGxOukeRz
         Le95lwWbqcplMaLdb4ef58oD3LygR9KS+mvRGU8d8M5YZUNK4RB56t9TJzAAEPZy0x/l
         7ReYiljVp7FcySq+mOkoSqOP4gtTspRYLijkl8TCTEALb5D93CcPJjXJFDdN/BJFUPDy
         dGfw==
X-Gm-Message-State: AOAM532m8tdLXfbxN7xLDdUT5pt80GmIWUH1WxBa89nuwMJrMGIEFmnJ
        xg6f79qDBlleat42vG6t072MVg==
X-Google-Smtp-Source: ABdhPJxHW5JydOSiC9Ml0dy6dX/xJijg6+C7Uy1XiIffHE+NGmEm7LEPvoGkysvQF4/ZsxSlfaZOSw==
X-Received: by 2002:a02:b10b:: with SMTP id r11mr7684802jah.14.1643075457219;
        Mon, 24 Jan 2022 17:50:57 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id k14sm8446572ilv.74.2022.01.24.17.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:50:56 -0800 (PST)
Subject: Re: [PATCH 4.9 000/157] 4.9.298-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <647b943e-48b7-fbe2-fae5-3729d68c8e2f@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:50:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
