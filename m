Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3AD6968CE
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 17:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBNQIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 11:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjBNQIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 11:08:24 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01535658A
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676390897; x=1707926897;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=bZ/pCpjd29pG10Cwv8yNoqOplpvuf4IODWoe56xtXus=;
  b=FEuaX8O8JLfeGSGxzxCNqn326uaCpspk12HlxKyqE/A/N27mItTcXc05
   IN6dCeWN03d8e7VIejEB3gInfSY8VUysKUp+oVbgH5BqHhQQxYNtwsEtb
   SaslzjntAwtgCWGe6QGuhLw0c8tBYGSd0wu5e/tgqEKRf2dvWXnWwk88D
   sIhy6m9FTIBGDMFH3oXcRQE6jKWaKzsylabkf8WLAAqa3fHIUxV+KmD3+
   n2lG8T+ywMeC0IvC2y638x4hLaV00H1IWkCNVGjw17oaxsPkNDTwdf7n2
   2Qd2b8iqdG05cJ9dahqLYFLsQN6TQPAwXPJjZJosMq+Cn4whLb7DYSZ8W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358608997"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="358608997"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:08:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="646802585"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="646802585"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 14 Feb 2023 08:08:15 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRxqp-0008cu-0M;
        Tue, 14 Feb 2023 16:08:15 +0000
Date:   Wed, 15 Feb 2023 00:07:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 6.1 4/4] selftests: mptcp: userspace: fix v4-v6 test in
 v6.1
Message-ID: <Y+uxtnX9ZC7M1cp2@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-4-02f36fa30f8c@tessares.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 6.1 4/4] selftests: mptcp: userspace: fix v4-v6 test in v6.1
Link: https://lore.kernel.org/stable/20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-4-02f36fa30f8c%40tessares.net

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



