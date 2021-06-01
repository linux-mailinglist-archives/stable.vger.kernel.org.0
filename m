Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4867F396AFF
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 04:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhFACZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 22:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhFACZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 22:25:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA14C061574;
        Mon, 31 May 2021 19:24:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so949228pjq.3;
        Mon, 31 May 2021 19:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UpzhSNwLiW0YeEWD8X316pfssjFG1xaIfF4B5TBGhug=;
        b=CkklemdYph3jwNNdKXeuwgfOM08GVgZNlDEN4Vy5NpHX770HioX+whdzoXrX13cKQ+
         WAxKMisyZfN0f/ztmZmyRvzK/lHYoGGexa2SBgxWhPXeRsUfn2fZMC+CaFSNOCvDSS5c
         6wTh7Z04zPBmgpdace08S6XeUfnXsMyrsQ/U9vwOKV/iNUb9F5+rsHDk8RrzoAqQaYi2
         JTZZhACip196vsEBpQUqvwhaa3VVlwB/BTOeU4c8U+kiz7ZDkuqCIU2HIJZ1ySkpRiA/
         xNwReZlNwsRbgKUR5m1CaZ0LGnkAFUdJBlOPyi8mGdhqYvo+OR5gBhOuOxgLHqk/hyVV
         Q4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UpzhSNwLiW0YeEWD8X316pfssjFG1xaIfF4B5TBGhug=;
        b=pcHZMSW0ng1CjEn70HtAL6iNPND9LbMwpZ6YQYZyfgvlmSxyP6Bbky73rN77V2hlJA
         a66UEx+vcpk+eg2bUrk6f3zzvTf3JiMr0AAc0vO0yr3qdDl0ABGYUHkLsG0fdf/KZKWU
         adxtGcB+TTz5RE+brT97wwRW6FgpQa7CJDBJl7+Euzl5T4zLYLjecF9zT7OFji8S7nnk
         oWUkiosYmxjgkZrrXK7J4NMUV+BOwAfkr5yGOFJA5GRbCYVoob4nOWc4PEnIvyFsvisS
         utmPllnWAmrmWioRKRlROCwFn1n/HxjV9Bcm4AIm2gTiu6lGVD3H779GjcQUgqjFToqE
         N42w==
X-Gm-Message-State: AOAM532ceIGNKih4enoPEjiOPR8F3cO4qVMDn6F5XsfDmabh4bKZlTn8
        LcZWObSyprBJhNM+7vTqcOVTT841ZQzfgw==
X-Google-Smtp-Source: ABdhPJzUhaVduybp1p70m0klT/mfXpqeAcXGiBYm3thNi3R7b36JRtTc8ma4XwuYdG313uSBvEnydQ==
X-Received: by 2002:a17:90a:28a6:: with SMTP id f35mr2124949pjd.1.1622514241559;
        Mon, 31 May 2021 19:24:01 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id g6sm2686934pfq.110.2021.05.31.19.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 19:24:00 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/177] 5.4.124-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210531130647.887605866@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9abbe647-b522-3db6-7587-90e9532a5e76@gmail.com>
Date:   Mon, 31 May 2021 19:23:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/31/2021 6:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.124 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
