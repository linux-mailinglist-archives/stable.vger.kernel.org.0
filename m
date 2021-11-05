Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36644446586
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhKEPRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhKEPRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 11:17:01 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F1DC061714;
        Fri,  5 Nov 2021 08:14:21 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id q33-20020a056830442100b0055abeab1e9aso13505125otv.7;
        Fri, 05 Nov 2021 08:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rB8TivmnNFOO4crbKjDZngE5WARom4sg8haEEYtAyg=;
        b=Iw7pBtINQ8IX+bvmEFWslWdfq/zxDSDBKUqCXRUY8faUjFQHVFrxbANBMoRpP47Rcf
         xs9cg3fKB3YUJy/oYaSPXgcxvZBg81scXCQ5vTu9feCZNA3xPkNeDKpp9kMy09DVo3dd
         FBnzLUNDYKtcRnHn82Tpqoy1rckCIFUyHU+ECB3goOXRNSNaN890zXrY29GS92yv8tkZ
         lls80/XSmhTYOZUhVF3qrz0HZG5zxIk4n4aV6zXRcKDZv7Ll4/OBIbIGTnnkAxbxQnH/
         6KU65lvFkCDyLuFh9ByLFOsVXvqGU80LOtP6tSpeuj73JNMSPP2H+Idl9sVqslSN+M+M
         jYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1rB8TivmnNFOO4crbKjDZngE5WARom4sg8haEEYtAyg=;
        b=apRvFM0+xghXMskifo7nNG59zFcf8DSWdaGpmR1Gjmkk+Nvpkfhmm1D7olqgnwoQUi
         khKnye08IxiOeYvKL3zFYAi266Zu/TOnu/E3+udDzpWgB6+ulstvdlFFOZCbGfrh/0sL
         YgNXthp42tMwkvzeR5o9B2giJQBLKBydWJ/XsfkXwGgX0SAQwVmB3YwwtogbzW58DxtQ
         x52Ucrq0cVjD6cr6MEawgxHBAWjXFadJ4hvU6VPyRDJXc3qf85mFmvQh9ZnB18vhEMzY
         V6eXTyw1VrVclbSzjVZgdFqbwdXxKF7uUMELsJGmP0dcPR3bOkCTn4nqjQDb6XDbJq2P
         Uy7g==
X-Gm-Message-State: AOAM533v25E43z2wvjplb9uTI1b0pMqglywld/SyhiZlGCrBYTEB5krn
        WUmuzl8xG5xpvoI98CbfUFI=
X-Google-Smtp-Source: ABdhPJydY3F5wzkAEwXibfaPBVrEn8JXB+gXZYdrZb1JsV1AkZXlcLPSz1Z4yrGIDj5BjBOVrnN07Q==
X-Received: by 2002:a05:6830:91a:: with SMTP id v26mr29798519ott.313.1636125260707;
        Fri, 05 Nov 2021 08:14:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t18sm1021856ott.35.2021.11.05.08.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:14:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Nov 2021 08:14:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/7] 4.19.216-rc1 review
Message-ID: <20211105151418.GD4027848@roeck-us.net>
References: <20211104141158.037189396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104141158.037189396@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:13:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.216 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
