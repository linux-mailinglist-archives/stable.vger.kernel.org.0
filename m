Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8D33FDEF1
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 17:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343823AbhIAPqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 11:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343821AbhIAPqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 11:46:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE71EC061575;
        Wed,  1 Sep 2021 08:45:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r2so3164978pgl.10;
        Wed, 01 Sep 2021 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vtJboLj6DWizBsUGIabivZ4ZpzzyeGX1x3GJ6kiUpbs=;
        b=kz0c/j+oXtU7PthGgru+9CmqWRQloQxtCePOAmvlpuL3/uVdEvyyF7n3xf9VBPRuLp
         EmdAFY/6MFxoULU9Ri+SKezEQeEjOXwfAQPaTiHrvnE8RiI88C2wadglCRCLu8Se5R9r
         OvAxCUKd6Tl4p1hbwYieJzTFj6X5tLW8lsGRzZFWTtjPL1/VS+G/0hhVDCD+JnSNO3n6
         7+buZYwRRT1MT+q0sUCcmfSBIsMQSX6z67DmLScVG9ovwbmfz9/E82vBH30x4sIREQBn
         IA/NyaHXcXfEHu0oeIYechI1pJM5YuPwT1dZnCtcb844HsfDnJU/aOUAGNSUFxJS6YOc
         Gq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vtJboLj6DWizBsUGIabivZ4ZpzzyeGX1x3GJ6kiUpbs=;
        b=IMqxpgtcbObweDvL/wCAD+jnzZx/PgAxBo9QFRDNTy9V06s082R6gfJKCvUUSATnAb
         ZeqtdpUkXNVr8CIFIWJmhcUVbApGIRBhIN25k+CzATS0E2TlDps8d8p4oMxe+IxMGEHc
         R31J9d53lW2fdJb9SWlAm9/oGaaE63kPKoqikUqCEYKYiFOGN5sphUvUq5ImUbK5XHex
         IW1EFsmWTfpQNXzJWxCMVEqwNNn0fBI7DskleS61gvhXB0WLoWLRLnNTu96i2VIPJGev
         kPvTTqLGfhCyHGrjQahIZF/XNMtXW+yrdvhvMH1z4PVcX+jISarnyBEbf4175gESR+ct
         RbwQ==
X-Gm-Message-State: AOAM530FyoteHIpjXzlwTR/NFk3nLegpUAiu41+qMPKPfHX1cs2O4Pbj
        liCcpdT5SGZ5zFoqahzMelKoMeIXlkQ=
X-Google-Smtp-Source: ABdhPJxGkAOH0BjGf4nTs5tRBTgfRD0EDYs1ZzWbvaKdQsa4TsbnN13epgpcRewHQpxAIp+N91CjkQ==
X-Received: by 2002:a63:c101:: with SMTP id w1mr100544pgf.53.1630511133061;
        Wed, 01 Sep 2021 08:45:33 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id x19sm359415pfa.104.2021.09.01.08.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 08:45:32 -0700 (PDT)
Message-ID: <575e9768-f064-87d3-b816-d514a17b5fde@gmail.com>
Date:   Wed, 1 Sep 2021 08:45:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 4.9 00/16] 4.9.282-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210901122248.920548099@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2021 5:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.282 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.282-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
