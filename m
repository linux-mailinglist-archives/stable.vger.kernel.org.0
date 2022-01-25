Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6AC49AA0B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324008AbiAYDaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbiAYB7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:59:10 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E541C055A81
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:51:19 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e79so21894171iof.13
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PLNl1n+ArWj4qgvxdeXOuJ0Go6oqKB8kznJ4QDRWUEM=;
        b=QMmybs4P4z/N501e17N58Rqmft/exeSOywcpVLntSEwc6z8ZkVkrxP1N1tdrJ4cHRe
         8Q6ITbn0VT+8vdnaT4dPjcSOO/LssB0Yu/e3s0yb/WxRvqJqhTnoP8CLHkK/zUvpwMOQ
         a6utyFhOpOb7CfZlcWuFX5m2ml0rmsvTLSTLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PLNl1n+ArWj4qgvxdeXOuJ0Go6oqKB8kznJ4QDRWUEM=;
        b=V3aC5DMrqoL7QaDDlJOaw6FxmHPGA3Lj/4DYesF2ugDEzKen8Lb1eFbP59vZQjSb60
         j865arpjk3b6NqR/ZRNgD90EV0XJnWYOXkdXbN7UnlDLh6auBRX28Q08FC81DL32c0gR
         hVhly3uqrTf7TP9rehpdXXJc7Eq2Xgwgx3PJGL0Rn2cWdBOcsCBu2PYYn1FOpSLraMHy
         LnFNXECz9wK2x7nNp3RKQXTKDtABS+DpCCi0yn6ZubysvdbkmS1C/AVpgsq9r15/PdWj
         3wZFfpdLENFQNuIaeOIjbLuA43mr0qwf91BbaQOZZMwqCBAU91N/ZAcJwyEDB3mMPwr8
         /ZAg==
X-Gm-Message-State: AOAM530im7y2rk2ypkAdm7nT3M1OkYUs+Gv54pkVTyt2iUYKFKAGupH8
        GFSA1wQ1t3Z+xgpusrHSf7F8Iw==
X-Google-Smtp-Source: ABdhPJyG9fWz6ez4vBJUr5NEHb+kDo75RY6fOU8hfE7G7MsCUG9lsjGpnwqG9w7vNUMQof6ki72mXQ==
X-Received: by 2002:a02:a1d4:: with SMTP id o20mr4716189jah.45.1643075478323;
        Mon, 24 Jan 2022 17:51:18 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id u2sm8346698ilv.1.2022.01.24.17.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:51:18 -0800 (PST)
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <de58657c-71fb-96eb-3dbd-2d99f2507518@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:51:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.300 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

