Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751FD49CBD5
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiAZOH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:07:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:18857 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235353AbiAZOH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 09:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643206078; x=1674742078;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ATWiAh5adUik4jh9DAaJE+s1YCh+W1I+c+EDEhALlV0=;
  b=QRZGS2JA7djqw65FCRjCn/huuSNPto02OUB8Y6UE+VAB3d5+uXxKx/wV
   yvWriZ2Cy3cCmGQ0qXlrmGmmF5qtrFR9VjNmKhD93nCdTzm+eqgQpwD9i
   RRH4sCZB7wgYU14dp1bwJ7UWrKxdVAbxMe9F79+fEk6cNgEor7VaZkzS7
   jStoDckCasxXh3E5sRJIGw+gc9DQ+872EN+fzo+DG4wWWnbma3I0xA5IX
   3aKclcBTZUyBec0Qq7RPbW12c8hnK/h1tG6yMjPNdKMcVU918ZyCdiJGv
   8YPabIyMV7/PgcvB6IY4OYDrSombPvqyMMGTzq0ON4FVNNAFiQiTF9B5p
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="226531926"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="226531926"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 06:07:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="628311015"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 Jan 2022 06:07:56 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCixn-000LH9-Df; Wed, 26 Jan 2022 14:07:55 +0000
Date:   Wed, 26 Jan 2022 22:07:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Maciej W. Rozycki" <macro@embecosm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     kbuild-all@lists.01.org, Christoph Hellwig <hch@infradead.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] tty: Partially revert the removal of the Cyclades
 public API
Message-ID: <202201262147.FNYhDmDi-lkp@intel.com>
References: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi "Maciej,

I love your patch! Perhaps something to improve:

[auto build test WARNING on tty/tty-testing]
[also build test WARNING on linus/master hch-configfs/for-next v5.17-rc1 next-20220125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Maciej-W-Rozycki/tty-Partially-revert-the-removal-of-the-Cyclades-public-API/20220126-172520
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-testing
config: i386-buildonly-randconfig-r002-20220124 (https://download.01.org/0day-ci/archive/20220126/202201262147.FNYhDmDi-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/c9e707e313f471adbe057300f4fb163113cf062c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Maciej-W-Rozycki/tty-Partially-revert-the-removal-of-the-Cyclades-public-API/20220126-172520
        git checkout c9e707e313f471adbe057300f4fb163113cf062c
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from <command-line>:32:
>> ./usr/include/linux/cyclades.h:6:2: warning: #warning "Support for features provided by this header has been removed" [-Wcpp]
       6 | #warning "Support for features provided by this header has been removed"
         |  ^~~~~~~
>> ./usr/include/linux/cyclades.h:7:2: warning: #warning "Please consider updating your code" [-Wcpp]
       7 | #warning "Please consider updating your code"
         |  ^~~~~~~

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
