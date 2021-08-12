Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473BA3E9EDC
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhHLGvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 02:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhHLGvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 02:51:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FCFC061765;
        Wed, 11 Aug 2021 23:50:59 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa17so7827999pjb.1;
        Wed, 11 Aug 2021 23:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2LuKa5ZvLNNIZbNDJsXQL3xIdp2yQbpsWGoZqtzxgLE=;
        b=Xh5q71b7mkunOXGbpX7kWpjz5IuoadAdHMYALuGlMpaFzGQ86LKt74nmjW6lJ0oowS
         I8CW8Amhy5kHRZ+ihao/h8hl7AiTIticDYO2iPFHnH0HBtrsHBuFLFiAGqY5xp8zRT7z
         6fgP3wHwcxyVP/edgdQP7AT+NXlDPHHKj6/9THkZsGzsJRTHqoMXOizCWgdgUlLfXwYA
         4+95lHi/k/V30MJvo8vaoYAMQo7qUcqztJG023b8iCTePckF6/zeZU25pzcDxFqHqCc0
         hXEzRYEsrgrGjHqGfdPQ2zoX7+0Bq8kHIFqOZqAN5+0jjcR/UaIRUTnQluSWp24AwydD
         GJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2LuKa5ZvLNNIZbNDJsXQL3xIdp2yQbpsWGoZqtzxgLE=;
        b=qbE4TY6uEKR9oOUE80EmqFmTkxlbmDCAcXhfcAYxi3UgbUTCfxIssvrgD4rpG2cP4P
         cC2SVOqgSWYzMTk1PHgKEQ66I11U5jSMtB5PIAYSjibdRLlYkyaP7ORAthPh+pGlJHiJ
         UU4jnOQMzxlVEHHTpCia064TrFzlydOSDHjnaagTgc9vvyvanqRnKzjcQzJdsyeZYQu6
         BN3XiuCdx/xE1cRJfIke4YFISbdQpxh/KJkkdT6hEojFSlKFOsIugnNx2wXYMfSSu7rg
         BPLT9f5zMJ+ZXDdzvP090bha7itjay+a2/E0Ra6hyFMXo0y2KwNDUMHUgL0Yj7V65k+v
         bkPA==
X-Gm-Message-State: AOAM530UOvwwBwCBc6GQIQorIxOblmplvZFGDO1dYfS8YLHiR9wo2qDU
        isM8Eflq0r69ceO+zAkaUaA=
X-Google-Smtp-Source: ABdhPJxhZt3qKZ/ZXQepFxFpvGli5qIzl7wLBEz3lgEGORKMEvzJ6Rztv5uztP+np+TRbH5JNXxsFw==
X-Received: by 2002:a17:90a:d3cc:: with SMTP id d12mr2770507pjw.151.1628751059147;
        Wed, 11 Aug 2021 23:50:59 -0700 (PDT)
Received: from localhost ([49.207.137.16])
        by smtp.gmail.com with ESMTPSA id n23sm1997418pgv.76.2021.08.11.23.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 23:50:58 -0700 (PDT)
Date:   Thu, 12 Aug 2021 12:20:56 +0530
From:   Aakash Hemadri <aakashhemadri123@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.58-rc1 review
Message-ID: <20210812065056.niviykfmwc3yk23p@xps.yggdrasil>
References: <20210810172955.660225700@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/08/10 07:28PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.

Compiled, booted and tested with no regressions

Tested-by: Aakash Hemadri <aakashhemadri123@gmail.com>
