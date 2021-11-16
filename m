Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC794533A8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhKPOIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237001AbhKPOIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:08:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622CE61B48;
        Tue, 16 Nov 2021 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637071537;
        bh=M9FLPTtP07609iqESF/eWEm84Lo6Xvj+Qgpraw7HCXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dqT2R3N1Bmu/SDh/Y68i0dyqBq+3BQebkgKUIv7NescCfZNUyfiGWCzH3kwuDkaJE
         nLbLI3A+yHytqpazSHjGmOFwAG+3kr1FBhgaMyB+CYgZrnf6461nA852DhAWnIHjQv
         sJCFnjRgZjeAIQSi/yv7s/Qd0qqvxAWlceg8A9hM=
Date:   Tue, 16 Nov 2021 15:05:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 294/575] media: i2c: ths8200 needs V4L2_ASYNC
Message-ID: <YZO6rzLvrxhmeDcG@kroah.com>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165353.946824789@linuxfoundation.org>
 <20211116120023.GB24443@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116120023.GB24443@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 01:00:23PM +0100, Pavel Machek wrote:
> Hi!
> > 
> > [ Upstream commit e4625044d656f3c33ece0cc9da22577bc10ca5d3 ]
> > 
> > Fix the build errors reported by the kernel test robot by
> > selecting V4L2_ASYNC:
> > 
> > mips-linux-ld: drivers/media/i2c/ths8200.o: in function `ths8200_remove':
> > ths8200.c:(.text+0x1ec): undefined reference to `v4l2_async_unregister_subdev'
> > mips-linux-ld: drivers/media/i2c/ths8200.o: in function `ths8200_probe':
> > ths8200.c:(.text+0x404): undefined reference to
> `v4l2_async_register_subdev'
> 
> CONFIG_V4L2_ASYNC is not present in 5.10 kernel, this is should not be
> applied here.

Dropped from 5.4.y and 5.10.y now, thanks.

greg k-h
