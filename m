Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD466322B
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbjAIVES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbjAIVDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:03:50 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA5F87F1D
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 12:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673297849; x=1704833849;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=WGATvaZKNENAcof5v6X+B1QYZ2YOCfqAWjk4Z+luP/U=;
  b=SNUap85Ty9G9bAmFuZ+3YqjR2GUKixxmp/4xUpZxPgzGAdWlp1SvuKap
   3VFbqYlWimwgXhM2e52Y+4R+KpuuGybfMuFG0JP43sDcOMLbpRGK0iIna
   pSENzyIHleQwX9ASRIGvITG6b7u7lnKcV2Szj0fOhZ1nXymrb3F0TM9Td
   LryDVKyudodD8krR1+3xfL9iyas+4lPpUB9HFZtk0OX2z5RT500PQLsXX
   0v+v0nPzXt0nbyIdO6ridrSiLppww0zv+eZR42Do0Y/NSIHrXgldWKERt
   mEE5DOIVChkiwguBaGiE+GW5X62v7MzShl6PDckWxqPONILWfb/6b3D+/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302678858"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="302678858"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 12:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="745500491"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="745500491"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jan 2023 12:57:13 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pEzCi-0007EM-13;
        Mon, 09 Jan 2023 20:57:12 +0000
Date:   Tue, 10 Jan 2023 04:56:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] nommu: Fix memory leak in do_mmap() error path
Message-ID: <Y7x/cidNmLr9QoZV@d82c38c126d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109205507.955577-1-Liam.Howlett@oracle.com>
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
Subject: [PATCH] nommu: Fix memory leak in do_mmap() error path
Link: https://lore.kernel.org/stable/20230109205507.955577-1-Liam.Howlett%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



