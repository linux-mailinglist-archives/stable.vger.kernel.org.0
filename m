Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B954735CC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbhLMUY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbhLMUY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:24:27 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E98C061574;
        Mon, 13 Dec 2021 12:24:27 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j11so15554535pgs.2;
        Mon, 13 Dec 2021 12:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lMLRO/bB2xq3kiJL8NNPtAclQEmhmVhdhS5X1C2OHaw=;
        b=qY07egjRRDwVWfuXUYFvODIfp3GHG1r7UiDxfttS1qEd3OcZR5yL6ybksufLqvFzEu
         Pe/Yz0R820YlTWF+Q7isR+IV9pB+C5dWhgIzGArBUvDVXDoOf9uBmKzcY+vE5dY6yWZY
         rQv890knzSA6i5EAfuI0v7sIjk7w5sXTPj2Db81kJc1Ck5dWlpIxFEIvWt25/vtV63ir
         jBwBt6+6ZDyVCMwqsAB8+WiScvaUTtmRH3at/Y1+8EDY8B7nYPw8G8Ngq1sbjxT9m8Kl
         LWkXejhQK8pWLMKkoCORjXscXT2w3ZRffLmhOyWOPEygUKZl1ZL41n743YUJwNfhTrQf
         1u6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lMLRO/bB2xq3kiJL8NNPtAclQEmhmVhdhS5X1C2OHaw=;
        b=Xa2g6Ayyvx2gP6YtUr3zAt7VFv4Pqt2j3xySG9tYdVD77Y2S34T+rXGStHNJQ7WkPr
         bM5XoQNxF4NcurG+erbHCTyeuyuRvsMDlXiZ20sk/AHhvlW3qRfvcpMVbeO7dUbBFEcN
         nVuCQTqS6T3KF5Rlpy/bBYqugk/M7R24CuOhKzoeA6KYJTIuXoVCOol+5cmr+Cb40eFT
         B3LnoL9WN8jezSmdqHsOvPwTez5+kGkuxHYTpBi6lN0/5cC33h3VX+SzM9u+jIvef/V3
         2oxUqrkI1NcdooqxwRqIjFJDf7AYxboKXRl1D9NSwhhrKeBnTLChtxLAVTlfMfVqVv3w
         7DUg==
X-Gm-Message-State: AOAM533UscnM+rdyJtmCjN8JaVr4bEFE//I3rUfzNT0k8DHKs/nNsbw8
        zXVNTYlR/xnnKxRKOkuIg5vo+8mgq34=
X-Google-Smtp-Source: ABdhPJwAFHFlUHwWQSeb1u25egrMIblb/VoVxrnpwCUxUDw0p2qM34HNiEzLqD7kaIA/WaKeW6KrEg==
X-Received: by 2002:a63:565b:: with SMTP id g27mr609583pgm.564.1639427066712;
        Mon, 13 Dec 2021 12:24:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w20sm13919946pfu.146.2021.12.13.12.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:24:26 -0800 (PST)
Subject: Re: [PATCH 5.4 00/88] 5.4.165-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211213092933.250314515@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a2e9b8ca-bbd5-4437-8fd0-1438b6262b36@gmail.com>
Date:   Mon, 13 Dec 2021 12:24:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.165 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.165-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
