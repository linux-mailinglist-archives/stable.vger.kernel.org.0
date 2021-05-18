Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A56538820E
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352485AbhERVVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352453AbhERVVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 17:21:20 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD03C061573;
        Tue, 18 May 2021 14:20:02 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id f8so8642428qth.6;
        Tue, 18 May 2021 14:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=maWG1YzxabcJTPdnwsh9sjHOYefiWssfILELVm4VhrA=;
        b=XQK0nER2Uc9JXClSTYo/0G9uYXn8pgljfMp2mInBiSesIoK8GPsIub4M3tR4t+KNK4
         CBCJeLDBccepgaqzxXHZ8TqSwR+q5aC2XUk+z3sS5Klk2ZXZ6J3j/QEV67VR9Z5M5Acd
         4wXT9wexk+QCO71qZgp+dbAocQUybxns+DoCljsWVLP/N5Lz9IUDKCgv3jVVYd8ARI8u
         3I/wIUNpLIDpmF2IMpTwA8tfk1e5OCOWnvVHtpu2CAhyjbWtE5vyl9F5YxhKTQ90KiiV
         lT3iS2wLp8/K2JBo9+SPZQk+NyP8nM3Q0G4JT5VGYOJIH1Yue2YVaeLjCSFVSfjaSAS9
         P6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=maWG1YzxabcJTPdnwsh9sjHOYefiWssfILELVm4VhrA=;
        b=eqb4bESXIAhf7tQgQvdfc8t+Dk5SgX/QBHjuAh+hu1KyrjLoKOlqeVGgJt6KUYA7jF
         8gO24AFfCnMKYPe6nhiJp7UhPgVMfq2sKrb4XDR7P1pdJEbWczJ5j5stWbpHJ+LHEDZi
         Ucyp4LI0qVMVEVvG8dJAbaMkYakeBzNldDIEFLYmeZpfnNYGwXCRfJD/ELHJYM4chMAU
         y0CgKlRmQId0iGjkvRXdDts6wPoe7+U11e01a0kW4l3nObtDBU4gSJ0Kb7bwA6oZVyBQ
         QQhWYBwXtIe5zEJFD05dP+MZXwyhNz+Z2BOnJ6GwdJUWPI4ja/ijVd9t28vdojWLgYd7
         oLZQ==
X-Gm-Message-State: AOAM531CxKJBFd5G9AGO9OLbAIASxyMGRkh/q3adJhy+sBw1Y10BFAej
        KMBZuBdTGTgVtoMm3VDc9FHqDhCzClI=
X-Google-Smtp-Source: ABdhPJwIMqEwjAftYfAuXSInypGCoqVJfho0Y+8bLY1bCpQVKhiHpCqX2DTxAtPdRJChR+wFzqRJ/Q==
X-Received: by 2002:ac8:67d1:: with SMTP id r17mr7029987qtp.242.1621372801387;
        Tue, 18 May 2021 14:20:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 7sm15632106qtu.38.2021.05.18.14.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 14:20:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 May 2021 14:19:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc2 review
Message-ID: <20210518211959.GC3533378@roeck-us.net>
References: <20210518135831.445321364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518135831.445321364@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 03:59:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 May 2021 13:57:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
