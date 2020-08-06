Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9C23E243
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 21:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgHFTdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 15:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHFTdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 15:33:41 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E81C061575
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 12:33:40 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id z18so16617322otk.6
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 12:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fpq7wVyleeE3lJivC0yCSUpTWD3vPscmoHMBxV4pkMo=;
        b=Ola8E9AsNg2r+NHHc4cZAv1YL2AKrJeMwEhJ9CGOI1DSU/G/p9DIKZ8P17sSUlA0Uw
         XaM4aYKf8ckkD42uzhxhPsDd++mkvUKWGzD9tDGbGCBQn3ivY9ADwXtpI4zgmfvwSacC
         WN4KJ3yEwXygFqPvodBBUbBXzSBR4wlYyWLwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fpq7wVyleeE3lJivC0yCSUpTWD3vPscmoHMBxV4pkMo=;
        b=DD+j+n87KiqiAECCncOA4l3n+X+87lwgCBhZQxSqngaXx2P1zg3KjTBuf7ocC6sLG7
         aEE+tCYbmqOs8BkhQQRkDW/rLODiDxRsOAYx7zypxAQqO69AxNlzPRGMULQj1k6CN6v6
         YsnY8U4iwPIhFxpiPmD+wIn6YzcMyDrOf8eRgZUoPTh0z2ATjzr5toNezM5f+xmM8I8L
         jOO+f8ngXV6qCjHAc//XzcT7toPCuD2wY4k5vgKetDmFxx8Smro0PjU9e3HMhcJzAD51
         LiJ2yAajbgrjojpImJMQ3h2Z5Se5MndI6IzPY3VBtigJVgRGILaDExFaNIc2dmkRhqra
         2ayQ==
X-Gm-Message-State: AOAM532g+wftPWm8p6Zsdg6WcTT3Q2yxGotsQ5MSn89uh9SbF+j8+IXN
        eUAD0aYWxo6HbH2l6m5yV34KTQ==
X-Google-Smtp-Source: ABdhPJxgp4Nayzl+OkCvCOgm+xl3uLGJLuNhSxl78NDNfOLJhKPxR58mqm+F2D95N2q1oQbisl2c0w==
X-Received: by 2002:a9d:148:: with SMTP id 66mr8490804otu.132.1596742419998;
        Thu, 06 Aug 2020 12:33:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u72sm1285719oie.22.2020.08.06.12.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:33:39 -0700 (PDT)
Subject: Re: [PATCH 4.19 0/6] 4.19.138-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200805153505.472594546@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <909eb769-8c3b-ced8-94ec-53bf3a6696be@linuxfoundation.org>
Date:   Thu, 6 Aug 2020 13:33:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805153505.472594546@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 9:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.138 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.138-rc1.gz
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
