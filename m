Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB63413647
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhIUPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhIUPgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 11:36:06 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934CDC061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:34:37 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id b15so23136533ils.10
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LgS90YfL2o736jYRsUsNNIgckQ5JWc7O96G7L/BGZjc=;
        b=S/z9zLurpISRrOkX8myoL7ElRssRsdsiangCaSEUSJeuwJlNS+0UX+8HVsxSIUm7e8
         VHL8UsSghj7c+gGUO7af20kzLdqgE+TSSuP6noZg8osA+dRsDVJ6xJmV8mnaG9hBkLD4
         n5d8obmt/c0WEWaFbFCwbs0R0HMpyD44zUTRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LgS90YfL2o736jYRsUsNNIgckQ5JWc7O96G7L/BGZjc=;
        b=NujSuonB/wmucbnVG33kVndgTfHNJSWwBIiRGZlk8AarS4pLdt5kLXCgXWddlg1Amc
         s16Q3JelUT/N9g/urxPypZJxEL9mADynfHCiedWy7g7/vvmDtDen+CL9QNSlK7Yn1MhC
         CxWv6B6tST/o7Gi00nKl6/sfFr3FH5KilB4UWxULy1qeaCuwbITH4FNbcsaK8EhW+o1r
         bMFC9SMbRtuXuXf0gETunAibxhQZQk3N+rVeSMJkupndldePCQ6Y1SvBdVvllyY8XC09
         XiJqU4/jvoNLH6LW7U3HJ/ZhGk5mY1nHR9CxdMp6QytwCuAP9h/5dHi4UCryxEZ8XmfP
         F23g==
X-Gm-Message-State: AOAM531OBbZ5DCNpybTcfk+tBn6WeKErQk3t+wsYc/rOCvZLEQsjvIiP
        kFICHJzZqu4zGzz+t6itVMR9dg==
X-Google-Smtp-Source: ABdhPJxT5BPyUVQ+dawuwLKKg3zgJKIAsKxkZzDActBJNIpV5bSvT3AHqR8YGj86wZXzq/I89P8lEA==
X-Received: by 2002:a92:c8c7:: with SMTP id c7mr22299510ilq.62.1632238477062;
        Tue, 21 Sep 2021 08:34:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b12sm9162448ioj.55.2021.09.21.08.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 08:34:36 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/175] 4.9.283-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c4c19a05-7932-7ea9-a485-2176432c8874@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 09:34:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 10:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.283 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.283-rc1.gz
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
