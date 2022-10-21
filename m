Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F199606E2F
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 05:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJUDMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 23:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJUDMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 23:12:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504441D1A81
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 20:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666321930; x=1697857930;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=p8DZXPVTDMIUXbd4t722Ov5BiURZc3cMdvFA1wFqGCg=;
  b=gaPpd25BgmkrPcUpOEftCn5nLr0IisedVydyDTvCOkHi0QMpUKPCQfc9
   qWiWBSDKuz5viWvWyHugyYKFByFNei6KeN+iA+fW04ZXnfqxUBBU/7C+a
   p+9f+2LsnSEfquRyUvtWcLSueFP1pw3Noy32WI98nTvGbqrKxn0212mip
   Kw3usRgiJnJaHjaVhS2vE8dCNSaJrf0jZI/QAas2NWTdWooFgCLfdA2Ko
   i3SVd37Sz8nb8/5WbZFHSPInmHKuMLi3NBWkpjJ7/v8c76Tisa3yGsU9Y
   QKMObP4gbzN0tLZGgEMP+YkaLmQG9h0VuL4p80FliAoet5TMExJOGZ6d/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="294295020"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="294295020"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 20:12:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="719454960"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="719454960"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Oct 2022 20:12:07 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oliS6-00020F-2D;
        Fri, 21 Oct 2022 03:12:06 +0000
Date:   Fri, 21 Oct 2022 11:11:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maria Yu <quic_aiquny@quicinc.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] mm/page_isolation: fix clang deadcode warning
Message-ID: <Y1IN91+Gjol1XAS1@b995051e45c0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021030953.34925-1-quic_aiquny@quicinc.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] mm/page_isolation: fix clang deadcode warning
Link: https://lore.kernel.org/stable/20221021030953.34925-1-quic_aiquny%40quicinc.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



