Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C7827D945
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgI2Uxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgI2Uxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:53:38 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EFCC061755;
        Tue, 29 Sep 2020 13:53:38 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id o8so5872570otl.4;
        Tue, 29 Sep 2020 13:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lQOys/l17TDlA8UPD6f6bsAx6Xc8yNRWLzmHZbu6Uxc=;
        b=aRpSbl/Px6OV+m7O0NiA3sTmChYcZiXHEUg/kBjSsi+VL3hAVK04SgEbU8LXLPuB78
         pyHVNg4fxDVzrgFJo7GFQjUmtevMTsz92Zfh6WiyMQg0bLDUb7YoYWYfTcaI5Z0jmlu4
         C+IWThFF2zrKN+HWRmKJcDJiacB57WJSwvomfVQYplmIEXhNbFaj5pFuuv542aQH7Yn9
         7j30zA6OGgrEotJguerfIHhPr3MfQjYG+TbXXa4NXBHWZDm4CkU1io69bQqBtCe0XL6D
         CFuTPUGmCOEUlI8DKDnMETXJfckbzeHPshtIlGNl5T5QzykALIk/4RusffyamVeo3mYz
         sYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lQOys/l17TDlA8UPD6f6bsAx6Xc8yNRWLzmHZbu6Uxc=;
        b=sbN8hunHgyavG22afr0yYtJ8fNLSt0o99mrbnrj8NvZYvRE9K4Lp8CMzkAmtpaR/pI
         sZ5/7kBpN6h3H2rxeMW15F5kCsuWp43AxaK5yxz21ifw6fJoW23enFzZ/oqr8ziG5n80
         xRjUfCdUxuA0khuw5TVUh6Ft+ULSR5kMQp1wjBkyLsgduPXDV3nRoZAuGu+TcRH1dxci
         UQh++QvrGfotCwHs8ICgT38xgZ1rXNMh9SU+XfoS5B0TOivAN8wNvc21G4s8ehp4InCd
         c9Tbv5mWWot1AMDMq9Z/ykf5kTpemK0ItKqjrzKincbyPC0Prmd2AyTm/tWxaapKOzqV
         GgAw==
X-Gm-Message-State: AOAM531PTzzpGuAdvILFO0Zx3sBLjp4QrQ8tuCbSyiB97oDw01VSe7SB
        BHZA7Ur018sUFig789V6vFq98MIpL4Y=
X-Google-Smtp-Source: ABdhPJylD5VFp4+ZB6yHbn1uqzRNGu73XYnktPn2wElas9+vjhONbgYL9+/yOxCNZ8yilH7y+FzJTg==
X-Received: by 2002:a9d:6c4d:: with SMTP id g13mr3858783otq.367.1601412817678;
        Tue, 29 Sep 2020 13:53:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12sm1274075otq.8.2020.09.29.13.53.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 13:53:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Sep 2020 13:53:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/388] 5.4.69-rc1 review
Message-ID: <20200929205335.GA153176@roeck-us.net>
References: <20200929110010.467764689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 12:55:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.69 release.
> There are 388 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
