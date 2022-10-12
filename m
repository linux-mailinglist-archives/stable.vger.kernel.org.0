Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E15A5FCBE4
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 22:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJLUPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 16:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJLUPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 16:15:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE6F38472
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 13:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665605748; x=1697141748;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=YuKw5N4sq/HD1dWBqpdbFqcm7RLAoAtzmEPoA2gTdik=;
  b=n4DXeVy7Wp2NX98pwF+7jIlNg/A+F8n66XXtYUwDdL4mR9vMOXUpvaQ5
   o40cHIhW0MMj4LTJxaRESZ7MT5LUuQogOw3oIBdqfynwEKizcl6ao9DlK
   jrNVJ36sXygYg5OHk4IvMf1luWLictqH5gv1nY/Z4N1wbC4uVEYBTCKcF
   SW3ApCvWKB+Qq+hB92z0CauRO2IYJ5K6o4UnIxOfhrZLsyQfilUgwnwYx
   5zTZCHindv/YUco6djs2W9BRdUEzwAHQodKUx+ooPf7n9o9Te8h5/hyGw
   XHHR3YjgaLIIFUGCP5iXbWaWzzcLF/EBNXpsZyA4+AK92dmLqspCU9nhb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="305959678"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="305959678"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 13:15:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="577958703"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="577958703"
Received: from lkp-server01.sh.intel.com (HELO 2af0a69ca4e0) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 12 Oct 2022 13:15:46 -0700
Received: from kbuild by 2af0a69ca4e0 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oii8o-00048x-06;
        Wed, 12 Oct 2022 20:15:46 +0000
Date:   Thu, 13 Oct 2022 04:15:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] dmaengine: idxd: Do not enable user type Work Queue
 without Shared Virtual Addressing
Message-ID: <Y0cgaLG05R/enXAk@6594fa6d681d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012201418.3883096-1-fenghua.yu@intel.com>
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
Subject: [PATCH] dmaengine: idxd: Do not enable user type Work Queue without Shared Virtual Addressing
Link: https://lore.kernel.org/stable/20221012201418.3883096-1-fenghua.yu%40intel.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



