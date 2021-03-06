Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E00132FBEC
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCFQa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhCFQaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:30:05 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBB9C06174A;
        Sat,  6 Mar 2021 08:30:05 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id a17so4965562oto.5;
        Sat, 06 Mar 2021 08:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u4s15T5UHlnh/87GH0EBg155WbiHdNkym7IZpW5fqlk=;
        b=T382xVeJqXPF8CvlJ7Din3P6XT0bC0vARgEOPRMccUHre58JBtVZrgQPqbOV/vTJt3
         YfYhMTDsYft1NKjZS818oTwVTMmeVZWyM8n3Ekjbr2j68zUaJ7vfnHVJaqS9UXkilEnN
         HOhvc+a7KpMOXBtm890f5MHo1oJ5K/ktV4C69f55qtOJNRPvlW+bOI6fnzfmOleXoYUg
         VvMP5JWXTGbwWjf7jul92EbyOHn70M/wioBJRykEkUe5gB/a+gtxVmiXYWxxNBen9Km2
         SDPRp88cJ0hOEMn9EaC7LVaHQt8F88wB4yCb4SkHktXoQBod92SsLuri6rA/VT1rLAlE
         /uKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=u4s15T5UHlnh/87GH0EBg155WbiHdNkym7IZpW5fqlk=;
        b=KwpdL5uzhX4Qa7lLJH+Io03I7+YZgjgJnvYWa9DwBMks0d7rVp2p/s2kcB/xCaaNV0
         SSU8NRqh5kADoviVkKxwnEVJOsTJY54t5kogMJFt1ZCK8DC1MZdKyqFY+MEsFmoSBfFt
         cXpQ/tP/eNWvVvYh3Dzrc1Fh4vS6mNI7cD+BkGvD4QX/5cirovnFJaVHX2yurvoQqHja
         WLF0Kj84r5aceKo+fEzgmwWvdSfh3WXnM8TZ+0ns7WBsqSAaPeR7dCZPZ8PqW6C5f2zk
         l0RcvbWp8ZTcKHX2muitRa/GoICDqC/hRZUvD56geITdZ9AdBTvdGdiQBliUHwNkeaGV
         vWJQ==
X-Gm-Message-State: AOAM532Sl1atOs9blp5yQ89wIAi3i72yb2/y4SK4kZHI6ckpqfMB3fqW
        D2C71vrJ0wTaryUlaBVvphQ=
X-Google-Smtp-Source: ABdhPJwYFYftwoENs5pxAAq7YQ09tNDfRpyYyifXFYrc8YncCjhawljqyguwtH3IaWjz3DVoHZpIGA==
X-Received: by 2002:a9d:823:: with SMTP id 32mr12199967oty.306.1615048204962;
        Sat, 06 Mar 2021 08:30:04 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u24sm1465431otq.51.2021.03.06.08.30.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:30:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:30:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/39] 4.14.224-rc1 review
Message-ID: <20210306163003.GC25820@roeck-us.net>
References: <20210305120851.751937389@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:21:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.224 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
