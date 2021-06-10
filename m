Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F8D3A2790
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 11:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFJJCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 05:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhFJJCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 05:02:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC07C061574;
        Thu, 10 Jun 2021 02:00:07 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso5926344wmj.2;
        Thu, 10 Jun 2021 02:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lRB0WuCgLkcln7hWm/ejbJaLMn/s7iiKzl59hbQU0D4=;
        b=o/DKP+6XXkaH0eR/2Yvs7r44J7zHcmRWqor8JZV1sRAye4eAtj/7EMMtNOyNVBW63J
         DUmIeavcpuS5ksQuQesce6msC94bM2qXNMtEkzzBeCqkPOGYPTjP1OPDtXJQ5wKrwnAP
         hvyizWDEv38kHuw3KwozDdwmW0zOoWPC+W/hwBePJWH20cb+YNuOufSKRGNIFQcPkuVR
         ZTob31gzlv7bcFix4Sb3uFhFfvCIRWNipRz7+QxHVr0t8VUBCe/AfNPtx/xCzoLONymd
         je8r/Ig/rv+BK3iGVQBT310I5mCZymqE0YPWu9rIXH7aHwUYZPa4FFkETidIjmatqKXI
         bxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lRB0WuCgLkcln7hWm/ejbJaLMn/s7iiKzl59hbQU0D4=;
        b=R33rguvV91mPZGawzYHk9YQA2zR9hFGL3DULExrIHnBOglFMJ0j0huFVjGOl+LS6Fe
         gs8CVEfQrtEDbfSJDWpxYm9gpoDHc1ztdi4IVMVAn8gtHcWMFKus96yaB/CRK8G4NeAc
         xyhC6O8tn+SenzM+Ri87szTaSCioT2TzWkCY/I/aI78/LbXa3tUtAQzg5NCYbClYDQ/y
         Ixew/1FA/KyUEqaLYI0eLFrm4p1/pXJiVQgWWk6YTj0BVwmgrLtlK82pB7gkqT3Hgjr+
         2md2bTEWZOsTc1dlAH6iV7duRAKL/fEtDbfvuU9atYTPFtI47ZKDaON3XS6eaM71AT/7
         R1sQ==
X-Gm-Message-State: AOAM530hzUTjVn2S4eRZRb+ha+wzDslRE+JCgewMZHDozWIhONAf31PI
        VQHTA8M50ufjL4u8mfMeX5g=
X-Google-Smtp-Source: ABdhPJy05LjQw75KAN4WIQLoMhqfV30CsHp+ZtY2Ls19cxY1G9zjy5PM8XgAZ6j4gCxyPmZdiwYwLg==
X-Received: by 2002:a7b:ce8a:: with SMTP id q10mr3992818wmj.184.1623315606406;
        Thu, 10 Jun 2021 02:00:06 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id a1sm3082782wrg.92.2021.06.10.02.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:00:05 -0700 (PDT)
Date:   Thu, 10 Jun 2021 10:00:04 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.194-rc2 review
Message-ID: <YMHUlEXPBtv0l6+h@debian>
References: <20210609062858.532803536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609062858.532803536@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jun 09, 2021 at 09:54:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.194 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Jun 2021 06:28:32 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
