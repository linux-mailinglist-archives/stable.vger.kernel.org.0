Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939273A6EBA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhFNTUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbhFNTUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:20:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C65C061574;
        Mon, 14 Jun 2021 12:18:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e1so7119919pld.13;
        Mon, 14 Jun 2021 12:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZCJbIJV/nfxgcCIcUtBDKRwC0IFsKldYz04bEu2ohmQ=;
        b=JZ1Op034ncom0Ie0M+ChMI7vDG5AUnNbS7ogJV5xxk4j12uIzpB9A3IeSlY3Br6fg5
         lVPXpyr2ubTzY5jaDlx4/wKr7BJgtHF8m2jWKEdZlovoOogfThhKjnFLpfsRYAFgJiRV
         mC92IlX5oVfcOBgLMSpg9JlW/8KKwk8LFiAIYvoq1hrF2tYj3qbBgKDG2Y5djN8/yW0u
         ApUdvOvo7xkWJ4q902z/YnP6S2tQKlF+JFtxpOKyd4YUptQ8+c9uCU65bI809Ru7kCWF
         Xmimyd3bSqkB9MYLXaadmpAHdTVlulUWBLDFUUJMHvrEM6URPW1c+gC2XalIcyOqXhwE
         Cerw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZCJbIJV/nfxgcCIcUtBDKRwC0IFsKldYz04bEu2ohmQ=;
        b=MzffjkdlrRBjpbgc2tNaB83JMJSzRhULn0MzOYNZb7odVBdSsHSQHgAeJwaft7bZ0c
         HTwddfHyek7Shq54w0IZ4R0c8/GWNCFJuhKummaowuue3ZPyKSWN1ETXUd/irT3MUBIA
         nrMw4fJRTscYsSi89Uyh5DTRHlqVdJeEG6ZwTuW2KpydHscAASGV5NHHZVxBQClkn2iY
         Z4yfciVJvYyxqxrpcB/wibfrCyfnCGZsoIAG90anD1IqtxO/M7vF8AqFOWTnVFTp+9JO
         boR9vwq0s67X+q3/0O0AqBT39oq1hJIB+k5kHMqJ/r3fd6696EZk/G37wbXJGKicm8r5
         nZYQ==
X-Gm-Message-State: AOAM530z3pzUJdUdn45raSjspY4gr6fWCCga+iAHf/VILUa0pFqoN3s1
        pwkHkaPlFvwQRosadpJGkEeuaXpD3Rs=
X-Google-Smtp-Source: ABdhPJxT8jDHY2Ff0Xf2ZtwrEconnb86cTAF1g0JunV4SK184w1v6gI/6rbixCpavNdwGOPhtqnVEg==
X-Received: by 2002:a17:902:bb90:b029:11a:cf7c:997c with SMTP id m16-20020a170902bb90b029011acf7c997cmr587482pls.80.1623698316376;
        Mon, 14 Jun 2021 12:18:36 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n37sm12901390pfv.47.2021.06.14.12.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:18:35 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/84] 5.4.126-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210614102646.341387537@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1f35e79-2105-eb71-818a-7a617a495679@gmail.com>
Date:   Mon, 14 Jun 2021 12:18:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/2021 3:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.126 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.126-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
