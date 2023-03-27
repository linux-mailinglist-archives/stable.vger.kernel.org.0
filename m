Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66F6CA8A4
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjC0PJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjC0PJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:09:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777D444B3
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679929757; x=1711465757;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=cd7ixFbbLsyCU+q2G1WCUjK0TTArODU1ZCZ0BSb/+wQ=;
  b=XNUObkZMyzabAhmFt6Abx+Y1vw2K1PP7T0q28llQc6GiB6v07Ldmbsdv
   MXYqg2hs3qz3OLJwlK1v9fsPOYg+HVr5i0ZL2f0VeqzeNVcK3dYKkgzwe
   jKFykCjmrW5Yj+O+YjCcsHkicRbdZs6VuQ49N05QS5y9T5QbCkQ7GJkkC
   SKXn+xUjBk/mmc/X5Q2NcAveXUU1cBtgI23bfGNFThvdQHXC56f66ZJSM
   AzAGhlOwIGWjGCcOjzMFYBj3YTWtxw5RUe24ohjTwYIT8qPTmB+BpB/6E
   4Herqc0Ypb0wABv6h9dDpzejghqpT97Rsu4fqBmhjUhaJMTdnMVB4s6y1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="337791644"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="337791644"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 08:09:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="772746713"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="772746713"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Mar 2023 08:09:16 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pgoTC-000HnL-2v;
        Mon, 27 Mar 2023 15:09:14 +0000
Date:   Mon, 27 Mar 2023 23:08:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v4 2/2] x86/purgatory: Add linker script
Message-ID: <ZCGxfEx8M6lsOmC3@0f0c699f4fc0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321-kexec_clang16-v4-2-1340518f98e9@chromium.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH v4 2/2] x86/purgatory: Add linker script
Link: https://lore.kernel.org/stable/20230321-kexec_clang16-v4-2-1340518f98e9%40chromium.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



