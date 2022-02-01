Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218D44A6054
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiBAPnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiBAPnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:43:40 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02108C061714;
        Tue,  1 Feb 2022 07:43:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id w11so32799600wra.4;
        Tue, 01 Feb 2022 07:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DTLU0heAwYt/KZGU8/7uhSVEIhV4pM7/jersUvt+wF0=;
        b=mnzDEjW4lmA4HO5TBMZuKc4keNsFklcttx4kxM763Coz4KRDDgCNi1klzfXgl6QNnU
         ry1jIq2TblbLDJF32tL24FXma6zCphxtgeg6UD0z+4Tc6dhO+CqNCGM86XaAQ60j5ncg
         6xpGxNuMwHyboULfTtmoGCATdBDcUFp43J7iT7QZD8Djl0mNtS7xfQ0qSLbbGC2Nc2Ri
         FNWLzrdKD/j7e112o7cAdG3Q4VxSiOPZJq9GhzWvv5hGIFC8lobiZYZFCDFlPAwgPbeq
         D+0Bma4dHGZUYhSrYzSc3hnOXBnnQm/wxnQwDazpwMkfPcZ605Wht6SkzCigTNPnirHu
         I8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DTLU0heAwYt/KZGU8/7uhSVEIhV4pM7/jersUvt+wF0=;
        b=ePDeKp7EzPPHilzAQ+RirXaL/fPobz1/QLYBNeCKetPpDwrqW3kGjvGj7WqVN3B3QM
         r/G8SDbUU+U2jfDbUAZJtCyrih4WNmlXCEHB38SH6uaE0YUmecF/qaZot+3Y+gcbGsDb
         B4Wl7Juj8RC+cW0wWfU8jHQQZwWHXuAAXxSSWABWXiusijnstXDU+D7Al4xfTnRT+ewp
         A9aEs4bY6tVSjUHVG0RxUDpum/kevo+4gWjaubiHUJgE8DgGDxqELbLXNry4mJxDQDeh
         b5iQAd4AXCu+z2XRGMrsXcnWKiUD1S4azdD4pburMvZ2rWR3BN7Utmz76hcnzIIrl4nb
         ySpQ==
X-Gm-Message-State: AOAM533Ym/Gvg3SvXF6O3Ywz3qyeHjpBXf6FFT2+42I5BOVtXExivdDz
        Ico1kjUTpCDgRnWjevWs9JI=
X-Google-Smtp-Source: ABdhPJyBb/FTWYbt2Mve8lzn6w6UK3uVuIirO1iIAvCL8rYoOVuSPAbWkURO1uTvJtHywP2Q/+/BMA==
X-Received: by 2002:adf:e941:: with SMTP id m1mr21644288wrn.76.1643730218523;
        Tue, 01 Feb 2022 07:43:38 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id h9sm2397634wmq.8.2022.02.01.07.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:43:38 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:43:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
Message-ID: <YflVKBWYrJAylqsv@debian>
References: <20220131105229.959216821@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 31, 2022 at 11:54:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 62 configs -> no new failure
arm (gcc version 11.2.1 20220121): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/688
[2]. https://openqa.qa.codethink.co.uk/tests/692
[3]. https://openqa.qa.codethink.co.uk/tests/689

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

