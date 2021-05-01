Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1037075B
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhEANPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 09:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhEANPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 09:15:06 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657B7C06174A;
        Sat,  1 May 2021 06:14:15 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so235599oop.12;
        Sat, 01 May 2021 06:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QsAGeZ3NYYxmbbhCWDwFUkF6pXOIBIqdRAQPW2b/PHQ=;
        b=IwC4IHm7Q2BGuDmQ60rd8hmY9Z6LjldeqZheKP1pN3HoSpuG15mKVJBBUydfS0bxc3
         L9dMe6JOKsChPKuC/cU5T/KjL6jrolWgH2x3p1Yc5iFTgedezmfkmzElgXvXhygDue5B
         xoiNp6n0wdilwzTC3ILQNEyZr73cyaoH9mTVZpvvYpKf9f2huwGm5INMHN+x+KnJmAFS
         GJkOgfTZdiJJCcWDT7AMrK36MICBQgmEarfFSp7+QGpbt1WOOvB+zKJJDY04JqOkeXg5
         MP/9afyr8XATsnZWvmklzYFakzzQxJBiPCBCTcXzqiV43vzCHm7rKfElSCHPnwuLNQTo
         FOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QsAGeZ3NYYxmbbhCWDwFUkF6pXOIBIqdRAQPW2b/PHQ=;
        b=YIe36tO4Jd7VonelOs8xhQa3Xa4WbB2brxQivWVcmhZFibVe7Oaf2Bx2JJxdneiT+9
         Sn1rKHrbzUKQW8f5+etc2DRq6kgHF0YnaR2TqtcdTMSV5lTwEfRLhMN9X9ma32Aq6FeX
         j+EdcT2O9UQvSJzSYnlEbpRWt1vhYxj10zTTUmv4nFIYMt7RRN8lpzArukgePwj46pSU
         ubJKltN+v347/0IZxhe0fGV9aRypnepIhvdAIESaKJvviMrJeWuCBdRbfw/WZfZLnCnU
         rdoEkS7oE6jORpwZW+zRL6gl/yPExXYEArcqeDDJcESOuU0ytvIo5kdtkeG46hj8I9+O
         21OA==
X-Gm-Message-State: AOAM531de0RnfaZx60QsBxX+kVMF7AhRs+mffzG2K98lsIidSzmPoiF/
        7W2k8+1eZl211zkoUGLwZQw=
X-Google-Smtp-Source: ABdhPJzauBEEzLvA7koSZlcslywGxlU97WqeLPh2sNFYs1tTup1gDvDmh2FrKpbJb+EUBSdIt0PyVg==
X-Received: by 2002:a05:6820:455:: with SMTP id p21mr8445245oou.56.1619874854853;
        Sat, 01 May 2021 06:14:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 3sm1478557ood.46.2021.05.01.06.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 06:14:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 1 May 2021 06:14:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 0/3] 5.11.18-rc1 review
Message-ID: <20210501131413.GC1774517@roeck-us.net>
References: <20210430141910.693887691@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 04:20:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.18 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
