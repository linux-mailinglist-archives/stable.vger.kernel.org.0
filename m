Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726B0653D63
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 10:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiLVJTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 04:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVJTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 04:19:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EB821240
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 01:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671700753; x=1703236753;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=16bTkjPfOm4GVVOCLxOWVI48vCRaZP29kQwpIIAcYm4=;
  b=IcY7selkCHlwqYBd+G7xI+bnk3O7W4VM1RsU5/cTZLk5pO0CsdPQNbs1
   +0E8Bhx8EtKl7pemtjfVUE8uyxD8sOEgcjNAr+y61SkpKCDVy/mwnOA09
   He7nO1kxebRgSt/9eR6PRnmg61JW0RFLIyzjJvCLBXGOOE/Jl5qZttCNN
   WMVuunqKyOwuXZFo5pA8Euj7nXzbBi5yLI1sqKawcut7lBm2lORMzTVqM
   VtH6FIuYV5NOQ4Haxr4w6GvCqAh6NgVJsADOLckCWT6BT+bg/Jm3CLPlg
   YAY1ZWUGwWoW/XW4f+UTGouJfQeCrjDtxF5aBb4Bfd79jnOjmPwEFANSS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="382313514"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="382313514"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 01:19:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="758882471"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="758882471"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 22 Dec 2022 01:19:12 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p8HjL-000BS4-2E;
        Thu, 22 Dec 2022 09:19:11 +0000
Date:   Thu, 22 Dec 2022 17:18:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] Documentation: stable: Add rule on what kind of patches
 are accepted
Message-ID: <Y6Qg/msh9b9TYSPp@181616e551cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
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
Subject: [PATCH] Documentation: stable: Add rule on what kind of patches are accepted
Link: https://lore.kernel.org/stable/20221222091658.1975240-1-tudor.ambarus%40linaro.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



