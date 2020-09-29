Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F2E27D951
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgI2Uyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgI2Uys (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:54:48 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5194AC061755;
        Tue, 29 Sep 2020 13:54:48 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id g96so5824591otb.12;
        Tue, 29 Sep 2020 13:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fHuOrzSQZffWlySFfQDETSzvj6Y1lkDHWPBd7NUZaFk=;
        b=l0pnQJv/HtPJm8RaEpMaeb4S39jz+dmjAnGZVtXGzCySWN9E5HhH87QbRC+rmsLtWG
         urJ02xCRBDrDWY76ZbTzK1kAMvMIpfeYCm0uTm9MrvPU8ruOqfidvyvHw5M58ZXAY/EV
         aed1wt/CefwkHuj4yZH6oulVTBw2qP2dbfX+yz49It1ZqKwqJFTv3FgBeRWR9RmY9lO1
         pq4bmTrSeHDZjq9G3SoniERSPzhDngklCzqXlnOZ5s+mjBaoVgJhLqMMmu4+xBI3ys3p
         QRO7pjtK3+qfNvLy5ciJuUCim6Dc+otuMerC+qQp2w2RJA502zQ8MPsFzHgUlzwujyeR
         qGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fHuOrzSQZffWlySFfQDETSzvj6Y1lkDHWPBd7NUZaFk=;
        b=dyQJpG1gxfqC5xFnC2K5GEcJ/FzrlBY/j3HfOQ0JviF+ipMZxgxtleAYPpzNpm7gnX
         qc2mdNBbDTJ0ftGCEVgBWVC0f8BS5Id48lXh5gdKU60TsRZPOlhGSYuPhPrkrlUsGS+r
         H8zcQ/vSACp/RbfxrRPT6F9TaZIPDWKLqTvhVxpwyyNhIinuDPFKKreUqkTgdbsL9tOJ
         sa+emUlgi1EvKj1kUG+88rQKLi1iCAb3mr1nEzmkKDfv5FkWeCFFnIHQ5zeJVRQWbtKk
         wph093xlWyKnewUh8N/0BxrmIBtB+Tc1CjPQczW3ozkOdAGVtPKgaUM8w2D5uKo4NLxA
         kF3Q==
X-Gm-Message-State: AOAM53208zo1jAzeAafhMq9VK1O8PiYPXM4d3JNj4cLU29iJbZvmG1tJ
        1mhzWXx/XUN4ES+kXM2t4oI=
X-Google-Smtp-Source: ABdhPJwNEkUFpR/QxpbcvUASGjzkCt/0otFRip1mb17c5iOdJrSywgOJZ3uAQ7ftwK3pgIZz0Y6LmA==
X-Received: by 2002:a05:6830:1d4f:: with SMTP id p15mr3804464oth.223.1601412887745;
        Tue, 29 Sep 2020 13:54:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a20sm3181568oos.13.2020.09.29.13.54.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 13:54:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Sep 2020 13:54:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
Message-ID: <20200929205446.GB153176@roeck-us.net>
References: <20200929105929.719230296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:00:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.13 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	powerpc:allmodconfig
Qemu test results:
	total: 430 pass: 430 fail: 0

powerpc link problem as usual. The fix has still not landed in mainline.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
