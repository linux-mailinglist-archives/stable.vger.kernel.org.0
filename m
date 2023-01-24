Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BBE67A4D5
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbjAXVTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbjAXVTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:19:02 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65C51C5D
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 13:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674595126; x=1706131126;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=ty7ZTdLDSc2wb8AN+rqi8YHqWURlqUb203Zaw8pYjvQ=;
  b=PG0punH7SkSGsYuI1AM7gfI/xkbOPM00L3zs4BJJ4L1/uvyyPfiSfPGj
   zDBrVtIxwD7/geuNYo3mt/TzZz/MUGCKXHSRpi7ZFXEG4vE42h6Oj5gPf
   mZqQsOtr+Xm3/Uc/YLV+H1ZD3SFNIUqnulKoSorQyYVXFhSgKcAib/UeK
   ErdNc5ekk7H+GZJWn0CChtnxhkExEpvfI7yY6mx77Vtb4tLnfine148yy
   n0U38vU94gl5jSz4Xu71N4mgiE9++TDCnKGdeSUmhz2eljFzLqsiILtlN
   PZPVoKKf3rqu2ocCE5338y+l9rJKQ501Ul00cTqyZ1jIiFwdykLMSCgES
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="306070307"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="306070307"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 13:18:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="907661348"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="907661348"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 24 Jan 2023 13:18:21 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKQgO-0006mm-1b;
        Tue, 24 Jan 2023 21:18:20 +0000
Date:   Wed, 25 Jan 2023 05:17:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.4 fix build id for arm64 6/6] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <Y9BK+z2pRJHnQ8dd@06a1915e439d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.4 fix build id for arm64 6/6] sh: define RUNTIME_DISCARD_EXIT
Link: https://lore.kernel.org/stable/7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



