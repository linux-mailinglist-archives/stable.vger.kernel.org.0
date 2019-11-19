Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B51D5102B4A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 19:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfKSSAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 13:00:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42282 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKSSAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 13:00:05 -0500
Received: by mail-pl1-f193.google.com with SMTP id j12so12148787plt.9;
        Tue, 19 Nov 2019 10:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wv41PPu6EmCtUmj6WAxFactHJxIkJXo8H+4DQ21DEhQ=;
        b=JuKQac/srBNXbHZJZNKzkBy37cCEV7gmaDunK5og2AMayUonn6nPfd5BwEshnA/sMH
         TuQEbpMfJTLzfoaajluHkGGF/Fm1lOfCzy5LHZczKZZ44Q3BN2/i2ElumXUjimOV7W/3
         8OrNwnqFwFtaBhyc6dss89UBrQS2BjYiR6bhk6Ub8qhBHtrU292jemVLatgMgSTAX3vW
         qgycOmrTtc+t6aZ6JlUOGbZaxEtVtLx4fF6ikWus6a7/nq5iTQOwTwxtTfB2gKIPwepg
         ZPAB6F/guk28n680cms9gUYmcW+0vJGNxXQWOOlekScAK+AkhW1louZiOuhlOS0k6KuX
         NU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wv41PPu6EmCtUmj6WAxFactHJxIkJXo8H+4DQ21DEhQ=;
        b=ZKbWe+zklUbGVkoL3bfwNpT0hzY/6FSmn+vwBPc0vdyaZx/q4gsVuXPW3N3Eg56v7f
         c290bgMMdStGynpJd05HXO/sGDVUGQd0yshKFWKmqeG14NvohGKrRN9wo8xUCzzeVYWO
         iJDfNUX9W0AORjkeVCo3DfI48ML15m/9ZQflpiOvhYMjVJblROlLNYQirXnoH0sO+MBp
         iOICnXTzXeWSCsehSxkxtlqMeV5XW4AMvXuD7WILQ/fzsXzox4QTwEP8hkUy/iV9hPpA
         cyxRe8/SvxyRPENJaguYwn91jBtFEWl2Qf4Tr/+mWYbHMLU2V3VWCxqx/IW79rg52mdN
         F0dw==
X-Gm-Message-State: APjAAAVn4dObaBxmeDDD97CT8y5EcaOX9ymkBNUAQpPow36Ka84AlWah
        +nnxNGWm36dUlD4SRXHf1H8=
X-Google-Smtp-Source: APXvYqwLuaGQ6XNB+Tq1qfKotdJl9s4pZr+U2bG23Ozt9lMQFPoyd3ioXk2inelVGh5QlWhGPEPF9w==
X-Received: by 2002:a17:902:6bc3:: with SMTP id m3mr35377196plt.329.1574186404460;
        Tue, 19 Nov 2019 10:00:04 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l9sm4487647pgh.31.2019.11.19.10.00.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 10:00:03 -0800 (PST)
Date:   Tue, 19 Nov 2019 10:00:02 -0800
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
Message-ID: <20191119180002.GA17608@roeck-us.net>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
 <TYAPR01MB228560FC98FFD1D449FA4EC2B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119154839.GB1982025@kroah.com>
 <TYAPR01MB2285698B8E0F38B9EEF47128B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119165207.GA2071545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119165207.GA2071545@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 05:52:07PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 19, 2019 at 04:38:06PM +0000, Chris Paterson wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: 19 November 2019 15:49
