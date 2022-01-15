Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF12148F67A
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 12:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiAOLHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 06:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiAOLHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 06:07:47 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8617C061574;
        Sat, 15 Jan 2022 03:07:46 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso11740959wmj.0;
        Sat, 15 Jan 2022 03:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=49cMYEAT/BjVZYMFgdWLTUrWi8kXzuhxxLdsLpUVzRY=;
        b=FgYLDqMsrjmJVI94AWq+39BBdWqiGQi+RYxzrI8+tdB9wpgi+nEz7kCya3laXaVySq
         KsqfcUPxC1w+rh9/I4aJDiiA++H+2k+FEUjWq3y3x2PA+cH53OlUrxAdJ1A9Eao5GAKy
         pRd3Vn7zoAH88AmV8u/pkm0EtpEVlQI+hPdVBfOQ2TuxTbk38hy+oMGkw+bI1LHDM63C
         di4bGeP1w3BvzDB7JUjsMU51ozNn3CNOSBBJki8ChDQMHvCunzw8luwJmkE+xUY4Qjdv
         Z8u3GyC+0ziRzAbMhy4ULBrEOT5q2AMTHNFGdQmeMzx3xTjQ7pU8fBfFvBqmJ9Zfeojn
         Z1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=49cMYEAT/BjVZYMFgdWLTUrWi8kXzuhxxLdsLpUVzRY=;
        b=1zOKIaofQyZZsaMnCHqd1VODcYL02sjXdccn2Cc3mQ7FMtmmIGpfdYAdfmErx6i6LW
         Fk4NU79kC4opcQaEGS9/yuJ4bL9sUbPW3518fsKdmBYx+S2RP/nKC7TO7MbTUfhDd+4a
         6KKv+dmV4YAujpzezG4jZfIReHnyi9tvJvgEsaB+BwEHWqqGJQikM/DAEpyJcMXG1arU
         Cx9PH6tiF45woFFR15GqY+dg0ATDY/JwCCxAHD2QgxGud27AXUvTPEtBqhhSej0cXTAB
         gz7obt/IduYjg2q3WaEo+ajLJT4ACjQ3hD0hkRsNNLbcGStpTaW6iDYV7xQnkCEaM+4D
         MuFQ==
X-Gm-Message-State: AOAM532TX2k5LMiGWFZIsRbl98dGcDJQ7oWefOD1+Bn7KFc8NtOBGJ6/
        tScFH8aMg3yeYZ857q5c4+8=
X-Google-Smtp-Source: ABdhPJyQZKvhIkFcqUMtT0cMX9nAWsLhFBVaHcGDZozXWpg7zZl/MNTcjdFJcKSs6EGUtSJ1mhb9lg==
X-Received: by 2002:a5d:6d49:: with SMTP id k9mr11985247wri.530.1642244865500;
        Sat, 15 Jan 2022 03:07:45 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id a3sm10009010wri.89.2022.01.15.03.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 03:07:45 -0800 (PST)
Date:   Sat, 15 Jan 2022 11:07:43 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
Message-ID: <YeKq/2bnquT3xvjx@debian>
References: <20220114081542.698002137@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jan 14, 2022 at 09:16:08AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220106): 63 configs -> no new failure
arm (gcc version 11.2.1 20220106): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220106): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220106): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/626
[2]. https://openqa.qa.codethink.co.uk/tests/628


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

