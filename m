Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D5663231
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjAIVFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbjAIVE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:04:56 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A536A496C3
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 12:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673297894; x=1704833894;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=oxaBLBiyy8sDivw/x/aJdQJ4utjCEgcX7oI2CFlquCs=;
  b=jZl8tTjo24WGdN5PgBi5IBfaWtzk11Kq9NAq5u+pbxns9rVZQ6wYJyUQ
   I/LLv9/5pZ+B8bYjNe6YxtSkew1l6ue6xuuqeuWOFRlvpOoG4lqeFJCxX
   oStsGeUxPRK7G3v8TNPH69iCOYe39h3GTEPyU0ouma7CMUY3oE9gWHEUB
   nDZBRuk29BNr/BGKY8F5VS85R6PYVpe56NMPoyv9B+utRc6V5lXRnV2zd
   uzycmgapROd4en0GGDxn815zIhP03MyuJsD3yw9UsJkML+89gqHSNpWyZ
   pnSusSbS/Lgxoea907/Nh79e5wxmYbxXGHRcJDszwdNjd7xmHAYEVqTbW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="387427894"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="387427894"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 12:58:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="780815460"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="780815460"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 09 Jan 2023 12:58:13 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pEzDg-0007EQ-1A;
        Mon, 09 Jan 2023 20:58:12 +0000
Date:   Tue, 10 Jan 2023 04:58:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] nommu: Fix do_munmap() error path
Message-ID: <Y7x/3kkRKM5wWEjX@d82c38c126d2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109205708.956103-1-Liam.Howlett@oracle.com>
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
Subject: [PATCH] nommu: Fix do_munmap() error path
Link: https://lore.kernel.org/stable/20230109205708.956103-1-Liam.Howlett%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



