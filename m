Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBFE49AC3D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244264AbiAYGSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S255273AbiAYFO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:14:29 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF212C058CAB;
        Mon, 24 Jan 2022 19:42:14 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso955136pjh.0;
        Mon, 24 Jan 2022 19:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XZxwgGXS5u34rb9Sl9jUl7RcmJzC3oerdmHXpfcVU1A=;
        b=lAqBMaLaQiYQ8ecwrmLAghnzb6TaxUTC4PMDLnj+cCSctcwxKtPj0kTAQrLbOnidpm
         ZoXoh6dq9sSIeELGVOWlOzQx/YSiK7HgP5mXFCr0gT6aj4R8XgcLfpjFYOrMLVE+5pTx
         r/Tr60HPP3G5w2TUxfQv4Xn5oVg+Oj0LnyrHn5EaYqdKmaMDLeDfvewyWODMoNDc0R1n
         zq/guPe0mCc7Hv+6+mVxTLWTkRcnQxQwBs/gQj+oOZmlWt47pJAKQ3E9IVEZK7dv8EoH
         rvmPRWGLvsS5UDwFVywzC4DiihjLVZk/SIMCG0XZydlruSkPLxHNDkPPZDdjA4Kvv+Rh
         zc0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XZxwgGXS5u34rb9Sl9jUl7RcmJzC3oerdmHXpfcVU1A=;
        b=35v/OjgItDgux6hULuyfOeUE0ZjBwA2anOt9YPoFTVo/7flqkYb8X2TfqCJVytF/FI
         /LRRnlVBSHJ7vwBiuuDValrmhri55zD6BblQcXVs3UcYezxzXjixJ8bBFNuDlk8jwt0o
         CpBoiMno8KDRNPZUzfJy6GQA9MAEIkWI7yZQUKV6zrlPxarXbRzQRlV/mkEiRi1BM15r
         MrTUS++UDDAxnloztncSOhzms4rBjJPRNk56ZFciCPdEhIzDRzo9U/QleG60iRTFFaj6
         o2lMgBT6GZ30Ot6C0hp/R8FzQMEAubqNIDx12VQh3UrektdRVeals6YxfyFZGwzDRDy5
         DHbA==
X-Gm-Message-State: AOAM533oudau3cQbXrVd2BywH7M51gymf6mJLF7j+ijJQsGn88WgpMF6
        yJLRidYuU2vKpIxuGijUgm0=
X-Google-Smtp-Source: ABdhPJzYUjmqnUNSypj9bFL/qOUd8/ODoI7D1sSy1rbAy1yRcqei75D/ttt6swffL0qxrtVGPlXQSg==
X-Received: by 2002:a17:902:7d96:b0:14a:42e1:4793 with SMTP id a22-20020a1709027d9600b0014a42e14793mr17176964plm.154.1643082134255;
        Mon, 24 Jan 2022 19:42:14 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l12sm715791pjq.57.2022.01.24.19.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 19:42:13 -0800 (PST)
Message-ID: <19ade631-f2cb-f51a-2ca4-832613dd66b5@gmail.com>
Date:   Mon, 24 Jan 2022 19:42:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220124183953.750177707@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/2022 10:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.174 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

same perf/libbpf error as reported by Daniel for arm64.
-- 
Florian
