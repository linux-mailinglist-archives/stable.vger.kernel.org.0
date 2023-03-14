Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6186B9AC8
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCNQNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCNQNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:13:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B30AB893
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 09:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678810397; x=1710346397;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=faJaWntiVCGWz9Mq8eHxleM80Hs/dIosUCg+ytVAJQE=;
  b=kRLxFL0Stk3Cm0/RTjCXEp79c57CIrDQTXbr0iBv2rVSwQ9AQ96oM5jA
   2K0/gSGW6+jvCMuH+ot9tnmf6T1kkq9dLagNJH1BhBp80uUmUGjpioknn
   1LkwtFgaEBIQHRXV3QSebOr0UMOHrhOeKlAAfidLKbOqYHn5ew63CzPr8
   L7MEqhTY62xDZFadvn/xUTBno2GyQQNTZulVBFmPc2gHBp8c3Qgzgh9sj
   viiYru7kfNVWQP0PcYcbyndt3KrXM2mDQwQFS+G+Dr1VPxqRhBqNc9JL8
   TUrcW5eHUbILo/6+DPPnf2rDdPPHy5cyD0nRvStSGQcADvPWVQL9Q23Mb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317866765"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317866765"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 09:09:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822424203"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="822424203"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2023 09:09:43 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pc7Da-00071I-3A;
        Tue, 14 Mar 2023 16:09:42 +0000
Date:   Wed, 15 Mar 2023 00:08:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3] i2c: xgene-slimpro: Fix out-of-bounds bug in
 xgene_slimpro_i2c_xfer()
Message-ID: <ZBCcFsRVwUSwI436@0f0c699f4fc0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314160416.2813398-1-harperchen1110@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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
Subject: [PATCH v3] i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
Link: https://lore.kernel.org/stable/20230314160416.2813398-1-harperchen1110%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



