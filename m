Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5573F664689
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjAJQvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238669AbjAJQvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:51:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338D5203B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673369463; x=1704905463;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=BAd06rtmMXFRaSqKZ0oSUYvyH0olKfYhzZL/Ml6ObJE=;
  b=iPPMS/cUokwtKa48I6+BX2Ha/u49rdxQ6LJFFRwmVsLRZmeCSTyAN/fY
   yHIJfBhiI146AyRgRpxelKWNVm9JZj6HJg2eBTbw+OH0oZMpGuERvqL2d
   ZprNjUgcSUgG+/8gmlAo7lqM/5yP6cFEn40EJYZf0IQTLPP4hznO3LMjj
   03ve58d8xXn+sTOkunmRBKFpy+8jwHczB4kxFMEF2gxiwtD2xqkpdoCsJ
   W2R0jt9xFsSN1Ocx+HcmFqCs7aConifDXsfYmCli+1NFpHJYUYKCLVu2G
   dZ7ltLUt0BU9Y34WnW15SECPqPclUrrKGUOxLs+H103y+EIEgNVQ+UQsV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="310997794"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="310997794"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:51:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="745838371"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="745838371"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jan 2023 08:50:59 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pFHpz-0008Da-0a;
        Tue, 10 Jan 2023 16:50:59 +0000
Date:   Wed, 11 Jan 2023 00:50:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.15.y] io_uring: Fix unsigned 'res' comparison with zero
 in io_fixup_rw_res()
Message-ID: <Y72XbqncuE9kRqKJ@d82c38c126d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110164647.755556-1-harshit.m.mogalapalli@oracle.com>
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
Subject: [PATCH 5.15.y] io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()
Link: https://lore.kernel.org/stable/20230110164647.755556-1-harshit.m.mogalapalli%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



