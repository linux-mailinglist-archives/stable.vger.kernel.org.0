Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54D96D6E6F
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 22:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbjDDUvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 16:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbjDDUvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 16:51:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF2BAC
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 13:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680641507; x=1712177507;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=sN0sU+Z3KFvHPELOIkUyvxC/trytnuZU6N+uD76iUao=;
  b=kCbfvFaIccIpzLTbPISaj8661BPvgLqu1Il1py0fPxVz/heSJZT56Mdx
   VYLtpK+68CiQvccadZ2NDKSx2Tw+aYJGL1Jc20wTaFPk4meCX6ii8KGym
   0Eo5x0cYsQQMQyV32UpIPXUF1pQk+tF3Y4WERLp/2pGffv2jdP8Ibph5X
   q5UD40tl+lrUkOrKwXhBJWGNZYrVgbyEjlrUAUYah1aZwbZpgnu6cxj4m
   +c0RQDO9KiUQdt2e2uH6xI7E84sPc2ClMf3jx5z52jrfA/LaU9hZPMZYv
   Ymv1XfVdaSWXzWCdbegEBGmxaa8yPOsqi/bMvQP34geX51lIhQ8wPi4bC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="344015820"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="344015820"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 13:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775795214"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="775795214"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 13:51:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjnd3-000Q24-1U;
        Tue, 04 Apr 2023 20:51:45 +0000
Date:   Wed, 5 Apr 2023 04:51:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shaun Tancheff <shaun.tancheff@gmail.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] memcg-v1: Enable setting memory min, low, high
Message-ID: <ZCyN3x8n3vZNXUYh@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404205013.31520-1-shaun.tancheff@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] memcg-v1: Enable setting memory min, low, high
Link: https://lore.kernel.org/stable/20230404205013.31520-1-shaun.tancheff%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



