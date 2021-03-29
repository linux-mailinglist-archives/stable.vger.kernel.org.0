Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC67C34D9A6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhC2VfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhC2Ver (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:34:47 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5538C061574;
        Mon, 29 Mar 2021 14:34:47 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id d12so14435177oiw.12;
        Mon, 29 Mar 2021 14:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w1JglHwOh+BlGZEYs0OCIE6e9RMRuh8C6cU2uj1U3V0=;
        b=GJofKS6ZiD5YjLHTYwx4mj+yT4rPNaTGRVlVWxc+rwQiE7PLnyGobYJ4IxhNjgkaE2
         wkabY5M3hZUgsBt2AwyhJ56mEw1R83ZIK62Z7muXxZrzZE8xhZk1ojkeHJ/pc/29HJ8x
         6fhQ3mJuhGcF3Xq44ya7V3649PN0CjxAyjYJ4Pm1vYt72q9e4Y6iz3DIV/f/XLU9a0hH
         /yghEL0fOPyS1LPiV65Ao+CG3GfUqRK6GKOQ/rPalwyzituV3gEknzdha26KHdmac16J
         J8QRaa/4u6NYgAC9NgSdD3M0cfTfh5j5Klg37UicyszYMU+dv1Mc4z3t6Drtq6I5pLZB
         p4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=w1JglHwOh+BlGZEYs0OCIE6e9RMRuh8C6cU2uj1U3V0=;
        b=tiGOsot+JX50DsUVVxsFlqezsrBosBz2A7m71NpEIL2q5TMJqrd/r5bQe2rVRQtQTA
         UHMK2cIQZ4gY1kiD1E9WOB9kwLPtRqKRVT5nNS/QaGePIzAWhTyG8/YC1Reca8AUV498
         QgKNe5K1wiEbewckHvomI5ZKKhI177eoowSGJyMymdglkLU5pQjT5ig0Jvsgg9vZUK/c
         +gD3/mJNIxWZowb/1Zqs+tPM+75WYfN5YCzwAPIw/M94qxKVwuqIK3MxcXuEj/k0FX93
         9DXBSZMCn06/CbOs6bg8b9qi2aO7MGMtDJFYP7/UZij5mW6zxxQDUoIkwKqsCAVn3e+i
         VySw==
X-Gm-Message-State: AOAM532sQ1mVIlPz8bA4zzWV5a0bkqkkXo3DywmE4fi9VjZ7HBJ80iSj
        P0L8vbFzYRIVFI5Lu0JlMhU=
X-Google-Smtp-Source: ABdhPJyK+FQ1BLmzIcilyQXesMioub4KFJ1vKVHFoqQ+K0Yg3K7wEvTDWBwifUgiomaZVJshoqVdcw==
X-Received: by 2002:aca:cf95:: with SMTP id f143mr814414oig.104.1617053687199;
        Mon, 29 Mar 2021 14:34:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n12sm4814473otq.42.2021.03.29.14.34.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:34:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:34:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/252] 5.11.11-rc2 review
Message-ID: <20210329213445.GG220164@roeck-us.net>
References: <20210329101343.082590961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329101343.082590961@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 12:14:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.11 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 10:13:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 458 pass: 458 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
