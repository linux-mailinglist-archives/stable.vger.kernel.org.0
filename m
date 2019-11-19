Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE1F1029A6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfKSQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 11:46:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34789 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKSQq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 11:46:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id z188so11639529pgb.1;
        Tue, 19 Nov 2019 08:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N88IvzubVsX0fszeRU54yuPiG1qCCXajzAAcBlZsZlc=;
        b=OMXytIh62mE98rqPh2OrsrHoSOdGc+kISBXOfwcq6UCkm4i7gAZf2b8GmwJJwcBnxv
         J9DuOiucxjKGkQPPUaXx/1LouZ6J5SydtXNUd11t7CH22P3b0p2mvlFBMiX1qbop6tVZ
         fefyXjlG67Q2MjrQwheelFDTutJCC7lhUdOyd061BCwmvBe1mn9cAkTsZeq2HOnfZUDl
         UOf4/iwugz2Mh55Cdu9R5dj57eWQhZLs9VShj4LJAqSTZFw5MdzeuEMgJcuDZSyIZbyH
         +vnbMUvKqzkW5fxQaikf/AeBk++mWApk+nrBovjowLMSGPt28hb73agEczfFv6ARYWHy
         k4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=N88IvzubVsX0fszeRU54yuPiG1qCCXajzAAcBlZsZlc=;
        b=uVPXX0Xf3VdpJC3f4UlscD6kQ0U0itX4NSRaePLGgZK6rFQqK6rRzvi6O/Rb5SPFAM
         Ao6ZYFzgGHu2j5C5RqnyEYBmwfgsfwBQtfilg9I4I+vkKCbdPCOS+5f8WsWXGcVkT8JG
         V331lEeRVmjgkkCJiFEquv+o70HxwIS8oQ0YvwZ/YdSn7egtlyj4Jzo7bL6kXPF1McdR
         3jy7eN95EIeK4B3vS0cVo3O5zdO8UgGcPHj1K7JulWvPr7zAZrqwGYkvqAP/Q40R2Ig3
         sLOjQN+ALrnknxogcjE2HchUtvdb8hV+ds3ta6J7lkl/pwdz4diDVfbcu9vdEj8q6wYl
         fLYQ==
X-Gm-Message-State: APjAAAV6IKxOPXLw/BYo0qAX+uBCkuueV6EI4OyQiPFm4kaBWTOceY7g
        2y9hi9WbZWY0foCjy/EbebLE0JVL
X-Google-Smtp-Source: APXvYqw78SVR1Quud8+jWWUcLN56/L91kDoVI+1WrS2fDWCH0IxHeSigIZgug9d4qQLnw/eUAccIww==
X-Received: by 2002:a63:ee4b:: with SMTP id n11mr6785861pgk.450.1574181988866;
        Tue, 19 Nov 2019 08:46:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g4sm25079113pfh.172.2019.11.19.08.46.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 08:46:28 -0800 (PST)
Date:   Tue, 19 Nov 2019 08:46:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
Message-ID: <20191119164626.GA5739@roeck-us.net>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119122909.GC1913916@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 01:29:09PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 19, 2019 at 08:54:25AM +0000, Chris Paterson wrote:
> > Hello Greg, all,
> > 
> > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > Behalf Of Greg Kroah-Hartman
> > > Sent: 19 November 2019 05:13
> > > 
> > > This is the start of the stable review cycle for the 4.19.85 release.
> > > There are 422 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > I'm seeing some build issues with module compilation with this release (1b1960cc Linux 4.19.85-rc1), I also saw them with the previous two versions of Linux 4.19.85-rc1 (cd21ecdb and 1fd0ac64).
> > 
> > Full log available on GitLab [0]. Build conf [1].
> > [0] https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/354591285
> > [1] https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/354591285/artifacts/file/output/4.19.85-rc1_1b1960cc7/x86/siemens_iot2000.config/config/.config
> > 
> > Main error below:
> > 
> > 3907   CC [M]  drivers/net/ethernet/mellanox/mlx4/main.o
> > 3908   LD [M]  fs/ntfs/ntfs.o
> > 3909   CC [M]  drivers/net/ethernet/intel/i40evf/i40e_txrx.o
> > 3910   CC [M]  drivers/usb/musb/musb_core.o
> > 3911   CC [M]  drivers/net/ethernet/nvidia/forcedeth.o
> > 3912   CC [M]  fs/udf/balloc.o
> > 3913   CC [M]  drivers/net/ethernet/intel/fm10k/fm10k_debugfs.o
> > 3914   CC [M]  fs/udf/dir.o
> > 3915   CC [M]  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.o
> > 3916   CC [M]  drivers/net/ethernet/intel/i40e/i40e_ptp.o
> > 3917 drivers/net/ethernet/mellanox/mlx4/main.c: In function 'mlx4_init_one':
> > 3918 drivers/net/ethernet/mellanox/mlx4/main.c:3985:2: error: implicit declaration of function 'devlink_reload_enable'; did you mean 'devlink_region_create'? [-Werror=implicit-function-declaration]
> > 3919   devlink_reload_enable(devlink);
> > 3920   ^~~~~~~~~~~~~~~~~~~~~
> > 3921   devlink_region_create
> > 3922   CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.o
> > 3923 drivers/net/ethernet/mellanox/mlx4/main.c: In function 'mlx4_remove_one':
> > 3924 drivers/net/ethernet/mellanox/mlx4/main.c:4097:2: error: implicit declaration of function 'devlink_reload_disable'; did you mean 'devlink_region_destroy'? [-Werror=implicit-function-declaration]
> > 3925   devlink_reload_disable(devlink);
> > 3926   ^~~~~~~~~~~~~~~~~~~~~~
> > 3927   devlink_region_destroy
> > 3928   CC [M]  drivers/net/ethernet/packetengines/hamachi.o
> > 3929   CC [M]  fs/udf/file.o
> > 3930   LD [M]  drivers/net/ethernet/intel/fm10k/fm10k.o
> > 
> > I haven't tried to trace the issue further yet, sorry.
> 
> Any chance you can bisect this?  I don't see any obvious reason why this
> error should be happening, and it isn't showing up here :(
> 
I see the problem as well, with powerpc:defconfig.

Underlying issue is that devlink_reload_disable() is only declared in the
include file if CONFIG_NET_DEVLINK is enabled. There is no dummy otherwise.
The dummy declarations which still exist in 4.19 were removed with commit
f6b19b354d50c ("net: devlink: select NET_DEVLINK from drivers") in the
upstream kernel.

Guenter
