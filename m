Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047AA5A08A2
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 08:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiHYGG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 02:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiHYGG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 02:06:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2EB95AFF
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 23:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661407587; x=1692943587;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=DMLjyH2qcXuuTTcpA3FVzokAdTwbj9vd+Fddx96vos8=;
  b=BfI2C6aPHemZjR3paRC2XoHNHRJdFNwUylDKVEwEslFhsUMKorHI3oF0
   U3Xg+GsCuu9i/5sncWMDWwdtFYBD4bA/zSVwcFMp+C69DUn3v5cjCu9Ft
   14Y0y2uiVCOAA7ViQCRuUB9/JybGbn7J1qTQyqVzckXk4bCfoRafMFd6a
   twEkcKTE8Y7EIAjRax7Pt2PU/Q7RvPG92gi/f9hmFXZwBIPhzzr0VcN4K
   62UCoS9kUB+ywhDMxyfRQTPTcqqAF+1oeXqGpPVJnLP/hFdXkwrj3J90J
   bj9gs8sECTPFgxgy0YdOHu6lCw/XH2UGW9+FSNMEHQh2fPQABIX36XU8o
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="355880319"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="355880319"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 23:06:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="670832367"
Received: from lkp-server02.sh.intel.com (HELO 34e741d32628) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2022 23:06:25 -0700
Received: from kbuild by 34e741d32628 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oR60W-0001lb-2l;
        Thu, 25 Aug 2022 06:06:24 +0000
Date:   Thu, 25 Aug 2022 14:05:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Adrian Zaharia <Adrian.Zaharia@windriver.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH 1/1] mtd: mtdpart: Fix cosmetic print
Message-ID: <YwcRLLuoMg7wGpRa@b1a0c294b6c5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825060407.335475-2-Adrian.Zaharia@windriver.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
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
Subject: [PATCH 1/1] mtd: mtdpart: Fix cosmetic print
Link: https://lore.kernel.org/stable/20220825060407.335475-2-Adrian.Zaharia%40windriver.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



