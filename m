Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E9D32FBFF
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCFQkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhCFQj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:39:59 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5B8C06174A;
        Sat,  6 Mar 2021 08:39:58 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id e17so1206862oow.4;
        Sat, 06 Mar 2021 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I7ENwVzIJXHokjZNW5L3BhtoVd/XNyuaNZGQ0PONZYU=;
        b=Hz4PU5KO+f2Inotf7hwjZ6UA7O4F3YUHNs9hzGCJPxkHoapSOtskviByoq5QQhcC6r
         +xRdGTpDz4OcN7FSx3Mi+DrMaa4MOhNcyvUcQRdJ2Zw6Kidacz4Zn4uWdubIIwpSHrvZ
         XpbBorxZceTxvxkA2IdoORq9/6UajJmy4rHM/hL+x2hKmBkNZJOjlj4Jck+XWscAkfD3
         V6mwAZSW2uMru1NSq4XH0R+oUtWOGR2QaBYCzVa+zhPzIUDltnI8m4NSdmiTy3W1jqYq
         rVxkMOIZ2+li01om3gZVj/qn8UjNLT3le1uE4tJUx0z/iRI7tc94al9GB4gImLW6KsNc
         cP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=I7ENwVzIJXHokjZNW5L3BhtoVd/XNyuaNZGQ0PONZYU=;
        b=UPE0wTIsuI66LdsYQNp9RF9I5QCL7MJPHrCGbJ639GFnDLp/UupXq5fP0d43YN6olw
         IS0xbryi2Qxzv+qWrlbQFn13FInhFC+xQii/6OdLFaJ9mTTMy7PS67XuYDB4x3Mv85A7
         d2rc0EQdZ8db/fdUFe+rdcKLb8BmFPwHraDanPUY/F0EO8guERNWbZIbpxXEFvTMokGW
         RLJ7YoU9HILqAdrZ4ZfKxjrxC/GdYA9mlRDV8F3VhapIMbTp4cjKoBprObzaiq0JKIeq
         PA3IK9Om+51cN2NwSWZRHbWHkoxxyqSceMvlLZ7qOS2XLDJeY6NO7IEm5MOjttlVwc9C
         PxPw==
X-Gm-Message-State: AOAM530KB8KgcC9qZrmXUeC+C03q9Xbro2ldUEBIyBTho72Nfx8H3FrH
        PV5FpgQu9weBIGo3eEqHG6M=
X-Google-Smtp-Source: ABdhPJwBYzxG6b/TgooGw1xTFo0OnZE4ckLzUZyy5lk9iR+uJ0kJpIDevCtNwYAUZAtpsP9GawlLRA==
X-Received: by 2002:a4a:d05:: with SMTP id 5mr8859914oob.10.1615048798271;
        Sat, 06 Mar 2021 08:39:58 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l25sm1284404oic.49.2021.03.06.08.39.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:39:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:39:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/104] 5.11.4-rc1 review
Message-ID: <20210306163956.GA26313@roeck-us.net>
References: <20210305120903.166929741@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:20:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.4 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
