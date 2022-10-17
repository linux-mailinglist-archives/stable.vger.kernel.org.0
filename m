Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFAA60052D
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 04:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJQCT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 22:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiJQCT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 22:19:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3BEE3A
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 19:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665973163; x=1697509163;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=0oREvbLCm1hojIZ1oCEA/wc9xCP1GM9dW+TpJGZ3Ftg=;
  b=OvWUsmzH/57jv0SSom9HILbgSyBubjRHWTYHYndyP5AEiPQFYYC8MiuM
   mDxzHGe/f4U4kng6kG13TUm1ORF2oi5U73aJTM2I4p62v3MN2BHUhz1ux
   4rI2PYajvEcvFpGsV800aPKRJx8XbhBKT5IRAGLEed2YqCJ7ELc9ZwIWu
   omK8PGYnHZBzcLoY6dHNmzVewZ4HYnzxBzHrrkUTqX929lBW6Ur10JhZh
   wuyIRpQL0ACftGWIJXXv8afyE694+8qqfMg5S9q4Fj8CwUfiqtzXORcra
   on4WjDuteA13xovp9VmMhAJ3KKnEWHew0Q/CF0ahqJ762nUnofKYioScb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="285412876"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="285412876"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2022 19:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10502"; a="691177834"
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="691177834"
Received: from lkp-server02.sh.intel.com (HELO 8556ec0e0fdc) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2022 19:19:19 -0700
Received: from kbuild by 8556ec0e0fdc with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1okFio-00003P-23;
        Mon, 17 Oct 2022 02:19:18 +0000
Date:   Mon, 17 Oct 2022 10:18:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [RFC v5.4 2/3] wifi: mac80211: don't parse mbssid in assoc
 response
Message-ID: <Y0y7iz8NwN/r12EE@cbc4ca7ce717>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014184650.f3deb2e15fcb.I6c0186979a2872e7f7da75f9f8f93b07046afcf2@changeid>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [RFC v5.4 2/3] wifi: mac80211: don't parse mbssid in assoc response
Link: https://lore.kernel.org/stable/20221014184650.f3deb2e15fcb.I6c0186979a2872e7f7da75f9f8f93b07046afcf2%40changeid

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



