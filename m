Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85F44DF75
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 01:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhKLBBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhKLBBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:01:46 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A6FC061766;
        Thu, 11 Nov 2021 16:58:56 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id h12-20020a056830034c00b0055c8458126fso11566739ote.0;
        Thu, 11 Nov 2021 16:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=In344CXDd52/Nt4JUYbIPiNjUuVZkS0uWFZNnCSN9Zs=;
        b=WuILXmlTJaXb892KONi6u3279I1KY0RzJttfOYS6qI7FmPggyelrT5SjYPQAxe+xA5
         LUcD5+e+zCs6GxWnSRMS1kdCKrYO3B9vpB2yFZ1bQq4d1UlczWKe857qWu+KA2DEDFYR
         t2R6oXOZa1R/lZEHPjfPM+DkfOa6b5JWLShEVPYyRua6G6NzTi4gShf5rpVHkierdpRW
         TrrnAi/ROSc0vSjqSqV7zOBWUx/Rt+DHZyVeRT8TB2htuDMyfiS/5xX0Rg/ZuCQaO/y/
         cHM0n3p9QLOvb7dR33avKDNckHtU3B4pQ0Bt+KwRs/VKE548+tUTQ7l4q656wsHHZ5YZ
         iz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=In344CXDd52/Nt4JUYbIPiNjUuVZkS0uWFZNnCSN9Zs=;
        b=wZp/xqt8gz+yez8yT1ajnEmoxUmFrlspt0TtsIytejdDnZTAMFGZ/Ho39ex5P53HWn
         tiGp41Bigx6FtZYNkwks76loXQcBnZ71TVgvWHNoYym7YFEo5XbdhM3Y1ivIFl0QPglQ
         9deKeeI/blRyP+fOI4cziBQ64h3G6vS1YpmnMg0rMLRnEClFptwCftk1l28iVfGv4W0V
         pjjpl1LRQ/ZyZTiYAL8o7VHgS0yDC6DXgbXXb047irZmusce/9u34RhFcWdIE5SNEjFF
         HF68LCxHtJGBlep4Yb2P+zUjZX+8ScAiDhxqLHk6BbvLnlawgnuNTR1d/w9ssefaYE6j
         OQ5Q==
X-Gm-Message-State: AOAM530Xs3xDGTWT9fwmVwjfhSGMiMTNp0n6qxDNS90jE/z1VbN3DCbN
        XnjRFDjwRFaCMVP6OtNuEwQ=
X-Google-Smtp-Source: ABdhPJx1wewErYzLQ1CjxBJdxuygGyyoabeu72Wu4jfan9LCG8KIBetxbDYfT3VrhnOefuFIS499/w==
X-Received: by 2002:a05:6830:22f1:: with SMTP id t17mr9139974otc.39.1636678735922;
        Thu, 11 Nov 2021 16:58:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm523210oik.11.2021.11.11.16.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:58:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 16:58:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/16] 4.19.217-rc1 review
Message-ID: <20211112005854.GD2453414@roeck-us.net>
References: <20211110182001.994215976@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.217 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
