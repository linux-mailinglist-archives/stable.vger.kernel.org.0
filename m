Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAAB42E44F
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 00:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJNWlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 18:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJNWlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 18:41:19 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A956C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 15:39:14 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id m20so5591852iol.4
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 15:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZLcUEf3FJ4EcdjOEZ269qg1+3MF5x+kzGi+tnY9ucNQ=;
        b=F9D3U7eYZ5ovOBvd3wWy9U4Ybx3IbTScSwLOrqxbkkbpm6Wr/rrPCBg8DJ4ZvoGJYz
         NQzH8Jb2/uLCchL2mJF7PSJsrqWY9IEFOkhEJpTz1DjAvJfbgzNAhbgGL7PVaELy4TWJ
         mjcrxmLplOKqkOKmUxAsBllQrTJULXDnQaOGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZLcUEf3FJ4EcdjOEZ269qg1+3MF5x+kzGi+tnY9ucNQ=;
        b=K0GbxRNrkDRajQ58o19VcPvxqSLqtrmR/6fO6EbDm/u+c/fmTzk4rGDAS6nL7e4lCA
         vNeog7fwJ3tl2pCaMSpLsvDW40HPIigoOhdmvqrDVtPiy9anr6Lm+YFx6pE+aDlsjHW3
         JmWI639eFGSXsgIbRymJgNkMOPZJ/n8dN/X1u/uhsURKxTsUT5/b/pdX0Mj4EpC6jjm9
         CescjsEzWMxdwXG/uD+QCs4yl9gqCGQE5ZMiftoINEcM8oLgiLWB9G0+b5yQgDJFRX9V
         yfv0/SzukUjUS8ehTiwn9BXhh+nmi1W13gfunNRfhwNrgpOeBMpsXgHVUupjdWOkCffo
         vI4g==
X-Gm-Message-State: AOAM5311Ep5CBhdLkeRdAbpx0ILIEOWqej4hNflH4JWPmtdo8gJVX8Nu
        o0sBA4h0UOaBkZiTpE9JeN91DVbm5WEFog==
X-Google-Smtp-Source: ABdhPJxiTSkAvQxEOIVK3hG4YoZUmL+9mReDJ4BEWaLTlzv1j/3UF9jlNL6QWwnrhOhjV62QzIgGcw==
X-Received: by 2002:a02:858c:: with SMTP id d12mr6104814jai.110.1634251153400;
        Thu, 14 Oct 2021 15:39:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y5sm1791255ilg.58.2021.10.14.15.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 15:39:13 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/16] 5.4.154-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e51b76f9-2c02-d9ba-f8e5-d278e98e97c6@linuxfoundation.org>
Date:   Thu, 14 Oct 2021 16:39:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/21 8:54 AM, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
