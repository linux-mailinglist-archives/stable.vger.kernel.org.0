Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02AB40FFFD
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344825AbhIQTvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 15:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344089AbhIQTtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 15:49:32 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E867C061574;
        Fri, 17 Sep 2021 12:48:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d21so16870446wra.12;
        Fri, 17 Sep 2021 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0LiRPWrnBm9c1Rt8hhWYou9LBzchrf8FtTx3luadPIU=;
        b=XIB11Bm36/By4kmpLVmLsVaFDF7dxnsUohSZRdg31I6RDCsgVMQuB7VkV1h6xiqdZy
         HAnmPiSOd1QSjlf/wBjH5gQThpeWyvLF7vPgvXm91wtU/p0X1bbVD4FdyvjmXCQWUqbl
         VcRTsb4wx6AxvBqEEoIKSU8QidO6HW2WrPgVyUaJkpsG/ixzI6DSiY7IYt/xka1rTm29
         QDtXnm6jEbLvHhCIEq9YxX3UOlPLRzaz2gQTlGSaFz6WCoE74xDQxIWm4NmocNpOB1TL
         eqs6rFF0+n2POj8akAHdPr9UnzGWNDmN1veBrls+j+itxw7qe4V+tqAo9gGgFbKZVHJ7
         PtHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0LiRPWrnBm9c1Rt8hhWYou9LBzchrf8FtTx3luadPIU=;
        b=fCJvr2q9GB/qFjnCy4atKq+JyKY/s0XReN9EGk7y6vm6sWzxASs/jsIcNPoOMI6Mts
         cqGIDIOcGdWaj1PqP02WQJkeHl5pAGVqI5+5K32qHK1Jc0S1R9ZlM9C06WMxceYF6NDK
         /Z3h9CqkMBnui53sK+aPfN0uta5etlNfgsl9uSzTPXqTtBZEocBSv5gZ1Uk7Us32kkY0
         BWJasExi4pqNS8Np99bWsL2jEij2aUUkA2Y+TXb6i4quIO4OUIdvhT8cb/I/HNWmJhfW
         /waEiRvq5GneCOJUT2/Hbb+4mzqn69QBHTozLdbkDpeTlCQUe7PHp3mm9mk6z6TLEkFV
         6t9Q==
X-Gm-Message-State: AOAM531IYzqEuBDTw3or5LMkKrYXTu9+qM9sBIV92PIlNmpam1JblH4R
        FIyj0QJfKnOl5jMJ3BjMKbL3MZZSE5M=
X-Google-Smtp-Source: ABdhPJyAX1qXbfgYD2VTyz0yFqkdIknla01y0LDa4c2kzSXF39ZJzE1i+Af6RMk4Ib1Qk+Vf1YqlCw==
X-Received: by 2002:adf:f2c4:: with SMTP id d4mr14316073wrp.434.1631908088648;
        Fri, 17 Sep 2021 12:48:08 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id o26sm11436730wmc.17.2021.09.17.12.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 12:48:07 -0700 (PDT)
Date:   Fri, 17 Sep 2021 20:48:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/306] 5.10.67-rc1 review
Message-ID: <YUTw9oSoZB5q4+8a@debian>
References: <20210916155753.903069397@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Sep 16, 2021 at 05:55:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.67 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/145
[2]. https://openqa.qa.codethink.co.uk/tests/144


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
