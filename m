Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13362BB8FF
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 23:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgKTW3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 17:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgKTW3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 17:29:08 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481CCC061A04
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 14:29:07 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id t8so11531858iov.8
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 14:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5ShaT5at/15Wk+l6TQvMcSJX2KPbHXeaX8eBWb/OiLA=;
        b=DAkI7GqfxYyBkSk1Yoj+3ra0CFQhecgHSjalcSq5ShUwPFNweEj6NhUVmKB1CI14Kv
         UpQUix6Wddj2iLg9efM63EJJ+8iwDLTSZ9elRHZoqw597LZRBsjwdxhrMdtEFisCS+It
         UGNC+KRCck/XkOUaMF8auUAEf+Q8BmqqR0Uco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ShaT5at/15Wk+l6TQvMcSJX2KPbHXeaX8eBWb/OiLA=;
        b=OCUZUTEscdXu2Og70mZO45Ao2pE2izIh0kqP2X76qH9W3/YohuJ1Lq36zYXWoTvIYq
         Dp0Cha79iGaQSlsYkB/k/W9Ilbmxf/M8nN/uDNBy3sl+bayRSiXhdivARI7uDiATFWjb
         Mk3SQXnTaapH4+VMThQZeOutvJlwNtTsdNbIMxNmkIFsgRpEowNTM+t4ORTlq7tav6VW
         8GVkHI14HOrRQ0SoveTaclmYaGqv9TS3x9IwlLUsCZW1I0K5DcC9Q1mXLFNrmz2u9eks
         wpyDokBMXpl8kpU6AbGy8y3VB08WPP4Hb63gMXTeGReUAtmlFfGlSJ7rpaAGvFHLsEM/
         LHfA==
X-Gm-Message-State: AOAM531t2xOc53+sun6K/Yh0OGpCNLpVoLsQdwOv8ZBGjEgGYIExFNd7
        NwdvwS5EENAavSWNBNCfDBHWLA==
X-Google-Smtp-Source: ABdhPJzXQTpTP4PGIVMpnACGU85mHTbaATdYP96EszjuPp5+uJoSATZjXTiV+Gng2VWk+LWRgJEo+w==
X-Received: by 2002:a02:883:: with SMTP id 125mr20613873jac.30.1605911346655;
        Fri, 20 Nov 2020 14:29:06 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l6sm2808331ili.78.2020.11.20.14.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 14:29:06 -0800 (PST)
Subject: Re: [PATCH 4.19 00/14] 4.19.159-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20201120104539.806156260@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6388f273-440e-42f1-5eff-c58c51d09411@linuxfoundation.org>
Date:   Fri, 20 Nov 2020 15:29:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/20/20 4:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.159 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