> > > 
> > > On Tue, Nov 19, 2019 at 02:44:12PM +0000, Chris Paterson wrote:
> > > > Hi Greg,
> > > >
> > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Sent: 19 November 2019 12:29
> > > > >
> > > > > On Tue, Nov 19, 2019 at 08:54:25AM +0000, Chris Paterson wrote:
> > > > > > Hello Greg, all,
> > > > > >
> > > > > > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org>
> > > On
> > > > > > > Behalf Of Greg Kroah-Hartman
> > > > > > > Sent: 19 November 2019 05:13
> > > > > > >
> > > > > > > This is the start of the stable review cycle for the 4.19.85 release.
> > > > > > > There are 422 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > >
> > > > > > I'm seeing some build issues with module compilation with this release
> > > > > (1b1960cc Linux 4.19.85-rc1), I also saw them with the previous two versions
> > > of
> > > > > Linux 4.19.85-rc1 (cd21ecdb and 1fd0ac64).
> > > > > >
> > > > > > Full log available on GitLab [0]. Build conf [1].
> > > > > > [0] https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/354591285
> > > > > > [1] https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > > > /jobs/354591285/artifacts/file/output/4.19.85-
> > > > > rc1_1b1960cc7/x86/siemens_iot2000.config/config/.config
> > > > > >
> > > > > > Main error below:
> > > > > >
> > > > > > 3907   CC [M]  drivers/net/ethernet/mellanox/mlx4/main.o
> > > > > > 3908   LD [M]  fs/ntfs/ntfs.o
> > > > > > 3909   CC [M]  drivers/net/ethernet/intel/i40evf/i40e_txrx.o
> > > > > > 3910   CC [M]  drivers/usb/musb/musb_core.o
> > > > > > 3911   CC [M]  drivers/net/ethernet/nvidia/forcedeth.o
> > > > > > 3912   CC [M]  fs/udf/balloc.o
> > > > > > 3913   CC [M]  drivers/net/ethernet/intel/fm10k/fm10k_debugfs.o
> > > > > > 3914   CC [M]  fs/udf/dir.o
> > > > > > 3915   CC [M]  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.o
> > > > > > 3916   CC [M]  drivers/net/ethernet/intel/i40e/i40e_ptp.o
> > > > > > 3917 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > 'mlx4_init_one':
> > > > > > 3918 drivers/net/ethernet/mellanox/mlx4/main.c:3985:2: error: implicit
> > > > > declaration of function 'devlink_reload_enable'; did you mean
> > > > > 'devlink_region_create'? [-Werror=implicit-function-declaration]
> > > > > > 3919   devlink_reload_enable(devlink);
> > > > > > 3920   ^~~~~~~~~~~~~~~~~~~~~
> > > > > > 3921   devlink_region_create
> > > > > > 3922   CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.o
> > > > > > 3923 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > > > 'mlx4_remove_one':
> > > > > > 3924 drivers/net/ethernet/mellanox/mlx4/main.c:4097:2: error: implicit
> > > > > declaration of function 'devlink_reload_disable'; did you mean
> > > > > 'devlink_region_destroy'? [-Werror=implicit-function-declaration]
> > > > > > 3925   devlink_reload_disable(devlink);
> > > > > > 3926   ^~~~~~~~~~~~~~~~~~~~~~
> > > > > > 3927   devlink_region_destroy
> > > > > > 3928   CC [M]  drivers/net/ethernet/packetengines/hamachi.o
> > > > > > 3929   CC [M]  fs/udf/file.o
> > > > > > 3930   LD [M]  drivers/net/ethernet/intel/fm10k/fm10k.o
> > > > > >
> > > > > > I haven't tried to trace the issue further yet, sorry.
> > > > >
> > > > > Any chance you can bisect this?  I don't see any obvious reason why this
> > > > > error should be happening, and it isn't showing up here :(
> > > >
> > > > Looking through the commit history, the issue seems to be related to:
> > > > 672cf82122be ("devlink: disallow reload operation during device cleanup")
> > > >
> > > > I've reverted this commit and Linux 4.19.85-rc2 (af1bb7db before revert) will
> > > build with the configuration I'm using [2].
> > > > I haven't looked further yet though, sorry.
> > > >
> > > > [2] https://gitlab.com/cip-project/cip-kernel/cip-kernel-
> > > config/raw/master/4.19.y-cip/x86/siemens_iot2000.config
> > > 
> > > If you add:
> > > 	#include <net/devlink.h>
> > > to the top of drivers/net/ethernet/mellanox/mlx4/main.c, does it fix the
> > > issue for you?
> > 
> > This is already defined:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/tree/drivers/net/ethernet/mellanox/mlx4/main.c?h=linux-4.19.y#n47
> 
> Ah, ok, the issue is that CONFIG_NET_DEVLINK is not enabled, the driver
> now requires this.  This was resolved by adding the dependancy to the
> driver itself, and then just punting and always enabling it over time.
> 
> We can backport part of f6b19b354d50 ("net: devlink: select NET_DEVLINK
> from drivers") if you want, but that feels messy.
> 
> For now, if you enable that option, does it build for you?
> 

Selecting NET_DEVLINK manually fixes the problem, but at least for my part
I was unable to find a means to define the dependency in the Kconfig file.
I either get a recursive dependency or unmet direct dependencies.

FWIW, reverting the devlink patch fixes the compile problem.

Guenter
