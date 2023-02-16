Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3BA698DCC
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBPH3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjBPH3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:29:22 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234C139284
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 23:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676532562; x=1708068562;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=9Aqlsn9tYwv1kPM7ZlJxs0paeRwIrvrhAfVz57PoM7Y=;
  b=KrbVQCg1RGVMcOJL7Lcp/L7vIOFbdvEKvsEdbUc9SBsCItPKFWpjBN/D
   ZJCZ20zrOplnydfgjrQt3a0i1/q8+eUY1vbaG2I76Z5sd6KLdx5KCEw/f
   v+4oOqKRzBLDuIYr478TnTe1RclZypo1KexdJbesvEFqRJdJa7ucNWe/f
   WPfaWeunipsJ4KdReGkSEshmvZy2GhG759CpGqPmddZGzplDYWnXSqHIS
   aE5bEKN3WGFNkhd/YBO8frGP+vQ84kruPxKNIriX0JcV/bdiWwfcuPjxE
   dLIu6N+OXEWyP/AGoQnk9xCALbeaPmdmxArYUkIF/iA7Xi38X5xBr2rBE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="417870004"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="417870004"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 23:29:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619895613"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="619895613"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 23:29:20 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSYhj-000A65-2J;
        Thu, 16 Feb 2023 07:29:19 +0000
Date:   Thu, 16 Feb 2023 15:28:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yonggil Song <yonggil.song@samsung.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2] f2fs: fix uninitialized skipped_gc_rwsem
Message-ID: <Y+3bNRowNeWShQqF@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216072821epcms2p35e1fecca382380723ac0031862687173@epcms2p3>
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
Subject: [PATCH v2] f2fs: fix uninitialized skipped_gc_rwsem
Link: https://lore.kernel.org/stable/20230216072821epcms2p35e1fecca382380723ac0031862687173%40epcms2p3

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



