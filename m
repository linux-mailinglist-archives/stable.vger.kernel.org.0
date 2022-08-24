Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D3B59F1DD
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 05:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiHXDL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 23:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiHXDLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 23:11:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAEE8F95C
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 20:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661310437; x=1692846437;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=+garnPMs82qtTurEc2O2B7+V4tqYSfFmV1KfVd4STAQ=;
  b=Oo5eWXZBTdrPYNA5PgciWI5siy7zANwFz3Rt54uwox7rRhps2IsQipBV
   ohKpSUIGVD/oBRpwT1cUuFLouEwjudKK40qMosI28ZxpJxFv/yHE58472
   LaxnLC3a3ZS/J3PD4Uklj5znXbmjEROkZR7ZD40EnBWgyhHHGcVUvuijl
   +6Ii8g8L4KvnZWdaTElG02L4tGJbs5FPLytWhY0zlc/9+Qxs6+B6RYZat
   F/C0jaMPHcM2shk6zlRQeWygl5N/nJUmu+n3yB5ZSiRKCl6fIiebvPftj
   5cZZkLsRnZtdZlnERRYC8mTaguuoxLucZypqcNUI+er/dGhUHHraqvGtE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="294640271"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="294640271"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 20:07:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="670309745"
Received: from lkp-server02.sh.intel.com (HELO 9bbcefcddf9f) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 23 Aug 2022 20:07:16 -0700
Received: from kbuild by 9bbcefcddf9f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQgjb-0000tv-1H;
        Wed, 24 Aug 2022 03:07:15 +0000
Date:   Wed, 24 Aug 2022 11:06:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v3 3/3] selftests/hmm-tests: Add test for dirty bits
Message-ID: <YwWVp83+9Wd5GbCV@b1a0c294b6c5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e425a8ec191682fa2036260c575f065eeb56a53.1661309831.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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
Subject: [PATCH v3 3/3] selftests/hmm-tests: Add test for dirty bits
Link: https://lore.kernel.org/stable/8e425a8ec191682fa2036260c575f065eeb56a53.1661309831.git-series.apopple%40nvidia.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



