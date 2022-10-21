Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14049607B5F
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiJUPki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 11:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiJUPjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 11:39:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0858827D4D9
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 08:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666366665; x=1697902665;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=fB73eeu8mN391ayLOs4s5o2Nf7ZFJ8cHeeiPUEo1F18=;
  b=mpeu5weCpOVS0TiRlJlHCBMsLNjtmpqBkCO+hHIfjdjifAxAc6uViE20
   T8inlcC2veVMQJSjAq/9nk3WG6AObZUuJH0vVDhj+CLrCmy/t76iiIXy0
   qL1YV8x/oecZXSx9Qi575lFdW4TMdaMYnjVQA8G/iGSYwV/9vqTFLsfLY
   yyRk/FUAlDg7vvsUmAni1Ra0AUivwaNHci0J826vTTS2BVoyxDohMW6z1
   oEC6tfufNz2FFH6jYRyo6WyR3304yeoZg4P2E0yPubEKrao39XxkBmuhb
   g2yk5a1BoiuDZWQqTfGWIuPuj0AqO2TAQc7YOxcK071LggvxKNBKlTFo5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="305766290"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="305766290"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 08:37:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="661650911"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="661650911"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 21 Oct 2022 08:37:30 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1olu5R-0002jV-1S;
        Fri, 21 Oct 2022 15:37:29 +0000
Date:   Fri, 21 Oct 2022 23:36:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joe Korty <joe.korty@concurrent-rt.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] arm64: arch_timer: XGene-1 has 31 bit, not 32 bit, arch
 timer.
Message-ID: <Y1K8hEXN2YLVvG0t@dba927f25f90>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021153424.GA25677@zipoli.concurrent-rt.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] arm64: arch_timer: XGene-1 has 31 bit, not 32 bit, arch timer.
Link: https://lore.kernel.org/stable/20221021153424.GA25677%40zipoli.concurrent-rt.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



