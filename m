Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A24576ED
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 20:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhKSTSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 14:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhKSTSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 14:18:31 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA84C061574;
        Fri, 19 Nov 2021 11:15:29 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g18so10150826pfk.5;
        Fri, 19 Nov 2021 11:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PTE/LkuVqRne50PhrC9asQcDCzYeHYuc0TLAK4FwREE=;
        b=bu7yms1va7xh7VXH3fu/Hz2It1jq26QK9SRMenIPOvRLIfR9DG94HXpPG8Un7rYegr
         YhSc/sDx2ys/qs0qFyEyPJqiUiFGMGSeHiMOJHoboYtlWA+qzk6U85DSsGokumb4oFkr
         6KdO2WWK/vgO4b2pqfw7nD5vmA+B/L3bsqdKDOYg3a885dO1+rhibiuibpyTPl5wrzJB
         /x+7japRMddh4VhnDVeQI4mN/LPgLpUgeGJyggIWGwD8d4Ry4/N9WhhUgbbZnYbMDzpV
         qkMwI3ONW1NqdMPioCsyOX/CXnj4sklVeoVrpmTx0gUqvXhD9eDxYY1LGBa97QY5iDxy
         vK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PTE/LkuVqRne50PhrC9asQcDCzYeHYuc0TLAK4FwREE=;
        b=alhWqfsX3EV9iMoLu8Zn7+IVXOry/EsQvx7D7+avtvlnVyygAUKxT1ezWlUQxRqCvF
         a+4N1rzona2UmX+w8Bt/fRHQLbpEIExANgPgr91BiR+qTVoAWGYMd+gQIR3uWQY9/Xie
         C678TF9U7tY80kP/CrG0Pe+qKheLtlIytv2KY3eux6PNCWkkPAE+Om1yhM6jqsZTsXid
         uPdCPfGiJs2KaR+xOdr3fkLsvWmjxrEfPhC3ZqjB1dG//r8QDNlqAA6a9mpxSjNhkqP9
         9Ds/PsbYvuOBixYWieflDpWfu9UcU22JRRZStjsY60SgGvaaxJLBkwzbIfQ8ZrASUz4r
         JQpQ==
X-Gm-Message-State: AOAM5319MMIUFDjhZT70hh5F6cAOCfABQAW9EsJsIH73YB+MH7DmeiY7
        1xDIDOIB/mTAN3q7ke88oMu/M2HCvZA=
X-Google-Smtp-Source: ABdhPJwnEVuYnIut29Ja9J4ISpceDqFlPuGWxbDXvtRUSFJN+02hdKH7cpIH9ALO8j0csbRDpCr8mQ==
X-Received: by 2002:a05:6a00:2181:b0:44d:c18d:7af9 with SMTP id h1-20020a056a00218100b0044dc18d7af9mr66923978pfi.16.1637349329047;
        Fri, 19 Nov 2021 11:15:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i13sm351244pgr.22.2021.11.19.11.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 11:15:28 -0800 (PST)
Subject: Re: [PATCH 5.15 00/20] 5.15.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211119171444.640508836@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0825e38-49d3-7aa9-9795-ecd2fe90d8a6@gmail.com>
Date:   Fri, 19 Nov 2021 11:15:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/21 9:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.4-rc1.gz
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
