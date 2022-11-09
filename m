Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE3F622139
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 02:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKIBMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 20:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKIBML (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 20:12:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9919D64A04
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 17:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667956330; x=1699492330;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=IDiP8Bajv6sQOr6ZCHUZaZFcQ/MzEpa8/+6LjcKF0Lk=;
  b=AfCeCcWKOi2ZIlU3kqnqnD/sUvp62CQfulmUEor+ODryWWgwDhNvRuo0
   9MIAx0JZBZwb1Um+f1y4fG/xPTzUaXMR46HlUOTunJtKEFqqaSscgmTuz
   Sy/zjv+7yLi4mYAdXpLA4g+3jjBJtFKahaL1mY53rCMWGR64YlO0S+daG
   7hotCKiqHu1hdqhI35bS5tWg8s2N7R+nUiB2aa1mVzbXIYG1YH4YdEpCZ
   OAeUXHPiCsUqq9O9+btcjEn6tmHLJAQKZTgT0pDl2BIcPvSj8mMYhgDxc
   M0KNYmeWZ/GUlYidb/+nedankwlSomgTCEI2cjEP1Wdb22F1cTNHRoZcV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="375128394"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="375128394"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 17:12:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="614484465"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="614484465"
Received: from lkp-server01.sh.intel.com (HELO e783503266e8) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2022 17:12:09 -0800
Received: from kbuild by e783503266e8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1osZdQ-0000rE-1O;
        Wed, 09 Nov 2022 01:12:08 +0000
Date:   Wed, 9 Nov 2022 09:11:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peng Zhang <zhangpeng362@huawei.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] udf: Fix a slab-out-of-bounds write bug in
 udf_find_entry()
Message-ID: <Y2r+Ths//T0za2rl@9c6a254c5b7f>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109013542.442790-1-zhangpeng362@huawei.com>
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
Subject: [PATCH] udf: Fix a slab-out-of-bounds write bug in udf_find_entry()
Link: https://lore.kernel.org/stable/20221109013542.442790-1-zhangpeng362%40huawei.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



