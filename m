Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB05688DF5
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 04:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjBCD3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 22:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBCD3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 22:29:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3ED210B
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 19:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675394971; x=1706930971;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=MuNV1TIMvNcl/UhWhouvSOMpjN7l8eq83kLUPAvY+pQ=;
  b=daSFa+U8L+OUztCH36hnukjFQcTn20ShZK7IgvvjiXbc77NXh1MesW3q
   zpCjwJ6FycyhHvvVXKkyUv2Px3PbSJ7hxdK4UZEpTE2EOIExNsnblPr+x
   T1lMTkokkO3g6mT3yiMmAslH/yNl05weS5VcVgwOOhRWYwElXcFXB1VOG
   qjzlJvvOgRY1Der7dao9WQXY3HYiDScDm2X3oZoWKXEXIHrilm8KfLeSE
   i86LhRsrK5Hdw8L7N42tDj3pfinLMigwmDbllAeyeIjv8IHaHgfKO0t8s
   D/CuniCtoKBv0zZFI/om0AoBpCO9a0Pvkj9ZO8yIeoQzrTlrhReR1H76c
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="329931572"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="329931572"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 19:29:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="774151085"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="774151085"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 02 Feb 2023 19:29:29 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNmlV-000025-0F;
        Fri, 03 Feb 2023 03:29:29 +0000
Date:   Fri, 3 Feb 2023 11:28:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2] bcache: Remove some unnecessary NULL point check for
 the  return value of __bch_btree_node_alloc-related pointer
Message-ID: <Y9x/YmU23HV4N1W3@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203032750.578589-1-zyytlz.wz@163.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Subject: [PATCH v2] bcache: Remove some unnecessary NULL point check for the  return value of __bch_btree_node_alloc-related pointer
Link: https://lore.kernel.org/stable/20230203032750.578589-1-zyytlz.wz%40163.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



