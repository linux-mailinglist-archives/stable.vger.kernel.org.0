Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9645BF464
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIUD0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIUDZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C54474D2
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 20:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663730757; x=1695266757;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=9RMUpyr6/pLf4U3hotm4gFB/LvflIdW8Q/3Il7bBwt0=;
  b=Y2PFdBmoNv4rZXRSBs8EAHGUy4HS3NTDlO8mYuWtODglJeneVtGKH7Kf
   6UfnRlMCE0DF1uWwFPAes5aIGf9JiOOdNUr2DxlZ4xHPfDymNKed5ICUf
   yQ+MPEXSpFr6dGzvNXcPoR02ZnM+7W5EO4G3MNBurq4TXI78o3PuSp+fl
   pIabJi9pox0xTsHVx4o1YQDl/0ZwsUvoOnED96JOr988AaMTSd7LPdLdy
   lujzYTt3OqCe3jgD2XLYKvmCVr174NqecuFi6Zhvid7TlLpjjax8lMVGn
   /k3M0k7sRex3Zmyo6I/zaOKWIYYmhuaaQcEh0Z/Y6A/JQa6eN5JgnO6tn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="326198144"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="326198144"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:25:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="570357568"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 20 Sep 2022 20:25:56 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oaqN1-0003Bp-17;
        Wed, 21 Sep 2022 03:25:55 +0000
Date:   Wed, 21 Sep 2022 11:24:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH 5.4 01/17] MAINTAINERS: add Chandan as xfs maintainer for
 5.4.y
Message-ID: <YyqECm2aBtFS7cig@2e39709a3c0e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921032352.307699-2-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.4 01/17] MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
Link: https://lore.kernel.org/stable/20220921032352.307699-2-chandan.babu%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



