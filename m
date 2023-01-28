Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8375467F3D5
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 02:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjA1BsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 20:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjA1BsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 20:48:10 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93396252A5
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 17:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674870489; x=1706406489;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=3l1dpx9qNNxXrvKaN70QBlwRSqXrNHKUMUBqn2pDjIE=;
  b=Reb4mQbYSKoJqd/3uqj9jp01S3GK8P9tFTk1SZ2EBVOeW6v8WHcnDA7r
   Xy1qTIgVa1EMF5efe54lSTXaY2I/ZKHxBhJcdIKyLdIaVpLuYJtkGpgbB
   X9IwKj+IcQ3rmYs0btwjpHvHeyOIs1n4HPnJxR2KJXfaLP7UzOXfl9WcM
   7gVFJPWXtcejJPUyXGP7O+BhY6MUTSnSjJQ9rMf74Aj8vYtg6+fMgmgYu
   JdvrqAR7d993ZWIw2BXtYzgHMOtZCj89Y/SM3Dx4vh6hpv2yXWrL80PXv
   Wy4RA66LzHG7RZIxE1GmfY1QZEEE348muH1TJ19Rx4/b86WLpvo5L5/QS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="389625780"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="389625780"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 17:48:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="992272328"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="992272328"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 27 Jan 2023 17:48:08 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLaK7-0000FZ-0B;
        Sat, 28 Jan 2023 01:48:07 +0000
Date:   Sat, 28 Jan 2023 09:47:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10 1/1] i40e: Add checking for null for
 nlmsg_find_attr()
Message-ID: <Y9R+p2B0QSZyRkAH@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126135555.11407-2-n.petrova@fintech.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.10 1/1] i40e: Add checking for null for nlmsg_find_attr()
Link: https://lore.kernel.org/stable/20230126135555.11407-2-n.petrova%40fintech.ru

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



