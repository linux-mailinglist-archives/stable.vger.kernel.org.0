Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF295BB180
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIPRKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIPRKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:10:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023536050D
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663348212; x=1694884212;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=czp4uYVcMeqQPnxyuM9RNMrV7jv8HTTDXS17Z67LCws=;
  b=gU2xbpcbj048qneLUSq9nmgKrMSX8J8Tf7HUo91eyAe3bz3WoAzg4mOB
   Rhka5ce1aJBsdd3TCLM3Kuo1jJVrK3w1Ibfgs33slB18c7EuwLfRs0PxU
   H9VsogMXfBp2EqTFtQEs6D5mlEonK58l0adGCY33shI4SVGu12zXjcNCd
   +Pfvu+KHs9qaq7o5Hi+0IUB93jR2lVnVVLam8a3B+6yNcJle9ArkKV1RV
   a6ib8uXnOPi/68VVb+XZsYiLc6NiIqWHKNnxz+uhx5lUtAyXQz0I1yJWe
   Zxzs1y1khWfsQ9uwiwszK5ruY844mO2qkY3GOGdextGiqxM8JbIyvFrEr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10472"; a="299859734"
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="299859734"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 10:10:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="946449749"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 16 Sep 2022 10:10:10 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oZEqv-0001ys-20;
        Fri, 16 Sep 2022 17:10:09 +0000
Date:   Sat, 17 Sep 2022 01:09:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     wangyong <yongw.pur@gmail.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH 1/3] mm/page_alloc: use ac->high_zoneidx for classzone_idx
Message-ID: <YyStxmIX/EAhgG0C@facefcfb2e4a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1663347949-20389-2-git-send-email-wang.yong12@zte.com.cn>
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
Subject: [PATCH 1/3] mm/page_alloc: use ac->high_zoneidx for classzone_idx
Link: https://lore.kernel.org/stable/1663347949-20389-2-git-send-email-wang.yong12%40zte.com.cn

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



