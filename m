Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EC632FBF8
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhCFQdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCFQdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:33:43 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216D4C06174A;
        Sat,  6 Mar 2021 08:33:43 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m25so6158460oie.12;
        Sat, 06 Mar 2021 08:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6YMn1Tv+xGdetVfsABhq1njwRIlvXZdIQwHsYFvh5iY=;
        b=ZrBubTCTV91vRahcl6iW3NgBCrqStvBPKRxY/m6TNSuFw4mJuDkmX8jpCVtR19++p1
         EAE1ko11Ek+VwmtjcimhAy9TlFS/NonXP8ucMePlCRnKdhtHfJqb8jJ27o7HjEuOYVhb
         eED4G8jETnNQxULt2jbOdCcvYp0jB/6QH1XX1kRR/cYllNi+WvByBBmcAp2G6Lap2DXG
         loGR585ZG7YavVITFUzqJ3IFLh99kerJFuwn1Lno1uyvfJpzZg8+bN7PNfVGnlvEW1fL
         iYMMWNrIug7n5xrnVVFXS3eC2ibHc6EyXJW+ZDES5rvHSpNUbHW7VfXC0SGGQULdwW6G
         jz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6YMn1Tv+xGdetVfsABhq1njwRIlvXZdIQwHsYFvh5iY=;
        b=Ww5rY3fC2/ShxvXyCsIAOlzSDk1J0sg94Jqw3SRyrjh8MRKJLPeeARoyt1YNYFKujK
         Sh3MWA4kHAonE+GkbuDCpNT7G4x1y0GA0sLJKHPSCNAt1vXk82Xor4845jRW678qkf9R
         Px4X4iiqtwc3yZX/+okSB9P84kUzvWGiWBWIh+rIYto0Cf7U10Yy8+FrISQDQAbO2Y+W
         5T8w1M95pq8lsbkJk4GeWKqv07LVJzHFzhrXE19nBIYqfhTfeX2cMvxsK+IVVpwNz6rz
         lfATxQwcbKZaZbZNnCAeH70D0mTZiUQWoufxCiG2pD7KJ5bBhMUTbyyRYPf8vJ8ZqhhR
         ybBg==
X-Gm-Message-State: AOAM530QZNunQgSagpm0MlWzuY/pYjDBBHpqhgAEHF/G26nkrGCuYhCg
        WeswEdLSeoIzAySTZ55hPjOoNIAEYRo=
X-Google-Smtp-Source: ABdhPJzqeMl6kx0OUZn8g09IrdjJNWHbCfgOyLt4zleY/ODJL4jwHh+8uWxukOo5BRIYLI0JZtCDXA==
X-Received: by 2002:a54:4689:: with SMTP id k9mr11457467oic.149.1615048422465;
        Sat, 06 Mar 2021 08:33:42 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s21sm1298955oos.5.2021.03.06.08.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:33:42 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:33:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
Message-ID: <20210306163340.GG25820@roeck-us.net>
References: <20210305120857.341630346@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:21:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.103 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 425 fail: 4
Failed tests:
	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd
	arm:realview-pbx-a9:realview_defconfig:realview_pb:arm-realview-pbx-a9:initrd
	arm:realview-eb:realview_defconfig:realview_eb:mem512:arm-realview-eb:initrd
	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:arm-realview-eb-11mp-ctrevb:initrd

Failure as already reported:

kernel/rcu/tree.c:617:2: error: implicit declaration of function 'IRQ_WORK_INIT'

Guenter
