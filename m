Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB8411AC5B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbfLKNpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbfLKNps (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 08:45:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F29A20836;
        Wed, 11 Dec 2019 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576071948;
        bh=K1F/pJRPoNVbq//HvKp71lAz0yCIPfAtNYx36dfyV9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ScFH4KDs4Ndkp5VeXJEGtMO6YtYe4fWw7wl2QXvhcrSRD1hNBudn6KqfyE8kVy54M
         DTgvowg669aVcP5fTmVSYhw6bg97Bggza1vYXL5RnJkQ+bNbY1AgTyAqFyGk6J7+P8
         ukNJAtZSkRD5zVaLmGvqQjybpARjHa0rtnQw9KT8=
Date:   Wed, 11 Dec 2019 14:45:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
Message-ID: <20191211134545.GC523125@kroah.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
 <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210073514.GB3077639@kroah.com>
 <TYAPR01MB2285B5834B1FBA71F8DA512BB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210145528.GA4012363@kroah.com>
 <TYAPR01MB2285433EA1E6DF9EC621E31AB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210205951.GA4081499@kroah.com>
 <TYAPR01MB22852454802BAB486871D944B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22852454802BAB486871D944B75A0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:52:44AM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> [...]
> 
> > > > That's a lot, are these all new?
> > >
> > > I've only just started building with this config in our CI setup, but
> > > building the dtbs locally with v4.19.88 didn't produce these results
> > > for me (and building locally with v4.19.89-rc1 does result in the
> > > above issues).
> > 
> > Any chance you can run 'git bisect' to track down the offending patch?
> 
> The two dtbs that fail to build are fixed by reverting by the patches below:
> 
> > allwinner/sun50i-a64-pinebook.dtb
> ea03518a3123 ("arm64: dts: allwinner: a64: enable sound on Pinebook")

Now dropped.

> > qcom/sdm845-mtp.dtb
> d0a925e2060d ("arm64: dts: qcom: sdm845-mtp: Mark protected gcc clocks")

Now dropped.

> The rest of the dtbs just had warnings, all produced by the patch below:
> 
> > arm/juno.dtb
> > qcom/apq8016-sbc.dtb
> > arm/juno-r2.dtb
> > arm/juno-r1.dtb
> > hisilicon/hi6220-hikey.dtb
> > qcom/msm8916-mtp.dtb
> > qcom/msm8916-mtp.dtb
> 3fa6a276a4bd ("kbuild: Enable dtc graph_port warning by default")

Now dropped as well.

I'll push out new kernels in a bit, thanks for this info.

greg k-h
