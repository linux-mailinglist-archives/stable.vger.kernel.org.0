Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1263F7D19
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242583AbhHYUZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhHYUZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:25:44 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA14C061757;
        Wed, 25 Aug 2021 13:24:57 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id s21-20020a4ae495000000b0028e499b5921so174611oov.12;
        Wed, 25 Aug 2021 13:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zmYRpTiq+cfs/fTz8rjeCTtOyMoiKW3DFS0XXXOZzyM=;
        b=X+dJ8QzSkw9WAoQ5RmrksyYJB5Ug4KfIyMNjKDIkHleTf+HecQyyG4ccg+WHLaf0hr
         2obaXBHZECijM1EbZe3RrK50l+W9TCN4pt0mw1gJMmES4kQHL1g7uga563mZC+CgxjWC
         16U6vb2eRIRM012uLOl6yRwDjLwJpqZG3vAeGRl6D1+ewES+uRU31bx3zgeWXWHohDki
         73IdI0PS7K9LiwJrIQp+u4/cxz5sP4jTQe8YEuXfxVpCwroeA2xdp46nmsQYzluN2kaM
         +ZmDT1KAvcSEmL8KDmEC9VrcH9Bc585XkAyVUB1q/kO/uHXLWi67ygnv3OaHcG+PFUHh
         b+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zmYRpTiq+cfs/fTz8rjeCTtOyMoiKW3DFS0XXXOZzyM=;
        b=ewBe13+e0iMB7Yg9vb87K30L79Sm73Ocu2VaqvoHgF2E9NVXYUZMIAqF0KixSPUA0t
         JaxkZ/0q36e3RHB9GgPFEY8l3uoB6VnKpgEI40S8iyG+m6K286qFSO1BPpe87CObbB3Y
         DzOlqzEG/2xBKe911F3PWKRyYIG8bFV/ICIaN63qTGWVBHmmjQIptpzVM2lG0yGoBWUF
         EJmJRQK52mzJ/eJ7H/b+blIiBVPjDIE/IEsur1M7978LpmNYkzxNz+vh9pjxKEwp15kl
         eoQAbkMBkotFYkqc2HUBYqemrAt4iOzmV3SKlV4t+6gJvn4ZcDOmbJAHq9wEeuKfZyri
         mwMA==
X-Gm-Message-State: AOAM530CBSXmhd9/b4iYc/q6lKBTCRInt6Hyv+v9H07Z3Z+nftbJmX+Q
        RtPY97CyOd1XdDJZeTSdO1s=
X-Google-Smtp-Source: ABdhPJxm3qKlzQyypkQTliXVxlJ4YZrH+9jGcfO/E2UUkXa8U466sheh/ocelOHnwUgrhMkQYi+c3g==
X-Received: by 2002:a4a:8d41:: with SMTP id x1mr155994ook.46.1629923096737;
        Wed, 25 Aug 2021 13:24:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23sm166367otp.44.2021.08.25.13.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:24:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:24:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
Message-ID: <20210825202455.GB432917@roeck-us.net>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 12:57:30PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.61 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 04:58:25 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 471 pass: 471 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
