Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10D5681DDB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 23:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjA3WNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 17:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjA3WNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 17:13:31 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A54528D21
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675116811; x=1706652811;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=Ion2rKDlFD4u8kASATPD8U4gUW8PKTG9lyDZg49MS4s=;
  b=RZYkYA376Y3/7vLs4H4ywNhsPEUAo35ReLQnLT6DaTpFFicbENw9h6tA
   sAOaBfeNSZWvVUW1hM0BSNpQelnldg1zWtTvhrVsjkph6vhJL4yk/abL/
   LCbHNygzwHLoVLwwIas/5agFUcLWDkxLtHxPAw+ZepzACUOqFWJoJCYIw
   BmXHOY/HedJYWbXjaKkEnIEz32xk8Aheb50raNxSc8lXmqPj7pSW9/Hmd
   pwo1vfwgYMzn9N5AU4aNQh00QGrpjpMQ/yl/h9r6rixVGk0REQ/HhOPrt
   FYyX49YfuUTODhAaeORNQYGY7OtNCjaXGO1/nE69QcyYwvFUZe4H3cLlG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392235143"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392235143"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 14:13:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="772701792"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="772701792"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2023 14:13:26 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pMcOu-0003vY-2J;
        Mon, 30 Jan 2023 22:13:20 +0000
Date:   Tue, 31 Jan 2023 06:13:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2] i40e: Add checking for null for nlmsg_find_attr()
Message-ID: <Y9hA+Y3db2AQYvP+@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130221106.19267-1-n.petrova@fintech.ru>
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
Subject: [PATCH v2] i40e: Add checking for null for nlmsg_find_attr()
Link: https://lore.kernel.org/stable/20230130221106.19267-1-n.petrova%40fintech.ru

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



