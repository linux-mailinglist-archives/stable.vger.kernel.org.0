Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60103A82CE
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhFOO24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFOO2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:28:25 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E0CC06175F;
        Tue, 15 Jun 2021 07:21:24 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so14414015oth.9;
        Tue, 15 Jun 2021 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9jwyWSu2yHUvlIAHuHxRiBsCGmbg3T8HpYR9rfCbvtI=;
        b=iFMEAf/OcFH34qlI1qwaHglHeXVmtgsdRuw+vr0obat8vu2hE2domYag3R6D6P4XZe
         aM/0+DJHQtfimnzCpaZl2isvsPlfXgs+BadRi2gPVtpr5TVLcCLa1yoIG3vg0VBB+uP2
         6dh7pLLyfpNLcCVcFjxAqxU2jMuIji2VTsO/K592671Kn9f9fgMloOM01RXedpwp7HTi
         L9gd3uKc1591JdDUri54jozvvoQL3sLb9vyc8584an3j9c0Qjwtgs7BNanPJvDEBYbGd
         CYwilKCCa1nvV453G3ZaGKJhZvwN3991Az2AUY2TWi792QYOITU3ywZl4dri+G7ALZZe
         BOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9jwyWSu2yHUvlIAHuHxRiBsCGmbg3T8HpYR9rfCbvtI=;
        b=qmbOULmJkFd8DP3Lwu2v4GVglGf/a2STEwmpsXJIjX+fi/M7CYI+E529Is6XS5Mvee
         dUP2lK222LkYB+2Dp7VercMIp0xJpVTTUKnpJa2EvjwqAtn0p4tTgm+nEudn/UN0XSWz
         6wg7JOOaOPCXJSsUXutjZC986irYtRk8k3pGgqSyhUrWa+xwDhIh9Yu1cSe+s3rKZ69m
         WJeDLs2GHh1RLOv1feUrzLqSmZl4xGarSfR7hGfi6/VSdbM5TmbayrpZ+0a/Dif/Wlct
         kMNv/K5BASp46EupUh63yvj364y/GDbl83wRQrATbtTGwdePHF3gwSoEPKdec8MVbJBh
         nCjQ==
X-Gm-Message-State: AOAM531fZ4vBLzNCkOulRl/hZJa1zlxgIsJO4rBSxqLgdK4sCRRZy7ZE
        WGMVXmzO4FH+IzdbSXpOAs4=
X-Google-Smtp-Source: ABdhPJwapUaThIYEy8mfcTI1G0lT0RvoFSf9VHApQMgGsitPxR2gMetLhBWi4SbgjcrUZUGkqVSNGQ==
X-Received: by 2002:a05:6830:1da4:: with SMTP id z4mr15384638oti.83.1623766884368;
        Tue, 15 Jun 2021 07:21:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r2sm3149255otd.54.2021.06.15.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:21:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:21:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
Message-ID: <20210615142122.GF958005@roeck-us.net>
References: <20210614161424.091266895@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 06:15:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
