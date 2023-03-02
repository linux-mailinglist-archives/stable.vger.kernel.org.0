Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4616A8B85
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 23:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCBWJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 17:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCBWJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 17:09:39 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DBE9750
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 14:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677794978; x=1709330978;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=3BAXfAVqk1f5v8SC4ZDHFMqkj906qjSEk4yxiRB1IeY=;
  b=MUSw4er9y/oXCwq7BhRvQSNNI2keRSIrzB+v28Fv/cqkX++ZOz4sMpNl
   XWhvTsCQAzgpk0hVUANYUC518dZMGA9whm0zTwClcJtOmTWokL8WaA4ye
   16ga8CoxVfL0G1IMcIRBL8Z5SPv6wBgQ12q3XQi0gk+gkwsGdi9xNCBqp
   eYQIbwkRr2vUoS1wN5PBymlDFeIEAHQUWa4BmlM4E451wLXYpS4wOlYCF
   Y+WfFRxDXgLsT0y1hrNLAzxGwizXOXx6x2Rp8kWIOkzhElHQPf4jt/0OG
   0SnmNXYBddPTMQUVvB3PoBooYu5l0BkxZNO6MK9zJ0JmRdx/pgENo8mKR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="315278330"
X-IronPort-AV: E=Sophos;i="5.98,228,1673942400"; 
   d="scan'208";a="315278330"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 14:09:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="1004330752"
X-IronPort-AV: E=Sophos;i="5.98,228,1673942400"; 
   d="scan'208";a="1004330752"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2023 14:09:36 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXr7H-0000ve-3C;
        Thu, 02 Mar 2023 22:09:36 +0000
Date:   Fri, 3 Mar 2023 06:08:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] gpio: ws16c48: Fix off-by-one error in WS16C48 resource
 region extent
Message-ID: <ZAEeaAajyZJf77pG@42ed42284782>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228081126.94280-1-william.gray@linaro.org>
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
Subject: [PATCH] gpio: ws16c48: Fix off-by-one error in WS16C48 resource region extent
Link: https://lore.kernel.org/stable/20230228081126.94280-1-william.gray%40linaro.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



