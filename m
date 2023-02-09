Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35983690A55
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 14:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBINey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 08:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjBINep (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 08:34:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6BA60BA4
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 05:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675949666; x=1707485666;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=c6a1woMwScId8bFiEUw9B9h07IJLn2W0UeFa6SHhm5U=;
  b=AObKhRQAYS52dhWtqfyDAR0aHj/Qa5bjBGHUKjDNXpUyzIkJQDFUjz94
   ZtJCoYjfoefohcnglqCme25vLm26/XKb2j7a2yn1GIpjbHBBpGNrobIFV
   7bkEt9q1uYYHmZ4Dc8DFLQUQZ0XK3e/FO9gee/eATUeJyW1N7E46I15Bu
   whbakozVC0y0N3U0n6dP8d+wBJIem+KvSFfHyMcuQK7Yr5cnUQoR9qghG
   aSGYYz7jju/MJnUE/3PIzf9433JtbFvueAS/sv19jhjqRHpQ7Em2yN8H7
   EJVmWEvzs+HvWk10ECey1tc5svgqnyAP38Pyw4NYfW5h6tLPdUcKAkqmL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="310460869"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="310460869"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 05:33:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="698021323"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="698021323"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 09 Feb 2023 05:33:42 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQ73W-00056E-0B;
        Thu, 09 Feb 2023 13:33:42 +0000
Date:   Thu, 9 Feb 2023 21:33:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address
 mapping arrays
Message-ID: <Y+T2NL721QUMl8/a@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209133023.39825-1-qiuxu.zhuo@intel.com>
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
Subject: [PATCH 1/1] EDAC/skx: Fix overflows on the DRAM row address mapping arrays
Link: https://lore.kernel.org/stable/20230209133023.39825-1-qiuxu.zhuo%40intel.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



