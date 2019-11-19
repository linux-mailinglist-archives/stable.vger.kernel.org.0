Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08913102B91
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 19:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKSSQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 13:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfKSSQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 13:16:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9F32231A;
        Tue, 19 Nov 2019 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574187381;
        bh=yUCETfyVN5xc/2se3q53OR75yWv2RfkA9h9g6kT8hng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B0d+mRkKuflugNuRJZkMewaUYPK9RR6o8UF22vWWnfT1U+KO2+PGLFbW6wqkOrFKr
         e2MxmRwF8jrNMD0jPZPgvS146jyCjkP54xH+luNRqbuq4OVw3Xoo6WbdqAepCTJnoG
         gwUL/aI2m2248UlvG1jANVYRbssGs0L9DCA4hx1U=
Date:   Tue, 19 Nov 2019 19:16:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <20191119181619.GB2283647@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
 <TYAPR01MB228560FC98FFD1D449FA4EC2B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119154839.GB1982025@kroah.com>
 <TYAPR01MB2285698B8E0F38B9EEF47128B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119165207.GA2071545@kroah.com>
 <20191119180002.GA17608@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119180002.GA17608@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 10:00:02AM -0800, Guenter Roeck wrote:
> On Tue, Nov 19, 2019 at 05:52:07PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Nov 19, 2019 at 04:38:06PM +0000, Chris Paterson wrote:
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Sent: 19 November 2019 15:49
> > > > 
> > > > On Tue, Nov 19, 2019 at 02:44:12PM +0000, Chris Paterson wrote:
> > > > > Hi Greg,
> > > > >
> > > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > Sent: 19 November 2019 12:29
> > > > > >
> > > > > > On Tue, Nov 19, 2019 at 08:54:25AM +0000, Chris Paterson wrote:
> > > > > > > Hello Greg, all,
> > > > > > >
> > > > > > > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org>
> > > > On
> > > > > > > > Behalf Of Greg Kroah-Hartman
> > > > > > > > Sent: 19 November 2019 05:13
> > > > > > > >
> > > > > > > > This is the start of the stable review cycle for the 4.19.85 release.
> > > > > > > > There are 422 patches in this series, all will be posted as a response
> > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > let me know.
> > > > > > >
> > > > > > > I'm seeing some build issues with module compilation with this release
> > > > > > (1b1960cc Linux 4.19.85-rc1), I also saw them with the previous two versions
> > > > of
> > > > > > Linux 4.19.85-rc1 (cd21ecdb and 1fd0ac64).
> > > > > > >
> > > > > > > Full log available on GitLab [0]. Build conf [1].
> > > > > > > [0] https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/354591285
> > > > > > > [1] https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > > > > /jobs/354591285/artifacts/file/output/4.19.85-
> > > > > > rc1_1b1960cc7/x86/siemens_iot2000.config/config/.config
> > > > > > >
> > > > > > > Main error below:
> > > > > > >
> > > > > > > 3907   CC [M]  drivers/net/ethernet/mellanox/mlx4/main.o
> > > > > > > 3908   LD [M]  fs/ntfs/ntfs.o
> > > > > > > 3909   CC [M]  drivers/net/ethernet/intel/i40evf/i40e_txrx.o
> > > > > > > 3910   CC [M]  drivers/usb/musb/musb_core.o
> > > > > > > 3911   CC [M]  drivers/net/ethernet/nvidia/forcedeth.o
> > > > > > > 3912   CC [M]  fs/udf/balloc.o
> > > > > > > 3913   CC [M]  drivers/net/ethernet/intel/fm10k/fm10k_debugfs.o
> > > > > > > 3914   CC [M]  fs/udf/dir.o
> > > > > > > 3915   CC [M]  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.o
> > > > > > > 3916   CC [M]  drivers/net/ethernet/intel/i40e/i40e_ptp.o
> > > > > > > 3917 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > > 'mlx4_init_one':
> > > > > > > 3918 drivers/net/ethernet/mellanox/mlx4/main.c:3985:2: error: implicit
> > > > > > declaration of function 'devlink_reload_enable'; did you mean
> > > > > > 'devlink_region_create'? [-Werror=implicit-function-declaration]
> > > > > > > 3919   devlink_reload_enable(devlink);
> > > > > > > 3920   ^~~~~~~~~~~~~~~~~~~~~
> > > > > > > 3921   devlink_region_create
> > > > > > > 3922   CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.o
> > > > > > > 3923 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > > > > 'mlx4_remove_one':
> > > > > > > 3924 drivers/net/ethernet/mellanox/mlx4/main.c:4097:2: error: implicit
> > > > > > declaration of function 'devlink_reload_disable'; did you mean
> > > > > > 'devlink_region_destroy'? [-Werror=implicit-function-declaration]
> > > > > > > 3925   devlink_reload_disable(devlink);
> > > > > > > 3926   ^~~~~~~~~~~~~~~~~~~~~~
> > > > > > > 3927   devlink_region_destroy
> > > > > > > 3928   CC [M]  drivers/net/ethernet/packetengines/hamachi.o
> > > > > > > 3929   CC [M]  fs/udf/file.o
> > > > > > > 3930   LD [M]  drivers/net/ethernet/intel/fm10k/fm10k.o
> > > > > > >
> > > > > > > I haven't tried to trace the issue further yet, sorry.
> > > > > >
> > > > > > Any chance you can bisect this?  I don't see any obvious reason why this
> > > > > > error should be happening, and it isn't showing up here :(
> > > > >
> > > > > Looking through the commit history, the issue seems to be related to:
> > > > > 672cf82122be ("devlink: disallow reload operation during device cleanup")
> > > > >
> > > > > I've reverted this commit and Linux 4.19.85-rc2 (af1bb7db before revert) will
> > > > build with the configuration I'm using [2].
> > > > > I haven't looked further yet though, sorry.
> > > > >
> > > > > [2] https://gitlab.com/cip-project/cip-kernel/cip-kernel-
> > > > config/raw/master/4.19.y-cip/x86/siemens_iot2000.config
> > > > 
> > > > If you add:
> > > > 	#include <net/devlink.h>
> > > > to the top of drivers/net/ethernet/mellanox/mlx4/main.c, does it fix the
> > > > issue for you?
> > > 
> > > This is already defined:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/tree/drivers/net/ethernet/mellanox/mlx4/main.c?h=linux-4.19.y#n47
> > 
> > Ah, ok, the issue is that CONFIG_NET_DEVLINK is not enabled, the driver
> > now requires this.  This was resolved by adding the dependancy to the
> > driver itself, and then just punting and always enabling it over time.
> > 
> > We can backport part of f6b19b354d50 ("net: devlink: select NET_DEVLINK
> > from drivers") if you want, but that feels messy.
> > 
> > For now, if you enable that option, does it build for you?
> > 
> 
> Selecting NET_DEVLINK manually fixes the problem, but at least for my part
> I was unable to find a means to define the dependency in the Kconfig file.
> I either get a recursive dependency or unmet direct dependencies.
> 
> FWIW, reverting the devlink patch fixes the compile problem.

Ok, I've now done just that, and pushed out a -rc4.

thanks,

greg k-h
