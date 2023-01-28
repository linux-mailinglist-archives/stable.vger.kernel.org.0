Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6387A67F49B
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjA1EOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1EOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:14:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0D1103
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 20:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674879259; x=1706415259;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=uQ0dGdeiBL8YUNXV3TvjJSJ86mqLVPZOiqcfMLDpvM0=;
  b=XnvDSDY8dGMQj3+czMUb88PhHJM6JVzZbg/DDFjZZDY3DeKtwUNfItzM
   o7NsejoiqFILLVRNleUnsIf2Us3gQvF89V15S6pCj5eNGNV4DrkIARdJz
   1+H0lWYC4eI77j0nMIdEk+smGS1dKfS6/tJ/wEVOJLSCwMJgLH7W3M1E9
   QOt6/9PadrHSM1pWksdWOflOaupPZkevqi4auNWd5FQXr9FfrJwPsp46p
   +QUtwvCU0UKskJZTgSNPaLEdEM5L2EfcwUAPFDJGrEWhVDVjZKuFs1FlW
   qFyPJQpwIIoWbdF7F5sbPqeWKIX8fq4qU5rvXnyjMF10bbms9M7tDKq6S
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="310883727"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="310883727"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 20:14:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="908882738"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="908882738"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2023 20:14:17 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLcbY-0000OH-1W;
        Sat, 28 Jan 2023 04:14:16 +0000
Date:   Sat, 28 Jan 2023 12:13:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 6.1 fix build id for arm64 5/5] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <Y9Sg3XGyb35OJZcK@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffaafd3083a1738007a3043b698ec5ac6d8d83d6.1674876902.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 6.1 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
Link: https://lore.kernel.org/stable/ffaafd3083a1738007a3043b698ec5ac6d8d83d6.1674876902.git.tom.saeger%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



