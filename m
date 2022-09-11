Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30975B51C1
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 01:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiIKXDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 19:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIKXDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 19:03:15 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7759422BDD
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 16:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662937394; x=1694473394;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=CyvqSIqedvSv/6SYgC4uLqX60tKlkiL5yOMZV8wNwKo=;
  b=CeeWoBE537z0ID/UvKP2+gFrqckJU57gW8Y3EPiyrT76eKJ8mgy1R2kB
   cvhWeQktA1CUtKmp+L1qVHaAspu17qE4SQzCAgDDe+SPiDY15RRK1OZev
   scZU2dBfaH+TovPuwVRPlZKtsfbguk5XGjOhtT0HVXlBhkttIdSZekQc6
   ltajDwIXrGi+RT0U48vfyzxGeJ3U94vr+NziyFvncqsom5ujd5Jvx/A5X
   65CABdy1TWJmQMi9WRGv14AvRoblWWGHuDpnXjeNA2AUJ2szlzZ4g24v0
   XR3Utq99gfz6lpxmhn5ReWWf6sY/cxttndPlkTl7y5lfsUy97tqapw5zJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10467"; a="284777614"
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="284777614"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2022 16:03:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="704979314"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Sep 2022 16:03:13 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXVyq-0001wG-1U;
        Sun, 11 Sep 2022 23:03:12 +0000
Date:   Mon, 12 Sep 2022 07:03:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     NeilBrown <neilb@suse.de>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH - stable] SUNRPC: use _bh spinlocking on ->transport_lock
Message-ID: <Yx5pLWZjWvCiOf+W@facefcfb2e4a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166293725263.30452.1720462103844620549@noble.neil.brown.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH - stable] SUNRPC: use _bh spinlocking on ->transport_lock
Link: https://lore.kernel.org/stable/166293725263.30452.1720462103844620549%40noble.neil.brown.name

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



