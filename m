Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEC92F2245
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbhAKVyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 16:54:34 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457E4C061786;
        Mon, 11 Jan 2021 13:53:54 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id j8so114941oon.3;
        Mon, 11 Jan 2021 13:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LuPKzMNbCuvt+8PSGg/mt75FDbdcukJ2g/cvMmJFvQI=;
        b=PG0z3oYozIZtXGxQiqSPR3muelF04JmpPodVK0BsSMLcC86k75JmIOMC02J0WDerDi
         bLMBKQgRHVq43GJBHDEILYnJJ8cK1QvYySgERtp/nHsBOkmNRhUohq3Bvz50/RDHnvso
         0X/8XhQKeexi6vft8F71b4+VpZAFL35MSHXv9lgzULpxgMzjNsieYDYJKOavPiajkrzy
         IXlvlESGzbwDI2qsAreYHkDJ10bbyxj7U3axEjaNDSrd/G4RbK7MJhRXcx0eyT8kQENi
         rhs1aHSUWmL4HetMWjsEmh5cOL2sxzzCTxspDtDPsAXgpZmVgcAcn8UtQroKq61XaH8O
         d95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LuPKzMNbCuvt+8PSGg/mt75FDbdcukJ2g/cvMmJFvQI=;
        b=q7Er6YSPoBK7tg+Vr0tLts+M/PfmI7Xlg0JHSCxAEn6vZ6mW/9WWmW95Mf6MzDpl8D
         Ik/9NkwMkSGK3aGA5Kb/WFlddmIb9UfKf4WNEfxkPk/gGxy4u5dLrhc9itzHGWP8c/fo
         7UOhnQN4MfgUVz4jge7gnZGzYRGsUY6XYG8OA4Z1oY7oNpsZMoVoGAUAA/F2aqzgh/kj
         OQ1JgWYZ2NEtJEBOOSJ/527sgVyY2FLWULA6KmNmVhHhuaytmAqITfdp9j5sZeC7cfj/
         xqtRkgtR7TICjwv+k3/NaJalrZAh1XsUb9peePQfl7L79UNDT8QgUl7yGEciBQE6TGot
         2z9g==
X-Gm-Message-State: AOAM530vUuRcEWRKnoSMIAxBNXcFWZ20a0nCwaLPPkov9wzQ/w2BVbbD
        m/8y6VWsEmDPnwUAgNaTkOmK1K49QNE=
X-Google-Smtp-Source: ABdhPJzHAlVXkjcR1oQdOGI3J1LpOHNnAsdqx+B3JUQFYOBR6vN+7mJG5B7uDutTRhpJPv2gaUBrxA==
X-Received: by 2002:a4a:a2c5:: with SMTP id r5mr835325ool.72.1610402033660;
        Mon, 11 Jan 2021 13:53:53 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i20sm21606otl.78.2021.01.11.13.53.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 13:53:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jan 2021 13:53:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/92] 5.4.89-rc1 review
Message-ID: <20210111215351.GE56906@roeck-us.net>
References: <20210111130039.165470698@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:01:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.89 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
