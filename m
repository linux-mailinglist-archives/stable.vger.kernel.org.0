Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9745B27E4
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 22:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIHUuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 16:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIHUuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 16:50:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D404B0B18
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 13:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662670230; x=1694206230;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=CeUoh8gS+hXzun925gU57SSlfhz+EcRMFuYwIbFnMVo=;
  b=bKk2Rzc/cKFB/Y+BIWdQJgTNJ4Jinr0JJRzefe5KkLqid2nYiy8ZvsGS
   nkWhrtJN4jJ9kGwEO48Gdr+TtYK20jtsoa+wgRyYLF9dZk9OyEY6+jV+k
   NTSOJFiiZXKj6hOlYpV1rXGp2dpFCnTS4sOBX7KOn/ZVAwOa/RueUxmGY
   /X+swjuzxYQbmrzvs6vgPD7dQ+wf7QPqPGndZTyVspPsckrlxtmARpq0v
   Te6+g0dzV4Hq1Ih863dMXVhE3nqVjNpPEG6JduUGBkIJ9CGp1D+pOfjqa
   r1D4iS1UKO8brMZZT7k16QTk14I2M9hTQcwCI4pOF9Z03qUWtBV/JzPLk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297320937"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297320937"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 13:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="683381430"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 08 Sep 2022 13:50:29 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWOTl-0000Jd-0j;
        Thu, 08 Sep 2022 20:50:29 +0000
Date:   Fri, 9 Sep 2022 04:49:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] mm: bring back update_mmu_cache() to finish_fault()
Message-ID: <YxpVYNZrmF/eZjEv@facefcfb2e4a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908204809.2012451-1-saproj@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] mm: bring back update_mmu_cache() to finish_fault()
Link: https://lore.kernel.org/stable/20220908204809.2012451-1-saproj%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



