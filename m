Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95146483BF9
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 07:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiADG2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 01:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiADG2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 01:28:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE43C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 22:28:19 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n16so26442195plc.2
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 22:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=socrBGQfucWKW3aEhPqrm5BfPK116xS5lGaBWDAFhJk=;
        b=iV43JRn7OQ+HSMOXEYqL9n5OJhryxOqawWNv9jrQ6wM5l9g4CunIYJGJVEvhKV3WCD
         XBH2N62lJBTk4bnwB9HjEjJLstmsZAGrnIpcbubqpYqvE6+9OuCnkh4Un9KoTw2m23oA
         itVCSWJEP3alK4LVxVcPj2e0dHXCSqGUPIFJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=socrBGQfucWKW3aEhPqrm5BfPK116xS5lGaBWDAFhJk=;
        b=vXo/P7P9PHkvmjtitust7TSsqUy1uoK7BIXV7UeFODOcHduKOzkeJNjP8GASSFr24J
         5O9vdmaYklZa0yob5wm8mJqiJa9cifOkWS6c+nFDnyX/icTRMV0j9q73jFvo2m1ZS2y3
         PqFdw853lZQM3ACwx1C0hyxS/nMACWCPNcFbfVAl/LGSIrrkCPUqltuKD8iBb82Vev3Y
         FCLKuP0kQ4YjMS3NTZLHVAw5VOZRzBtxv6aEFylfIQwF3a+6r8Tn4xnGZlFXBMeyJAzy
         XLHpHD9aveNktis+cCgnoZtmwY3JMM6dm3uNhLE7o8PqvPY+p+IC2mfakwf6TIp0uSz3
         PfAA==
X-Gm-Message-State: AOAM530aExvYyeH4JPVYJa73qwC54GxvUMR+lWqE7BBVjnLQUKO+ls58
        +e61KdsI+8Kd1N4s1C5gn1yXvQ==
X-Google-Smtp-Source: ABdhPJwgYMB9hhMvtj/o7ktnWoeTkYMWDf+dW9lNaqqPXM4+EE3Lcyj8QekwxGjNw4OCH6iZE9wNDQ==
X-Received: by 2002:a17:90b:4f4a:: with SMTP id pj10mr58544723pjb.112.1641277698600;
        Mon, 03 Jan 2022 22:28:18 -0800 (PST)
Received: from 12c50cb15705 ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id h191sm34541436pge.55.2022.01.03.22.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:28:18 -0800 (PST)
Date:   Tue, 4 Jan 2022 06:28:09 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/73] 5.15.13-rc1 review
Message-ID: <20220104062809.GA2057326@12c50cb15705>
References: <20220103142056.911344037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:23:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.

Hi Greg,

Looking good.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition: build tested on:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
