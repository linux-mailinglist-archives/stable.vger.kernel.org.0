Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43714429473
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 18:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhJKQ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 12:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhJKQ2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 12:28:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E9AC061570;
        Mon, 11 Oct 2021 09:26:10 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r201so11308259pgr.4;
        Mon, 11 Oct 2021 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JO2ClopEYUQ6YbQwWtxthjon2iiiwlNRn4klOk10yRA=;
        b=OtjM6jjtLdgsmjPM70lUL88uciW3U7N6YH2UWpbwX0pFO7SC3Mw/N5BRIvgPFX9W9M
         qJJjshk2uk5ZDb60aGFKkyq9V93JkwpgbTNz/kkHSrHQwsepDB9loamP5BISUE1ecq8A
         pYPtoa+m5T6WKqiMjdgxlJVqAaZELKLe1ToCQbnU7u+F0pcXeDrRV1SuctYqsJnHEacv
         jNNM1hrpqj6jc25uxcZNaYGAl8wIJn6X5KdZvT1o7s2DbOuCQizdCdAC5MLPxKAQfBAR
         W+v1M8GgTGKvz5eFXM2vuEaa/XgUDi0ZfTsr+NRdLz6gHFQLihqUNUZuYP7Xqe4ZF9Mc
         ewPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JO2ClopEYUQ6YbQwWtxthjon2iiiwlNRn4klOk10yRA=;
        b=mG51xjIB/4ZpRbrf/vEIKl082dGlPdeoTQ3w0JwbBQmrTEdSPk/Vvi4PoUfYQQCAqq
         Y5r3J30d7Sn2IDel0gNpMs+bnxhzlaqw+4PKTuWwUzqUyCWvecUcszSb7OUFRghe66HG
         XEElqBY7PC0romVOqp90AC9cJKhgP3KGdXehW++oCu3NAu9RJ4VYbAtruGgA4GhjWup2
         A1u9AWoCcIGiLQevPl53Ava9r7SOTt4Bw6noWVuQiMHJWgkgotk56gfaxDU+2g6boAmS
         jJqYkKm0ilwUwd84X/dARP0LTFyvM4W335QshSiJyrfJdnOUZSpw9TJo0iyaFepbTR5m
         5rUw==
X-Gm-Message-State: AOAM533Qt5jkZNPKe68cVaalg1Qs6Wt4hyGxLE/3JswSI0S+vmgVhmdW
        cI7AnvOWxuYZgvFz8u18GSk4ojKwA/M=
X-Google-Smtp-Source: ABdhPJze6jkWOr8I8AY+AzkidF644og126Sw1jAOCSLFPk/tBED3WkVoOV6QP5hRHVBBRhlGRKdNLQ==
X-Received: by 2002:a05:6a00:1148:b0:44d:2798:b08a with SMTP id b8-20020a056a00114800b0044d2798b08amr3430681pfm.2.1633969570045;
        Mon, 11 Oct 2021 09:26:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d12sm8583531pgf.19.2021.10.11.09.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 09:26:09 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211011134517.833565002@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1cf605f8-0e82-e06f-0297-0c8329bee015@gmail.com>
Date:   Mon, 11 Oct 2021 09:25:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 6:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.12-rc1.gz
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
