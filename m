Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2CA623E24
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 09:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiKJI6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 03:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKJI6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 03:58:31 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BFD1CD
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 00:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668070701; x=1699606701;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=Gf3GXeUSlo7n0zjvagoFb2D9uFIDAkCSjtuVjSKZB3g=;
  b=AfnqbfeCuWigjkDU0GBnEFQJ6zvTYGtWZZS6olGrIihZrfamy7Sq8Lv4
   e+qmXZbnIC21TCvtLJI4/78GBRVqEEZY2wGj0F61/VXVQW7ZvEkCSJ8X4
   euIadOe5HKaAucy8oq13uhehgUN8nbKBTNWG6DgcAnIuxPqr+SXCEK+BM
   HnVqLMrpjKzDx/kmfxa1UmjsVQ1SvRc6OMD7g6IIiM2r5o4ciQQXSpY56
   1dTrTvRPz3zHyqvcXap/1M6F6011n+vzBIWHgtfnAc2GUen6QXLdFyrL0
   ZsADIMhDmWug8qaf0b1oNEuW8k9sfYBqcmybpRSoq6BeadOaNgPgYWK3E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="373377385"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="373377385"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 00:58:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="615026704"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="615026704"
Received: from lkp-server01.sh.intel.com (HELO e783503266e8) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 10 Nov 2022 00:58:19 -0800
Received: from kbuild by e783503266e8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ot3O6-0002gj-1G;
        Thu, 10 Nov 2022 08:58:18 +0000
Date:   Thu, 10 Nov 2022 16:57:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alban Crequy <albancrequy@linux.microsoft.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH bpf v2 2/2] selftests: bpf: add a test when
 bpf_probe_read_kernel_str() returns EFAULT
Message-ID: <Y2y88PVeCDK8MORB@9c6a254c5b7f>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110085614.111213-3-albancrequy@linux.microsoft.com>
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
Subject: [PATCH bpf v2 2/2] selftests: bpf: add a test when bpf_probe_read_kernel_str() returns EFAULT
Link: https://lore.kernel.org/stable/20221110085614.111213-3-albancrequy%40linux.microsoft.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



