Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF51396AE8
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 04:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhFACPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 22:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhFACPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 22:15:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3D9C061574;
        Mon, 31 May 2021 19:14:00 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c13so1127909plz.0;
        Mon, 31 May 2021 19:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FiNYOp2WDhjmbZvz+trYR0sYgu9U4pdGAJHnzSHmxdU=;
        b=VTp/4yXUmP3jNr6GbzZ00yJnxjGd+gK2Sx8YdolKVINXM7cb1+nIBDgbq+tOHW2GLG
         9HSl3hkt0Qv/GYpWtnsexcs5UnLNDQIRKCcee0Oy/bGuzjvjdpm6E0nTlTyA/D57H46q
         5HoyGMv7U2sMHyWr4uk0cMsmbibC2sePMgxrg37JM8hNBcha6Q4XdAhApLrxKTtIE6hx
         l837ZIBlTYwl/qO42YBEfQT9Fv/KkZ8L9MI9Ty63b5trzDgsOBZruAIAEumOFSBhIyDo
         4zyqZtI9vnsnKvwYYyiRgVoWC/l7wguZ5acMvA0rTXGzLCCRgn4TAqyU5zr/QNIiaC4a
         4VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FiNYOp2WDhjmbZvz+trYR0sYgu9U4pdGAJHnzSHmxdU=;
        b=rfmRdXf/XXtESB8oTfiACouvSCfnDSR12r+TXF+76t3miuQgHpr2Dxw5glO8zSJkL3
         /mXEe1AGFo51AJjm/lMFBJfMaTVfTCSXrcRwOgnAKrzNgF9UA/fdVIiD0eWWmzy7Oo9U
         cpaQkHPSvraOEnbL51Bf1RPuq8FXrpC0jb9Vo+bqhlJlBn80VK/43NAKCB3eQ91Uj7br
         b55ZxY+a2mN1ZaDqtHjrXdHQxSKlNbQCTrLN3WLsz5eABWo/STU0nQZi8cBrdPNc4A4X
         nFkls4xRPGTXfz2pKDjm6we3nCESk8orSJIjeidyGO2SOGiJUdUbMhcjiOu+hKyCmUe7
         pJww==
X-Gm-Message-State: AOAM530Evrl+76JEHV9fouy1R9/8alIMhLh7av7JGjU+Tgnz1X9mPT8G
        mHq3L5l63l+dUocq/Ic7M7/Ugn8IbyR25w==
X-Google-Smtp-Source: ABdhPJz46Iir++2MWHS9quMBD4vqaD3PG0V5faPOmC6KTNGsevZoShoGUz+59PSsl4h4HFUogYpipQ==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr22204705pjo.200.1622513639538;
        Mon, 31 May 2021 19:13:59 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id j20sm11536873pfj.40.2021.05.31.19.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 19:13:58 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/66] 4.9.271-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210531130636.254683895@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8fbf80fa-6ccb-a775-42d7-6966871d20ad@gmail.com>
Date:   Mon, 31 May 2021 19:13:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/31/2021 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.271 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.271-rc1.gz
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
