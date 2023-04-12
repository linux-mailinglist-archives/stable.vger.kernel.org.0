Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3606DEA84
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDLEaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDLEaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:30:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4710E524B
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 21:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681273796; x=1712809796;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=B2Xf3W+blcNOV/HeIic9RXmTN+H9NAvk4gyMAKj6kCQ=;
  b=mgYc+g0GfOeX9Kd+Ze4PCFVQAOc1Qa8s8+0rUnDwpzLEOI3YdLrjbfVL
   /iQ7ywJXYslOlfU3vgT5hzs4e/VM9Omvj5slVTwZP4p8KYtdxHR0r3l9Y
   Hh4nDkssa+D0fKEhdj8tZfcvC44KtriGlqft7XZ9sXUPVlYKqavYG2ppL
   1XnbqZkc9La8yMjIdn1e0YliF2+9cCVIJK8m+s5Myfm9qa8o4LP8LbUof
   LVNHg2SLrm7AiCLeHkuHRrrIlFeEowTJ7GajJK4H/gPX5eAj6BojZ/XiB
   AoWpeRJ4wCkA9Gu8tq5bSQBKDApYE6FojY7hopLBnIWA0AAauHw7glO2/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="406627484"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="406627484"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 21:29:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812844997"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812844997"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 11 Apr 2023 21:29:54 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pmS7F-000XGh-1Q;
        Wed, 12 Apr 2023 04:29:53 +0000
Date:   Wed, 12 Apr 2023 12:29:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.4 09/17] xfs: simplify a check in
 xfs_ioctl_setattr_check_cowextsize
Message-ID: <ZDYzp9l2Ku6cbtQC@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412042624.600511-10-chandan.babu@oracle.com>
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
Subject: [PATCH 5.4 09/17] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Link: https://lore.kernel.org/stable/20230412042624.600511-10-chandan.babu%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



