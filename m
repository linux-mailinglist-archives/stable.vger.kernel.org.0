Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4095D38CD27
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhEUSWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbhEUSWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 14:22:34 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816F2C061574;
        Fri, 21 May 2021 11:21:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso7904259wmm.3;
        Fri, 21 May 2021 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w+MGTPmIHEV0oE5RHb+cZC3bI8NiqQcMsd/6MKYtY7E=;
        b=K6YLBGa+BgaQHmdt4GsibeWssiFLeVSTvIf0Car4ffL035P7gnUo2L2BJMLiTefeZL
         nT2xzCUyCjbha3JgpMRV4mXDyu2r9c+2FL8vgaqj4F0ztRFwugqHOJOlLza81FVIzihJ
         Txm/zaYBeB9Cy/Ji34zNWrl2vy+hi9TdC9of12iEzsmDrefdFEDc3OyLzYtwCAvwzBz5
         SbLlS8bn96+w6UqDRAX/mvJl3+34BCwsXmM2rBeZsPFCL3ZdQwDGSXqzKhw13iFrqPxq
         MTzqyPwSXf4SZzFqU6pCuD5PfHHrYf9xF7PQCH86VuJtqYrwYlYtHiK0hdFuRwNhnjr8
         CtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w+MGTPmIHEV0oE5RHb+cZC3bI8NiqQcMsd/6MKYtY7E=;
        b=i4PuHQxJnBr8qhZ+V36egoYdB4Tkc9Qw1xLPE9LW1M80nabijoh+Nw2n3v9S221MFX
         1Zf29pEu3YGNQWmS3dGJbiWWPyWvPGsF1Khfm5EPxM2W4vpjo8NaWvVM09QnjfCnsZqZ
         qzki6FRrdliGGdQX7YhWbRCJJaqYyOqR6nResmebABX0yCm0hKdOmuESVaa1ZHhgctf5
         2/3/dhLE0LkKOQxznVIL9DSsNG6QKNWEBHtnCDqpF6ex0hKkgkgYHN8wBWtA8sF/+3oz
         qOj7EHuZlprZawg4wZcJnFUAWAHIP/YbdzsQX2eS30A9zJ6haSs73N0sdn1k91Zy+tRz
         nUpA==
X-Gm-Message-State: AOAM5302ymboJoH6aIGr0Ia5sPHdviffl9hSJPf14jofmVP2omFQceve
        t64S2yiptU2Qbk00QyRG7BaQhx5ZkNwPaA==
X-Google-Smtp-Source: ABdhPJwVzjc5Fz6Phjhjgq3ezQtTrp3HmJf8MzWcGkthnAOMVJPXkkRyDyp7L+8wUUQwAaHBKCD6Yg==
X-Received: by 2002:a05:600c:b48:: with SMTP id k8mr2639224wmr.52.1621621270067;
        Fri, 21 May 2021 11:21:10 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id x2sm298638wmc.21.2021.05.21.11.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 11:21:09 -0700 (PDT)
Date:   Fri, 21 May 2021 19:21:07 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
Message-ID: <YKf6E5qKSjdf2IHF@debian>
References: <20210520092052.265851579@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, May 20, 2021 at 11:22:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 65 configs -> no failure
arm (gcc version 11.1.1 20210430): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
