Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17D60052C
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 04:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJQCTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 22:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJQCTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 22:19:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C25CEB
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 19:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665973162; x=1697509162;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=nCEju7MEMxmJTcYSSVK7iwZtGDNk0NK7O4pr9oGpIDU=;
  b=nw9DJBTTFRvbhgGW1/T4lraq1bnYerlNXCa4UtI/x5S5td0LK0s4174+
   4JqhUgxVk7cwRNd1H+WeetOU+mWaw6d0fCNDK6hZpRN0N+7WKWXYUfEes
   YjgZrN0ZowxE2s3kpW1OEVqQ02Tnn+3PvkuHYH180sLDGapGbRoyXVHDQ
   y46/gS9I8ya8SzNNle6Lyjzcbn+h+ZbSvvmoPRE16Nc+n1R7v/LaS3L9C
   OH4v58uh34vw71+wC+XnBDbNkkTXJ/lqap+c5BegdVxeIdxA+SC+jCMyR
   AkbJz8/d9B8Qkj71QWmSEc5wLOTGdYTPAt0YPr/fdjWFeWs073fMrMGwk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="293052048"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="293052048"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2022 19:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="957166657"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="957166657"
Received: from lkp-server02.sh.intel.com (HELO 8556ec0e0fdc) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 16 Oct 2022 19:19:19 -0700
Received: from kbuild by 8556ec0e0fdc with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1okFio-00003X-2A;
        Mon, 17 Oct 2022 02:19:18 +0000
Date:   Mon, 17 Oct 2022 10:18:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [RFC v5.10 1/3] mac80211: mlme: find auth challenge directly
Message-ID: <Y0y7gXwSCPfthrYz@cbc4ca7ce717>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014164150.24310-2-johannes@sipsolutions.net>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Subject: [RFC v5.10 1/3] mac80211: mlme: find auth challenge directly
Link: https://lore.kernel.org/stable/20221014164150.24310-2-johannes%40sipsolutions.net

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



