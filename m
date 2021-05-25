Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265523903DF
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhEYO2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhEYO2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 10:28:01 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E915C061574;
        Tue, 25 May 2021 07:26:30 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id t206so16883239wmf.0;
        Tue, 25 May 2021 07:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epLKaHTVL/G/oEp3w4hmWyDYOH6fS3V0skMQYYC57zM=;
        b=ZJm7QiJucxLkaU0MkFh4syoJHoJa88wWLqVHEpxyninukg4EzZ0yqd4kl3Y18hs1Kd
         GhsMVBmcU5YDf0wr55e6gsPJl6GXpll5/3U+RlxGXmbRc8t3ssCwBDyu9RVa5xSJStnd
         x5dyrUgFL7GGBMq4GmztB/GhQoslqML1iZu0TBBXmnKlOUf8tMx2sUYNonuNd8XKCtym
         7cAaTQ+mPVnygAAMliH0suBxnsCzbQ9DwyHaMJ4R56741eP90yulLpWKdr6HQluPwljB
         jIgb7rIttKkL98RqjOOZuF7DPJRyVNh5nye3W0BZyS2IIa0MH1Cxxxj09zNoE1eXrAQW
         q0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=epLKaHTVL/G/oEp3w4hmWyDYOH6fS3V0skMQYYC57zM=;
        b=l2wUGw0x0T78DZ4EJWsqCjyB90tUsikQUW9hiLYWWOEvnVaKMH3PuzFsjfsAGnGHzN
         nWVJFR/H6OpcbC+gSER63CpGAbW1nnGRiNccPVJ7c2cklFbRY7HQNId3kg5DbuFSTmYo
         gpKJvvqDKP4ZFxixCsO9ye46qvX9Tj6oCRo/dFxt6aZJo+OHUc9RZZlYEYSCY/XI76sK
         f0QhcWOjKndwc9xzQgJ5NQcWI0q44AhLyeLxhDl2rcRFzGPdmSsw311MRp/+114Zvy3j
         XnhxA0ktyxOGIyjwkI1izOitaX7RCVq855iENga4XWwtVmV46fiWHRMzU5BnPIK2O+hH
         LRag==
X-Gm-Message-State: AOAM530XSVy7mbpwYgbf5C51/8jJ7HRC4KiicDm0ED55KSEb1sb0ju6m
        MeXSEVny2bM8SZwAFSPK2Ds=
X-Google-Smtp-Source: ABdhPJwknDwwydxk1KPREsDqwORF0i/m1F9UfMpuntaHYHLLs8a1GXlULUysA7WbZyNa1sH+wtvR0A==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr4104135wmi.162.1621952788843;
        Tue, 25 May 2021 07:26:28 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id a16sm15777472wrw.62.2021.05.25.07.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:26:28 -0700 (PDT)
Date:   Tue, 25 May 2021 15:26:26 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/104] 5.10.40-rc1 review
Message-ID: <YK0JEhMq8rkv+LDG@debian>
References: <20210524152332.844251980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 24, 2021 at 05:24:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b(4GB). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
