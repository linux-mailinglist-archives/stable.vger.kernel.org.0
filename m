Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C073616FC
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 03:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhDPBAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 21:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDPBAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 21:00:21 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E4EC061574;
        Thu, 15 Apr 2021 17:59:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w8so13766541pfn.9;
        Thu, 15 Apr 2021 17:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sWhToPWnlwV2e8V8ZMuGUQcN6/JZcLUSoyRQG7tn67Y=;
        b=Mf7VBnhiEwGtPhKOlDAJl1+AcNghYFujuHjm/+b0nG11WaRjVsKg5LcTCsc6yjZS9T
         RtGuMHUbQnX9fSsxKAnpxakuJYNQYeUa4lxEuUDN+laQaKb5HB/oE34etRKqU2mLS5Dp
         bCfUFpC91ylYKxIFpZyOy93g5XmK5JeeZvo7nhndd/MxuRQgvG0S3fUQ13h4UFWBVpwr
         zOwJmvniQbWZEK5MzCPoBkP/xZhXmLTfqn3sUUeCfS1F2xROlV8IdLEdB0uJ0pbTKX58
         cqMGwoQ+b2vqgyplDLe2/gPVNz/cx6lR1/TBktrRayh1sB25QtTSgW50ahMR4UQ0SmGg
         Vgkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWhToPWnlwV2e8V8ZMuGUQcN6/JZcLUSoyRQG7tn67Y=;
        b=IOIT8Ec8VXSs62r1Cd7V3EJDr37OrCUkOlgRqXIJR99rA/3eK/n2fylHEh8x8qwb47
         8tTTxZbnBflW01yPuG2o6YpOA2D+J3aNT/i/7Q23zT/efwMuuL5vWiRTJAl86PX6yw/f
         wp6HFNmdhwYqVcMvzpKAdrJ/oj3Ilp5+Lpp56ZzW3ErIq8MpqXXov8qqkWzRRv4vj+rt
         XQ1L5g1/Ju+yucFgiz6jToOkbe8jUSlF/xCRdQ1PU/1X2sp+SukE3M9exXoBPZGWyFui
         zGH1JpEwsWlMoFSCphhMW9y96HTiKW3Oc300zXcxZCXjegcnwHjDySGV3KpwUlR6DGrX
         I93g==
X-Gm-Message-State: AOAM530hrVH6ER9EiskEsuNAzL6yIfsiEfs4a8C/Br4xZaJjGo5uyGsM
        s3hDUAu1Pm4j4UACjECLbDmgjha4JBw=
X-Google-Smtp-Source: ABdhPJwwtSGjErgczxw+hCv23h2tN1qUKARG9aC50n1YhU2QhiCeSoKPxe8zbVD/ltQB1oINvyP0qQ==
X-Received: by 2002:a62:b403:0:b029:20c:cbd5:5be1 with SMTP id h3-20020a62b4030000b029020ccbd55be1mr5869901pfn.53.1618534795853;
        Thu, 15 Apr 2021 17:59:55 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m15sm2993430pjz.36.2021.04.15.17.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 17:59:55 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/47] 4.9.267-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210415144413.487943796@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <243c501d-b7ef-0e5a-0454-8fd0df21972c@gmail.com>
Date:   Thu, 15 Apr 2021 17:59:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/15/2021 7:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.267 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.267-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
