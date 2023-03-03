Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01416A9BBE
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCCQ2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 11:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCCQ2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 11:28:23 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D0F17CC0
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 08:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677860902; x=1709396902;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=mJfFLqQNlGLKYVGmiqt/zVaRBspmVn6dqILuvq4QdNw=;
  b=e26ixV/9f+VX3FFnOCad7bxP+gdEYdsm22tgDQnoYzoBAT4xG/4x8Emd
   8occVqTL25Yi3lQjzpOcaBNKm5knBELa5P5oJFPZz7nVQ8rov4jvFLc6v
   Nx9sCJpP5b6yK0zk+dCkM2Aqg+qzIFOkASEdwkEGnnRUIQxi24C/+hN6s
   IbPzoTZEcay5zgeI66giNQjK4palPXI6+bByCAZSFZGO+Nq4zIYpeD3dd
   mJ0eKpPwghlbI5Lnr54ynsS7UKbdB6aDCZ6P5p+WDdeRuydZMIDbGMBmB
   XriDUXwSZ6FmqbRlPOUORI3fjUjIZAwSD/ghtAtk+ADvs4mscnqLnrdU7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="314740235"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="314740235"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 08:28:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="818525511"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="818525511"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 03 Mar 2023 08:28:18 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pY8GY-0001Xs-0F;
        Fri, 03 Mar 2023 16:28:18 +0000
Date:   Sat, 4 Mar 2023 00:28:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] docs: add backporting and conflict resolution document
Message-ID: <ZAIgFLJ0tRCxzwjN@5bb25e6b0e5e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303162553.17212-1-vegard.nossum@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] docs: add backporting and conflict resolution document
Link: https://lore.kernel.org/stable/20230303162553.17212-1-vegard.nossum%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



