Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7863B117D
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 03:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFWCBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 22:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFWCBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 22:01:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCB2C061756
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 18:58:58 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2772467pjx.1
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 18:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P5PtrKC9BdXykLLTnlC43FIWRW0aAh6zQskb0Bi37+o=;
        b=MwiYZPgOvt//Exx/SzMRAT93UC6GNbfsWOIwmy2iSYuOdjFaQTl1MUo5O6tXWLVa5W
         C35lr5mEZHzWkGDyQLC4PWJzmldEC1uC5yzR09jZMxzAJh6AyKaR/pk2+C1fKSzgiUdL
         QzFEm1gMtOj3DPTjbxAS4gb0TRtypIgZavZl8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P5PtrKC9BdXykLLTnlC43FIWRW0aAh6zQskb0Bi37+o=;
        b=pyFsoDiA0XKYG70xlnbK1i8BbZpN0nY1g+6n6zbsS/ViohRlnm9ZErOFhRWOTiKuw9
         DuagTFqBPrkWOO/JEwCZsehrGpNMMp4BcweBYiDAPithGFw0bmVI8lYfLDO/NcNQVqjS
         D0heoITLLO+73B+Yq3JUHvLPCq0HM9mClld1Te5PPuLGbymNxYyjyKobVyJjqenwc5Ga
         vCRuG+FYyt6/7Ptl+tAEIntclKagEHsQIKWG26sTeIzbK7JClCtBH+ANuurDnm802W9x
         nZJqVm7MpsTg8kg4JY/18dHRKJydgHYcRhQXJZ0Mb8OsvtPRRqsqxmSHvkXfpSeoq4/k
         xpKw==
X-Gm-Message-State: AOAM532k4Yyv4xajPjvs3tw7wAst5tlmDY8A8biU4AMKLibwVFBahV4k
        eYYkBQ/YLUIpVMX2Yvxn2/+f9Cn+4n2C/zl54y0=
X-Google-Smtp-Source: ABdhPJxlmlfbS0hvcRkA20u7GDWoT7mCvv2+/4iOghHL/y8nzewuL6/UlJShiqjH2AyxX8SaihTx5A==
X-Received: by 2002:a17:902:b095:b029:118:cfad:c536 with SMTP id p21-20020a170902b095b0290118cfadc536mr25304861plr.79.1624413538355;
        Tue, 22 Jun 2021 18:58:58 -0700 (PDT)
Received: from c8bead504505 ([124.170.38.181])
        by smtp.gmail.com with ESMTPSA id h24sm3429379pjv.27.2021.06.22.18.58.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jun 2021 18:58:57 -0700 (PDT)
Date:   Wed, 23 Jun 2021 01:58:51 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/178] 5.12.13-rc1 review
Message-ID: <20210623015847.GA757183@c8bead504505>
References: <20210621154921.212599475@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:13:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.

Tested ok on:
- Intel NUC11 x86_64 (Tiger Lake - TGL)
- Radxa ROCK Pi N10 arm64 (rk3399pro)

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
