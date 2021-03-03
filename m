Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA732C83A
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377133AbhCDAfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387978AbhCCUJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:09:04 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836FEC06175F;
        Wed,  3 Mar 2021 12:08:23 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id l64so27379988oig.9;
        Wed, 03 Mar 2021 12:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yhAIh0E2AhJgo47aVCr1o+GqkAkBvkQcpLo/JXOL0V8=;
        b=Z+qCxmEWzXWYQ1lpJTcIcW+PTCF8rPgplY2B+Jrk1tTKfJY3m1Lw24AqDNwuDVZZK7
         ND41XK/hLkqw6bOzQXJwTwhC2xxn+wf3EbMZVfp3MraFLVEyQvo1GvidBNey+VmuDv2F
         64+xYDaTR6fwyyILcU1I3CIfvQvxje92Ip71RGoMiLxzF7wEKo7OP7kcmPXVDdj6Yryq
         SCs/YF3KASrGtkSchCoWByRRFs3RUv9oFImnsH7+rZ0/PiPBMbfOl0k57sXrpTy/Kjdr
         YBmagaxtUemuJBDWB5uyuY1a8X4qiricroM5LIOO0h44uZgp+gwu4+JjkIk1axHgxTm8
         T87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=yhAIh0E2AhJgo47aVCr1o+GqkAkBvkQcpLo/JXOL0V8=;
        b=FyurZhqILdFJkmk1fjfRZgpytEYVZvP+t/SOkrEg540KEpH76StnIDyUGYqv8rte0/
         F77T3K0WWIPzKZrCnW2btrU/7mYs8p97lp9uz741rw1occ1L4fi1YVngUl3bYZvaDYJ9
         /z2qHfegedSe/mvI0TcDs6xB6Qi0bnBhvLEQSK6KuzrOxaHJLFYpETIvA9XZxasH2mrZ
         5ssi7ceUXCx6GdPOE6xUx18av8PBQMFTYQQUPgOhXoe/GZekNHazrvMxDvmLca130TQW
         aI09FQ8DRWpLvFhx3WK1dGS9lI4HyO+oo1QrEoa4OmCZDeN/KL+LLZlr8rsmEaDJywf7
         nVoA==
X-Gm-Message-State: AOAM530XggMmH8ImqkBJpz1+krv0EXkk6iR3kND5alP3Q6mY9aGYD2ee
        ZO0/zALXWrt4/NmBlA9e82U=
X-Google-Smtp-Source: ABdhPJwVn0GHMdeHa91aYi2xTmkX/50DuAhrFum0MmKPDVOCi/6y+vL5T5fn+pSiXoc5cNCHHOPiWA==
X-Received: by 2002:aca:4dd3:: with SMTP id a202mr436313oib.13.1614802103032;
        Wed, 03 Mar 2021 12:08:23 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h17sm2456024otj.38.2021.03.03.12.08.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:08:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:08:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
Message-ID: <20210303200820.GF33580@roeck-us.net>
References: <20210302192700.399054668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192700.399054668@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:28:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 657 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
