Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F94C34D998
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 23:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhC2VeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 17:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhC2Vdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 17:33:51 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE42C061574;
        Mon, 29 Mar 2021 14:33:50 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id m13so14431743oiw.13;
        Mon, 29 Mar 2021 14:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p5uG/83deN7fkE+65BzYsh5OFVE6auA2I3Hi0Ph/ON8=;
        b=NxN7Jcyf2anILr9gxLOSmio71KN482iMywa1GZTnJP2JpgwRAetKfuWNjUMTFCKtK0
         WLIVueJpFOt6EwlebCnieYG+PDEKXy3LXz3hAm+NaoCk/q5bejSpxi6IyZ4oZJybSGTc
         85TAYINN8bbxjCzuWgtKiT5biaywptq18qdkckn6uddckRjreM9si+YgQXzQ9VZMjN+q
         lMJgygjmm3Ao7flXEt01qr7iZDUUDXz5PCEoKUJVGRP7yRBGvtF1hd7WpcshRu37HUSD
         FMWYGVEyQe/A45dAXAvZ+6maR4f5NxJ+d2/Wy/P1yjAzqG8U2TaKUBqKu2M9pmjzaUcu
         4lkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=p5uG/83deN7fkE+65BzYsh5OFVE6auA2I3Hi0Ph/ON8=;
        b=t0qtPSBDNRpb2yM6Fd4ZQ4CTl6bc2Dau8Hbvr77H5cr+QIArrNEKq04OgtlhrswYLN
         HxQRPh5INFNIJWgLdxA/eNoGUoh1F3iHsEwnquJKNoXmGQYUt49J+skdy4TX9kpf2VUL
         zlmwM+pXc39RNql/MGgJKv826aW/zHaICgn4PRVDxtmy39hyCDqvtDfWHXeubPskbJGD
         grOiHrpcR6bio1sufOkChPYsAU/xm5xrhqe5Xm+acFRbhYu9eskTUe6tC2FWCsBlLx5X
         FaRSTN9P8mvNp3KuyYZc9kRO44KH8FnSr6RoY7xtM5BzES8Dy6kH47CUjF8QdJbUcAP4
         QdUw==
X-Gm-Message-State: AOAM532kgBCLjHYjR0ZRPLbrO34CxmwuDZ/atnhqSkL9Pa6E2Os1bzz4
        nv4hi5jnkXSdTs9XRcXb1GU=
X-Google-Smtp-Source: ABdhPJzWV+zEYWtZn0XuoBGEgbmJGERkiXw94U9elwGlZH3nA9PGMlB/lPWPWmoNcyU7vhxByPae8g==
X-Received: by 2002:a05:6808:8da:: with SMTP id k26mr790020oij.115.1617053630259;
        Mon, 29 Mar 2021 14:33:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j72sm3711736oih.46.2021.03.29.14.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 14:33:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Mar 2021 14:33:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/111] 5.4.109-rc1 review
Message-ID: <20210329213348.GE220164@roeck-us.net>
References: <20210329075615.186199980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:57:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.109 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
