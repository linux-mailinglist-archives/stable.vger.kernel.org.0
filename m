Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED072210C0
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 17:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGOPV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 11:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgGOPV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 11:21:29 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBE3C08C5DB
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 08:21:29 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id t198so2474770oie.7
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S+mEbldNjekOAjBJM0NmckvbKRVF97h+Ywp9Wt3KSBw=;
        b=GUVGbVxbzQBASfq0k0NfeoLGqfSN6o9DVo9cHLqSHN8qZvimraDJn3JsZM6a3QObpI
         dK0CGRHRdl4skeFQ/yDlfLqqmvMq79KRIH4Wu1m0tVZ0CibcMZP66oBi39TjHy28Su/P
         slAPKkXByI81Tfdj0hIXTlmqIwKhCKzCweHr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S+mEbldNjekOAjBJM0NmckvbKRVF97h+Ywp9Wt3KSBw=;
        b=fs86TQzkguINVchxL0uVJNnndbpyp3D6DoZzKG2K7xFVQbuewSf4NqXG4avRwh6Z1l
         r5sNKeudUKnDFtiwre7L6BbLYlfDb7nM3G7QNjJLdxJkugWNFAjbNKfn1uwzp4Pmft7c
         yrVh1+nD4rSX/XwU4d6K6OivRNsUYvg+CQgmxR2mpififBM9t2mmoYqM0BAuELYArKIP
         jh/ZJSmjCNCVRnM4aPY22s17OIBKG8KKW/G8Vk6LccgrBA/wMOGqp35eXc6dlg3H1djK
         SRLYvLZpnA/FACyQNaALCKr1keevxo1SngsaVY/2k00EX3sYfP/ZVu+n02kDhYVUKpMb
         0Nkw==
X-Gm-Message-State: AOAM533HpeVsrs/KuBrOAsEJyWRMdesKN2rIMxyq8e2UMPre4Jj485di
        TOdakrPKUC+5mf8Z8nN5hNl8ug==
X-Google-Smtp-Source: ABdhPJywbTaLo88T2FlKgY2Hef8ERVFqwYzsx31F/9q9OsqBzKlDAgGvMkORRroUqLmNDb8kSD8m4g==
X-Received: by 2002:aca:518f:: with SMTP id f137mr203982oib.86.1594826488807;
        Wed, 15 Jul 2020 08:21:28 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r131sm435265oif.33.2020.07.15.08.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:21:28 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/58] 4.19.133-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4c9bc9d0-de00-4af7-46f5-34cc73c37394@linuxfoundation.org>
Date:   Wed, 15 Jul 2020 09:21:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/20 12:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.133 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

