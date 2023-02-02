Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE2687EC6
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 14:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjBBNgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 08:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjBBNgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 08:36:49 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B25779CA5
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 05:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675345009; x=1706881009;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=ofKN6pdYNSrQbvweD2jq4mGqjgTfrQID4aanb98QxhU=;
  b=gA2ohzBpgtcNdpZA1o4CZG0QQF7LdxJZ3u0CaHEQI9QBhVFDRk+D1pfW
   //V69DxRRnyjeDMlOSdkDob3Q0Px7EO4w78DKcwDeRkUAV1GYqjPxUn1s
   gT5ZCf59rIJM3rhx+Ep9eCJEhZC5HmjaFcisdNHn1jjOHkM6WC4RsvEkJ
   Cja/xeB3W8Jb9TtEzm2PdQQ8Aunx0m2gWNGy7R2NLbMl5VcGwBqW3/8eZ
   LRLFPcSx+LDFlPUlbtxALOkRM1WQtepOaxsPh1tu0EIDo+r/wm2nZKG0l
   UqYJ4D94+gxLtoVYcuqEN9asXobJhCm/mzPntIMUPItcPHGWBzX2/4PwI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="326140985"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="326140985"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 05:36:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="615284358"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="615284358"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 Feb 2023 05:36:33 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNZlQ-0006YC-1s;
        Thu, 02 Feb 2023 13:36:32 +0000
Date:   Thu, 2 Feb 2023 21:36:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 4.19] cfq: fix memory leak for cfqq
Message-ID: <Y9u8VnupyG2jPXjM@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202135850.2415165-1-yukuai1@huaweicloud.com>
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
Subject: [PATCH 4.19] cfq: fix memory leak for cfqq
Link: https://lore.kernel.org/stable/20230202135850.2415165-1-yukuai1%40huaweicloud.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



