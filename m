Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2D3749CD
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 23:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEEVFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 17:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhEEVFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 17:05:06 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108EBC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 14:04:09 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q127so3029035qkb.1
        for <stable@vger.kernel.org>; Wed, 05 May 2021 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SCT1S/Fsqjp/wX30By/exSgOJtdfEZmays5dtaFQImE=;
        b=QCB/agHmu+t2jIfgBGZga77A+wzamefn2dFdFTwa8YrVz5ANO3QiLoYIJa5ApG7N3I
         RjYEBBHyYWvHrDF5SOi7FiJ8cnf7U0ETbS9C7w8Nxm6LKO+/IsdAtaSxoxyc0kkaytrd
         3b3eYgbJxJxAzfQib3y46HC54jMuZYNLltS2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SCT1S/Fsqjp/wX30By/exSgOJtdfEZmays5dtaFQImE=;
        b=G54CMZgKl6gNxZgjY3oCdKLb8713UB/MDD/cekKoUurldw0pmFm/yQdM1XRjeJcBEo
         WCafcAwn3pPgyX1hNfcbAFprLR43l5QO9tuYutI76vPdMyIPh4h2L65q5Mau5wYsCHMX
         ut2s9oXccTgjgc7pyeEy7UGQnItAs8RRPUHaHUxlJRf3yUT3EydhtrlvawE01K7ZSxqJ
         FtM1gzvemJDwT85iwcNerasFywnHVFNjR4xYCl/gmrebneUPJU1iHiNHdTZFgiP28UtK
         zo+8zPaHbqCtRuV1JY/ruy+Pk3OAykAj8zutgDv5Mfbd0nkLMDswpEAO8sLXFKi4jSt5
         sILA==
X-Gm-Message-State: AOAM532EqOflAijV4To8rongEDgEL9+cRlGrfgXKMo56b4Gj6UWY+7fH
        OgdBz3InSMAH6dDNmpfr2GU+hw==
X-Google-Smtp-Source: ABdhPJzeLRyCkgNL8lwFawis3+wR05YVGgxWX/agqscfWZNEl2ul4VBYKhAT+vJjfO6lXKaFV1+7+g==
X-Received: by 2002:a37:42d3:: with SMTP id p202mr697591qka.456.1620248648250;
        Wed, 05 May 2021 14:04:08 -0700 (PDT)
Received: from [192.168.151.33] (50-232-25-43-static.hfc.comcastbusiness.net. [50.232.25.43])
        by smtp.gmail.com with ESMTPSA id i5sm468557qka.0.2021.05.05.14.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 14:04:07 -0700 (PDT)
Subject: Re: [PATCH 5.11 00/31] 5.11.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ac9cf5ee-df0c-fee1-960e-8b929c71c94d@linuxfoundation.org>
Date:   Wed, 5 May 2021 17:04:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.19 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

