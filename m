Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93558609DF5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 11:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiJXJZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 05:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiJXJZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 05:25:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2234663F
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 02:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666603546; x=1698139546;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=GHl+xTqg+OokgkVtAvoNq+5HzKPUaZZpVLK3GvIpn9c=;
  b=hcxtIQybNp5xDaaoxDum77FeoEu5JwCci6wjQ4RMjxpn1Zh68IVcJi4S
   eW2/RMOSs6WBoZg869bkS+TyLcTI2g5RSdY/PsF3Ub14ezr30WS19W+U+
   ptO1IPdCGLPqeKOGPTC3RuaUuTqO/kb3/7n8A9WuHTFoBJZkZhJhONcE+
   +kN6jc9jN8W0Se60BIr8MnkQtf5mv/hxIT+rQnFXoJL+s2J99XbMs5uux
   DAbE5SYzzStFiGqV8ZV8R2cN2nbMaT6rRSVMV37NTl+C8zbmJxyUqQb4O
   /kR7osDCxWRXhKiSrbNfqzpm5p5nxHCOlVDAyFSJ95SIj5dFkI8sUmTwC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="287094504"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="287094504"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 02:25:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="664486372"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="664486372"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 24 Oct 2022 02:25:44 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1omtiJ-0005Fz-2D;
        Mon, 24 Oct 2022 09:25:43 +0000
Date:   Mon, 24 Oct 2022 17:25:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yuanzheng Song <songyuanzheng@huawei.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
Message-ID: <Y1ZaChUEi/qBCEFa@dba927f25f90>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024094911.3054769-1-songyuanzheng@huawei.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in the copy_present_page()
Link: https://lore.kernel.org/stable/20221024094911.3054769-1-songyuanzheng%40huawei.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



