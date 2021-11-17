Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE5453F35
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 05:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhKQEEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhKQEEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:04:05 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45B1C061570;
        Tue, 16 Nov 2021 20:01:07 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso2345135otr.2;
        Tue, 16 Nov 2021 20:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=laHXPu8ycy5smg65VxGm5uM5RqhHwh2eR6svxTsCvt4=;
        b=X3vIu+J+uTTMulxZJhGu4EKO/fkCztSqx2IA0s/QYfKtcL5iHR+t1JZmCAbSkLmNMJ
         Ks0pMC5ZOIdjdi4rjC5lUHvZwetzdbVbxToW1t0lmir6+Rmxvu9Vr7VAu8b+j/tEK4ax
         EJS9MpVs+dUAdVH/DERAitugzKwX4P1C5H+CHlWIxEQC1RTqOhRUGm/9s1qJxG+rvhyq
         h3lmhhxhCwPYyE3Cn3bWf931FaukM7XfuvIx4n9bSsVCN8zY9fJtLlcAYryVGe2W5BEh
         NlgWXkBV/ozrQtz0CAWbj6xjg//Kevl2m7oxGrUQ+A5W8E+MHGBJERyI9g+3RnlL58E7
         XRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=laHXPu8ycy5smg65VxGm5uM5RqhHwh2eR6svxTsCvt4=;
        b=jkSJ4ay09v1oR53PCwWcVKpaWhkydMAhTLqcxT+iXK2mwoQ//sZJceJ/X5iQ6bNcbr
         8Lv3rpv8RZ3kG7MkLQuCDM1E02Mrt9K1VLvuJtLmwmvrpK+/rXOatcGye4O5VSOAS9ku
         OrCkf2KAwxiBMEVduOMGu1exFut2U42+O7k5zD+MSbRbWjrldmKL69Sz4Lk/b7qJxrBs
         jN97RWY0DYgTy6yy/RH3OY4mqo5X97HaxPBkgLkX9CemMjskcySAAjuyiP/2JgwckDj0
         vqX5Uf0+MqzioqoJGONgPHRJbxiDJ3iKZdM4PQXtiEQ0ZI3HTSeU8/onax+b3P5iRpEk
         Ptlw==
X-Gm-Message-State: AOAM53130B7ar/F2TvqurqTUG6oaLHi3d6LyiH4p8ktwMHz4wFGzWoSe
        YyCrFyoQ6bseBr0vsGacrCWmyKpC6rw=
X-Google-Smtp-Source: ABdhPJybzD6+jckMnkJDmuvRox//CM0WW5ZrfNsX0RlPkviC35tP7S13GX3XfhfQjCZGw65ygCAJ+g==
X-Received: by 2002:a9d:458a:: with SMTP id x10mr10543383ote.267.1637121657152;
        Tue, 16 Nov 2021 20:00:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v2sm292300oto.3.2021.11.16.20.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 20:00:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Nov 2021 20:00:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
Message-ID: <20211117040055.GB212153@roeck-us.net>
References: <20211116142545.607076484@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 04:00:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	m68k:defconfig
	m68k:allmodconfig
Qemu test results:
	total: 474 pass: 474 fail: 0

As already reported, the build failure is:

drivers/block/ataflop.c: In function 'atari_cleanup_floppy_disk':
drivers/block/ataflop.c:2066:17: error: implicit declaration of function 'blk_cleanup_disk'

drivers/block/ataflop.c: In function 'atari_floppy_init':
drivers/block/ataflop.c:2133:15: error: implicit declaration of function '__register_blkdev'

Guenter
