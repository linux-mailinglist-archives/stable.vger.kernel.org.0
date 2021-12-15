Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285804766A9
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 00:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhLOXqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 18:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhLOXqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 18:46:19 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E215C061574;
        Wed, 15 Dec 2021 15:46:19 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z6so17925267plk.6;
        Wed, 15 Dec 2021 15:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q3SOY0GnBdcWKH+D/4Nkrs1rt/Pr20FSK0Xntas2zR8=;
        b=GVEILhipuAU/C/YtMLxJ/42VCjY70Jzn4Bbyh1AaslN9IIt+vU8vE8iD7Mc6SvWFiW
         p6ifjG9z8hUNeV5Q0vccTNwUFYGbxebzjNZlN/gBOjxWdyAHeokdTB6dr6b7fGy2sdAu
         lGFZKweSHG5P2uPPBTFTxNFuy8TrHwPz/hLUtWKQJOxh5s4paBP3530Me+naJX2tTALK
         z9x135GgcsT2AH5ZPwev8W0FBN/KDtwDSOB5YxDSa2BSHAYAeRHPcCt+mY8HC4bp9pEW
         tBw3ETYx+QBnKQdyyyx2sJH+r21JC0o8jOG21qJOOVHxIIM3mYBk3yXuSxoR5w4DJ944
         8jKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3SOY0GnBdcWKH+D/4Nkrs1rt/Pr20FSK0Xntas2zR8=;
        b=yJE9zedWtbFU8N2CXmwzJmuRNBWv/BZDOJDbcfbfNrxyjdL5a7f66LWboc9wYifdH3
         WBquQSlwoi4OjnW4o7M8TrxVZg5jHE5XhROvC0nJlFEq1dxPp0vP+9zKNQHxbpNhpwlG
         uoH/Q7CK8VtEUISVsWvU/mViscS5XQzNA6U5PgeKz/AnzhVlzcczBJSMooEwOQOdn/a1
         ruE8yN7vbsRzw+LUxuBbHTVtNYHiEQzAgh0zUSmC6hiM5yI/QgcyYGe/1dnTmWt9hxQh
         ztZkVhazJ65mYmUze088ous6QPz+Acqo2CkiTNwF/QPF63yTGJyim2/qCin95Km/aKlM
         iR4A==
X-Gm-Message-State: AOAM530UhwGjEizFrGHlXAdU6hwLifSrCr52+iu66TFVp7VIXc1DPCle
        ZgdbDWqbVZmXAbkhyq6fDRn1U/AUkeo=
X-Google-Smtp-Source: ABdhPJxnOyufCg1aMp2Jca3GpvEv/C/3UCDPVDBXMYIq55Cd7eebo47xDXBGtJnIm/1UEIScaRNkUw==
X-Received: by 2002:a17:902:8544:b0:142:66e7:afbb with SMTP id d4-20020a170902854400b0014266e7afbbmr13422234plo.62.1639611978711;
        Wed, 15 Dec 2021 15:46:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x11sm3168725pjq.52.2021.12.15.15.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 15:46:17 -0800 (PST)
Subject: Re: [PATCH 5.15 00/42] 5.15.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211215172026.641863587@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0fcbd44b-93d3-aee6-f483-49b4653289ae@gmail.com>
Date:   Wed, 15 Dec 2021 15:46:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.9-rc1.gz
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
