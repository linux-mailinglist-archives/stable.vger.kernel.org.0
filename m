Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4038D1F6689
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgFKLWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgFKLWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:22:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18EFA2081A;
        Thu, 11 Jun 2020 11:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874559;
        bh=NqyX0dNctaON3v50j+DstaJj9DH5OoqXDmZzRhr2bc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0EAnRRPSnMn+Lpw1aHkmcMpsDc3XZx3ziWJinM22SQpxQu0xWePatP5ulGdWf3TU
         7nG6KFpy83CW1Zu/hRjVyZSz+hsiysHn+wCtnXA0qc3E0a8Cne/BfmqwBdn63Nk6uM
         MNTEWJic9VBFGZvs5p2XasfFzfWMO/pKamIN87/4=
Date:   Thu, 11 Jun 2020 13:22:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Price <steven.price@arm.com>
Cc:     kbuild test robot <lkp@intel.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        kbuild-all@lists.01.org, Rob Herring <robh@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-5.4.y 2150/5369]
 drivers/gpu/drm/panfrost/panfrost_job.c:279:31: warning: variable 'bo' set
 but not used
Message-ID: <20200611112233.GA342390@kroah.com>
References: <202005281519.WXxHWhBJ%lkp@intel.com>
 <e9750a6f-742e-e148-e1d6-0f4d405f06c9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9750a6f-742e-e148-e1d6-0f4d405f06c9@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 12:13:03PM +0100, Steven Price wrote:
> On 28/05/2020 08:17, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > head:   e0d81ce760044efd3f26004aa32821c34968512a
> > commit: 3e041c27b9909704a54bc673f9110391e740f583 [2150/5369] drm/panfrost: Add the panfrost_gem_mapping concept
> > config: sparc-allyesconfig (attached as .config)
> > compiler: sparc64-linux-gcc (GCC) 9.3.0
> > reproduce (this is a W=1 build):
> >          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >          chmod +x ~/bin/make.cross
> >          git checkout 3e041c27b9909704a54bc673f9110391e740f583
> >          # save the attached .config to linux build tree
> >          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=sparc
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>, old ones prefixed by <<):
> > 
> > drivers/gpu/drm/panfrost/panfrost_job.c: In function 'panfrost_job_cleanup':
> > > > drivers/gpu/drm/panfrost/panfrost_job.c:279:31: warning: variable 'bo' set but not used [-Wunused-but-set-variable]
> > 279 |   struct panfrost_gem_object *bo;
> > |                               ^~
> 
> FYI: This was fixed upstream in fe154a242233 ("drm/panfrost: Remove set but
> not used variable 'bo'")

Thanks, but this is not a real issue, so no need to fix it in stable
trees.

greg k-h
