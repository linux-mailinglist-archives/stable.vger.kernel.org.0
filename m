Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7946447DF
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 16:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiLFPVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 10:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiLFPUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 10:20:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B13EB1
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 07:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670340006; x=1701876006;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=px51s1I8Q20++rz+44sqxe8BinnmrgYrIMOiGxLwkog=;
  b=csQVnbIj/9AXXv8SGQXGslJtErg6pMIIc7IaNUsPGgMD1KRBRgjVhgMj
   zQT0vsmcu9SguFnk0fpvv2ZIuNiytd92PUaY7YRJqwDZSJYS6P2PhFhEJ
   I42GRWRjbsVm7KLQ6OXxazdAaKOLd1xCYw5Zjdt0j/PHa3EUthlRouIdj
   P779l15EEK1y8yKPGUsa5GSvcSoN1cK9bs7CM5anegindUff+Ce6ul36k
   1ynwsfD8F53389V7FkpEGZRdONYnHWkWwPRgObX5nVzGLZj780/1LD6oi
   4hyIPEq+BN9xj5mVTRP4dduEF4+3trsBhNovoCia6Wkf6QNdlaPJqZh5G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="297003681"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="297003681"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 07:19:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="770755357"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="770755357"
Received: from lkp-server01.sh.intel.com (HELO b3c45e08cbc1) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 06 Dec 2022 07:19:08 -0800
Received: from kbuild by b3c45e08cbc1 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p2Ziu-00011J-0W;
        Tue, 06 Dec 2022 15:19:08 +0000
Date:   Tue, 6 Dec 2022 23:18:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] net: dsa: sja1105: fix slab-out-of-bounds in
 sja1105_setup
Message-ID: <Y49dO6qcmcWfZ+k0@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
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
Subject: [PATCH] net: dsa: sja1105: fix slab-out-of-bounds in sja1105_setup
Link: https://lore.kernel.org/stable/20221206151136.802344-1-radu-nicolae.pirea%40oss.nxp.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



