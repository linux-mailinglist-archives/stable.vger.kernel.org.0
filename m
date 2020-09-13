Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60A8267EFC
	for <lists+stable@lfdr.de>; Sun, 13 Sep 2020 11:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIMJnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Sep 2020 05:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgIMJnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Sep 2020 05:43:10 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C0E20796;
        Sun, 13 Sep 2020 09:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599990190;
        bh=g2kZ8VU/dV4hxq9fiHOO6AMzPY+3Tn5IM/Mjj2glBIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iASmzCJGLHNUfneLXBb+sEIIolfZd2PyVYjuMBs4yCvSG+V/+y1kX71aLm45cTMbU
         Nkgc1gfhFWNujkF2UfKuVuBk6AivGx1Vo8stEVRnxhtcTon5BSRchJZqMZX5plv7sC
         PckhH6L4C9TwCSPx5JSLR9h/xExVGnmDUz7L3KgE=
Date:   Sun, 13 Sep 2020 10:43:05 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Christian Eggers <ceggers@arri.de>, kbuild-all@lists.01.org,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio: trigger: Don't use RT priority
Message-ID: <20200913104240.5c1b98ae@archlinux>
In-Reply-To: <202009100951.s9xJuuod%lkp@intel.com>
References: <20200909162216.13765-1-ceggers@arri.de>
        <202009100951.s9xJuuod%lkp@intel.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Sep 2020 09:54:06 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Christian,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on iio/togreg]
> [also build test ERROR on v5.9-rc4 next-20200909]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Christian-Eggers/iio-trigger-Don-t-use-RT-priority/20200910-002619
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git togreg
> config: i386-randconfig-r026-20200909 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> ERROR: modpost: "sched_setscheduler_nocheck" [drivers/iio/industrialio.ko] undefined!
 
Looks like we can't do this unless we have a precusor patch to export that
function for module use.

Jonathan

> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

