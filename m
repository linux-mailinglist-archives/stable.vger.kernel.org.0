Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076FC455B89
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 13:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243833AbhKRMfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 07:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242412AbhKRMfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 07:35:03 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841A4C061570;
        Thu, 18 Nov 2021 04:32:03 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so4694402wmz.2;
        Thu, 18 Nov 2021 04:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HTUmXOuwAK3b2BpkEcD3R3Tlh4bL303PitPz8j6jUtg=;
        b=LqHIGx3daPLmG/Ro9J1LPjHyvQ0EUd1ji9TZusts5Tp3i5fZG/KG4Och7nFBWj3rTu
         V0S7koYYPfqnLs/RwaZPwFulL+scdZBS1f63Ho9mPHYZHaljMDvwZUshZWfSL/VDOYqi
         CCU9wq0Dtx5l6I4rkKhAGVm0hp085b1ZRNosBvHCak86crCaZl3zP1YtAqQDX7ZCaAO/
         nJe4OnFHJoWIeyI4uYJVreaNCNXSfUL/uilIRN8Vv8x+U8KnWRuwwjL2POqnpfCN5Ix/
         350wbgtlmavs2gX13wn6W/m9p6XgpfAjruHy89jQrhL0JKqHhNACAqWFDKL1idROoPNT
         Mudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HTUmXOuwAK3b2BpkEcD3R3Tlh4bL303PitPz8j6jUtg=;
        b=IIxC1LRgXncU68nH9+iVDOTdgW9vrm4ACSydqjGNIwGAc+iBJvBROSruV2yabMtEsc
         XbtYT0npGYH+RCq9YJ3ah9ha4bHJU/vVzsimBM9UT50M+9YmIk+n0dpW91P7ovv6V8Wd
         ZQgt+Yq+774hYgQlGzcnfk9p7gcGsKw7nJQuXXshYDBWDdqcFIlOOO/x5oNJdsAgMQdE
         8Q7oJYjWp6nypkcotvGwdALWdq6cM12Xn8neXKvwN5LITv4LC8rb8NjJoIP4ddwG3or6
         P/m+b7kSlBtpqxLr/o1lTIJF8asqSfPzDqjS97ErxrljWIKTiHscgynTDeBUaS0rm4ll
         poqg==
X-Gm-Message-State: AOAM532AihOOeaS4Gwd8xWo1tdU9gTR0lUff9CYZcsaB9VENElWvERMS
        VUA+ir7DBRnegxIqr6p9ZRY=
X-Google-Smtp-Source: ABdhPJwvtRUA57aI7bT+0Zfqfl36sxWXyRpMYnfT3spnFAjOwXo8Rp6pyrjFH8oAf3s/0OE0J8sRtg==
X-Received: by 2002:a7b:c207:: with SMTP id x7mr9705355wmi.108.1637238722153;
        Thu, 18 Nov 2021 04:32:02 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id t8sm3754930wmq.32.2021.11.18.04.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 04:32:01 -0800 (PST)
Date:   Thu, 18 Nov 2021 12:31:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
Message-ID: <YZZHvzCrIsqbo46z@debian>
References: <20211117144602.341592498@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 17, 2021 at 03:46:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/402
[2]. https://openqa.qa.codethink.co.uk/tests/401


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

