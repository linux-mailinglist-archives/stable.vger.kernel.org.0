Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78E5AC478
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiIDNVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 09:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIDNU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 09:20:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8552A26D
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 06:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662297658; x=1693833658;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=V6AD01z9fJJphGnpw2+GTGDvfh/RO9iL9SIXQF3Xudw=;
  b=JddmAy2FRWp6t+zVPNy74Oo7Tx7pXQfk7m5tEX7QWL4JxYSSrUYSY1Uv
   SXU8zexBSRCBLMgtNH/L6nkjokpYsVSpO65VZwU9bMi+G5oqvuAnR32gO
   3h6hO05/3RB+HTkPzhmA+fPzOuPh5Jo/NWWpzGOmEcBkSP1f41HJT4LJX
   JkLYs/MGWtT42UxioVDmBCYQ8BqY9O7SNBSh8n0Lgo+aEZVtvQuzUVSVB
   0bijJnnsPb+hdDZQXLrbgwfexnhUiWqTedK6fp+1jje7ZbwpVXZugEfks
   lZTivu6MrD8RH/OBadp1DYc1jB84WWGKHIi1O6wX7ad9drEqzPDu7U+C4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="297026979"
X-IronPort-AV: E=Sophos;i="5.93,289,1654585200"; 
   d="scan'208";a="297026979"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 06:20:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,289,1654585200"; 
   d="scan'208";a="941809856"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 04 Sep 2022 06:20:56 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oUpYV-00035h-2U;
        Sun, 04 Sep 2022 13:20:55 +0000
Date:   Sun, 4 Sep 2022 21:20:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH stable 5.15 2/2] kbuild: Add skip_encoding_btf_enum64
 option to pahole
Message-ID: <YxSmMFXC1a02zBDn@876d715a1888>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904131901.13025-3-jolsa@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH stable 5.15 2/2] kbuild: Add skip_encoding_btf_enum64 option to pahole
Link: https://lore.kernel.org/stable/20220904131901.13025-3-jolsa%40kernel.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



