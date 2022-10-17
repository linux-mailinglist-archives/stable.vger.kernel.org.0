Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E8E601CAF
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 00:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJQWzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 18:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJQWzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 18:55:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E4804B6
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 15:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666047350; x=1697583350;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=XoUSuw2+PXvTYBtoPJmt7mtCRiWef4NEj6lon4ANn7M=;
  b=aKwAM8wCnc3L3aHkrgUQlHL0VjgEw6uKUvHeaSDKnxTgoLX2nXDnEckL
   BVdn2UVHum/F1crWtJUhucOeGnoK3WNITV+lzts1QIedv0Xv5w0Cbt5PR
   oGvzi4829qS4+ZmmXrnxF9aFCtggk5KqYLOWpHmee5CR4FKq+tWswzrw2
   g5yC2ZAuYOEB7Sz0hmKI9H9FM+LfI+R/vQgYv5j5ODsxB+f5Ib8Ujoxbs
   Z7sow6XvMaaXFrhQJxclOOGMOxkRyBhZ7U13lUaXjjOXk8gIC+mnHm5w5
   572hMW8h8JNR/4nqxZ04jf5JPt2i6W/AkyeATSH8Pz3mNiqHgEwB7nB6W
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="307600982"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="307600982"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 15:55:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="957516698"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="957516698"
Received: from lkp-server01.sh.intel.com (HELO 8381f64adc98) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 17 Oct 2022 15:55:48 -0700
Received: from kbuild by 8381f64adc98 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1okZ1Q-0000yu-0X;
        Mon, 17 Oct 2022 22:55:48 +0000
Date:   Tue, 18 Oct 2022 06:55:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] counter: microchip-tcb-capture: Handle Signal1 read and
 Synapse
Message-ID: <Y03dYZzM6mmJ7N64@cbc4ca7ce717>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017225404.67127-1-william.gray@linaro.org>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [PATCH] counter: microchip-tcb-capture: Handle Signal1 read and Synapse
Link: https://lore.kernel.org/stable/20221017225404.67127-1-william.gray%40linaro.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



