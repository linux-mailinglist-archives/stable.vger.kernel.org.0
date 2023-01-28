Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C0D67F426
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 03:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjA1CzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 21:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjA1CzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 21:55:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6727020069
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 18:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674874516; x=1706410516;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=7+Mc2omHcntn2HcQV50bUQTth25WOoEsYDN9xxW+Py4=;
  b=jk6DhptLhZbLzYn8Gxa2qaeuoYbmEnzPJZF6RKfqUpkK6bwOAt/4RpUP
   ccprcc8QMX/cUaP7+pHBo1wBme/PGLsAkYJ+KGzlswWeHJBFfq4OGdA76
   eulChNrCLiJN1jvnbr9bzGdC6XQll0gwQIDprkD04lENynvNSnyDtJJib
   lr+86TQrk3Rzaq1zl/b5/LNGvADAgdMWOvNHV2o3wnTQLLAeOhDAbWNFx
   rD8CAopUoyBgiWbQtBDG8EmbOWtIC+CC++tixtc3aqd2cEViL9y5bzq9n
   5YA5bu/8g1x9eJpOUvmvxZ13KQBe8oHIgZpilRa7cEEFI8DCZi82UPALV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="413475561"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="413475561"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 18:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="992283153"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="992283153"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 27 Jan 2023 18:55:15 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLbN4-0000L2-0h;
        Sat, 28 Jan 2023 02:55:14 +0000
Date:   Sat, 28 Jan 2023 10:54:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.15 fix build id for arm64 5/5] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <Y9SOYOaNnbb7zMDW@904499574ff1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ce08524259cc3f1a0eff588aeb5ce6b7105630c.1674851705.git.tom.saeger@oracle.com>
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
Subject: [PATCH 5.15 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
Link: https://lore.kernel.org/stable/4ce08524259cc3f1a0eff588aeb5ce6b7105630c.1674851705.git.tom.saeger%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



