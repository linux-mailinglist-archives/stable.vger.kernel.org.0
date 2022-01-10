Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B958B48A0C8
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 21:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245747AbiAJUQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 15:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245729AbiAJUQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 15:16:22 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A40C06173F;
        Mon, 10 Jan 2022 12:16:22 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so1766544pjp.0;
        Mon, 10 Jan 2022 12:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bRe6M5AX2fPQvayGmPdGz6POX5LLWdgtZ17K2TZp4oo=;
        b=U8cH8wS2Cr7sMyJZJrWkNeDAppf1i6NngGkKQjOSq4ixSwREg3dJ0BAOqYVweAebvB
         ziZBBaMRSyGC30NwEW7S+IPWSRfu0ViMeZK0O3mtFMA7oUcO4bwwnLnSGAGwHeVFtH4I
         DXjOd4aRZKwmTyrTFamstmYyXW1JDc+gVLqIk6ePOKiugNrfDWG6KBQR8+CcfzZe67eM
         JhgRlSjUEIyf9J3WYyOikmIf60DAJE2vXi4tTTGcxzfDtiY15N63g3ep23ht49xqOMGb
         X+f0Ks95s8x2k4VZDBs/8xIWDjqgimF6wR1U7EL3dvhRQjZos+Up+6frAnCRv9716Q1v
         FA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRe6M5AX2fPQvayGmPdGz6POX5LLWdgtZ17K2TZp4oo=;
        b=uX2qOWHVoCOWDWhyJctA8sR8mKMplxF6nr/Ql2OsPI4YjKrpURbmeqp3DBRKAOxbpu
         ZNHL5N7vnhg5KEmrZXjNmpizFUGnUW1ZuzMWFmMcAwvaWgoSwCx3IxgHika0iQbT2ORS
         0mrUy0auONZCRHneSvGNDH/gPhgQ8CZlNl12fg1dCoLyWxtZ2IydmklC86x0qXjlkDdp
         ec3Zf8Qe6cF5MncA1Dn6CoWzaD2hyvEf1cLv0ygCtEG2KR8FkWlRQGSNPipAaT1fYna4
         o5GvOUJiX8ZqkqfnU48Rf/YedFolE3cnee7E8s6quPkbN3y17xVyohj7FrDMjj/ywruz
         xOfw==
X-Gm-Message-State: AOAM532yvsb+9T8s6wBdY0+Wqy4n0v8DcLrnHwYRQU2bH7HeBG1J4B2D
        7fnX9rBezE2FSNQjMB9Inugil//u0BY=
X-Google-Smtp-Source: ABdhPJy9A5z8P9jErlsaTsS9OFoLCO1luOu6R8g8vtelJsHLDEh7uZU5g95jHVVoa+eM/xA2BryyDQ==
X-Received: by 2002:a62:2743:0:b0:4bd:356:21e with SMTP id n64-20020a622743000000b004bd0356021emr1285971pfn.51.1641845780700;
        Mon, 10 Jan 2022 12:16:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id my5sm11321692pjb.5.2022.01.10.12.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 12:16:20 -0800 (PST)
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220110071821.500480371@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <254e451b-52f8-598c-d32f-9dfd7dd83932@gmail.com>
Date:   Mon, 10 Jan 2022 12:16:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/9/22 11:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
