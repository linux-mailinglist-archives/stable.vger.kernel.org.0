Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689146E3083
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 12:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDOKPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 06:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjDOKPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 06:15:03 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5D04683
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 03:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681553698; x=1713089698;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=1C0mHI+agNTFHBpkndFOsXgcZwA3eL5ojftjvt4vIbk=;
  b=X0Oz+mwUZw3cnizzFdXug77vPOT38ipkLKVChsxSgZhoydZOgTxiAThq
   CE5hBb9mW1WjcWGa+OISXCoso77meWF53c0H1xuWMC3WbTNPmvnEd1dy4
   3gKQJZ59yRyWj7Zih0vIfJ9b5lG0maf/G87FZ+gfrDOwG8INItVX/NIT0
   pxlxHLkO6IxClInYzIRvfQqwlK85nQutQgcCi6IwukWeAZbUdd8AHv+2L
   NzMRtGJ860YIcyCZIifviaAfl6OhWxokE0/wZ03bBUyc4aerg9jdJ7wPy
   XerQwahF2H/6e6CY9A4iX3nDyBubM5Rg22ofWSyU4CttaZBrfiUsUy0Ct
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="333421515"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="333421515"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2023 03:14:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="759426389"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="759426389"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 15 Apr 2023 03:14:28 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pncvL-000aqp-2i;
        Sat, 15 Apr 2023 10:14:27 +0000
Date:   Sat, 15 Apr 2023 18:14:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10 1/4] crypto: api - Fix built-in testing dependency
 failures
Message-ID: <ZDp48YsrIfYVFReR@96b608206aa4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415101158.1648486-2-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.10 1/4] crypto: api - Fix built-in testing dependency failures
Link: https://lore.kernel.org/stable/20230415101158.1648486-2-cuigaosheng1%40huawei.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Please ignore this mail if the patch is not relevant for upstream.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



