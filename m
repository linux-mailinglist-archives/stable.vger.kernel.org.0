Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3055D63D059
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 09:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiK3IXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 03:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbiK3IXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 03:23:07 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F7359855
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 00:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669796576; x=1701332576;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=5xilRVBAuThtmGzTq8Gww35RWKPJJa0ZuNw20LbAWc0=;
  b=FsFmVfygqTUMn7xM0e3OFp0hQbizqL165lgiosddr2XYWuJx6nIhi4eI
   cyReft9HXJuyai/2BvZqTNQFPylnqdXGFEtpqnTzivVMy+pOc1pKDzR5M
   QHQHNy5pgIyBU1wrGEx103jD9MXbJohcY74Tgf+Wr5DmkBp+Vcq15Ufis
   mSK/Hf0Vv4dO0IlgDSfVxG9kcYTznzkwxldRx9BVy1cExVRCngcQ2cSkl
   U2Apd5awP/jxhZEnsubYD83K5yOlwZ5kwpRHdHc+J+M/bBjls42hwGmz4
   38fzyUnqNbkzwhv7xlc+z8Ju/Gs9dhhCXXJJEM3ypxa4E7e8VpagrYLfS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="312955245"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="312955245"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 00:22:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="889199635"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="889199635"
Received: from lkp-server01.sh.intel.com (HELO 64a2d449c951) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2022 00:22:54 -0800
Received: from kbuild by 64a2d449c951 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p0IMo-000Aqr-0u;
        Wed, 30 Nov 2022 08:22:54 +0000
Date:   Wed, 30 Nov 2022 16:22:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 net  2/2] vmxnet3: use correct intrConf reference when
 using extended queues
Message-ID: <Y4cSx2xpF6v4Non6@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130082148.9605-3-doshir@vmware.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [PATCH v2 net  2/2] vmxnet3: use correct intrConf reference when using extended queues
Link: https://lore.kernel.org/stable/20221130082148.9605-3-doshir%40vmware.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



