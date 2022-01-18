Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F741492E8C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245123AbiARTkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348737AbiARTj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 14:39:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8739C061574;
        Tue, 18 Jan 2022 11:39:59 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b3so16298521plc.7;
        Tue, 18 Jan 2022 11:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CMrbu7d1tdpLr0gUt3hdr3z+X3lDj8gI8RJ8X44ubSA=;
        b=mh+vyWmGhmDIdWL9PdpJfBayq8BGIVTWH2tZP0BMMlu4sPJTbpx/LqAh72x9Ib85n4
         EjqSi/Orj76/vhgNnWTodb+ry3mL35e2B2Sn8B+RISI89QwbiU0IWpkWXU4yClAwWHg4
         C3z3tFMMvEb9WJKgAgtGDPPBHjU5jvwTXU1JBN7Cf9+E6feqxYtIyOBdJVKUg+dMIVOk
         rRD2OO9LT/eMaQ+VpV/ECkYw0zvnuN+A9BKx9oJOQKtUAVfN6g+TqsZBPmleALfjxe/3
         WPIyCDulMtmau97NgHtFbNRg3VtXXjinUtPCJ5VyBxK6xudz08cF2p9h63wkHXPEbnr6
         qrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CMrbu7d1tdpLr0gUt3hdr3z+X3lDj8gI8RJ8X44ubSA=;
        b=Kdk9ZGeZG0Soit0mwbD/0OKJunnsjuEiAkEYSul+OasmrZ8S3WP17/1mqe+kBtWxvb
         JIPZTGpuheTO30L402PTFyvukxGzmcaO/xkgQ1zdkYPLrgj9OaT7I6aeXGx+TOadURMd
         KNwjvZ61VTVnua/0GbZ2lfhMfMhjePoMbKmx/CKKT2kCxlQnftduXaU3pBLwNg+yzWua
         dYq59HesrK0qnJH7SSpuAkJGpGl1wajfUy3aaEmqvi7yhf+jQu/ZeLRrmCIGdWmZ79Lm
         TlyMeaPVW4Aa62vNkvDqUonDF7oyf81qmV+hKzB61ubvh/JTf+jB6v8oL93RqmoCQ27S
         L7fQ==
X-Gm-Message-State: AOAM532wsqNc4LSbPZOtBU3ImnzPNQrCfKdNuPlI6qyT+hbalOCGqVok
        CFle45vENcXpKXEg/b0ftEqKxfd0uWc=
X-Google-Smtp-Source: ABdhPJwPDwcoNcYMCjeKXdXJCJCiK9U9O9o0FQGKnUj9qVCwuUAR3ihLB8joDorhAL3nKNeNLiKh2Q==
X-Received: by 2002:a17:90b:3912:: with SMTP id ob18mr113737pjb.112.1642534798913;
        Tue, 18 Jan 2022 11:39:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u6sm16703387pfl.166.2022.01.18.11.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:39:58 -0800 (PST)
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220118160451.879092022@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bfdcaaf4-de4f-db66-815b-401569a8452d@gmail.com>
Date:   Tue, 18 Jan 2022 11:39:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
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
