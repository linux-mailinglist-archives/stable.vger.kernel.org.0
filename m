Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D861C696AF8
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBNRNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjBNRNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:13:49 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24D7222EC
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676394826; x=1707930826;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=3Z0VR5hYhY9LUYikBks77e38UdhiUwdO2XqkLuXPZRo=;
  b=mZWYAiQz9mYatYJrPGDwJe/Xo4oJo/fhANEI0DO7EhFyGuAQiKSBwRrv
   hdEBPETc6oDBjBiOvaECx1N/TzlKfMfbpGbMXed3NSb/sH1XpwmUo5+xb
   Og0F1EEu/qQYA83YulTmKFeMiEdgAT31HT6Tk/XkS09pJWpRyLQV+YH4C
   Lv5thJ6D80JizAwVTCjU0buFUZxEi9IGSIJhlu2SYpHf7L8YEa39Qd1Je
   Xp1vbPeU41KfdNz7ROdzlnPgmdvcnHHOGcBiMf/nKi9CABWhBXUhlMjzX
   /Kwn14JOvqBJiHO8rJdw/D+yQLEDJq3sAVSUbvH8El/kSuz+uXHpucUZJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395824756"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395824756"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:12:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="998148088"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="998148088"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 14 Feb 2023 09:12:17 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRyqn-0008ff-0K;
        Tue, 14 Feb 2023 17:12:17 +0000
Date:   Wed, 15 Feb 2023 01:11:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH for-5.15 3/3] Documentation/hw-vuln: Add documentation
 for Cross-Thread Return Predictions
Message-ID: <Y+vAuPVnSH1Z34m/@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214170956.1297309-4-pbonzini@redhat.com>
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
Subject: [PATCH for-5.15 3/3] Documentation/hw-vuln: Add documentation for Cross-Thread Return Predictions
Link: https://lore.kernel.org/stable/20230214170956.1297309-4-pbonzini%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



