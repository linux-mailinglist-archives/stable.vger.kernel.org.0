Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E723B01AB
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 12:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVKs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 06:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVKsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 06:48:20 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBBAC061574;
        Tue, 22 Jun 2021 03:46:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n23so12500813wms.2;
        Tue, 22 Jun 2021 03:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qMOGwsWYKHTZb8UYmFMCPsWfqOqd5Vu+RMIfnWvpSec=;
        b=R0y96Yw4atCjm/+Ea/MEQx3JB+nRlqH5w4lyV9sm7lJABArNr1gBiOcnjC1SVjUL3g
         RsRIv/sXqiwvxrG8vg3+nVNDOgjJePVL5DoPDLVBnXW/102FbWyMXz86A6oYORhD6eUx
         AxTHtGeAY8UIC46wpgo34Rhi61XbNLU5vi0rxvqFeOTqE7hlir2A65BIbCfZSk3og5gF
         TOl+g6rSL4AVgFh6SqHl4qn93Hmlc2k556mM50PHYfCHVPLKRjCbuNoLBv1GpHq6j6Ma
         iNIR5wI16Tl2Ypi2ChyC2GmImj4JtPzvdLCVXP2WbqzA237XW58qThEAe3Wh2mmz5RRZ
         nxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qMOGwsWYKHTZb8UYmFMCPsWfqOqd5Vu+RMIfnWvpSec=;
        b=Po3+2/riBjrcCc9XNsPZAd3fkt94JPDUyaBkA0KL1EXjaQ4UKh5zihNBzBrZl61w7J
         UF+7TColAyWPzAQx1WulUeRbrg6QEh6pjWBEa3Ashcy5sD0ST7ik/G06bCFflUQNrxgZ
         Xt8vGsZa1yRkd1bOiOQG0fAFKAoxj2ZwhSHB//Df46n67sgMKo1w3ChAATxWc2qnm3nY
         lDO7MYQ8+ECpMMHpY+fJ/JpBQTJ0ko4DfdfZSv8bxupyHFlM05mpSOgo/QZTDwQo1EmH
         XhzBMkIugacnn+1edJSZO9yLTiy5b/hvYg8zr2Md2lHHFQlDHLzLGcdg8F6+mz0mSGzz
         ZvqA==
X-Gm-Message-State: AOAM530ugtnoYW/Ifb5qEbYvpMPbkOg3p0NKihsw9Z7AfRxI1bDNTLzZ
        aALmPKsKU8lhMr2LjCRAvZg=
X-Google-Smtp-Source: ABdhPJxJ5vGzRo1V9Cp8vXwaCUciNyAZUk9oCAPNkyR+rJfg+SrwSFr/juwhLDFEv5mwADNcsZO2JQ==
X-Received: by 2002:a05:600c:22cf:: with SMTP id 15mr753586wmg.177.1624358761437;
        Tue, 22 Jun 2021 03:46:01 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id u20sm1870325wmq.24.2021.06.22.03.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:46:01 -0700 (PDT)
Date:   Tue, 22 Jun 2021 11:45:59 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.128-rc1 review
Message-ID: <YNG/Z19ODMtK9BVg@debian>
References: <20210621154904.159672728@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 21, 2021 at 06:14:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.128 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210615): 65 configs -> no failure
arm (gcc version 11.1.1 20210615): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
