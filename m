Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8EF2C1A14
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 01:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgKXAbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 19:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730535AbgKXAbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 19:31:41 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1ADC061A4D
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:31:41 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id x15so1993022ilq.1
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yW+htXww+ILrfMvpf0DqE8TQUsDLdhNfb2u9ut4JOo0=;
        b=SA0axGGPWvQjO28vobYFpKR+Yq5zvhsOkQ/XctdcspqN3BCH94LTmlZYHldnJsm3B2
         2bmOj3yDaTaA20wwEISd31Cnylwrn2r6G0jV7aV4sFblhOBiaqcnBcub2smr/z3PCPRr
         JKE1dEdWw3PeuJ2kC6QcqmcwFJC834A85f3Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yW+htXww+ILrfMvpf0DqE8TQUsDLdhNfb2u9ut4JOo0=;
        b=PjpwH9iU6xLvoj653ZF/IRtcG1pKsMxYJinG+wMEhzMvapgW4gEyCydTRoIMoD2FxQ
         VDNE41VdlzsE2r8xiJKpToMZonTF1On94tGwwgG3N47hLWAFLLV53oVEh2OSSWnOcdo3
         3YadMKqc3tpmwuLfVRy1NRvDD0vGr5c6tGAdFzzSInVWV+UiZ/EMIH6K3Y78RKRceznr
         s9p0/3z4FE+++WA+YYmmn0Ataggs2nPUzWVmah4vg4d9dxnqzz9WVO3ejy6ShBPEot9o
         orPJ+Su4+LIVauc8YGrTlVjHDSfCRSPlimfniNgYY4KwLVwiQMVrKZ54mmloOalx/GNl
         5kMQ==
X-Gm-Message-State: AOAM530wA0cLKRB0/A1TJc7sqzg1Ey55ilcAMQBe1DNlAkTDGDMC2zcP
        camx4jCRSeYXaRXs31tuPTsDjg==
X-Google-Smtp-Source: ABdhPJwcngZihIMco7RiC13Pgz8eRDJtx1nQqZeyt+lxhHoOqOKu5rSvjv+EvzKNwyRRXKqwgM2OHw==
X-Received: by 2002:a92:155b:: with SMTP id v88mr2046840ilk.303.1606177900983;
        Mon, 23 Nov 2020 16:31:40 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o9sm195205ilu.60.2020.11.23.16.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 16:31:40 -0800 (PST)
Subject: Re: [PATCH 5.4 000/158] 5.4.80-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8dbf2a74-c3fe-783e-7155-2ad6a969e500@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 17:31:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.80 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.80-rc1.gz
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
