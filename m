Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EAA663247
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjAIVI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbjAIVH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:07:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC05809A5
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 13:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673298015; x=1704834015;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=WXvmJQIGmlUFQwdRleXQqqs125T+vColyvk2q0DVH1k=;
  b=guoD/KAXx/X0Tf39aBCxsxgotde3WzzPt5FZv5/834U1O11yfMeC8O7c
   VP4aChH1wpDMz6skIX6iLMvKqsHftzG/l5ui8juTGvr8IF84/3D3Q+r7O
   kqd2JXXaqcgH54aJKvUmyP5A1XXSfMvthcyi0Q5KmYw1Rs1Somu2sfFIp
   Tl8F5sGHEM05XTYHnBCIctCZV8zQchtNGpUXdWQ2SVtQ15/nlR5sAlVwP
   K3oNCRY54XrKuxcOP2QSfXDUXNr5WdipbPJxKrIc0gjsz3ZX5mEtkXNrf
   J2jzdfreQodv5LsMDYNyqXkmniD4lRQBqzfW4N1V+fd8yaTbfhgHsjmnV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="303341821"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="303341821"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 13:00:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="689170073"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="689170073"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 09 Jan 2023 13:00:13 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pEzFc-0007EU-1P;
        Mon, 09 Jan 2023 21:00:12 +0000
Date:   Tue, 10 Jan 2023 04:59:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] nommu: Fix split_vma() map_count error
Message-ID: <Y7yARjJ/t08qWV+O@d82c38c126d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109205809.956325-1-Liam.Howlett@oracle.com>
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
Subject: [PATCH] nommu: Fix split_vma() map_count error
Link: https://lore.kernel.org/stable/20230109205809.956325-1-Liam.Howlett%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



