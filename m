Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64D967F425
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 03:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjA1CyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 21:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjA1CyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 21:54:17 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE1B1717C
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 18:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674874456; x=1706410456;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=PypngMrrFwhJL0Kwt6te9i9ZVeh6uthQkHCgL5Uiglk=;
  b=F9/mY6wrzNLN+pZ086f/tienp030CvX3RyYQx/FU9HJWfQKHLz41TWzs
   frWDjfawqiOUiStROpO150bVtsDl7HMyK/f+sqmNtNQ8rXouA7rG/QDt0
   g57lfXp2mN9MdPlL5rr4CEYeXFz1GAvZBOyb9+eIBjvOL9DzqHCDOzp63
   kzl6o4HbdChEkoMpEXudrXhScK5XyViLBNYYNPGS1ee8wXzHxvga6CX5Y
   c3MT2cbNk3/MwBGTevckGReDD0x9IKoN6Ev0NiWCEoXROMTXiDQiS8Tit
   fDj5zJhrztWEIAOeT/HMJtfmAfNAYguc+FwO+BsYiXALBPJiemMCs4pGK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="413475491"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="413475491"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 18:54:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="693923843"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="693923843"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 27 Jan 2023 18:54:14 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLbM6-0000Ku-0R;
        Sat, 28 Jan 2023 02:54:14 +0000
Date:   Sat, 28 Jan 2023 10:54:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10 fix build id for arm64 5/5] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <Y9SOUwRrhh5x5SJs@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c605722f1659d93d0e95402723830cf7bc74e145.1674850666.git.tom.saeger@oracle.com>
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
Subject: [PATCH 5.10 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
Link: https://lore.kernel.org/stable/c605722f1659d93d0e95402723830cf7bc74e145.1674850666.git.tom.saeger%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



