Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC02600530
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 04:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJQCWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 22:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiJQCWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 22:22:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0023ED5D
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 19:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665973340; x=1697509340;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=HNE97a26UMlYd3QReAnSc5yf3eqgOP+Y9A8/IDa/27Q=;
  b=nnYzLgNOTO+L86PxqW2caVwpxbzDHA7dbCnSFW3SMDqpSfwzpPrsecZn
   iEN5GLIOlHZ34wSMq9TRtk7HBlHoaSdNfqa3aJ0xr+rWRJQmp2Ttdf++p
   aNHSJvTPie3CfKVOxloxNEx1ixFm4iiXcX06gBKunoD7T3aCsS0I86/Wk
   q+GTBcYHHxrzwlC7qrHtpLeobK7aumII6BP4JAHWWz15Mho7SFDaVQyxZ
   y0S3Mkt5CVtNjNAENWYlO8f1gWuFqk+drcMNplrweYnCii2yAY8k2Q07F
   6CXYsaa46tBazuSZTtu/xOKzzO97mpMElxAtUHGwD8fmZgVciLsR73kXX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="303301508"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="303301508"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2022 19:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="873301807"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="873301807"
Received: from lkp-server02.sh.intel.com (HELO 8556ec0e0fdc) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2022 19:22:19 -0700
Received: from kbuild by 8556ec0e0fdc with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1okFli-000043-2q;
        Mon, 17 Oct 2022 02:22:18 +0000
Date:   Mon, 17 Oct 2022 10:21:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table w/
 link
Message-ID: <Y0y8IqEr0SIxHNvl@cbc4ca7ce717>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014171040.849726-1-ndesaulniers@google.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Subject: [PATCH v2] Documentation: process: replace outdated LTS table w/ link
Link: https://lore.kernel.org/stable/20221014171040.849726-1-ndesaulniers%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



