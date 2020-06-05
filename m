Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A751F02C2
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 00:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgFEWNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 18:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgFEWNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 18:13:14 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA2AC08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 15:13:13 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id o13so8837309otl.5
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 15:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4KUZ4vRpKIe3qa77IAxpCMFQKithPWzH7hezTb7q7nk=;
        b=ZdOrQY7G3ajRdNewu9pCCMymN5/xTvu8X1N/jdjsU4beSpSLUHtWP70EnMyM7sbQLk
         VrpISQ0cIQoNcVXSSJGDMidlz5Fo9h4+wDqc8d6mFZMzrrnhbQY011QMNb/CTQsHQYsj
         KKkAp6bY/Dm3TZV/zpUv82C/5k3lpYGPD85og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4KUZ4vRpKIe3qa77IAxpCMFQKithPWzH7hezTb7q7nk=;
        b=OqfEAGGTs6eHN7/PGp7ZTKYf2te34x7Nn5gxD1dRbaxTpRxwlOFJ5S6tjasDC4Mzra
         BnDULd2rPfffWmM3rLB7GdSDO9249IS4hfjzNH5T/lJO4IuCqP/xGu8zxp5OporFP9u9
         eBiaV1CAzvKLwUfHpplKgsO5Fwhj7HSwugiKIVjfkBwqzsN5ROWd3AnutkMCsNrufdGh
         PU7Vc1UdabGQFwmLQWvwpZfdbjgB8o25k9XqNZREAxsbNa73DBQ/dba6W3aJdM4QqW4p
         wIgjFCBPWtD3GOadZbm94vlKBpFayy/11eeydBkyOmaiu64Ou0rHN8ku5j4T1bA0AfQq
         WW5w==
X-Gm-Message-State: AOAM531r0f9MdVVYmv/0u1JjDHaTpaEznXfNvURFCivzRMOi9xcHwWqb
        oCyVcIi2DUbk96wbQDnjjz5lBQ==
X-Google-Smtp-Source: ABdhPJwLYIQM+XujncUEcDbtC5NuhnZCRaliaqneZj6TT8D5NezIxrWSFGtEXfep3uy+OGZV7MV0TQ==
X-Received: by 2002:a9d:5d0b:: with SMTP id b11mr8677745oti.97.1591395193352;
        Fri, 05 Jun 2020 15:13:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q186sm948995oib.12.2020.06.05.15.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 15:13:12 -0700 (PDT)
Subject: Re: [PATCH 5.6 00/43] 5.6.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <54d45ae5-0354-a401-af46-d80f01cf450f@linuxfoundation.org>
Date:   Fri, 5 Jun 2020 16:13:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/5/20 8:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.17 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

