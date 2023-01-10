Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACD2664678
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbjAJQro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbjAJQrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:47:15 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE961DDE9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673369185; x=1704905185;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=PkhBq/zvP+lRjp86ajagPkVnZzfkI+X9oK4GrUJ4TCI=;
  b=naUQvHKl+ZQ252q6fXdQaUQYJ6Q4Az+fvzUgb+jgHDViGo/9THhqQRwH
   t+qr+ozTbnHd4Y48C4Dsw49OSrQysUcXII2dWBBDZe7o6plL1ojllJS6V
   9Pi8DWFvh7TPx9vZtpCXaacpad7Cg1EuS4BEjuH1/DSXmaak/S67qyKOm
   MkUXFO0ka663Ojwa8tGJvYH8zgch1TkMSso5VYSdA4EKHFqfD/ulTdeYR
   +IPguKEBIB7NsOan6rLUabMHt0BP3r45NMHfopBnBfWCN7Owo1+B1GK/d
   O8YWaYMbE/lvGfBWQadSqzB7IDeQR7FJgTRDgCuhaD33G5a32HlkMe3XY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="387649455"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="387649455"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:43:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="687625635"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="687625635"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 10 Jan 2023 08:42:59 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pFHiE-0008D5-2P;
        Tue, 10 Jan 2023 16:42:58 +0000
Date:   Wed, 11 Jan 2023 00:42:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.10.y] io_uring: Fix unsigned 'res' comparison with zero
 in io_fixup_rw_res()
Message-ID: <Y72VYW1FaqvbCYKm@d82c38c126d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110164044.755234-1-harshit.m.mogalapalli@oracle.com>
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
Subject: [PATCH 5.10.y] io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()
Link: https://lore.kernel.org/stable/20230110164044.755234-1-harshit.m.mogalapalli%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



