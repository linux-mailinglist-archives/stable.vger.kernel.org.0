Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8522D6098A8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 05:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiJXDUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 23:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiJXDUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 23:20:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC431837B
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 20:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666581456; x=1698117456;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=I5FGfjIwinQKGDzAzFYTfcD0lUVv4TDOS8NA1RFPTo4=;
  b=Z5+qj8TMSO7hknUUogV1VNq0F2yaX8cdSu5rELAlO8eHWsRJv/tFS+JC
   aAQdUG1itodYCapvTSrge8CF6ngG3Xd/PU1yjm4/WmS3p3Rf3sURjc5dV
   1XqSw5f7IbPnNeZiK6+0l77HydepiwgxqKY07xKzCkGewdbOsldhde4YY
   jyvu4a67dt/OrYEYis6ek/OT1MC+Jd/BRwTyPfPaeUXLGwN3TpK1K1cQN
   /Fdlk7cxIB5dchIht0hdPNKzAZ3UUP1+Vx46pP8Wyd1BhwDcctjJFy3FI
   FuBzLyrIdGdvxj0SlDIByo1MZJrO4ISApFxEJ9CJHMCthvnPnZqEBY1j7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="333913162"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="333913162"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2022 20:16:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="664411469"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="664411469"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 23 Oct 2022 20:16:30 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1omnwz-0004y3-22;
        Mon, 24 Oct 2022 03:16:29 +0000
Date:   Mon, 24 Oct 2022 11:16:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Joaqu=EDn_Ignacio_Aramend=EDa?= <samsagax@gmail.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v2] drm/amd/display: Revert logic for plane modifiers
Message-ID: <Y1YDjMF8FkmgV8EC@dba927f25f90>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024030832.119039-1-samsagax@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Subject: [PATCH v2] drm/amd/display: Revert logic for plane modifiers
Link: https://lore.kernel.org/stable/20221024030832.119039-1-samsagax%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



