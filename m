Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CA040ED90
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhIPWzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhIPWzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:55:15 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F71DC061574;
        Thu, 16 Sep 2021 15:53:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q22so7425369pfu.0;
        Thu, 16 Sep 2021 15:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wwsZOlMMirH6TC+SvGiT/r5Rp4j4FujinCyxHsjZ+pw=;
        b=huv2r8mB8gIXfigsSOPljz3WnS0OxC548mYCEW6H5zj6yTpZDrhBvO3/eenKW1hfBr
         N11VQt1NvoRA4+08Y0nwVsWTXitCnxy/fF8UR9qGcLZXfjBJrkQUDgAwnwaAKDc4SQZw
         wbkrZKJtiu90xDKIjV0sD8Rh2bPKkjSlKyBgQqvo9n04HY1JhhexWbaAu1jE9gWFdlWM
         QR986DMa8Lsx9BjmiVoo3K+Lnkq0dDt3YHLRMlsZPhLhevnzvXp85kQOuA110I92gxUZ
         TYUgZNds+wscET3HWROTJE8mQ3fwaD0sDHRd1LCI58J3+Puj2yp/WBwVvFHplcRM0C/N
         jxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wwsZOlMMirH6TC+SvGiT/r5Rp4j4FujinCyxHsjZ+pw=;
        b=dfwxtFghm4lapQ5emp8iMAupW71B16dYESUFQkd9QGKRwF2BwJYSH2egHHlat+mAz/
         LEAAkOamzsLrpE5UQb3WLNVGOkiU98O3FJODTaCWR5pqZmaFZCXjgbmmSWUPcqdpdFcS
         y8WWpG6qZxXWodR7OIfjUynAciH+A6pM3N9HMSNZoP/shQqFmwbXPa23bgd1Szur7cSw
         d4iYQUyEWaVHZarwYl5OuqAjcSy1VFzO3RQeFdq/pc9WaMl4Lw+azPeCf0Mqj0tKEgO3
         lWduQu8LGFskb5oINEz4v6QtDaqbW/BUfdJkqHTkOhvQCrEPR6FebWAgNow3mraV3kZw
         zqZg==
X-Gm-Message-State: AOAM5323uHuZop3kt8VIO/tpxXle8a8O1Y8vlOII4HA3gIcqwps7QsZf
        pKuYXleqeCLjSCldMvIlYw/zmPnaCrQ=
X-Google-Smtp-Source: ABdhPJzF7a2gbFHLmsIEpaRBYEOyAIU1Cv5bp1IEn3AQ9grZGUttTh7raCOWB8glLQfBoQ3WM9duPg==
X-Received: by 2002:aa7:998a:0:b0:444:b077:51ef with SMTP id k10-20020aa7998a000000b00444b07751efmr540024pfh.61.1631832833590;
        Thu, 16 Sep 2021 15:53:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d3sm8954737pjc.49.2021.09.16.15.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 15:53:53 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/432] 5.14.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210916155810.813340753@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0d0f22a8-57c5-b303-1d25-3b635a29afd6@gmail.com>
Date:   Thu, 16 Sep 2021 15:53:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/21 8:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.6 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
