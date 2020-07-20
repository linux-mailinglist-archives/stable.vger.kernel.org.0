Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EED227339
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 01:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgGTXnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 19:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGTXnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 19:43:33 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28166C0619D2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:43:33 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id t4so15777697oij.9
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/kU9asGm2tLYrzftHBhHd5vQnhrVpYxep61O6cw23Rc=;
        b=Dz+Mu9yRZguchCVf0nhPn6+/kl2yl7+g0aCTWbD29Oa0+SDqsTAbZBCjwYokw0Yzi4
         RKBgLnq9HjLU8muuqhJDYtKhEPUAOxvh4EOupvMrLYuL4FUmoHQNd46rec3C+96CNWTi
         XUhe3IN30/FzvT+ins/PB92dYnuUD39cX3pkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/kU9asGm2tLYrzftHBhHd5vQnhrVpYxep61O6cw23Rc=;
        b=XpMAItxT6xNTux3rBCGsF00tBFz2kZV8oJqJMzZ2/1Ge+II1BwJoUb3pZPi3g8u29f
         CEWr0XHJyHtyOuOZrg2FumD/JMDMBUDgE8jZYDkx2XIzqkLCNNM+lSxsIwGTg3xJrdJB
         gbtqwvK00oBMXqTLJ0ipesd1y/FdkszJ7NaIGcnjezf+K5Ft8OmklxYdWjQZbSLR5V6t
         tRFXb8n3C1nYogAjQJ+OlTxjTDAv6cgXJPhg/fhZGRlyaE4KT7sR8e1Wn0kNTumfL62y
         cCMp5vZVh8OQbQ0YUct0MWwGDGdFJTu8vhQEZ1s0thrcaYlH94OnCR/J40zzv6w7VHlg
         eGfw==
X-Gm-Message-State: AOAM532oMp8mHPT9GiHAm/5YfTo9yuD/qmp+mrQQBwBABHv62gIxhvjb
        et2ScTkw9BIWPt4Ef38ci2dT/g==
X-Google-Smtp-Source: ABdhPJyvtb3xprhLdnmQ0RVq3WPbUBUc9wCsvRaqzj4peBIHuLR8wwU2HQtHh7NaT5O6NKhvv4M3vQ==
X-Received: by 2002:aca:f05:: with SMTP id 5mr1185144oip.93.1595288612492;
        Mon, 20 Jul 2020 16:43:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o84sm4297607oif.55.2020.07.20.16.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:43:31 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/133] 4.19.134-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <910415a1-0280-0f05-7dd1-46cf39580445@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 17:43:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/20 9:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.134 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.134-rc1.gz
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

