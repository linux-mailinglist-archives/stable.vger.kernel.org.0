Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414315AB4BD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 17:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiIBPMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiIBPMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 11:12:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57955130A0E
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 07:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662129715; x=1693665715;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=KHELKon6tAPeaiGieUR1l95nkZ4Z9JCYIPgZsmbS3zs=;
  b=WyREVZ8DJDLzvTByE3Tb4hz1rwu+1Wav6cNcBAIaP/bOFg2T+9G5xpvN
   vGIBYKome/Yq49qPH/UltKB9L/WXG0OEbS3o4y11t5Xw8kcIBSq3QZGDl
   5WQb1vHji4fSvz9ij6prwk09iruME+ZloLz95I5eXXUONkUZ5R/8/09CY
   7p+XG+lMVvr23jlnJCiEoyaM2OeEcYWg3d1NkF6AqVidyR3VMKbTPvzGc
   FlAlKDyArpvj3VK5BXIhg+XsifHECSa3rch1EPKbUI45E1eHihQ4GyxjG
   uvtrVx1h80hVfgbdEVIHJbSVIw3RA4DL4c4a+wDbI0b+Qa7kUCfaBMavq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="282980548"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="282980548"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 07:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="642927698"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 02 Sep 2022 07:41:54 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oU7rl-0000CI-15;
        Fri, 02 Sep 2022 14:41:53 +0000
Date:   Fri, 2 Sep 2022 22:41:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Varsha Teratipally <teratipally@google.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] ipc: replace costly bailout check in sysvipc_find_ipc()
Message-ID: <YxIWA7QIiPsgX1o8@876d715a1888>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902135912.816188-2-teratipally@google.com>
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
Subject: [PATCH] ipc: replace costly bailout check in sysvipc_find_ipc()
Link: https://lore.kernel.org/stable/20220902135912.816188-2-teratipally%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



