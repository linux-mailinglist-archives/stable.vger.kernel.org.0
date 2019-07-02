Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA45E5DAC9
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGCB1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:27:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39608 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfGCB1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 21:27:22 -0400
Received: by mail-io1-f67.google.com with SMTP id r185so890971iod.6;
        Tue, 02 Jul 2019 18:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pAci9weqdgGIQBmNcdVFp+Cps1SlEdfna2ZTHfidk4s=;
        b=fQfg7pH4Sm1UfYaKtwjCqwOkANJcgpsdEef2Jc0Vnnv6CrjpMAqzINySn3ZsFImMKe
         T9CzN3e5xprsAsfUp9wzNfa6hrMmvfV5YFwjeMWrH/vZk0utjNGZ8LVwTmXfeM9s9KFV
         awuVWqFOYH9/vubLgxVHa2piApnGDYbSDwJ6J7YeeFCFW3SKAncrOnHeLd9z2Wl9MqGa
         vYzUbqeKYE9A+StWlIjF/TL1UnP8TxtHX9INiHIvdM9c7+3nxH/w3lVUaDUGUUHcBeAg
         wQ7DR+mRbupzYT/9aVthIW/NyhKsrdBh2+E8yhR3mnP0eUY42G3EQsFo2aplRTLF+lnD
         ib6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pAci9weqdgGIQBmNcdVFp+Cps1SlEdfna2ZTHfidk4s=;
        b=g2sp6uBmTkVx+HwuUTg/MIhzzCI0F9Cd5arg19pYz0sECNrt3xt6TDO7mEbXYrl8Sd
         krqlghpUlBj7JCrkuQ42cThpJ7WZusAVRdKqwP60R+lJizCaJhsdHzuxUJioan977hWr
         3HaWARyJWmRTQzdyv5HWTPmtXORlYlv+R6vLG7mpDGpHdproc+J2FxsdUIi8MqIBgFyP
         ZZGrSYzqWaBfZ9gbkMP/AeO/BGGRzrfhI/vIOiLLoqgZJZsJqHrXMboukLF/dG1WIMHM
         NAyoHnp7ELu8YTk60iRWQdRJhONmP+YX5FRmtuPjinZmzter83LSLp5ev47ig6gvC9DE
         iXdA==
X-Gm-Message-State: APjAAAXMqEkU/ZMNViDCYVmkZ5rN459Dhv37wPrjUhyIro7aCLD8iyFh
        aXoukf4jrlVXOSR6hfAjTk0s+36gKDeNjg==
X-Google-Smtp-Source: APXvYqyVaw65phiu70giHYXUIs2ipt+3VtM+wJ6S/zZrZsx+FDh/mt+BJBdInlTIJpHWmlAYGh9HEw==
X-Received: by 2002:a6b:7602:: with SMTP id g2mr1878572iom.82.1562101796619;
        Tue, 02 Jul 2019 14:09:56 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id f17sm114199ioc.2.2019.07.02.14.09.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 14:09:55 -0700 (PDT)
Date:   Tue, 2 Jul 2019 15:09:54 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
Message-ID: <20190702210953.GB2368@JATN>
References: <20190702080124.103022729@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.16 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled, booted, and no regressions on my system.

Cheers,
Kelsey

