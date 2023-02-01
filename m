Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975A0686E84
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 19:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbjBAS6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 13:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjBAS6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 13:58:22 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A8014E9E
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 10:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675277885; x=1706813885;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=jY9aceRMzA0wn3rFqgUEfrXi1HGUJNTGkgp6+4/alSI=;
  b=BHhhioYphiYADocLQzrNJbxoUzUBhRuA5Z5ZmNswiUYHIy9AHK2vq1id
   fieaPnyegW0tk7zsEPNHaK8vgbq5bclqUfN965aZEGliDfmGsyHpVIf3/
   JuyqsI09q9I0+/3gjiL7+1frgD95kvtim9kqN98HFiPyctNJ7y08ey8lp
   bfA9UCVa5W9YATNp0W450p6WHrZtaZUCV7Kw5MXOgsk8OXBtj4J5IZma3
   PTpg1pKt4IQHMxRs16jWis4u8RzdozKqgWokoJk+MkS2VzfklY+LJJz5E
   k4TrleCmihyCgkAtQGqISpZt+BxvesaD7073Egt0IlDTsI8bp7vGoQGhq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="316240941"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="316240941"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:57:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="753784246"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="753784246"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Feb 2023 10:57:50 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNIIi-0005iU-1e;
        Wed, 01 Feb 2023 18:57:44 +0000
Date:   Thu, 2 Feb 2023 02:57:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel Kolesa <daniel@octaforge.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] drm/amdgpu: drop the long-double-128 powerpc check/hack
Message-ID: <Y9q2I2bvF54ioQ1a@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dab9cbd8-2626-4b99-8098-31fe76397d2d@app.fastmail.com>
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
Subject: [PATCH] drm/amdgpu: drop the long-double-128 powerpc check/hack
Link: https://lore.kernel.org/stable/dab9cbd8-2626-4b99-8098-31fe76397d2d%40app.fastmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



