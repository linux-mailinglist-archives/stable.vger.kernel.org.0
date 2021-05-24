Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F362A38F540
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 23:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhEXV7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 17:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbhEXV7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 17:59:37 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEEDC061574;
        Mon, 24 May 2021 14:58:08 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f22so20167789pgb.9;
        Mon, 24 May 2021 14:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IBMIAWQdGmx4lMWgKW+ARGSTnwovRDeMr/3UG7SGN1I=;
        b=TR9oIFPkiyyLKZW75bAD1vliknHml5tUGO4aZejyrX3QwreVF9vplt/5d/1fNXqK4S
         6VtPrq2VClfmSx3YI/EMVQNP8LAi9f9cEOHCVUu/lpcAcoPL0v8hEEjEhaMrjRYvOzWP
         ZznTjvvh+/XQTk+cm3hS4rY0mIi252j0GWrLqqFuaJF4/5bndkKBMWT48QfxdKX4gnPG
         RtqEb7vT0E8D06OcfPd5YFKxtjG7PrBN37C9GrE2nisRfxz15z8KkXDoE5IGLEyDq3Ha
         8Bx/q1lfCDP66vSWRjY62iy9idg5D9QVxDLbnkbJ/TX/H/KZjM2zthMXjVp5VmTpSLOO
         EJuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IBMIAWQdGmx4lMWgKW+ARGSTnwovRDeMr/3UG7SGN1I=;
        b=Bym1U3YoJs8iyfyZ6JZudzpWTMdMX0BitJEVcesSefMirHEHw6C1LJBqP+QeWcbr25
         bLiMGX4enDGscrWoFocEAOut8exmEN4Bp5dUvXs0rFfEk0rWYjQQar6FYsMfLvH7EJa9
         Au1LG/3v8GxWYvJFerwWT7oU/UBSBumCkuiJm8XCVDkGlGo9XL9Xa0lXR5L7s8VzwbEO
         GTFYqPaNAbskTfa+EUdEO1aVgyRteDZAq5gSiTyJmgf9xeF4ZfcR4KRwba49slqtMdV6
         Z3yXySplx2MvVl2g/0ssxZO4IttTL0WNIWQZG8wbqE+EKhFgvhQSW8cAhYRCgIogCWYO
         Hj7w==
X-Gm-Message-State: AOAM5309/FkHwsu6wW6TN3vFHxocq900Jy5V+/vV0HhGfG+TQjqGKMU1
        RcNF2+SffQ5haIZgTrqxfh5gQPMq6iM=
X-Google-Smtp-Source: ABdhPJyhfexzn6ZdaVsaPc7YcXFMUaLNj+YGuW37/rde1vaKnZrmb3ot7a/LaDBQwqW2EpmQLQ0z3Q==
X-Received: by 2002:a63:514f:: with SMTP id r15mr15463896pgl.374.1621893487334;
        Mon, 24 May 2021 14:58:07 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l7sm357451pjh.8.2021.05.24.14.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 14:58:06 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/104] 5.10.40-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210524152332.844251980@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a307cb54-0497-a6fe-1b27-a99824dc459a@gmail.com>
Date:   Mon, 24 May 2021 14:58:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/21 8:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
