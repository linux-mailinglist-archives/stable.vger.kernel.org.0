Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBAA423ACF
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbhJFJtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJFJtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:49:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753D6C061749;
        Wed,  6 Oct 2021 02:47:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id o20so6970697wro.3;
        Wed, 06 Oct 2021 02:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pqMoBj46ibDME4JpAKT4v/7ZLq+IPkc3GBPuKjiEO+g=;
        b=MoPyrYyDq1IL2QE+P0JTn7g4yjulP+vRLgRnyI49/oTkSmPpLv4itdxjHXg3D3sC3d
         AKOZihAfhSJMgoPk8i5JIjIsL/OOxzZiTC5Li9d5t0sqk4N9uRVsP07Z+M3hI7w9MHZc
         iMhq5J56ndxJr5LGTFGnCRKuqe7Mx+5aHyGTYVWtnhDuJLPa7YLbCA1O+851ZRW8YTUp
         h6+OcFrw+TcXo61I4SIvtUxEv6EmXJKBWda3tJbvVL6/KX2jW4+fJ7w9CEM4UxuqoOlI
         SVuGqG3VkINJE9tVW1Wc5ptG6h5QYRnWHUFhX60u4QCQY+bgKvZtkHSHBHskGRHVZ358
         mVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pqMoBj46ibDME4JpAKT4v/7ZLq+IPkc3GBPuKjiEO+g=;
        b=q6m8aY596sDwfSokFQPcm7iRl+uKTCwLhZgwmqpckxNx2KpuUiDMsdls58j1Pl48LJ
         5wbJYxLaP/br3JIO3cDqU9VDNsENJh5IrmlrL69gk1H7t0NtdG/+m9iOZek3GnE/zMFo
         AWTOeB450TLVTE1aEaioIG8W23H1QwSL0xNoK9NpzVUOtXpRjNXSySyWOKlqgIRYX+J9
         1nOh8VJZguDzU2dXTHLrz2i2uY6BykFsZa0kiU9Wk0DPE9H5ik4hhflzT5UDDXq8Imxs
         J30otYF/YZqj/BiCb/BA1yLfO7j0cVBvVPEo7ramJ9wFgORRo3DdW/gQ6K19LZ64NAHC
         VS5g==
X-Gm-Message-State: AOAM530HIsZr1m+nNrR45FHpbdxa9o+h20CmgMkqUao+frYLAPJTMj/l
        rfTXRQt7u7C+NWTh+yqSsLs=
X-Google-Smtp-Source: ABdhPJzhhqqCkWv84l/l1/22Ky18FwLjOez3v9T1rtL9tLl8CFQQsNLB10pHHG7gRcK3sQuZ+2Tw4A==
X-Received: by 2002:adf:9bce:: with SMTP id e14mr20564864wrc.353.1633513676010;
        Wed, 06 Oct 2021 02:47:56 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o1sm5972472wmq.26.2021.10.06.02.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:47:55 -0700 (PDT)
Date:   Wed, 6 Oct 2021 10:47:53 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/53] 5.4.151-rc2 review
Message-ID: <YV1wyZ2a6c03BLtX@debian>
References: <20211005083256.183739807@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005083256.183739807@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 05, 2021 at 10:38:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 65 configs -> no failure
arm (gcc version 11.2.1 20210911): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/229


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

