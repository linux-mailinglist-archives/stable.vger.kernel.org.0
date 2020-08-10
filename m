Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B6924138E
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 01:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgHJXE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 19:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgHJXE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 19:04:29 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C66DC06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:04:29 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id a24so10497426oia.6
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XRtSwbypZFNRRMuQ+PKBEYpCpUDWNU/PfWfWLrKLeDY=;
        b=NGQ1lwTgRg5LyKNoISD3Kj4Wah8d6ne82UhNakoz15/7O4FSnLbBeZMHRDPu+8Df8d
         TnluECXDZ1Cy27IgtX3tMuRXKkKpHvO3efQEzoI4LbehpL5RDAjI6Pkx9hnf353M5k1C
         +RlDGEZ8k6dMmh4PQQLrJelre65Td5Ll5x1Qs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XRtSwbypZFNRRMuQ+PKBEYpCpUDWNU/PfWfWLrKLeDY=;
        b=Mau+Zs7D24wAqmRTVPczn75lXX1sij+G1lZWAtUcbPMK4BuaHfr1Bb2LS/YKAbw8/1
         lWwjQUSJgx0a758W2iXY99mpnEqz6BOx1w5+OZBpJNeyjwdS11byJ3TG7XBNmhWBbQgv
         WFxNYVAicBJAXkTKKTAiZgKtft6jhtXVW4wJwCouIJwU1Y1bx/SQf7aUQiUFzffxc48w
         vr0Xe7VIQrEP37N9bGGGumCrr4ZS52IGt5EamrfATKBbi4j9OMok03C2mmRNkvU/7W4d
         JY8/zhFX6ir4ugt87L08BM68iWSduu4St+zLq5oVajlC+mmXp70zHWWqGlIUMAxU6kh/
         oBnA==
X-Gm-Message-State: AOAM533OFu/3oAzALBn1PKZ/5dFlhkHAUh9EkTNVRJO7vXXyvihf/FEz
        AMYldzfOpohjNrLdWgoocrA3Mw==
X-Google-Smtp-Source: ABdhPJzNIWb2lAifa3fBKatQjQgacZAoLvxtlcFCkOdVE09pMIFe7l7P5zh/hLEQrLD7mw2GqOA8qQ==
X-Received: by 2002:aca:ab82:: with SMTP id u124mr1322124oie.179.1597100668539;
        Mon, 10 Aug 2020 16:04:28 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q7sm3712420otf.25.2020.08.10.16.04.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 16:04:27 -0700 (PDT)
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4ee644b4-55ee-35b0-bddb-0c4e95259151@linuxfoundation.org>
Date:   Mon, 10 Aug 2020 17:04:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 9:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

