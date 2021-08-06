Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990483E2F8D
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhHFS63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbhHFS61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:58:27 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D28C0613CF;
        Fri,  6 Aug 2021 11:58:11 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id a12so7233377qtb.2;
        Fri, 06 Aug 2021 11:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bGRLwgA4WHV+Em0Ja4HBPgRnuV7VI5nJfhqXYPeBYcE=;
        b=J8HxjB1aUyuIbLuCyO8TwV+Y+YSwayXqrQNjSGE1MT4KiPgizHpUJAmuc5qWBQQ4bm
         NyhRQyPUeOtzEjdEmjyxjtbHJbjAkCIxk6ucCz/HpSuIbvs52+3tQoqjZN2x2XEir/eZ
         kDspBqu/Gb/HqtJSgRwLZ8QklWJFsxMwO4qFgROH1YFf+81F6Vy8GV7h/lIaiFJZUu88
         09mJiAha0FDJHz4mfulabxykUImA27MbIGS5SNHHxRKbG9PJ/5ElFtU0aKCAW6yrjHyY
         b8gt0sEthGGmK8tsAm3S4vUlRKze2K1xJ7oPfzkAttlLjM7ebZBxVoHXkyvscGcN9Yan
         kIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bGRLwgA4WHV+Em0Ja4HBPgRnuV7VI5nJfhqXYPeBYcE=;
        b=giQbBndk/5BaCzF+CX+mdLzAR9MQN7PvVw8l80jwnlh1yBgQflOpXg24iMAm8l1IWy
         N19Zcd8n9bgao+5TRGVeIGpCDN1JuX60vwZDfzeczeVuWvFugezCSFhzk9vn9lx/v5J7
         L/MVdfuZvc7WclbF2it5Zj2ALFf+KGrWsWX4uV3p3Nm5UIAe2Wd83GQZtG/Hk4/kQwPS
         OMRzKJHZertb2+c1a7payTHKXxyfjVfjgmSP42bd6g6yktuD0szL64rzAlOBkBeIVk1H
         OchKTB3s6/Ze+kHbe688fWpuEjXsLhSEjEFNqaHULM8gi/LybBT/NTBIS2UIc9lZzjUL
         G86g==
X-Gm-Message-State: AOAM530Fu/dYLQILn0sQRBExbpOivHhbhUqxWt1VEvJEfqYCYBAyzQ+l
        hl/e2OsW/t5nh8KZOL7jkqo=
X-Google-Smtp-Source: ABdhPJxiu4XfatAELGcWzGfsuqHRQhrTDvLzS5WTv27yGiqTU9DgCxUozrUU72j9zWFlaU3fn/vugQ==
X-Received: by 2002:ac8:58d3:: with SMTP id u19mr10481958qta.306.1628276290961;
        Fri, 06 Aug 2021 11:58:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y10sm3667676qta.16.2021.08.06.11.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:58:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:58:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/11] 4.14.243-rc1 review
Message-ID: <20210806185809.GC2680592@roeck-us.net>
References: <20210806081110.511221879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:14:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.243 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
