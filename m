Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D548F67C
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 12:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiAOLJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 06:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiAOLJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 06:09:24 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED2C061574;
        Sat, 15 Jan 2022 03:09:23 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso12361721wmj.2;
        Sat, 15 Jan 2022 03:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wbtngQJLC1AXKVgmXqeSN04h1xtyl3WUPRPOVydw+k8=;
        b=n5rhOUPcZYStYqN2IderhavLDac2yeTnQ2qpc7mx6lVoy54aY5DJtafiYOtF6Wrrx3
         Hz4DSCheKQPYUfKQJScUovIh8H2KnTFJYSAcVKlQ69Wv6kRgoYI2X5YieKLIb6Bz5t+l
         oA/jfbTdf39j77UzArDMEKsTt2nxrhqWF+jNNqRFYgG+q9Qiv1mDbGQMGNQ/3ZmYeH8u
         dqns0Vf+DeLmahsW6R94A3bIWPeDFJBzR+O5SbcK5Abp9Fq+C7nV6xBehwIuJSE8DR0Z
         VbVkdW5ZnMvTjv90Yv4QYG3MM/o1zuNWdq4vVD7BABq9L3+J5PF06BLWG4fFAqlMMq37
         AbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wbtngQJLC1AXKVgmXqeSN04h1xtyl3WUPRPOVydw+k8=;
        b=0CSCV2BX+hqlmwNcE/dJL3/P58XZFSfF+hf6oCwyndqZSi0FPZKUK4iS+EUKrKJCCK
         VF82xZvCFGlUxJeLxZJZONSsT/o/AQyye5jCldTX6YMAzTw04AeXa5oJr7f8tiZQQmzL
         6ZwOLAv+Dm0KxeyUlqUtqJngreb+mlg/Aar6pxiy0HfBTKoktQPFus7kC8fAE1T9Bovh
         9efUBU42mWV27d8ImA4KoOA547BE5jGTMSwwUwN9SUdwNJZ+XFp6Ak1I/JH7VU5shPDV
         xWojtsjyI9eZdjhB/jhru3hqIgfyPLSx4pIq9EKlW5PCdx8dcOJ/jxeTDQgsFc0CZZcx
         tD7g==
X-Gm-Message-State: AOAM533w62W18UaTzdQPcZGWnTIQW1I5MElwpkmChXAaNV9Tv/7ERH4I
        mx2xNipCnILFpybtERCiCKjXcbcfJPs=
X-Google-Smtp-Source: ABdhPJxPD33H1ytFI+ReUajL78kwoPIPb75CbtKQHtbwo4aYG+YtbiW8AgdW6jkHcfP16ofpaYqBvQ==
X-Received: by 2002:adf:f1cf:: with SMTP id z15mr11733427wro.134.1642244962477;
        Sat, 15 Jan 2022 03:09:22 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id z14sm5035055wrh.39.2022.01.15.03.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 03:09:22 -0800 (PST)
Date:   Sat, 15 Jan 2022 11:09:20 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/18] 5.4.172-rc1 review
Message-ID: <YeKrYJjt8R2Jp4Kn@debian>
References: <20220114081541.465841464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jan 14, 2022 at 09:16:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.172 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220106): 65 configs -> no new failure
arm (gcc version 11.2.1 20220106): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220106): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220106): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/625


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

