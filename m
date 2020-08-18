Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90042490FF
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 00:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgHRWhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 18:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgHRWhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 18:37:03 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33936C061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 15:37:03 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id u63so19386748oie.5
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 15:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=73Y+MT7r5XyV+Cr1TuQDj/66F8btZWmAus+HTymwMTw=;
        b=QtVX53UOnBH3nnNzznI1obMEqdSgHDzldLMWYlV4uBvJEckY3aaO/LMOjhgPH0R7Vl
         e7Rey1/vddK0+qbVFxCh73Ih2ijVZ87h0TLdDSkqdIEEA+FDIlw6vgj9r9yuYqI86dGd
         JK7T//mZmlnZZBMBsXHnxU96JJoL1wzMLK+mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73Y+MT7r5XyV+Cr1TuQDj/66F8btZWmAus+HTymwMTw=;
        b=mnlp2DApAhE9rRRa+3YtuuNHA45vpTKibMm1PgQDA5ggyj2PUFtMLHg7ORb1FcsBRj
         XC86xCIWmcTlDweMUI08crq5mq5ZJEkGwxtaVmbTwAvHJ+dQv8y2zEC7sx5J16iBDDNL
         Wfs3YMCREcbNIG1ZbMPmh6fkYOmUg947a7wDIfkxEG/nwcunvzTw0WADHxClFJYgdq99
         KRF5rBNVrSD8qWe7KmOaQ59VoIuZpDUD0T+yjUbIf6h6ggaNVUc7sC9NgWDlnY1yump0
         tV/PFFCXMz+S2BgSqZWmmBEieGQYwJM1xvhv+jE5WmsLLdl89wLRgCuDa0SnbtAmWXzF
         DGOQ==
X-Gm-Message-State: AOAM532jPBTjAFPUWYdnX6AGOs39sw/n99Azfx564FSpZOMgwOKKOhHr
        edTBzU8IsLcfaQ2kckP+J0F/9g==
X-Google-Smtp-Source: ABdhPJyvqUeFoR6R87jznn6iEr4Dw0TO27P67DAZKgBGHMdaa9KKPMpoyVKZeyaLQESdaJdryguFsQ==
X-Received: by 2002:aca:5102:: with SMTP id f2mr1447558oib.169.1597790222648;
        Tue, 18 Aug 2020 15:37:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a15sm4250035oid.49.2020.08.18.15.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 15:37:02 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/270] 5.4.59-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <06732ff3-cbe0-ab76-1280-2f0df64f6580@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 16:37:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 9:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.59 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.59-rc1.gz
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
