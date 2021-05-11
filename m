Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D853437A371
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 11:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhEKJXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 05:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhEKJXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 05:23:04 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D41CC061574;
        Tue, 11 May 2021 02:21:57 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a10-20020a05600c068ab029014dcda1971aso795928wmn.3;
        Tue, 11 May 2021 02:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QHs3slST6breQ8e1T6OEdAIORl5h6uTSklDB+Afab8A=;
        b=tEakCvylSaNjGNefCOPSz2/gmGGayJZKv31p0dDWoDOeBE/Z1hFLIkRfBt+htnrB0U
         5AXW5quLjGKEA3WtDniHvKsDq3VufYh3Kk93bCHP73RdgJ4M64LvKk/Xflz9Mst90BrL
         V+QobveSBy88k522ARbALP6kf4F/fL+2tA2UiypmWkqMM7h6IFaiGFcLN81WP08w3ilO
         rkiu8ulCh5Zd2OHNARTWTQURfmw0pn1BzRjUpQaBnmctxzyExSyqsn/Z1WH6xEvODhZW
         88Lu04WzN8hvF8Nxiyrn5+AReSWwk3qGXS04akbB6aZVAv55g/scgpAwCG2OmtvEwy6T
         5tIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QHs3slST6breQ8e1T6OEdAIORl5h6uTSklDB+Afab8A=;
        b=h22bpz/xl68BDZPYqYIKNmwnmeIia40bz82iYxNn8W6QG9tFRHTIbWFonmJKR4ONRO
         Maas6OT0fECFQe3xVxJsjNQN6fu3TAdqrzFtQW+HM/ztQVAUG3+jjZtzjVxZVfUPxQqW
         J+/McBeaZF3ufHu6y+WLuAh9fRGWg+BI5TMjR9Etc68JhEMQ+ADp2Y159oZJmgXakdu2
         Kc/mSYd/nDbqJCn2hjdojtq/ALn6c4IZL11iLk9K4U6gn7y6DgtWfA6T5YF/hmPiKTcL
         lfup8yuG2tObKOdESAHUjwucBAmB0l4t0roFtF+DX4UG5WE0E0cKrWAJAd93FQXtKwlo
         njYg==
X-Gm-Message-State: AOAM531/Ai1iLAZq3ks49pp2JG6wh2JvXfqQMtU7m5ZfDkSgGVI8FKJC
        bU+eDoeLjs7NvbRHTs2ulBs=
X-Google-Smtp-Source: ABdhPJyLbYD/USAcm+QgpS2nHC1GcZpRbVTk8B+JeoztBVJkcLzaKxfaGRmgXqCylObFU4JPJH3mJA==
X-Received: by 2002:a7b:c93a:: with SMTP id h26mr4265932wml.107.1620724915677;
        Tue, 11 May 2021 02:21:55 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id e10sm28019225wrw.20.2021.05.11.02.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 02:21:55 -0700 (PDT)
Date:   Tue, 11 May 2021 10:21:53 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/184] 5.4.118-rc1 review
Message-ID: <YJpMsQqo9FETw9NW@debian>
References: <20210510101950.200777181@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 10, 2021 at 12:18:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.118 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 65 configs -> no new failure
arm (gcc version 11.1.1 20210430): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
